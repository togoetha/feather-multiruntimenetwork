package network

func GetNetNs(namespace string, pod string) string {
	return namespace + "-" + pod
}
