package network

import (
	"fmt"
	"net"

	"github.com/cilium/ebpf"
	"github.com/cilium/ebpf/link"
	"github.com/pkg/errors"
	"github.com/virtual-kubelet/virtual-kubelet/log"
	netlink "github.com/vishvananda/netlink"
)

func loadToSubPodTC() (*ebpf.Program, *ebpf.Map) {
	if (*PodAddressManager).IsIPv4() {
		objs := BpfObjectsSplitGenericRedirectIPv4TC{}
		if err := loadObjectsBpfSplitGenericRedirectIPv4TC(&objs, nil); err != nil {
			log.L.Errorf("Error loading BpfSplitGenericRedirectIPv4TC %s", err)
		}

		log.L.Infof("Attached SplitGenericRedirectIPv4TC program")

		return objs.ProgFunc, objs.Map //&l, objs.Map
	} else {
		objs := BpfObjectsSplitGenericRedirectIPv6TC{}
		if err := loadObjectsBpfSplitGenericRedirectIPv6TC(&objs, nil); err != nil {
			log.L.Errorf("Error loading BpfSplitGenericRedirectIPv6TC %s", err)
			return nil, nil
		}

		log.L.Infof("Attached SplitGenericRedirectIPv6TC program")

		return objs.ProgFunc, objs.Map // &l, objs.Map
	}

}

func setupSubpodTC(podIf netlink.Link, subnet net.IP, fromSN *ebpf.Program, toSN *ebpf.Program) (*link.Link, []*ebpf.Map) {
	if (*PodAddressManager).IsIPv4() {
		objs := BpfObjectsTailCallIpv4TC{}
		/*opts := ebpf.CollectionOptions{
			Programs: ebpf.ProgramOptions{
				//LogSize:  5000,
				LogLevel: ebpf.LogLevelStats | ebpf.LogLevelInstruction | ebpf.LogLevelBranch,
			},
		}*/
		if err := loadObjectsBpfTailCallIpv4TC(&objs, nil); err != nil {
			log.L.Errorf("Error loading BpfTailCallIpv4TC %s", err)
		}

		err := objs.JumpTable.Put(uint32(0), uint32(toSN.FD()))
		if err != nil {
			log.L.Error(err)
		}
		err = objs.JumpTable.Put(uint32(1), uint32(fromSN.FD()))
		if err != nil {
			log.L.Error(err)
		}
		err = objs.SubnetMap.Put(uint32(0), ip2int(subnet))
		if err != nil {
			log.L.Error(err)
		}
		log.L.Infof("Added program info fromPod FD %d toPod FD %d subnet %s", fromSN.FD(), toSN.FD(), subnet.String())

		// Attach the program to Ingress TC.
		l, err := link.AttachTCX(link.TCXOptions{
			Interface: podIf.Attrs().Index,
			Program:   objs.ProgFunc,
			Attach:    ebpf.AttachTCXIngress,
		})
		if err != nil {
			log.L.Errorf("could not attach TCx program: %s", err)
		}

		log.L.Infof("Attached BpfTailCallIpv4TC program to iface %q (index %d mac %s)", podIf.Attrs().Name, podIf.Attrs().Index, podIf.Attrs().HardwareAddr.String())

		return &l, []*ebpf.Map{objs.SubnetMap, objs.JumpTable}
	} else {
		objs := BpfObjectsTailCallIpv6TC{}
		if err := loadObjectsBpfTailCallIpv6TC(&objs, nil); err != nil {
			panic(err)
		}

		// Attach the program to Ingress TC.
		l, err := link.AttachTCX(link.TCXOptions{
			Interface: podIf.Attrs().Index,
			Program:   objs.ProgFunc,
			Attach:    ebpf.AttachTCXIngress,
		})
		if err != nil {
			log.L.Errorf("could not attach TCx program: %s", err)
		}

		log.L.Infof("Attached BpfTailCallIpv6TC program to iface %q (index %d mac %s)", podIf.Attrs().Name, podIf.Attrs().Index, podIf.Attrs().HardwareAddr.String())

		return &l, []*ebpf.Map{objs.SubnetMap, objs.JumpTable}
	}
}

func loadFromSubPodTC() (*ebpf.Program, *ebpf.Map) {
	// Load pre-compiled programs into the kernel.
	if (*PodAddressManager).IsIPv4() {
		objs := BpfObjectsTranslateRedirectSubpodIpv4TC{}
		if err := loadObjectsTranslateRedirectSubpodIpv4TC(&objs, nil); err != nil {
			log.L.Errorf("Error loading TranslateRedirectSubpodIpv4TC %s", err)
			return nil, nil
		}

		log.L.Infof("Loaded TranslateRedirectSubpodIpv4TC program")

		return objs.ProgFunc, objs.Map
	} else {
		objs := BpfObjectsTranslateRedirectSubpodIpv6TC{}
		if err := loadObjectsTranslateRedirectSubpodIpv6TC(&objs, nil); err != nil {
			log.L.Errorf("Error loading TranslateRedirectSubpodIpv6TC %s", err)
			return nil, nil
		}

		log.L.Infof("Loaded TranslateRedirectSubpodIpv6TC program")

		return objs.ProgFunc, objs.Map
	}
}

/*func setupToLhTC(podIf netlink.Link) (*link.Link, *ebpf.Map) {
	if (*PodAddressManager).IsIPv4() {
		objs := BpfObjectsTranslateRedirectLhIpv4TC{}

		if err := loadObjectsTranslateRedirectLhIpv4TC(&objs, nil); err != nil {
			log.L.Errorf("Error loading BpfObjectsTranslateRedirectLhIpv4TC %s", err)
			return nil, nil
		}

		// Attach the program to Ingress TC.
		l, err := link.AttachTCX(link.TCXOptions{
			Interface: podIf.Attrs().Index,
			Program:   objs.ProgFunc,
			Attach:    ebpf.AttachTCXIngress,
		})
		if err != nil {
			log.L.Errorf("could not attach TCx program: %s", err)
			return nil, nil
		}

		log.L.Infof("Attached TranslateRedirectLhIpv4TC program to iface %q (index %d mac %s)", podIf.Attrs().Name, podIf.Attrs().Index, podIf.Attrs().HardwareAddr.String())

		return &l, objs.Map
	} else {
		objs := BpfObjectsTranslateRedirectLhIpv6TC{}

		if err := loadObjectsTranslateRedirectLhIpv6TC(&objs, nil); err != nil {
			log.L.Errorf("Error loading BpfObjectsTranslateRedirectLhIpv6TC %s", err)
			return nil, nil
		}

		// Attach the program to Ingress TC.
		l, err := link.AttachTCX(link.TCXOptions{
			Interface: podIf.Attrs().Index,
			Program:   objs.ProgFunc,
			Attach:    ebpf.AttachTCXIngress,
		})
		if err != nil {
			log.L.Errorf("could not attach TCx program: %s", err)
			return nil, nil
		}

		log.L.Infof("Attached TranslateRedirectLhIpv6TC program to iface %q (index %d mac %s)", podIf.Attrs().Name, podIf.Attrs().Index, podIf.Attrs().HardwareAddr.String())

		return &l, objs.Map
	}
}*/

func setupToLhXDP(podIf netlink.Link) (*link.Link, *ebpf.Map) {
	if (*PodAddressManager).IsIPv4() {
		objs := BpfObjectsTranslateRedirectLhIpv4XDP{}

		if err := loadObjectsTranslateRedirectLhIpv4XDP(&objs, nil); err != nil {
			log.L.Errorf("Error loading BpfObjectsTranslateRedirectLhIpv4XDP %s", err)
			return nil, nil
		}

		// Attach the program to Ingress TC.
		l, err := link.AttachXDP(link.XDPOptions{
			Interface: podIf.Attrs().Index,
			Program:   objs.ProgFunc,
			//Attach:    ebpf.AttachTCXIngress,
		})
		if err != nil {
			log.L.Errorf("could not attach XDP program: %s", err)
			return nil, nil
		}

		log.L.Infof("Attached TranslateRedirectLhIpv4XDP program to iface %q (index %d mac %s)", podIf.Attrs().Name, podIf.Attrs().Index, podIf.Attrs().HardwareAddr.String())

		return &l, objs.Map
	} else {
		objs := BpfObjectsTranslateRedirectLhIpv6XDP{}

		if err := loadObjectsTranslateRedirectLhIpv6XDP(&objs, nil); err != nil {
			log.L.Errorf("Error loading BpfObjectsSplitLhRedirectIPv6XDP %s", err)
			return nil, nil
		}

		// Attach the program to Ingress TC.
		l, err := link.AttachXDP(link.XDPOptions{
			Interface: podIf.Attrs().Index,
			Program:   objs.ProgFunc,
			//Attach:    ebpf.AttachTCXIngress,
		})
		if err != nil {
			log.L.Errorf("could not attach XDP program: %s", err)
			return nil, nil
		}

		log.L.Infof("Attached BpfObjectsSplitLhRedirectIPv6XDP program to iface %q (index %d mac %s)", podIf.Attrs().Name, podIf.Attrs().Index, podIf.Attrs().HardwareAddr.String())

		return &l, objs.Map
	}
}

func setupFromLhTC(podLhIf netlink.Link, lhIP net.IP) (*link.Link, *ebpf.Map, *ebpf.Map) {
	if (*PodAddressManager).IsIPv4() {
		objs := BpfObjectsSplitLhRedirectIPv4TC{}
		/*opts := ebpf.CollectionOptions{
			Programs: ebpf.ProgramOptions{
				//LogSize:  5000,
				LogLevel: ebpf.LogLevelStats | ebpf.LogLevelInstruction | ebpf.LogLevelBranch,
			},
		}*/
		if err := loadObjectsBpfSplitLhRedirectIPv4TC(&objs, nil); err != nil {
			log.L.Errorf("Error loading BpfObjectsSplitLhRedirectIPv4TC %s", err)
			return nil, nil, nil
		}

		err := objs.LhAddrMap.Put(uint32(0), ip2int(lhIP))
		if err != nil {
			log.L.Error(err)
			return nil, nil, nil
		}
		log.L.Infof("Added address info fromLH localhost IP", lhIP.String())

		// Attach the program to Ingress TC.
		l, err := link.AttachTCX(link.TCXOptions{
			Interface: podLhIf.Attrs().Index,
			Program:   objs.ProgFunc,
			Attach:    ebpf.AttachTCXIngress,
		})
		if err != nil {
			log.L.Errorf("could not attach TCx program: %s", err)
			return nil, nil, nil
		}

		log.L.Infof("Attached BpfObjectsSplitLhRedirectIPv4TC program to iface %q (index %d mac %s)", podLhIf.Attrs().Name, podLhIf.Attrs().Index, podLhIf.Attrs().HardwareAddr.String())

		return &l, objs.Map, objs.LhAddrMap
	} else {
		objs := BpfObjectsSplitLhRedirectIPv6TC{}

		if err := loadObjectsBpfSplitLhRedirectIPv6TC(&objs, nil); err != nil {
			log.L.Errorf("Error loading BpfObjectsSplitLhRedirectIPv6TC %s", err)
			return nil, nil, nil
		}

		err := objs.LhAddrMap.Put(uint32(0), ip2int(lhIP))
		if err != nil {
			log.L.Error(err)
			return nil, nil, nil
		}
		log.L.Infof("Added program info fromLH FD localhost IP", lhIP.String())

		// Attach the program to Ingress TC.
		l, err := link.AttachTCX(link.TCXOptions{
			Interface: podLhIf.Attrs().Index,
			Program:   objs.ProgFunc,
			Attach:    ebpf.AttachTCXIngress,
		})
		if err != nil {
			log.L.Errorf("could not attach TCx program: %s", err)
			return nil, nil, nil
		}

		log.L.Infof("Attached BpfObjectsSplitLhRedirectIPv6TC program to iface %q (index %d mac %s)", podLhIf.Attrs().Name, podLhIf.Attrs().Index, podLhIf.Attrs().HardwareAddr.String())

		return &l, objs.Map, objs.LhAddrMap
	}
}

/***********************************
BpfTailCallIpv4
***********************************/

type BpfObjectsTailCallIpv4TC struct {
	JumpTable *ebpf.Map     `ebpf:"jump_table"`
	SubnetMap *ebpf.Map     `ebpf:"ip_map"`
	ProgFunc  *ebpf.Program `ebpf:"lh_tails_ipv4"`
}

func loadBpfTailCallIpv4TC() (*ebpf.CollectionSpec, error) {
	spec, err := ebpf.LoadCollectionSpec("bpf_tail_call_ipv4.o")
	if err != nil {
		return nil, fmt.Errorf("can't load bpf: %w", err)
	}

	return spec, err
}

func loadObjectsBpfTailCallIpv4TC(obj interface{}, opts *ebpf.CollectionOptions) error {
	spec, err := loadBpfTailCallIpv4TC()
	if err != nil {
		return err
	}

	return spec.LoadAndAssign(obj, opts)
}

/***********************************
BpfTailCallIpv6
***********************************/

type BpfObjectsTailCallIpv6TC struct {
	JumpTable *ebpf.Map     `ebpf:"jump_table"`
	SubnetMap *ebpf.Map     `ebpf:"ip_map"`
	ProgFunc  *ebpf.Program `ebpf:"lh_tails_ipv6"`
}

func loadBpfTailCallIpv6TC() (*ebpf.CollectionSpec, error) {
	spec, err := ebpf.LoadCollectionSpec("bpf_tail_call_ipv6_tc.o")
	if err != nil {
		return nil, fmt.Errorf("can't load bpf: %w", err)
	}

	return spec, err
}

func loadObjectsBpfTailCallIpv6TC(obj interface{}, opts *ebpf.CollectionOptions) error {
	spec, err := loadBpfTailCallIpv6TC()
	if err != nil {
		return err
	}

	return spec.LoadAndAssign(obj, opts)
}

/***********************************
TranslateRedirectLhIpv4TC
***********************************/

func makeRedirectLhMapObject(targetIf netlink.Link, lhIp net.IP) interface{} {
	log.L.Infof("Creating redirect lh map object for localhost IP %s to target if %d", lhIp.String(), targetIf.Attrs().Index)
	if (*PodAddressManager).IsIPv4() {
		return RedirectLhRouteIPv4{
			//TargetIfIndex: uint32(targetIf.Attrs().Index),
			//DAddr:         ip2int(lhIp),
			SAddr: ip2int(lhIp),
			//SMac:          [6]uint8{0, 0, 0, 0, 0, 0},
			//DMac:          [6]uint8{0, 0, 0, 0, 0, 0},
		}
	} else {
		return RedirectLhRouteIPv6{
			//TargetIfIndex: uint32(targetIf.Attrs().Index),
			//DAddr:         [16]byte(lhIp),
			SAddr: [16]byte(lhIp),
			//SMac:          [6]uint8{0, 0, 0, 0, 0, 0},
			//DMac:          [6]uint8{0, 0, 0, 0, 0, 0},
		}
	}
}

/*func makeRedirectLhMapObject(targetIf netlink.Link, lhIp net.IP, src [6]byte, dst [6]byte) interface{} {
	if (*PodAddressManager).IsIPv4() {
		return RedirectLhRouteIPv4{
			TargetIfIndex: uint32(targetIf.Attrs().Index),
			DAddr:         ip2int(lhIp),
			SAddr:         ip2int(lhIp),
			SMac:          src,
			DMac:          dst,
		}
	} else {
		return RedirectLhRouteIPv6{
			TargetIfIndex: uint32(targetIf.Attrs().Index),
			DAddr:         [16]byte(lhIp),
			SAddr:         [16]byte(lhIp),
			SMac:          src,
			DMac:          dst,
		}
	}
}*/

type RedirectLhRouteIPv4 struct {
	TargetIfIndex uint32
	SAddr         uint32
	DAddr         uint32
	SMac          [6]uint8
	DMac          [6]uint8
}

type BpfObjectsTranslateRedirectLhIpv4TC struct {
	Map      *ebpf.Map     `ebpf:"tc_redirect_map"`
	ProgFunc *ebpf.Program `ebpf:"tc_lhredirect"`
}

func loadBpfTranslateRedirectLhIpv4TC() (*ebpf.CollectionSpec, error) {
	spec, err := ebpf.LoadCollectionSpec("translate_redirect_lh_ipv4_tc.o")
	if err != nil {
		return nil, fmt.Errorf("can't load bpf: %w", err)
	}

	return spec, err
}

func loadObjectsTranslateRedirectLhIpv4TC(obj interface{}, opts *ebpf.CollectionOptions) error {
	spec, err := loadBpfTranslateRedirectLhIpv4TC()
	if err != nil {
		return err
	}

	return spec.LoadAndAssign(obj, opts)
}

type BpfObjectsTranslateRedirectLhIpv4XDP struct {
	Map      *ebpf.Map     `ebpf:"xdp_redirect_map"`
	ProgFunc *ebpf.Program `ebpf:"xdp_lhredirect"`
}

func loadBpfTranslateRedirectLhIpv4XDP() (*ebpf.CollectionSpec, error) {
	spec, err := ebpf.LoadCollectionSpec("translate_redirect_lh_ipv4_xdp.o")
	if err != nil {
		return nil, fmt.Errorf("can't load bpf: %w", err)
	}

	return spec, err
}

func loadObjectsTranslateRedirectLhIpv4XDP(obj interface{}, opts *ebpf.CollectionOptions) error {
	spec, err := loadBpfTranslateRedirectLhIpv4XDP()
	if err != nil {
		return err
	}

	return spec.LoadAndAssign(obj, opts)
}

/***********************************
TranslateRedirectLhIpv6TC
***********************************/

type RedirectLhRouteIPv6 struct {
	TargetIfIndex uint32
	SAddr         [16]byte
	DAddr         [16]byte
	SMac          [6]uint8
	DMac          [6]uint8
}

type BpfObjectsTranslateRedirectLhIpv6TC struct {
	Map      *ebpf.Map     `ebpf:"tc_redirect_map"`
	ProgFunc *ebpf.Program `ebpf:"tc_lhredirect"`
}

func loadBpfTranslateRedirectLhIpv6TC() (*ebpf.CollectionSpec, error) {
	spec, err := ebpf.LoadCollectionSpec("translate_redirect_lh_ipv6_tc.o")
	if err != nil {
		return nil, fmt.Errorf("can't load bpf: %w", err)
	}

	return spec, err
}

func loadObjectsTranslateRedirectLhIpv6TC(obj interface{}, opts *ebpf.CollectionOptions) error {
	spec, err := loadBpfTranslateRedirectLhIpv6TC()
	if err != nil {
		return err
	}

	return spec.LoadAndAssign(obj, opts)
}

type BpfObjectsTranslateRedirectLhIpv6XDP struct {
	Map      *ebpf.Map     `ebpf:"xdp_redirect_map"`
	ProgFunc *ebpf.Program `ebpf:"xdp_lhredirect"`
}

func loadBpfTranslateRedirectLhIpv6XDP() (*ebpf.CollectionSpec, error) {
	spec, err := ebpf.LoadCollectionSpec("translate_redirect_lh_ipv6_xdp.o")
	if err != nil {
		return nil, fmt.Errorf("can't load bpf: %w", err)
	}

	return spec, err
}

func loadObjectsTranslateRedirectLhIpv6XDP(obj interface{}, opts *ebpf.CollectionOptions) error {
	spec, err := loadBpfTranslateRedirectLhIpv6XDP()
	if err != nil {
		return err
	}

	return spec.LoadAndAssign(obj, opts)
}

/***********************************
TranslateRedirectSubpodIpv4TC
***********************************/

type BpfObjectsTranslateRedirectSubpodIpv4TC struct {
	Map      *ebpf.Map     `ebpf:"tc_redirect_map"`
	ProgFunc *ebpf.Program `ebpf:"tc_subpodredirect"`
}

func loadBpfTranslateRedirectSubpodIpv4TC() (*ebpf.CollectionSpec, error) {
	spec, err := ebpf.LoadCollectionSpec("translate_redirect_subpod_ipv4_tc.o")
	if err != nil {
		return nil, fmt.Errorf("can't load bpf: %w", err)
	}

	return spec, err
}

func loadObjectsTranslateRedirectSubpodIpv4TC(obj interface{}, opts *ebpf.CollectionOptions) error {
	spec, err := loadBpfTranslateRedirectSubpodIpv4TC()
	if err != nil {
		return err
	}

	return spec.LoadAndAssign(obj, opts)
}

/***********************************
TranslateRedirectSubpodIpv6TC
***********************************/

/*
__u32 ifindex;
unsigned char smac[6];
unsigned char dmac[6];
*/
type RedirectRoute struct {
	TargetIfIndex uint32
	SMac          [6]uint8
	DMac          [6]uint8
}

type BpfObjectsTranslateRedirectSubpodIpv6TC struct {
	Map      *ebpf.Map     `ebpf:"tc_redirect_map"`
	ProgFunc *ebpf.Program `ebpf:"tc_subpodredirect"`
}

func loadBpfTranslateRedirectSubpodIpv6TC() (*ebpf.CollectionSpec, error) {
	spec, err := ebpf.LoadCollectionSpec("translate_redirect_subpod_ipv6_tc.o")
	if err != nil {
		return nil, fmt.Errorf("can't load bpf: %w", err)
	}

	return spec, err
}

func loadObjectsTranslateRedirectSubpodIpv6TC(obj interface{}, opts *ebpf.CollectionOptions) error {
	spec, err := loadBpfTranslateRedirectSubpodIpv6TC()
	if err != nil {
		return err
	}

	return spec.LoadAndAssign(obj, opts)
}

/***********************************
	SplitLhRedirectIPv4TC
************************************/

func putNextLhSplitRouteObj(bpfMap *ebpf.Map, routeObj interface{}) error {
	for i := 0; i < MaxIPv4IPsPerPod; i++ {
		if (*PodAddressManager).IsIPv4() {
			item := SplitLhRouteIPv4{}
			err := bpfMap.Lookup(uint32(i), &item)
			if err == nil && item.Active == 0 {
				err = bpfMap.Put(uint32(i), routeObj)
				log.L.Infof("Route object put at index %d", i)
				if err != nil {
					log.L.Errorf("Route object put error %v", err)
				}
				return err
			}
		} else {
			item := SplitLhRouteIPv6{}
			err := bpfMap.Lookup(uint32(i), &item)
			if err == nil && item.Active == 0 {
				err = bpfMap.Put(uint32(i), routeObj)
				log.L.Infof("Route object put at index %d", i)
				if err != nil {
					log.L.Errorf("Route object put error %v", err)
				}
				return err
			}
		}

	}
	return errors.Errorf("No more space in map to put routeobject %v", bpfMap)
}

func makeSplitLhRouteMapObject(srcIf netlink.Link, targetIf net.HardwareAddr, src net.IP, dest net.IP) interface{} {
	log.L.Infof("Creating split lh route map object from dev %d to %d src ip %s dst ip %s", srcIf.Attrs().Index, targetIf, src.String(), dest.String())
	if (*PodAddressManager).IsIPv4() {
		return SplitLhRouteIPv4{
			Active:        uint32(1),
			TargetIfIndex: uint32(srcIf.Attrs().Index),
			DAddr:         ip2int(dest),
			SAddr:         ip2int(src),
			SMac:          [6]uint8(srcIf.Attrs().HardwareAddr),
			DMac:          [6]uint8(targetIf),
		}
	} else {
		return SplitLhRouteIPv6{
			Active:        uint32(1),
			TargetIfIndex: uint32(srcIf.Attrs().Index),
			DAddr:         [16]byte(dest),
			SAddr:         [16]byte(src),
			SMac:          [6]uint8(srcIf.Attrs().HardwareAddr),
			DMac:          [6]uint8(targetIf),
		}
	}
}

type SplitLhRouteIPv4 struct {
	Active        uint32
	TargetIfIndex uint32
	SAddr         uint32
	DAddr         uint32
	SMac          [6]uint8
	DMac          [6]uint8
}

type BpfObjectsSplitLhRedirectIPv4TC struct {
	Map       *ebpf.Map     `ebpf:"tc_lh_map"`
	LhAddrMap *ebpf.Map     `ebpf:"tc_lhaddr_map"`
	ProgFunc  *ebpf.Program `ebpf:"tc_lh2split"`
}

func loadBpfSplitLhRedirectIPv4TC() (*ebpf.CollectionSpec, error) {
	spec, err := ebpf.LoadCollectionSpec("split_redirect_lh_ipv4_tc.o")
	if err != nil {
		return nil, fmt.Errorf("can't load bpf: %w", err)
	}

	return spec, err
}

func loadObjectsBpfSplitLhRedirectIPv4TC(obj interface{}, opts *ebpf.CollectionOptions) error {
	spec, err := loadBpfSplitLhRedirectIPv4TC()
	if err != nil {
		return err
	}

	return spec.LoadAndAssign(obj, opts)
}

/***********************************
	SplitLhRedirectIPv6TC
************************************/

type SplitLhRouteIPv6 struct {
	Active        uint32
	TargetIfIndex uint32
	SAddr         [16]byte
	DAddr         [16]byte
	SMac          [6]uint8
	DMac          [6]uint8
}

type BpfObjectsSplitLhRedirectIPv6TC struct {
	Map       *ebpf.Map     `ebpf:"tc_lh_map"`
	LhAddrMap *ebpf.Map     `ebpf:"tc_lhaddr_map"`
	ProgFunc  *ebpf.Program `ebpf:"tc_lh2split"`
}

func loadBpfSplitLhRedirectIPv6TC() (*ebpf.CollectionSpec, error) {
	spec, err := ebpf.LoadCollectionSpec("split_redirect_lh_ipv6_tc.o")
	if err != nil {
		return nil, fmt.Errorf("can't load bpf: %w", err)
	}

	return spec, err
}

func loadObjectsBpfSplitLhRedirectIPv6TC(obj interface{}, opts *ebpf.CollectionOptions) error {
	spec, err := loadBpfSplitLhRedirectIPv6TC()
	if err != nil {
		return err
	}

	return spec.LoadAndAssign(obj, opts)
}

/***********************************
	SplitGenericRedirectIPv4TC
************************************/

func putNextSplitRouteObj(bpfMap *ebpf.Map, routeObj interface{}) error {

	for i := 0; i < MaxIPv4IPsPerPod; i++ {
		if (*PodAddressManager).IsIPv4() {
			item := SplitRouteIPv4{}
			err := bpfMap.Lookup(uint32(i), &item)
			if err == nil && item.Active == 0 {
				err = bpfMap.Put(uint32(i), routeObj)
				log.L.Infof("Route object put at index %d", i)
				if err != nil {
					log.L.Errorf("Route object put error %v", err)
				}
				return err
			}
		} else {
			item := SplitRouteIPv6{}
			err := bpfMap.Lookup(uint32(i), &item)
			if err == nil && item.Active == 0 {
				err = bpfMap.Put(uint32(i), routeObj)
				log.L.Infof("Route object put at index %d", i)
				if err != nil {
					log.L.Errorf("Route object put error %v", err)
				}
				return err
			}
		}

	}
	return errors.Errorf("No more space in map to put routeobject %v", bpfMap)
}

func makeSplitRouteMapObject(srcIf netlink.Link, targetIf netlink.Link, destination net.IP) interface{} {
	if (*PodAddressManager).IsIPv4() {
		return SplitRouteIPv4{
			Active:        uint32(1),
			TargetIfIndex: uint32(srcIf.Attrs().Index),
			DAddr:         ip2int(destination),
			SMac:          [6]uint8(srcIf.Attrs().HardwareAddr),
			DMac:          [6]uint8(targetIf.Attrs().HardwareAddr),
		}
	} else {
		return SplitRouteIPv6{
			Active:        uint32(1),
			TargetIfIndex: uint32(srcIf.Attrs().Index),
			DAddr:         [16]byte(destination),
			SMac:          [6]uint8(srcIf.Attrs().HardwareAddr),
			DMac:          [6]uint8(targetIf.Attrs().HardwareAddr),
		}
	}
}

func makeSplitRouteMapObjectMac(srcIf netlink.Link, targetIf net.HardwareAddr, destination net.IP) interface{} {
	if (*PodAddressManager).IsIPv4() {
		return SplitRouteIPv4{
			Active:        uint32(1),
			TargetIfIndex: uint32(srcIf.Attrs().Index),
			DAddr:         ip2int(destination),
			SMac:          [6]uint8(srcIf.Attrs().HardwareAddr),
			DMac:          [6]uint8(targetIf),
		}
	} else {
		return SplitRouteIPv6{
			Active:        uint32(1),
			TargetIfIndex: uint32(srcIf.Attrs().Index),
			DAddr:         [16]byte(destination),
			SMac:          [6]uint8(srcIf.Attrs().HardwareAddr),
			DMac:          [6]uint8(targetIf),
		}
	}
}

type SplitRouteIPv4 struct {
	Active        uint32
	TargetIfIndex uint32
	//SAddr   [16]byte
	DAddr uint32
	SMac  [6]uint8
	DMac  [6]uint8
}

type BpfObjectsSplitGenericRedirectIPv4TC struct {
	Map      *ebpf.Map     `ebpf:"tc_split_map"`
	ProgFunc *ebpf.Program `ebpf:"tc_generic2split"`
}

func loadBpfSplitGenericRedirectIPv4TC() (*ebpf.CollectionSpec, error) {
	spec, err := ebpf.LoadCollectionSpec("split_redirect_generic_ipv4_tc.o")
	if err != nil {
		return nil, fmt.Errorf("can't load bpf: %w", err)
	}

	return spec, err
}

func loadObjectsBpfSplitGenericRedirectIPv4TC(obj interface{}, opts *ebpf.CollectionOptions) error {
	spec, err := loadBpfSplitGenericRedirectIPv4TC()
	if err != nil {
		return err
	}

	return spec.LoadAndAssign(obj, opts)
}

/***********************************
	SplitGenericRedirectIPv6TC
************************************/

type SplitRouteIPv6 struct {
	Active        uint32
	TargetIfIndex uint32
	//SAddr   [16]byte
	DAddr [16]byte
	SMac  [6]uint8
	DMac  [6]uint8
}

type BpfObjectsSplitGenericRedirectIPv6TC struct {
	Map      *ebpf.Map     `ebpf:"tc_split_map"`
	ProgFunc *ebpf.Program `ebpf:"tc_generic2split"`
}

func loadBpfSplitGenericRedirectIPv6TC() (*ebpf.CollectionSpec, error) {
	spec, err := ebpf.LoadCollectionSpec("split_redirect_generic_ipv6_tc.o")
	if err != nil {
		return nil, fmt.Errorf("can't load bpf: %w", err)
	}

	return spec, err
}

func loadObjectsBpfSplitGenericRedirectIPv6TC(obj interface{}, opts *ebpf.CollectionOptions) error {
	spec, err := loadBpfSplitGenericRedirectIPv6TC()
	if err != nil {
		return err
	}

	return spec.LoadAndAssign(obj, opts)
}
