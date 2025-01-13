package network

import (
	"errors"
	"fmt"
	"net"
	"time"

	"github.com/cilium/ebpf"
	"github.com/cilium/ebpf/link"
	"github.com/virtual-kubelet/virtual-kubelet/log"
	netlink "github.com/vishvananda/netlink"
	netns "github.com/vishvananda/netns"
)

type MultiRuntimeNetworkManager struct {
	podNamespaces map[string]netns.NsHandle
	podDevices    map[string]PodDevices
	//dummy         netlink.Link
	//bridge        netlink.Link
	//subPodBPFMap *ebpf.Map
}

type PodDevices struct {
	baseAddr  net.IP
	podBridge netlink.Link
	//indexed by IP as string, since net.IP can't be used as map key
	addressesUsed        map[string]netlink.Link
	internalDevices      map[string]net.HardwareAddr
	toSubpodBpfMap       *ebpf.Map
	fromSubpodBpfMap     *ebpf.Map
	fromLocalhostBpfMaps map[string]*ebpf.Map
	linksToKeep          []*link.Link
	mapsToKeep           []*ebpf.Map
	bpfProgLink          *link.Link
	bpfToProg            *ebpf.Program
	bpfFromProg          *ebpf.Program
}

func (mrn *MultiRuntimeNetworkManager) InitContainerNetworking() (CNIManager, error) {
	mrn.podNamespaces = make(map[string]netns.NsHandle)
	mrn.podDevices = make(map[string]PodDevices)

	return mrn, nil
}

func (dn *MultiRuntimeNetworkManager) DeleteForTest() {

}

/*
 */
func (mrn *MultiRuntimeNetworkManager) InitPodNetwork(cns string, podname string) error {
	netNsName := GetNetNs(cns, podname)
	podIp, err := (*PodAddressManager).RequestPodIP(cns, podname)
	if err != nil {
		log.L.Errorf("Error making ip for %s %v", netNsName, err)
	}
	//First, set up the host if that captures all pod traffic
	runes := RandStringRunes(4)
	podLink, err := setupPodBridge(runes, podIp)
	if err != nil {
		log.L.Errorf("Couldn't create bridge %s %v", runes, err)
	}

	mrn.podDevices[netNsName] = PodDevices{
		baseAddr:      podIp,
		podBridge:     *podLink,
		addressesUsed: make(map[string]netlink.Link),
	}

	//Then, first thing to set up is the pod netns + veth pair with the next available IP
	netNsIp, err := getNextSubPodIP(mrn.podDevices[netNsName])
	if err != nil {
		return err
	}
	hostIf, contIf, nsid, err := setupPodNetNs(netNsName, podIp, netNsIp, *podLink)
	if err != nil {
		return err
	}
	podDev := mrn.podDevices[netNsName]
	podDev.addressesUsed[netNsIp.String()] = *hostIf
	mrn.podDevices[netNsName] = podDev

	//Then, we start multiruntime eBPF redirecting at pod<xxxx> towards the netns, any VM stuff should be added to the map later.
	toProg, toBpfMap := loadToSubPodTC()
	routeObj := makeSplitRouteMapObject(*podLink, *contIf, netNsIp)
	err = toBpfMap.Put(uint32(0), routeObj)
	if err != nil {
		log.L.Error(err)
	}
	podDev = mrn.podDevices[netNsName]
	podDev.toSubpodBpfMap = toBpfMap
	podDev.bpfToProg = toProg
	//podDev.bpfToLink = link
	mrn.podDevices[netNsName] = podDev

	//Then, start multiruntime eBPF redirect from pod<xxxx> towards other pod<xxxx> bridges
	fromProg := mrn.initFromSubpodRouting(podLink, netNsName)
	//And update other pod<xxxx> bridges with this pod's info
	mrn.updateSubpodRouting(podLink, podIp)

	link, maps := setupSubpodTC(*podLink, podIp, fromProg, toProg)
	podDev = mrn.podDevices[netNsName]
	podDev.bpfProgLink = link
	podDev.mapsToKeep = maps
	//podDev.bpfToLink = link
	mrn.podDevices[netNsName] = podDev
	//FUK

	//We still need to do the localhost stuff here, but that's a TODO

	mrn.podNamespaces[netNsName] = *nsid
	return nil
}

func (mrn *MultiRuntimeNetworkManager) initFromSubpodRouting(podBridge *netlink.Link, netNsName string) *ebpf.Program {
	prog, xdpBpfMap := loadFromSubPodTC()
	//Redirect from this pod's subpod addresses to other local pods
	for _, dev := range mrn.podDevices {
		if dev.podBridge.Attrs().Name != (*podBridge).Attrs().Name {
			rroute := RedirectRoute{
				TargetIfIndex: uint32(dev.podBridge.Attrs().Index),
				SMac:          [6]uint8((*podBridge).Attrs().HardwareAddr),
				DMac:          [6]uint8(dev.podBridge.Attrs().HardwareAddr),
			}
			if (*PodAddressManager).IsIPv4() {
				err := xdpBpfMap.Put(ip2int(dev.baseAddr), rroute)
				if err != nil {
					log.L.Errorf("Couldn't add route to %s, %v\n", dev.baseAddr, err)
				}
			} else {
				err := xdpBpfMap.Put([16]byte(dev.baseAddr.To16()), rroute)
				if err != nil {
					log.L.Errorf("Couldn't add route to %s, %v\n", dev.baseAddr, err)
				}
			}
		}
	}
	//We also need a default redirect for other (remote) pods to eth0 or whatever physical interface
	publicIf, _ := getPublicIface()
	rroute := RedirectRoute{
		TargetIfIndex: uint32(publicIf.Index),
		SMac:          [6]uint8((*podBridge).Attrs().HardwareAddr),
		DMac:          [6]uint8(publicIf.HardwareAddr),
	}
	if (*PodAddressManager).IsIPv4() {
		defRoute := uint32(0)
		err := xdpBpfMap.Put(defRoute, rroute)
		if err != nil {
			log.L.Errorf("Couldn't add route 0 %v\n", err)
		}
	} else {
		err := xdpBpfMap.Put([]byte{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, rroute)
		if err != nil {
			log.L.Errorf("Couldn't add route 0 %v\n", err)
		}
	}

	podDev := mrn.podDevices[netNsName]
	podDev.fromSubpodBpfMap = xdpBpfMap
	podDev.bpfFromProg = prog
	mrn.podDevices[netNsName] = podDev

	return prog
}

func (mrn *MultiRuntimeNetworkManager) updateSubpodRouting(podBridge *netlink.Link, podIp net.IP) {
	for idx, dev := range mrn.podDevices {
		if dev.podBridge.Attrs().Name != (*podBridge).Attrs().Name {
			rroute := RedirectRoute{
				TargetIfIndex: uint32((*podBridge).Attrs().Index),
				SMac:          [6]uint8(dev.podBridge.Attrs().HardwareAddr),
				DMac:          [6]uint8((*podBridge).Attrs().HardwareAddr),
			}
			if (*PodAddressManager).IsIPv4() {
				dev.fromSubpodBpfMap.Put(ip2int(podIp), rroute)
			} else {
				dev.fromSubpodBpfMap.Put([16]byte(podIp.To16()), rroute)
			}
			mrn.podDevices[idx] = dev
		}
	}
}

func setupPodBridge(id string, ip net.IP) (*netlink.Link, error) {
	//runes := RandStringRunes(4)
	podIfName := fmt.Sprintf("pod%s", id)

	la := netlink.NewLinkAttrs()
	la.Name = podIfName
	podIf := &netlink.Bridge{LinkAttrs: la}
	err := netlink.LinkAdd(podIf)
	if err != nil {
		log.L.Errorf("Add link %s: %v\n", la.Name, err)
		return nil, err
	}
	poddevice, err := tryGetLink(podIfName)

	netSize := 126
	if len(ip) == net.IPv4len {
		netSize = 30
	}

	addr, err := netlink.ParseAddr(fmt.Sprintf("%s/%d", ip.String(), netSize))
	if err != nil {
		log.L.Errorf("Parsing address %v", err)
		return nil, err
	}
	netlink.AddrAdd(poddevice, addr)

	/*err = netlink.LinkSetUp(poddevice)
	if err != nil {
		log.L.Errorf("Set link up %v", err)
		return nil, err
	}*/
	err = trySetLinkUp(poddevice)
	if err != nil {
		log.L.Errorf("Set link up %v", err)
		return nil, err
	}

	return &poddevice, nil
}

func (mrn *MultiRuntimeNetworkManager) StopPodNetwork(cns string, podname string) error {
	ns := GetNetNs(cns, podname)
	err := netns.DeleteNamed(ns)
	if err != nil {
		log.L.Error(err)
		return err
	}

	dev := mrn.podDevices[ns]
	err = netlink.LinkDel(dev.podBridge)
	if err != nil {
		log.L.Error(err)
		return err
	}
	return nil
}

/*func (mrn *MultiRuntimeNetworkManager) AttachToNetNs(cns string, podname string, pid int) error {
	return nil
}*/

func (mrn *MultiRuntimeNetworkManager) GetNetNsHandle(cns string, podname string) (*netns.NsHandle, error) {
	netNsname := GetNetNs(cns, podname)
	netNs, found := mrn.podNamespaces[netNsname]
	if !found {
		return nil, errors.New(fmt.Sprintf("Container network namespace for %s not found", netNsname))
	}

	return &netNs, nil
}

func (mrn *MultiRuntimeNetworkManager) TeardownContainerNetworking() error {
	err := teardownNamespaces(mrn.podNamespaces)
	//TODO stop VM interfaces (if any, the runtimes should take care of that)
	if err != nil {
		log.L.Error(err)
	}

	for _, dev := range mrn.podDevices {
		err = netlink.LinkDel(dev.podBridge)
		if err != nil {
			log.L.Error(err)
		}
		for _, subif := range dev.addressesUsed {
			err = netlink.LinkDel(subif)
			if err != nil {
				log.L.Errorf("Could not delete interface (ignore if container) %s: %v", subif.Attrs().Name, err)
			}
		}
		/*err = netlink.LinkDel(dev.podDummy)
		if err != nil {
			log.L.Error(err)
		}*/
	}
	//err = stopCNI0()
	return err
}

func (mrn *MultiRuntimeNetworkManager) GetNetNsPath(cns string, podname string) (string, error) {
	netNsname := GetNetNs(cns, podname)
	_, found := mrn.podNamespaces[netNsname]
	if !found {
		return "", errors.New(fmt.Sprintf("Container network namespace for %s not found", netNsname))
	}

	return netNsname, nil
}

func (mrn *MultiRuntimeNetworkManager) CreateVMTun(cns string, podname string, containername string) (string, net.IP, net.HardwareAddr, error) {
	netNsName := GetNetNs(cns, podname)
	podDevs := mrn.podDevices[netNsName]

	vmIp, err := getNextSubPodIP(mrn.podDevices[netNsName])
	if err != nil {
		log.L.Errorf("CreateVMTun %v", err)
		return "", net.IP{}, net.HardwareAddr{}, err
	}

	runes := RandStringRunes(4)
	ifName := fmt.Sprintf("vtap%s", runes)
	la := netlink.NewLinkAttrs()
	la.Name = ifName
	tapDev := &netlink.Tuntap{
		LinkAttrs: la,
		Mode:      netlink.TUNTAP_MODE_TAP,
	}

	err = netlink.LinkAdd(tapDev)
	if err != nil {
		log.L.Errorf("could not add %s: %v\n", la.Name, err)
		return "", net.IP{}, net.HardwareAddr{}, err
	}

	time.Sleep(time.Millisecond * 100)
	tapIf, _ := netlink.LinkByName(ifName)
	err = netlink.LinkSetUp(tapIf)
	if err != nil {
		log.L.Error(err)
		return "", net.IP{}, net.HardwareAddr{}, err
	}
	err = netlink.LinkSetMaster(tapIf, podDevs.podBridge)
	if err != nil {
		log.L.Error(err)
		return "", net.IP{}, net.HardwareAddr{}, err
	}

	//Add to poddevices
	podDevs.addressesUsed[vmIp.String()] = tapIf

	//Add to ebpf map(s)
	//mrn.updateSubpodRouting(&podDevs.podBridge, vmIp)

	mac := generateMac()
	routeObj := makeSplitRouteMapObjectMac(podDevs.podBridge, mac, vmIp)
	bpfMap := podDevs.toSubpodBpfMap
	//err = bpfMap.Put(uint32(0), routeObj)
	err = putNextSplitRouteObj(bpfMap, routeObj)
	if err != nil {
		log.L.Error(err)
	}
	podDevs.toSubpodBpfMap = bpfMap

	//Update map
	mrn.podDevices[netNsName] = podDevs

	return ifName, vmIp, mac, nil //ifName, vmIp, mac, nil
}

func (mrn *MultiRuntimeNetworkManager) GetGatewayAddress(cns string, podname string) net.IP {
	netNsName := GetNetNs(cns, podname)
	podDevs := mrn.podDevices[netNsName]
	return podDevs.baseAddr
}
