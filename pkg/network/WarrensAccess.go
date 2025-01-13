package network

import "net"

type WarrensTunnelAccess struct {
}

func (wta *WarrensTunnelAccess) InitExternalAccess() (WanAccessManager, error) {
	return wta, nil
}

func (wta *WarrensTunnelAccess) TeardownExternalAccess() error {
	return nil
}

func (wta *WarrensTunnelAccess) AddExternalNode(nodeIP net.IP, cniRange *net.IPNet) error {
	return nil
}
