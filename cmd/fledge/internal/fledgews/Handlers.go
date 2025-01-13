package fledgews

import (
	"context"
	"encoding/json"
	"net/http"
	"regexp"
	"strconv"
	"strings"

	corev1 "k8s.io/api/core/v1"

	"github.com/virtual-kubelet/virtual-kubelet/log"
	"gitlab.ilabt.imec.be/fledge/service/cmd/fledge/internal/provider"

	//"gitlab.ilabt.imec.be/fledge/service/pkg/provider"
	"gitlab.ilabt.imec.be/fledge/service/pkg/util"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	stats "k8s.io/kubelet/pkg/apis/stats/v1alpha1"
)

var totalNanoCores uint64
var reInsideWhtsp = regexp.MustCompile(`\s+`)
var PodProvider *provider.Provider
var Ctx *context.Context

// PID limit: cat /proc/sys/kernel/pid_max
func StatsSummary(w http.ResponseWriter, r *http.Request) {
	log.L.Info("StatsSummary")

	nodenameStr, _ := util.ExecShellCommand("hostname")
	nodename := strings.TrimSuffix(nodenameStr, "\n")

	//CPU STUFF, REFACTOR TO METHOD
	cpuStatsStr, _ := util.ExecShellCommand("mpstat 1 1 | grep 'all'")

	nProc, _ := util.ExecShellCommand("nproc")
	numCpus, _ := strconv.Atoi(strings.Trim(nProc, "\n"))

	cpuStatsLines := strings.Split(cpuStatsStr, "\n")
	//cpuStatsStr = strings.TrimSuffix(cpuStatsStr, "\n")
	cpuCats := strings.Split(reInsideWhtsp.ReplaceAllString(cpuStatsLines[0], " "), " ")
	cpuIdle, _ := strconv.ParseFloat(cpuCats[len(cpuCats)-1], 64)

	cpuNanos := uint64((100-cpuIdle)*10000000) * uint64(numCpus) //pct is already 10^2, so * 10^7, then * cores.

	//TODO: take time into account here (cpuNanos * seconds passed since last check)
	totalNanoCores += cpuNanos

	cpuStats := stats.CPUStats{
		Time:                 metav1.Now(),
		UsageNanoCores:       &cpuNanos,
		UsageCoreNanoSeconds: &totalNanoCores,
	}

	//MEM STUFF, REFACTOR TO METHOD
	memStatsStr, _ := util.ExecShellCommand("free | grep 'Mem:'")
	cats := strings.Split(reInsideWhtsp.ReplaceAllString(memStatsStr, " "), " ")
	memFree, _ := strconv.ParseUint(cats[6], 10, 64)
	memSize, _ := strconv.ParseUint(cats[1], 10, 64)

	memStatsStr, _ = util.ExecShellCommand("free | grep '+'")
	//bailout for older free versions, in which case this is more accurate for "available" memory
	if memStatsStr != "" {
		cats := strings.Split(reInsideWhtsp.ReplaceAllString(memStatsStr, " "), " ")
		memFree, _ = strconv.ParseUint(cats[2], 10, 64)
	}

	memUsed := memSize - memFree

	memStats := stats.MemoryStats{
		Time:            metav1.Now(),
		UsageBytes:      &memUsed,
		AvailableBytes:  &memFree,
		WorkingSetBytes: &memUsed,
	}

	//NETWORK STUFF, REFACTOR TO METHOD

	//ifnames: / # ip a | grep -o -E '[0-9]: [a-z0-9]*: '

	ifacesStr, _ := util.ExecShellCommand("ip a | grep -o -E '[0-9]{1,2}: [a-z0-9]*: ' | grep -o -E '[a-z0-9]{2,}'")
	ifaces := strings.Split(ifacesStr, "\n")

	//ifstats: ifconfig enp1s0f0 | grep 'bytes'
	//      RX bytes:726654708 (692.9 MiB)  TX bytes:456250038 (435.1 MiB)

	ifacesStats := []stats.InterfaceStats{}
	for _, iface := range ifaces {
		ifaceStatsStr, _ := util.ExecShellCommand("ifconfig " + iface + "| grep 'bytes'")
		log.L.Info(ifaceStatsStr)
		//TODO from here on
	}

	netStats := stats.NetworkStats{
		Time:       metav1.Now(),
		Interfaces: ifacesStats,
	}

	nodeStats := stats.NodeStats{
		NodeName:  nodename,
		StartTime: metav1.NewTime((*PodProvider).GetStartTime()),
		CPU:       &cpuStats,
		Memory:    &memStats,
		Network:   &netStats,
		//Fs: ,
		//Runtime: ,
		//Rlimit: ,
	}

	summary := stats.Summary{
		Node: nodeStats,
	}

	if err := json.NewEncoder(w).Encode(summary); err != nil {
		log.L.Error(err)
	}
}

func DeployPod(w http.ResponseWriter, r *http.Request) {
	decoder := json.NewDecoder(r.Body)
	pod := &corev1.Pod{}
	err := decoder.Decode(pod)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
	}
	if PodProvider == nil || Ctx == nil {
		http.Error(w, "FLEDGE pod provider not (yet) initialized", http.StatusBadRequest)
	}
	(*PodProvider).CreatePod(*Ctx, pod)
}

func DeletePod(w http.ResponseWriter, r *http.Request) {
	decoder := json.NewDecoder(r.Body)
	pod := &corev1.Pod{}
	err := decoder.Decode(pod)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
	}
	if PodProvider == nil || Ctx == nil {
		http.Error(w, "FLEDGE pod provider not (yet) initialized", http.StatusBadRequest)
	}
	(*PodProvider).DeletePod(*Ctx, pod)
}

func GetPods(w http.ResponseWriter, r *http.Request) {
	log.L.Info("GetPods")

	pods, err := (*PodProvider).GetPods(*Ctx)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	if err := json.NewEncoder(w).Encode(pods); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
	}
}
