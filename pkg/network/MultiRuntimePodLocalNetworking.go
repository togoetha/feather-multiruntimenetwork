package network

import (
	"errors"
	"fmt"
	"net"
	"time"

	"github.com/cilium/ebpf"
	"github.com/virtual-kubelet/virtual-kubelet/log"
	netlink "github.com/vishvananda/netlink"
	netns "github.com/vishvananda/netns"
)

type MRPodLocalNetworkManager struct {
	podNamespaces map[string]netns.NsHandle
	podDevices    map[string]PodDevices
}

func (mrn *MRPodLocalNetworkManager) InitContainerNetworking() (CNIManager, error) {
	mrn.podNamespaces = make(map[string]netns.NsHandle)
	mrn.podDevices = make(map[string]PodDevices)
	_, err := setupCNIDummy((*PodAddressManager).GetCNIIfIP(), "0")
	if err != nil {
		log.L.Error("Couldn't create dummy interface, possibly already exists %v", err)
	}

	return mrn, nil
}

func (mrn *MRPodLocalNetworkManager) InitPodNetwork(cns string, podname string) error {
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
		baseAddr:             podIp,
		podBridge:            *podLink,
		addressesUsed:        make(map[string]netlink.Link),
		internalDevices:      make(map[string]net.HardwareAddr),
		fromLocalhostBpfMaps: make(map[string]*ebpf.Map),
	}

	//Then, first thing to set up is the pod netns + veth pair with the next available IP
	netNsIp, err := getNextSubPodIP(mrn.podDevices[netNsName])
	if err != nil {
		log.L.Errorf("Couldn't get netns IP %v", err)
		return err
	}
	hostIf, contIf, nsid, err := setupPodNetNs(netNsName, podIp, netNsIp, *podLink)
	if err != nil {
		log.L.Errorf("Couldn't set up pod netns %v", err)
		return err
	}
	podDev := mrn.podDevices[netNsName]
	podDev.addressesUsed[netNsIp.String()] = *hostIf
	podDev.internalDevices[netNsIp.String()] = (*contIf).Attrs().HardwareAddr
	mrn.podDevices[netNsName] = podDev

	lhIp := (*PodAddressManager).GetCNIIfIP()
	fromMap, err := mrn.attachLocalhostBpfPrograms(netNsName, lhIp, netNsIp, (*hostIf).Attrs().Name)
	if err != nil {
		log.L.Errorf("Couldn't attach localhost bpf progs %v", err)
		return err
	}
	//doublecheckhostIf, err := tryGetLink((*hostIf).Attrs().Name)
	err = mrn.updateLocalhostBpfMaps(netNsName, netNsIp, (*contIf).Attrs().HardwareAddr, fromMap)
	if err != nil {
		log.L.Errorf("Failed to update localhost bpf maps %v", err)
		return err
	}

	//Then, we start multiruntime eBPF redirecting at pod<xxxx> towards the netns, any VM stuff should be added to the map later.
	toProg, toBpfMap := loadToSubPodTC()
	routeObj := makeSplitRouteMapObject(*podLink, *contIf, netNsIp)
	err = toBpfMap.Put(uint32(0), routeObj)
	if err != nil {
		log.L.Errorf("Failed to set default split route %v", err)
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

func (mrn *MRPodLocalNetworkManager) DeleteForTest() {
	poddevs, _ := mrn.podDevices["vmtest-debug"]

	dummyRoute := SplitRouteIPv4{
		Active:        uint32(0),
		TargetIfIndex: uint32(0),
		DAddr:         uint32(0),
		SMac:          [6]uint8{0, 0, 0, 0, 0, 0},
		DMac:          [6]uint8{0, 0, 0, 0, 0, 0},
	}
	poddevs.toSubpodBpfMap.Put(uint32(0), dummyRoute)
}

/*func (mrn *MRPodLocalNetworkManager) attachNetnsLocalhostBpfPrograms(netNsName string, ip net.IP, containerIf string) error {
	rootNetns, err := netns.Get()
	if err != nil {
		log.L.Errorf("Couldn't get root netns %v\n", err)
		return err
	}
	nsid, err := netns.GetFromName(netNsName)
	if err != nil {
		log.L.Errorf("Couldn't get container netns %s %v\n", netNsName, err)
		return err
	}

	err = netns.Set(nsid)
	if err != nil {
		log.L.Errorf("Couldn't set netns %v %v\n", nsid, err)
		return err
	}

	nsLoopback, err := netlink.LinkByName("lo")
	if err != nil {
		log.L.Errorf("Couldn't get loopback device for netns %s %v\n", netNsName, err)
		return err
	}
	trySetLinkUp(nsLoopback)
	nsLocalhostIp := net.ParseIP("127.0.0.1")
	fromLhLink, fromLhMap, fromKeepMap := setupFromLhTC(nsLoopback, nsLocalhostIp)
	if fromLhLink == nil {
		err := fmt.Errorf("couldn't set up localhost from netns %s", netNsName)
		log.L.Error(err)
		return err
	}

	//fromKeepMap.Put(uint32(0), ip2int(nsLocalhostIp))

	podDev, _ := mrn.podDevices[netNsName]
	bpfMaps := podDev.fromLocalhostBpfMaps
	bpfMaps[ip.String()] = fromLhMap
	podDev.fromLocalhostBpfMaps = bpfMaps
	podDev.mapsToKeep = append(podDev.mapsToKeep, fromKeepMap)

	internalIf, err := tryGetLink(containerIf) //netlink.LinkByName(containerIf)
	if err != nil {
		log.L.Errorf("Couldn't get container internal if %s %v\n", containerIf, err)
		return err
	}
	toLhLink, toKeepMap := setupToLhTC(internalIf)
	if toLhLink == nil {
		err := fmt.Errorf("couldn't set up localhost from netns %s", netNsName)
		log.L.Error(err)
		return err
	}

	mapObj := makeRedirectLhMapObject(nsLoopback, nsLocalhostIp)
	toKeepMap.Put(uint32(0), mapObj)

	podDev.mapsToKeep = append(podDev.mapsToKeep, toKeepMap)
	podDev.linksToKeep = []*link.Link{fromLhLink, toLhLink}
	mrn.podDevices[netNsName] = podDev

	trySetLinkUp(nsLoopback)

	err = netns.Set(rootNetns)
	if err != nil {
		log.L.Errorf("Couldn't reset root netns %v\n", err)
		return err
	}
	return nil
}*/

func (mrn *MRPodLocalNetworkManager) attachLocalhostBpfPrograms(netNsName string, lhIp net.IP, ip net.IP, attachIfName string) (*ebpf.Map, error) {
	attachIf, err := netlink.LinkByName(attachIfName)
	if err != nil {
		log.L.Errorf("Couldn't get tap if %s %v\n", attachIfName, err)
		return nil, err
	}

	//tapLocalhostIp := net.ParseIP("10.0.0.1")
	fromLhLink, fromLhMap, fromKeepMap := setupFromLhTC(attachIf, lhIp)
	if fromLhLink == nil {
		err := fmt.Errorf("couldn't set up localhost from netns %s", netNsName)
		log.L.Error(err)
		return nil, err
	}

	//fromKeepMap.Put(uint32(0), ip2int(nsLocalhostIp))

	podDev, _ := mrn.podDevices[netNsName]
	bpfMaps := podDev.fromLocalhostBpfMaps
	bpfMaps[ip.String()] = fromLhMap
	podDev.fromLocalhostBpfMaps = bpfMaps
	podDev.mapsToKeep = append(podDev.mapsToKeep, fromKeepMap)

	/*toLhLink, toKeepMap := setupToLhXDP(attachIf)
	if toLhLink == nil {
		err := fmt.Errorf("couldn't set up localhost from netns %s", netNsName)
		log.L.Error(err)
		return nil, err
	}*/

	//mapObj := makeRedirectLhMapObject(attachIf, lhIp)
	//toKeepMap.Put(uint32(0), mapObj)

	//podDev.mapsToKeep = append(podDev.mapsToKeep, toKeepMap)
	podDev.linksToKeep = append(podDev.linksToKeep, fromLhLink)
	//podDev.linksToKeep = append(podDev.linksToKeep, toLhLink)
	mrn.podDevices[netNsName] = podDev

	return fromLhMap, nil
}

/*func (mrn *MRPodLocalNetworkManager) attachTapLocalhostBpfPrograms(netNsName string, ip net.IP, tapIfName string) (*ebpf.Map, error) {
	tapIf, err := netlink.LinkByName(tapIfName)
	if err != nil {
		log.L.Errorf("Couldn't get tap if %s %v\n", tapIfName, err)
		return nil, err
	}

	tapLocalhostIp := net.ParseIP("10.0.0.1")
	fromLhLink, fromLhMap, fromKeepMap := setupFromLhTC(tapIf, tapLocalhostIp)
	if fromLhLink == nil {
		err := fmt.Errorf("couldn't set up localhost from netns %s", netNsName)
		log.L.Error(err)
		return nil, err
	}

	//fromKeepMap.Put(uint32(0), ip2int(nsLocalhostIp))

	podDev, _ := mrn.podDevices[netNsName]
	bpfMaps := podDev.fromLocalhostBpfMaps
	bpfMaps[ip.String()] = fromLhMap
	podDev.fromLocalhostBpfMaps = bpfMaps
	podDev.mapsToKeep = append(podDev.mapsToKeep, fromKeepMap)

	toLhLink, toKeepMap := setupToLhXDP(tapIf)
	if toLhLink == nil {
		err := fmt.Errorf("couldn't set up localhost from netns %s", netNsName)
		log.L.Error(err)
		return nil, err
	}

	mapObj := makeRedirectLhMapObject(tapIf, tapLocalhostIp)
	if (*PodAddressManager).IsIPv4() {
		toKeepMap.Put(ip2int(ip), mapObj)
	} else {
		toKeepMap.Put([16]byte(ip), mapObj)
	}

	podDev.mapsToKeep = append(podDev.mapsToKeep, toKeepMap)
	podDev.linksToKeep = append(podDev.linksToKeep, fromLhLink)
	podDev.linksToKeep = append(podDev.linksToKeep, toLhLink)
	mrn.podDevices[netNsName] = podDev

	return fromLhMap, nil
}*/

func (mrn *MRPodLocalNetworkManager) initFromSubpodRouting(podBridge *netlink.Link, netNsName string) *ebpf.Program {
	prog, xdpBpfMap := loadFromSubPodTC()
	//Redirect from this pod's subpod addresses to other local pods
	for _, dev := range mrn.podDevices {
		if dev.podBridge.Attrs().Name != (*podBridge).Attrs().Name {
			rroute := RedirectRoute{
				TargetIfIndex: uint32(dev.podBridge.Attrs().Index),
				SMac:          [6]uint8((*podBridge).Attrs().HardwareAddr),
				DMac:          [6]uint8(dev.podBridge.Attrs().HardwareAddr),
			}
			log.L.Infof("Adding route to %s\n", dev.baseAddr)
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
	log.L.Infof("Adding route 0\n")
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

func (mrn *MRPodLocalNetworkManager) updateSubpodRouting(podBridge *netlink.Link, podIp net.IP) {
	for idx, dev := range mrn.podDevices {
		if dev.podBridge.Attrs().Name != (*podBridge).Attrs().Name {
			rroute := RedirectRoute{
				TargetIfIndex: uint32((*podBridge).Attrs().Index),
				SMac:          [6]uint8(dev.podBridge.Attrs().HardwareAddr),
				DMac:          [6]uint8((*podBridge).Attrs().HardwareAddr),
			}
			log.L.Infof("Adding route from %s\n", dev.baseAddr)
			if (*PodAddressManager).IsIPv4() {
				err := dev.fromSubpodBpfMap.Put(ip2int(podIp), rroute)
				if err != nil {
					log.L.Errorf("Couldn't add route from %s, %v\n", dev.baseAddr, err)
				}
			} else {
				err := dev.fromSubpodBpfMap.Put([16]byte(podIp.To16()), rroute)
				if err != nil {
					log.L.Errorf("Couldn't add route from %s, %v\n", dev.baseAddr, err)
				}
			}
			mrn.podDevices[idx] = dev
		}
	}
}

func (mrn *MRPodLocalNetworkManager) StopPodNetwork(cns string, podname string) error {
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

func (mrn *MRPodLocalNetworkManager) GetNetNsHandle(cns string, podname string) (*netns.NsHandle, error) {
	netNsname := GetNetNs(cns, podname)
	netNs, found := mrn.podNamespaces[netNsname]
	if !found {
		return nil, errors.New(fmt.Sprintf("Container network namespace for %s not found", netNsname))
	}

	return &netNs, nil
}

func (mrn *MRPodLocalNetworkManager) TeardownContainerNetworking() error {
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

func (mrn *MRPodLocalNetworkManager) GetNetNsPath(cns string, podname string) (string, error) {
	netNsname := GetNetNs(cns, podname)
	_, found := mrn.podNamespaces[netNsname]
	if !found {
		return "", errors.New(fmt.Sprintf("Container network namespace for %s not found", netNsname))
	}

	return netNsname, nil
}

func (mrn *MRPodLocalNetworkManager) CreateVMTun(cns string, podname string, containername string) (string, net.IP, net.HardwareAddr, error) {
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
	//tapIf, _ := netlink.LinkByName(ifName)
	tapIf, _ := tryGetLink(ifName)
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
	podDevs.internalDevices[vmIp.String()] = mac
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

	//Attach localhost functionality for pod
	lhIp := (*PodAddressManager).GetCNIIfIP()
	splitMap, err := mrn.attachLocalhostBpfPrograms(netNsName, lhIp, vmIp, tapIf.Attrs().Name)
	if err != nil {
		log.L.Error(err)
	}
	err = mrn.updateLocalhostBpfMaps(netNsName, vmIp, mac, splitMap)
	if err != nil {
		log.L.Error(err)
	}

	return ifName, vmIp, mac, nil //ifName, vmIp, mac, nil
}

func (mrn *MRPodLocalNetworkManager) updateLocalhostBpfMaps(netNsName string, newIp net.IP, newLink net.HardwareAddr, splitMap *ebpf.Map) error {
	podDevs := mrn.podDevices[netNsName]
	lhIp := podDevs.baseAddr //(*PodAddressManager).GetCNIIfIP()
	for ip, bpfMap := range podDevs.fromLocalhostBpfMaps {
		//Add new ip to existing lh maps for the pod
		if ip != newIp.String() {
			srcIf := podDevs.internalDevices[ip]
			routeObj := makeSplitLhRouteMapObject(podDevs.podBridge, newLink, lhIp, newIp)
			err := putNextLhSplitRouteObj(bpfMap, routeObj)
			if err != nil {
				log.L.Error(err)
				return err
			}
			//Add all other ips to the splitmap for new link
			routeObj = makeSplitLhRouteMapObject(podDevs.podBridge, srcIf, lhIp, net.ParseIP(ip))
			err = putNextLhSplitRouteObj(splitMap, routeObj)
			if err != nil {
				log.L.Error(err)
				return err
			}
		}
	}
	//Add route to self
	routeObj := makeSplitLhRouteMapObject(podDevs.podBridge, newLink, lhIp, newIp)
	err := putNextLhSplitRouteObj(splitMap, routeObj)
	if err != nil {
		log.L.Error(err)
		return err
	}
	return nil
}

func (mrn *MRPodLocalNetworkManager) GetGatewayAddress(cns string, podname string) net.IP {
	netNsName := GetNetNs(cns, podname)
	podDevs := mrn.podDevices[netNsName]
	return podDevs.baseAddr
}
