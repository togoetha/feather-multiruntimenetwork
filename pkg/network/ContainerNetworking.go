package network

import (
	"errors"
	"fmt"
	"net"
	"strings"
	"time"

	"github.com/virtual-kubelet/virtual-kubelet/log"
	netlink "github.com/vishvananda/netlink"
	netns "github.com/vishvananda/netns"
	"gitlab.ilabt.imec.be/fledge/service/pkg/util"
	"golang.org/x/exp/rand"
)

type CNAddressManager interface {
	InitAddressSpace(nodeSubnet net.IP, subMask net.IPMask) CNAddressManager
	InitStandaloneAddressSpace() CNAddressManager
	RequestPodIP(namespace string, pod string) (net.IP, error)
	//RequestWorkloadIP(namespace string, pod string, container string) (net.IP, error)
	FreePodIP(namespace string, pod string) error
	//FreeWorkloadIP(namespace string, pod string, container string) error
	GetCNIIfIP() net.IP
	GetMask() int
	GetMaskAsAddr() net.IPMask
	GetTunnelIfIP() net.IP
	GlobalCNINet() (*net.IPNet, error)
	GetMaxIPsPerPod() int
	IsIPv4() bool
}

var PodAddressManager *CNAddressManager

type CNIManager interface {
	DeleteForTest()
	InitContainerNetworking() (CNIManager, error)
	TeardownContainerNetworking() error
	InitPodNetwork(cns string, podname string) error
	StopPodNetwork(cns string, podname string) error
	//AttachToNetNs(cns string, podname string, pid int) error
	GetNetNsHandle(cns string, podname string) (*netns.NsHandle, error)
	GetNetNsPath(cns string, podname string) (string, error)
	CreateVMTun(cns string, podname string, containername string) (string, net.IP, net.HardwareAddr, error)
	GetGatewayAddress(cns string, podname string) net.IP
	//Any future stuff
}

var PodNetworkManager *CNIManager

type WanAccessManager interface {
	InitExternalAccess() (WanAccessManager, error)
	TeardownExternalAccess() error
	AddExternalNode(nodeIP net.IP, cniRange *net.IPNet) error
}

var WanManager *WanAccessManager

func GetRouteDev(publicIP string) (string, error) {
	cmd := fmt.Sprintf("ip route get %s | grep -E -o '[0-9\\.]* dev [a-z0-9]*'", publicIP)
	route, err := util.ExecShellCommand(cmd)
	if err != nil {
		log.L.Errorf("Failed to determine public dev %v", err)
		return "", err
	}
	routeDev := strings.Split(route, " ")[2]
	return routeDev, nil
	//return config.Cfg.TunDev
}

func tryGetLink(podIfName string) (netlink.Link, error) {
	time.Sleep(time.Millisecond * 50)

	poddevice, err := netlink.LinkByName(podIfName)
	i := 1
	for err != nil {
		log.L.Errorf("Retry get link attempt %d, %v", i, err)
		time.Sleep(time.Millisecond * 100)
		poddevice, err = netlink.LinkByName(podIfName)

		i++
	}
	return poddevice, err
}

func trySetNs(handle netns.NsHandle) error {
	time.Sleep(time.Millisecond * 50)

	err := netns.Set(handle)
	i := 1
	for err != nil {
		log.L.Errorf("Retry get link attempt %d, %v", i, err)
		time.Sleep(time.Millisecond * 100)
		err = netns.Set(handle)

		i++
	}
	return err
}

func trySetLinkUp(link netlink.Link) error {
	time.Sleep(time.Millisecond * 50)

	err := netlink.LinkSetUp(link)
	i := 1
	for err != nil {
		log.L.Errorf("Set link up retry %d %v", i, err)
		time.Sleep(time.Millisecond * 100)
		err = netlink.LinkSetUp(link)
		i++
	}
	return err
}

func getPublicIface() (*net.Interface, error) {
	/*var ipr config.NodeInfo
	for key, _ := range config.Cfg.RemoteNodes {
		ipr = config.Cfg.RemoteNodes[key]
		break
	}*/

	pubIp := "::0"
	if (*PodAddressManager).IsIPv4() {
		pubIp = "0.0.0.1"
	}
	dev, err := GetRouteDev(pubIp)
	if err != nil {
		log.L.Error(err)
		return nil, err
	}
	ifaceName := strings.Trim(dev, "\n")

	iface, err := net.InterfaceByName(ifaceName)
	if err != nil {
		log.L.Errorf("lookup network iface %q: %v\n", ifaceName, err)
	}
	return iface, err
}

/*func getCNIIface() (*net.Interface, error) {
	ifaceName := "cni0"
	iface, err := net.InterfaceByName(ifaceName)
	if err != nil {
		log.L.Errorf("lookup network iface %q: %v\n", ifaceName, err)
	}
	return iface, err
}*/

var letterRunes = []rune("abcdef0123456789")

func RandStringRunes(n int) string {
	b := make([]rune, n)
	for i := range b {
		b[i] = letterRunes[rand.Intn(len(letterRunes))]
	}
	return string(b)
}

func generateMac() net.HardwareAddr {
	buf := make([]byte, 6)

	_, err := rand.Read(buf)
	if err != nil {
		log.L.Errorf("Can't generate MAC %v", err)
	}

	// Set the local bit
	buf[0] = 0x46
	buf[1] = 0x0C
	buf[2] = 0x3B

	return net.HardwareAddr(buf)
}

func setupCNI0() (*netlink.Link, error) {
	la := netlink.NewLinkAttrs()
	la.Name = "cni0"
	cnibridge := &netlink.Bridge{LinkAttrs: la}
	err := netlink.LinkAdd(cnibridge)
	if err != nil {
		log.L.Errorf("could not add %s: %v\n", la.Name, err)
		return nil, err
	}

	brdevice, _ := netlink.LinkByName("cni0")
	addr, _ := netlink.ParseAddr(fmt.Sprintf("%s/%d", (*PodAddressManager).GetCNIIfIP().String(), (*PodAddressManager).GetMask()))
	netlink.AddrAdd(brdevice, addr)

	err = netlink.LinkSetUp(brdevice)
	if err != nil {
		return nil, err
	}

	return &brdevice, nil
}

func setupCNIDummy(ip net.IP, id string) (*netlink.Link, error) {
	podIfName := fmt.Sprintf("dum%s", id)

	la := netlink.NewLinkAttrs()
	la.Name = podIfName
	podIf := &netlink.Tuntap{
		LinkAttrs: la,
		Mode:      netlink.TUNTAP_MODE_TAP,
	}
	err := netlink.LinkAdd(podIf)
	if err != nil {
		log.L.Errorf("could not add %s: %v\n", la.Name, err)
		return nil, err
	}
	time.Sleep(time.Millisecond * 100)

	netSize := 128
	if len(ip) == net.IPv4len {
		netSize = 32
	}

	poddevice, err := netlink.LinkByName(podIfName)
	if err != nil {
		log.L.Error(err)
	}
	addr, err := netlink.ParseAddr(fmt.Sprintf("%s/%d", ip.String(), netSize))
	if err != nil {
		log.L.Errorf("Failed to parse address %s %v", ip.String(), err)
	}
	err = netlink.AddrAdd(poddevice, addr)
	if err != nil {
		log.L.Errorf("Failed to add address %s to %s %v", ip.String(), poddevice.Attrs().Name, err)
	}

	err = netlink.LinkSetUp(poddevice)
	if err != nil {
		log.L.Errorf("Failed to set %s UP %v", poddevice.Attrs().Name, err)
	}
	if err != nil {
		return nil, err
	}

	return &poddevice, nil
}

func teardownNamespaces(podNamespaces map[string]netns.NsHandle) error {
	for netNs, _ := range podNamespaces {
		err := netns.DeleteNamed(netNs)
		if err != nil {
			return err
		}
	}

	return nil
}

func stopCNI0() error {
	brdevice, _ := netlink.LinkByName("cni0")
	return netlink.LinkDel(brdevice)
}

func setupPodNetNs(netNsName string, gwIp net.IP, ip net.IP, bridge netlink.Link) (*netlink.Link, *netlink.Link, *netns.NsHandle, error) {
	rootNetns, err := netns.Get()
	nsid, err := netns.NewNamed(netNsName)

	//netns.Set(rootNetns)
	trySetNs(rootNetns)

	if err != nil {
		return nil, nil, nil, err
	}

	/*
		#generate device name and create veth, linking it to container device
		rand=$(tr -dc 'A-F0-9' < /dev/urandom | head -c4)
		hostif="veth$rand"
		ip link add $cniif type veth peer name $hostif
	*/
	runes := RandStringRunes(4)
	hostIfName := fmt.Sprintf("veth%s", runes)
	contIfName := fmt.Sprintf("eth%s", runes)
	la := netlink.NewLinkAttrs()
	la.Name = contIfName
	vethPair := &netlink.Veth{
		LinkAttrs: la,
		PeerName:  hostIfName,
	}

	/*
		#link $hostif to cni0
		ip link set $hostif up
		ip link set $hostif master cni0
	*/
	err = netlink.LinkAdd(vethPair)
	if err != nil {
		log.L.Errorf("could not add %s: %v\n", la.Name, err)
		return nil, nil, nil, err
	}
	/*
		#link cniif, add it to the right namespace and add a route
		ip link set $cniif netns $containername
		ip netns exec $containername ip link set $cniif up
		ip netns exec $containername ip addr add $containerip/$subnetsize dev $cniif
		ip netns exec $containername ip route replace default via $gwip dev $cniif
	*/
	//time.Sleep(time.Millisecond * 100)
	hostIf, err := tryGetLink(hostIfName)
	if err != nil {
		return nil, nil, nil, err
	}
	err = trySetLinkUp(hostIf)
	if err != nil {
		return nil, nil, nil, err
	}
	err = netlink.LinkSetMaster(hostIf, bridge)
	if err != nil {
		return nil, nil, nil, err
	}

	contIf, _ := tryGetLink(contIfName) //netlink.LinkByName(contIfName)

	//containerIf, _ := netlink.LinkByName(contIfName)
	//atrs := containerIf.Attrs

	netSize := 112
	if len(ip) == net.IPv4len {
		netSize = 24
	}

	netlink.LinkSetNsFd(contIf, int(nsid))

	//Temp switch to container nsid, then back
	//origNetns, err := netns.Get()
	//netns.Set(nsid)
	trySetNs(nsid)

	addr, _ := netlink.ParseAddr(fmt.Sprintf("%s/%d", ip.String(), netSize))
	netlink.AddrAdd(contIf, addr)
	netlink.LinkSetUp(contIf)

	defaultIP, err := netlink.ParseIPNet("0.0.0.0/0")
	if err != nil {
		return nil, nil, nil, err
	}
	route := netlink.Route{
		Dst:       defaultIP,
		LinkIndex: contIf.Attrs().Index,
		Gw:        gwIp,
		//Scope:     netlink.SCOPE_LINK,
		//Via: net.Destination,
	}

	err = netlink.RouteAdd(&route)
	if err != nil {
		return nil, nil, nil, err
	}

	nsLoopback, err := netlink.LinkByName("lo")
	if err != nil {
		log.L.Errorf("Couldn't get loopback device for netns %s %v\n", netNsName, err)
		return nil, nil, nil, err
	}
	trySetLinkUp(nsLoopback)

	//netns.Set(rootNetns)
	trySetNs(rootNetns)
	return &hostIf, &contIf, &nsid, nil
}

func getNextSubPodIP(podState PodDevices) (net.IP, error) {
	start := podState.baseAddr
	used := len(podState.addressesUsed)
	if used == (*PodAddressManager).GetMaxIPsPerPod()-1 {
		return net.IP{}, errors.New(fmt.Sprintf("No IP addresses left for pod starting with %s", start.String()))
	}

	if len(start) == net.IPv4len {
		return int2ip(ip2int(start) + uint32(used) + 1), nil
	} else {
		nextAddr := start
		nextAddr[15] += byte(used + 1)
		return nextAddr, nil
	}
}
