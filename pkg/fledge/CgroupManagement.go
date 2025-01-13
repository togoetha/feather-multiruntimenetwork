package fledge

import (
	"fmt"

	cgroups "github.com/containerd/cgroups"
	cgroupsv2 "github.com/containerd/cgroups/v2"
	specs "github.com/opencontainers/runtime-spec/specs-go"
	"github.com/virtual-kubelet/virtual-kubelet/log"
)

var MainGroup *cgroups.Cgroup

// var Manager *cgroupsv2.Manager
var Cgroups map[string]*cgroups.Cgroup
var CgV2 bool
var Rsrc cgroupsv2.Resources

func InitCgroups() {
	if cgroups.Mode() == cgroups.Unified {
		CgV2 = true
		Rsrc = cgroupsv2.Resources{}
	} else {
		CgV2 = false
		maingroup, err := cgroups.New(cgroups.V1, cgroups.StaticPath("/vkubelet"), &specs.LinuxResources{})
		if err != nil {
			log.L.Error(err)
		}

		MainGroup = &maingroup
		//fmt.Println(MainGroup)
		Cgroups = make(map[string]*cgroups.Cgroup)
	}
}

func GetCgroup(namespace string, podname string, container string) string {
	cgName := fmt.Sprintf("%s-%s-%s", namespace, podname, container)
	return cgName
}

func CreateCgroupIfNotExists(namespace string, podname string, container string) string {
	cgName := GetCgroup(namespace, podname, container)
	if !CgroupExists(cgName) {
		CreateCgroup(cgName)
	}
	return cgName
}

func CreateCgroup(cgName string) {
	log.L.Info("CreateCgroup")

	if CgV2 {
		//res := cgroupsv2.Resources{}
		_, err := cgroupsv2.NewSystemd("/", fmt.Sprintf("%s.slice", cgName), -1, &Rsrc)
		if err != nil {
			log.L.Error(err)
		}
		//Manager = m
	} else {
		newGroup, err := (*MainGroup).New(cgName, &specs.LinuxResources{})
		if err != nil {
			log.L.Error("Error creating new group")
		}
		Cgroups[cgName] = &newGroup
	}
}

func CgroupExists(cgName string) bool {
	log.L.Info("CgroupExists")
	if CgV2 {
		m, err := cgroupsv2.LoadSystemd("/", fmt.Sprintf("%s.slice", cgName))
		return m != nil && err == nil
	} else {
		val, exists := Cgroups[cgName]
		return exists || val == nil
	}
	//return false
}

func DeleteCgroup(cgName string) {
	log.L.Info("DeleteCgroup")
	if CgV2 {
		m, err := cgroupsv2.LoadSystemd("/", fmt.Sprintf("%s.slice", cgName))
		if err != nil {
			log.L.Error(err)
		}
		err = m.DeleteSystemd()
		if err != nil {
			log.L.Error(err)
		}
	} else {
		group := Cgroups[cgName]
		(*group).Delete()
		Cgroups[cgName] = nil
	}
}

func SetMemoryLimit(cgName string, limit int64) {
	log.L.Info("SetMemoryLimit")
	if CgV2 {
		m, err := cgroupsv2.LoadSystemd("/", fmt.Sprintf("%s.slice", cgName))
		if err != nil {
			log.L.Error(err)
			return
		}
		res := cgroupsv2.Resources{
			Memory: &cgroupsv2.Memory{
				Max: &limit,
			},
		}
		err = m.Update(&res)
		if err != nil {
			log.L.Error(err)
		}
	} else {
		cgroup := *Cgroups[cgName]
		specs := &specs.LinuxResources{
			Memory: &specs.LinuxMemory{
				Limit: &limit,
			},
		}
		cgroup.Update(specs)
	}
}

func SetCpuLimit(cgName string, cpus float64) {
	log.L.Info("SetCPULimit")

	if CgV2 {
		m, err := cgroupsv2.LoadSystemd("/", fmt.Sprintf("%s.slice", cgName))
		if err == nil {
			log.L.Error(err)
			return
		}
		period := uint64(100000)
		quota := int64(100000 * cpus)

		res := cgroupsv2.Resources{
			CPU: &cgroupsv2.CPU{
				Max: cgroupsv2.NewCPUMax(&quota, &period),
			},
		}
		err = m.Update(&res)
		if err != nil {
			log.L.Error(err)
		}
	} else {
		period := uint64(100000)
		quota := int64(100000 * cpus)

		cgroup := *Cgroups[cgName]
		specs := &specs.LinuxResources{
			CPU: &specs.LinuxCPU{
				Period: &period,
				Quota:  &quota,
			},
		}
		cgroup.Update(specs)
	}
}

func MovePid(cgName string, pid uint64) {
	log.L.Info("MovePID")

	if CgV2 {
		m, err := cgroupsv2.LoadSystemd("/", fmt.Sprintf("%s.slice", cgName))
		if err == nil {
			log.L.Error(err)
		}
		m.AddProc(pid)
	} else {
		cgroup := *Cgroups[cgName]
		cgroup.AddProc(pid)
	}
}
