// Copyright © 2017 The virtual-kubelet authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package root

import (
	"fmt"
	"os"
	"strings"

	"github.com/pkg/errors"
	"github.com/spf13/pflag"
	"gitlab.ilabt.imec.be/fledge/service/pkg/storage"
)

type mapVar map[string]string

func (mv mapVar) String() string {
	var s string
	for k, v := range mv {
		if s == "" {
			s = fmt.Sprintf("%s=%v", k, v)
		} else {
			s += fmt.Sprintf(", %s=%v", k, v)
		}
	}
	return s
}

func (mv mapVar) Set(s string) error {
	split := strings.SplitN(s, "=", 2)
	if len(split) != 2 {
		return errors.Errorf("invalid format, must be `key=value`: %s", s)
	}

	_, ok := mv[split[0]]
	if ok {
		return errors.Errorf("duplicate key: %s", split[0])
	}
	mv[split[0]] = split[1]
	return nil
}

func (mv mapVar) Type() string {
	return "map"
}

func installFlags(flags *pflag.FlagSet, c *Opts) {
	flags.StringVar(&c.KubeConfigPath, "kubeconfig", c.KubeConfigPath, "kube config file to use for connecting to the Kubernetes API server")

	flags.StringVar(&c.KubeNamespace, "namespace", c.KubeNamespace, "kubernetes namespace (default is 'all')")
	/* #nosec */
	flags.MarkDeprecated("namespace", "Nodes must watch for pods in all namespaces. This option is now ignored.") //nolint:errcheck
	/* #nosec */
	flags.MarkHidden("namespace") //nolint:errcheck

	flags.StringVar(&c.KubeClusterDomain, "cluster-domain", c.KubeClusterDomain, "kubernetes cluster-domain (default is 'cluster.local')")
	flags.StringVar(&c.NodeName, "nodename", c.NodeName, "kubernetes node name")
	flags.StringVar(&c.OperatingSystem, "os", c.OperatingSystem, "Operating System (Linux/Windows)")
	flags.StringVar(&c.Provider, "provider", c.Provider, "cloud provider")
	flags.StringVar(&c.ProviderConfigPath, "provider-config", c.ProviderConfigPath, "cloud provider configuration file")
	flags.StringVar(&c.MetricsAddr, "metrics-addr", c.MetricsAddr, "address to listen for metrics/stats requests")

	flags.StringVar(&c.TaintKey, "taint", c.TaintKey, "Set node taint key")

	flags.BoolVar(&c.DisableTaint, "disable-taint", c.DisableTaint, "disable the virtual-kubelet node taint")
	/* #nosec */
	flags.MarkDeprecated("taint", "Taint key should now be configured using the VK_TAINT_KEY environment variable") //nolint:errcheck

	flags.IntVar(&c.PodSyncWorkers, "pod-sync-workers", c.PodSyncWorkers, `set the number of pod synchronization workers`)

	flags.BoolVar(&c.EnableNodeLease, "enable-node-lease", c.EnableNodeLease, `use node leases (1.13) for node heartbeats`)
	/* #nosec */
	flags.MarkDeprecated("enable-node-lease", "leases are always enabled") //nolint:errcheck
	/* #nosec */
	flags.MarkHidden("enable-node-lease") //nolint:errcheck

	flags.StringSliceVar(&c.TraceExporters, "trace-exporter", c.TraceExporters, fmt.Sprintf("sets the tracing exporter to use, available exporters: %s", AvailableTraceExporters()))
	flags.StringVar(&c.TraceConfig.ServiceName, "trace-service-name", c.TraceConfig.ServiceName, "sets the name of the service used to register with the trace exporter")
	flags.Var(mapVar(c.TraceConfig.Tags), "trace-tag", "add tags to include with traces in key=value form")
	flags.StringVar(&c.TraceSampleRate, "trace-sample-rate", c.TraceSampleRate, "set probability of tracing samples")

	flags.DurationVar(&c.InformerResyncPeriod, "full-resync-period", c.InformerResyncPeriod, "how often to perform a full resync of pods between kubernetes and the provider")
	flags.DurationVar(&c.StartupTimeout, "startup-timeout", c.StartupTimeout, "How long to wait for the virtual-kubelet to start")
	flags.DurationVar(&c.StreamIdleTimeout, "stream-idle-timeout", c.StreamIdleTimeout,
		"stream-idle-timeout is the maximum time a streaming connection can be idle before the connection is"+
			" automatically closed, default 30s.")
	flags.DurationVar(&c.StreamCreationTimeout, "stream-creation-timeout", c.StreamCreationTimeout,
		"stream-creation-timeout is the maximum time for streaming connection, default 30s.")

	flags.StringVarP(&c.ConfigPath, "config", "c", "default.json", "set the config path")
	flags.StringVarP(&c.StoragePath, "storage", "s", storage.DefaultPath(), "Root directory used by FLEDGE")
	flags.StringVar(&c.NetworkMode, "networkMode", "fullmultiruntime", "Use FLEDGE legacy networking (pod-local not guaranteed for anything other than containers) or multi-runtime networking - legacy | multiruntime")
	flags.StringVar(&c.AgentMode, "agentMode", storage.DefaultPath(), "Run either in a Kubernetes cluster or as a standalone node. Standalone enables a custom Rest API service to receive deployments - cluster | standalone")
	flags.StringVar(&c.DiskConfigDir, "diskConfigDir", ".", "Disk directory for any pod configurations to preload. Only works with standalone mode.")
	flags.BoolVar(&c.EnableWarrens, "enableWarrens", false, "Enable Warrens self-organizing CNI for this node. Only works with standalone mode.")
	flags.BoolVar(&c.UseIPv6, "useIPv6", false, "Enables IPv6 networking for multi-runtime networking and Warrens.")

	// flagset := flag.NewFlagSet("klog", flag.PanicOnError)
	// klog.InitFlags(flagset)
	// flagset.VisitAll(func(f *flag.Flag) {
	// 	 f.Name = "klog." + f.Name
	//	 flags.AddGoFlag(f)
	// })
}

func getEnv(key, defaultValue string) string {
	value, found := os.LookupEnv(key)
	if found {
		return value
	}
	return defaultValue
}
