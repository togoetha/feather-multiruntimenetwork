package network

import (
	"encoding/binary"
	"errors"
	"fmt"
	"hash/fnv"
	"math"
	"net"
	"os"
	"strconv"

	"github.com/virtual-kubelet/virtual-kubelet/log"
	"gitlab.ilabt.imec.be/fledge/service/pkg/config"
)

var MaxIPv4IPsPerPod = 8

type IPv4AddressManager struct {
	baseSubnetIP     uint32
	maxSubnetIP      uint32
	subnetMask       net.IPMask
	subIPsPerPod     int
	gatewayIP        uint32
	usedPodAddresses map[uint32]string
}

func (am *IPv4AddressManager) InitAddressSpace(nodeSubnet net.IP, subMask net.IPMask) CNAddressManager {
	am.subnetMask = subMask //strconv.Atoi(subMask)
	am.baseSubnetIP = ip2int(nodeSubnet)
	ones, bits := subMask.Size()
	am.subIPsPerPod = MaxIPv4IPsPerPod
	am.maxSubnetIP = ip2int(nodeSubnet) + uint32(math.Pow(2, float64(bits-ones)))
	am.gatewayIP = ip2int(nodeSubnet) + 1
	am.usedPodAddresses = make(map[uint32]string)
	return am
}

func (am *IPv4AddressManager) GetMask() int {
	ones, _ := am.subnetMask.Size()
	return ones
}

func (am *IPv4AddressManager) GetMaskAsAddr() net.IPMask {
	return am.subnetMask
}

func (am *IPv4AddressManager) GetMaxIPsPerPod() int {
	return am.subIPsPerPod
}

func (am *IPv4AddressManager) IsIPv4() bool {
	return true
}

func (am *IPv4AddressManager) InitStandaloneAddressSpace() CNAddressManager {
	am.subnetMask = net.IPv4Mask(0xFF, 0xFF, 0xFF, 0x0) //strconv.Atoi(subMask)
	am.baseSubnetIP = ip2int(initBaseIPv4())
	am.maxSubnetIP = am.baseSubnetIP + 255
	am.subIPsPerPod = MaxIPv4IPsPerPod
	am.gatewayIP = am.baseSubnetIP + 1
	am.usedPodAddresses = make(map[uint32]string)

	return am
}

func (am *IPv4AddressManager) RequestPodIP(namespace string, pod string) (net.IP, error) {
	freeIP := am.baseSubnetIP + uint32(MaxIPv4IPsPerPod)
	podName := namespace + "_" + pod
	_, taken := am.usedPodAddresses[freeIP]
	for taken {
		freeIP += uint32(am.subIPsPerPod)
		_, taken = am.usedPodAddresses[freeIP]
	}
	if freeIP < am.maxSubnetIP {
		ip := int2ip(freeIP)
		am.usedPodAddresses[freeIP] = podName
		return ip, nil
	} else {
		return net.IP{}, errors.New("Out of IP addresses")
	}
}

func (am *IPv4AddressManager) FreePodIP(namespace string, pod string) error {
	var foundIp uint32 = 0
	podName := namespace + "_" + pod
	for ip, cName := range am.usedPodAddresses {
		if cName == podName {
			foundIp = ip
		}
	}
	if foundIp > 0 {
		delete(am.usedPodAddresses, foundIp)
		return nil
	}
	return nil
}

func (am *IPv4AddressManager) GetCNIIfIP() net.IP {
	return int2ip(am.gatewayIP)
}

func (am *IPv4AddressManager) GetTunnelIfIP() net.IP {
	//Unsupported for IPv4 atm, not even sure if it'll still be required when going full ebpf
	return net.IP{}
}

func ip2int(ip net.IP) uint32 {
	if len(ip) == 16 {
		return binary.BigEndian.Uint32(ip[12:16])
	}
	return binary.BigEndian.Uint32(ip)
}

func int2ip(nn uint32) net.IP {
	ip := make(net.IP, 4)
	binary.BigEndian.PutUint32(ip, nn)
	return ip
}

/*func ipIntToString(ip int) (string, error) {
	var ipStr string = ""

	for ip > 0 {
		ipPart := ip % 256
		ipStr = strconv.Itoa(ipPart) + "." + ipStr
		ip = (ip - ipPart) / 256
	}

	return ipStr[0 : len(ipStr)-1], nil
}

func ipStringToInt(ipStr string) (int, error) {
	parts := strings.Split(ipStr, ".")
	var ip int = 0
	for i := 0; i < len(parts); i++ {
		p, _ := strconv.Atoi(parts[i])
		ip += p << uint(24-i*8)
	}
	return ip, nil
}*/

func initBaseIPv4() net.IP {
	if config.Cfg.Debug {
		return net.ParseIP(config.Cfg.CNIPrefix)
	}

	machineId, err := os.ReadFile("/etc/machine-id")
	if err != nil {
		log.L.Errorf("Couldn't read machine id %v", err)
	}
	hash := fnv.New64a()
	hash.Write(machineId)

	machineHash := fmt.Sprintf("%x", hash.Sum64())
	p1, _ := strconv.ParseUint(machineHash[0:2], 16, 16)
	p2, _ := strconv.ParseUint(machineHash[2:4], 16, 16)
	ipv4Base := fmt.Sprintf("10.%d.%d.0", p1, p2)

	return net.ParseIP(ipv4Base)

}

func (am *IPv4AddressManager) CNIGlobalIPRange() net.IP {
	ip := int2ip(am.baseSubnetIP)
	ip[0] = 0
	ip[1] = 0
	ip[2] = 0
	return ip
}

func (am *IPv4AddressManager) GlobalCNINet() (*net.IPNet, error) {
	//return net.IPv4Mask(0xFF, 0x00, 0x00, 0x0)
	_, net, err := net.ParseCIDR("10.0.0.0/8")

	if err != nil {
		return nil, err
	}

	return net, nil
}
