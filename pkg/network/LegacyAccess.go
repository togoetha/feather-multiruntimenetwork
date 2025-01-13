package network

import (
	"net"

	netlink "github.com/vishvananda/netlink"
)

type LegacyExternalAccess struct {
}

/*
ip route add $subnet/16 via $routeip dev tap0

iptables -t filter -A FORWARD -s $subnet/16 -j ACCEPT
iptables -t filter -A FORWARD -d $subnet/16 -j ACCEPT
*/
func (lea *LegacyExternalAccess) InitExternalAccess() (WanAccessManager, error) {
	iface, err := getPublicIface()
	if err != nil {
		return nil, err
	}

	globalNet, err := (*PodAddressManager).GlobalCNINet()
	if err != nil {
		return nil, err
	}
	route := netlink.Route{
		Dst:       globalNet,
		LinkIndex: iface.Index,
	}
	err = netlink.RouteAdd(&route)
	return lea, err
}

func (lea *LegacyExternalAccess) TeardownExternalAccess() error {
	iface, err := getPublicIface()
	if err != nil {
		return err
	}

	globalNet, err := (*PodAddressManager).GlobalCNINet()
	if err != nil {
		return err
	}
	route := netlink.Route{
		Dst:       globalNet,
		LinkIndex: iface.Index,
	}
	err = netlink.RouteDel(&route)
	return err
}

func (lea *LegacyExternalAccess) AddExternalNode(nodeIP net.IP, cniRange *net.IPNet) error {
	iface, err := getPublicIface()
	if err != nil {
		return err
	}

	route := netlink.Route{
		Dst:       cniRange,
		LinkIndex: iface.Index,
		Gw:        nodeIP,
		//Via: net.Destination,
	}
	netlink.RouteAdd(&route)
	return nil
}
