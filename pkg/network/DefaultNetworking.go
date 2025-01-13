package network

import (
	"fmt"
	"net"
	"time"

	"errors"

	"github.com/virtual-kubelet/virtual-kubelet/log"
	netlink "github.com/vishvananda/netlink"
	netns "github.com/vishvananda/netns"
)

type DefaultNetworkManager struct {
	podNamespaces map[string]netns.NsHandle
	podIPsUsed    map[string]int
	bridge        netlink.Link
}

/*
brctl addbr cni0
ip link set cni0 up
ip addr add $bridgeip/$mask dev cni0
*/
func (dn *DefaultNetworkManager) InitContainerNetworking() (CNIManager, error) {
	brdevice, err := setupCNI0()
	if err != nil {
		return nil, err
	}

	dn.podNamespaces = make(map[string]netns.NsHandle)
	//dn.podIPsUsed = make(map[string]int)
	dn.bridge = *brdevice

	return dn, nil
}

func (dn *DefaultNetworkManager) TeardownContainerNetworking() error {
	err := teardownNamespaces(dn.podNamespaces)
	if err != nil {
		log.L.Error(err)
	}
	err = stopCNI0()
	return err
}

/*
mkdir -p /var/run/netns
*/
func (dn *DefaultNetworkManager) InitPodNetwork(cns string, podname string) error {
	netNsName := GetNetNs(cns, podname)
	ip, err := (*PodAddressManager).RequestPodIP(cns, podname)
	if err != nil {
		return err
	}
	_, _, nsid, err := setupPodNetNs(netNsName, (*PodAddressManager).GetCNIIfIP(), ip, dn.bridge)

	if err != nil {
		return err
	}
	dn.podNamespaces[netNsName] = *nsid
	return nil
}

func (dn *DefaultNetworkManager) StopPodNetwork(cns string, podname string) error {
	netNsname := GetNetNs(cns, podname)
	return netns.DeleteNamed(netNsname)
}

func (dn *DefaultNetworkManager) DeleteForTest() {

}

func (dn *DefaultNetworkManager) GetNetNsHandle(cns string, podname string) (*netns.NsHandle, error) {
	netNsname := GetNetNs(cns, podname)
	netNs, found := dn.podNamespaces[netNsname]
	if !found {
		return nil, errors.New(fmt.Sprintf("Container network namespace for %s not found", netNsname))
	}

	return &netNs, nil
}

func (dn *DefaultNetworkManager) GetNetNsPath(cns string, podname string) (string, error) {
	netNsname := GetNetNs(cns, podname)
	_, found := dn.podNamespaces[netNsname]
	if !found {
		return "", errors.New(fmt.Sprintf("Container network namespace for %s not found", netNsname))
	}

	return netNsname, nil
}

func (dn *DefaultNetworkManager) CreateVMTun(cns string, podname string, containername string) (string, net.IP, net.HardwareAddr, error) {
	//netNsName := GetNetNs(cns, podname)
	//podDevs := mrn.podDevices[netNsName]
	//TODO FIX THIS
	vmIp, err := (*PodAddressManager).RequestPodIP(cns, podname)
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
	err = netlink.LinkSetMaster(tapIf, dn.bridge)
	if err != nil {
		log.L.Error(err)
		return "", net.IP{}, net.HardwareAddr{}, err
	}

	return ifName, vmIp, net.HardwareAddr{}, nil
}

func (dn *DefaultNetworkManager) GetGatewayAddress(cns string, podname string) net.IP {
	return (*PodAddressManager).GetCNIIfIP()
}
