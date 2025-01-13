package network

import (
	"errors"
	"fmt"
	"hash/fnv"
	"math"
	"net"
	"os"
	"strings"

	"github.com/virtual-kubelet/virtual-kubelet/log"
	"gitlab.ilabt.imec.be/fledge/service/pkg/config"
)

var MaxIPv6IPsPerPod = 16

type IPv6AddressManager struct {
	baseSubnetIP string

	subnetReservedIPs int
	subIPsPerPod      int
	maxSubnetIP       int

	subnetMask int

	usedPodAddresses map[string]string
}

func (am *IPv6AddressManager) GetMask() int {
	return am.subnetMask
}

func (am *IPv6AddressManager) GetMaskAsAddr() net.IPMask {
	mask := []byte{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	toFlip := am.subnetMask / 8
	for i := 0; i < toFlip; i++ {
		mask[i] = 255
	}
	return net.IPMask(mask)
}

func (am *IPv6AddressManager) GetMaxIPsPerPod() int {
	return am.subIPsPerPod
}

func (am *IPv6AddressManager) IsIPv4() bool {
	return false
}

func (am *IPv6AddressManager) InitAddressSpace(nodeSubnet net.IP, subMask net.IPMask) CNAddressManager {
	ones, bits := subMask.Size()
	am.subnetMask = ones //strconv.Atoi(subMask)
	am.subnetReservedIPs = 16
	am.subIPsPerPod = MaxIPv6IPsPerPod
	ipPts := strings.Split(nodeSubnet.String(), ":")
	am.baseSubnetIP = strings.Join(ipPts[0:len(ipPts)-1], ":")

	am.maxSubnetIP = int(math.Pow(2, float64(bits-ones)))
	//am.gatewayIP = ip2int(nodeSubnet) + 1
	am.usedPodAddresses = make(map[string]string)

	am.usedPodAddresses = make(map[string]string)
	return am
}

func (am *IPv6AddressManager) InitStandaloneAddressSpace() CNAddressManager {
	am.baseSubnetIP = initBaseIPv6()
	am.subnetReservedIPs = 16 //start at 16, we reserve 16 IP addresses for system interfaces i.e. cni, vpn, ..
	am.subIPsPerPod = MaxIPv6IPsPerPod
	am.maxSubnetIP = int(math.Pow(2, 16))
	am.subnetMask = 112

	am.usedPodAddresses = make(map[string]string)
	return am
}

func (am *IPv6AddressManager) RequestPodIP(namespace string, pod string) (net.IP, error) {
	freeIP := am.subnetReservedIPs
	podName := namespace + "_" + pod
	fullIP := getContainerIPv6(am.baseSubnetIP, freeIP)
	_, taken := am.usedPodAddresses[fullIP]
	for taken {
		freeIP += am.subIPsPerPod
		fullIP = getContainerIPv6(am.baseSubnetIP, freeIP)
		_, taken = am.usedPodAddresses[fullIP]
	}
	if freeIP < am.maxSubnetIP {
		am.usedPodAddresses[fullIP] = podName
		return net.ParseIP(fullIP), nil
	} else {
		return net.IP{}, errors.New("Out of IP addresses")
	}
}

func (am *IPv6AddressManager) FreePodIP(namespace string, pod string) error {
	var foundIp string = ""
	podName := namespace + "_" + pod
	for ip, cName := range am.usedPodAddresses {
		if cName == podName {
			foundIp = ip
		}
	}
	if foundIp != "" {
		delete(am.usedPodAddresses, foundIp)
	}
	return nil
}

func (am *IPv6AddressManager) GetTunnelIfIP() net.IP {
	//Not sure if this will be necessary when going full eBPF
	return net.ParseIP(fmt.Sprintf("%s:%s", am.baseSubnetIP, "1"))
}

func (am *IPv6AddressManager) GetCNIIfIP() net.IP {
	return net.ParseIP(fmt.Sprintf("%s:%s", am.baseSubnetIP, "2"))
}

func getContainerIPv6(baseSubnetIP string, container int) string {
	suffix := container + 16 //leave 4^2 dedicated addresses
	return fmt.Sprintf("%s:%x", baseSubnetIP, suffix)
}

func initBaseIPv6() string {
	if config.Cfg.Debug {
		return config.Cfg.CNIPrefix
	}

	machineId, err := os.ReadFile("/etc/machine-id")
	if err != nil {
		log.L.Errorf("Couldn't read machine id %v", err)
	}
	hash := fnv.New64a()
	hash.Write(machineId)

	machineHash := fmt.Sprintf("%x", hash.Sum64())
	ipv6Base := fmt.Sprintf("fd53:7769:726c:%s:%s:%s:%s", machineHash[0:4], machineHash[4:8], machineHash[8:12], machineHash[12:16])

	return ipv6Base

}

/*func (am *IPv6AddressManager) CNIGlobalIPRange() net.IP {
	return net.ParseIP("fd53:7769:726c::0")
}*/

func (am *IPv6AddressManager) GlobalCNINet() (*net.IPNet, error) {
	_, net, err := net.ParseCIDR("fd53:7769:726c::/48")

	if err != nil {
		return nil, err
	}

	return net, nil
}
