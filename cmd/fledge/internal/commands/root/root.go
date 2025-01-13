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
	"context"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"runtime"
	"strings"

	"gitlab.ilabt.imec.be/fledge/service/cmd/fledge/internal/fledgews"
	"gitlab.ilabt.imec.be/fledge/service/cmd/fledge/internal/provider"
	"gitlab.ilabt.imec.be/fledge/service/pkg/manager"
	"gitlab.ilabt.imec.be/fledge/service/pkg/network"

	"github.com/pkg/errors"
	"github.com/spf13/cobra"
	"github.com/virtual-kubelet/virtual-kubelet/errdefs"
	"github.com/virtual-kubelet/virtual-kubelet/log"
	"github.com/virtual-kubelet/virtual-kubelet/node"
	"github.com/virtual-kubelet/virtual-kubelet/node/api"
	"github.com/virtual-kubelet/virtual-kubelet/node/nodeutil"
	corev1 "k8s.io/api/core/v1"
	"k8s.io/apiserver/pkg/server/dynamiccertificates"
)

// NewCommand creates a new top-level command.
// This command is used to start the virtual-kubelet daemon
func NewCommand(ctx context.Context, name string, s *provider.Store, c Opts) *cobra.Command {
	cmd := &cobra.Command{
		Use:   name,
		Short: name + " provides a virtual kubelet interface for your kubernetes cluster.",
		Long: name + ` implements the Kubelet interface with a pluggable
backend implementation allowing users to create kubernetes nodes without running the kubelet.
This allows users to schedule kubernetes workloads on nodes that aren't running Kubernetes.`,
		RunE: func(cmd *cobra.Command, args []string) error {
			return runRootCommand(ctx, s, c)
		},
	}

	installFlags(cmd.Flags(), &c)
	return cmd
}

func runRootCommand(ctx context.Context, s *provider.Store, c Opts) error {
	if ok := provider.ValidOperatingSystems[c.OperatingSystem]; !ok {
		return errdefs.InvalidInputf("operating system %q is not supported", c.OperatingSystem)
	}

	if c.AgentMode == string(ClusterMode) {
		return StartVkubelet(ctx, s, c)
	} else {
		return StartStandalone(ctx, s, c)
	}
}

func StartStandalone(ctx context.Context, s *provider.Store, c Opts) error {
	baseDir := c.DiskConfigDir

	//Init container address space
	if c.UseIPv6 {
		ipManager := (&network.IPv6AddressManager{}).InitStandaloneAddressSpace()
		network.PodAddressManager = &ipManager
	} else {
		ipManager := (&network.IPv4AddressManager{}).InitStandaloneAddressSpace()
		network.PodAddressManager = &ipManager
	}
	//Init external access
	if c.EnableWarrens {
		accessMgr, err := (&network.WarrensTunnelAccess{}).InitExternalAccess()
		if err != nil {
			return err
		}
		network.WanManager = &accessMgr
	} else {
		accessMgr, err := (&network.LegacyExternalAccess{}).InitExternalAccess()
		if err != nil {
			return err
		}
		network.WanManager = &accessMgr
	}
	//Init container networking
	if c.NetworkMode == string(LegacyMode) {
		netManager, err := (&network.DefaultNetworkManager{}).InitContainerNetworking()
		if err != nil {
			return err
		}
		network.PodNetworkManager = &netManager
	} else if c.NetworkMode == string(MultiRuntime) {
		netManager, err := (&network.MultiRuntimeNetworkManager{}).InitContainerNetworking()
		if err != nil {
			return err
		}
		network.PodNetworkManager = &netManager
	} else {
		netManager, err := (&network.MRPodLocalNetworkManager{}).InitContainerNetworking()
		if err != nil {
			return err
		}
		network.PodNetworkManager = &netManager
	}

	provider, err := getProviderWithConfig(c, nil, s)
	if err != nil {
		return err
	}

	files, err := os.ReadDir(baseDir)
	if err != nil {
		log.L.Error(err)
	}

	//now we try to bullshit around a bit to see if the networking stuff up to now actually works
	//create a "pod" network for pod1
	//err = (*network.PodNetworkManager).InitPodNetwork("default", "pod1")
	//time.Sleep(time.Second)
	//err = (*network.PodNetworkManager).InitPodNetwork("default", "pod2")
	//time.Sleep(time.Second)
	//err = (*network.PodNetworkManager).InitPodNetwork("default", "pod3")
	//(*network.PodNetworkManager).AttachToNetNs()

	for _, file := range files {
		if !file.IsDir() {
			namePts := strings.Split(file.Name(), ".")
			if namePts[len(namePts)-1] == "fljson" {
				log.L.Infof("Reading %s\n", file.Name())
				fileBytes, err := os.ReadFile(file.Name())
				if err != nil {
					log.L.Errorf("Failed to read %d", file.Name)
				}
				pod := &corev1.Pod{}
				err = json.Unmarshal(fileBytes, pod)
				if err != nil {
					log.L.Errorf("Failed to parse %d", file.Name)
				} else {
					provider.CreatePod(ctx, pod)
				}
			}
		}
	}

	//(*network.PodNetworkManager).DeleteForTest()

	router := fledgews.KubeletRouter()
	fledgews.Ctx = &ctx
	fledgews.PodProvider = &provider
	log.L.Infof("Hosting API on port %d\n", 31138)

	srvError := make(chan error)
	go func() {
		err = http.ListenAndServe(fmt.Sprintf(":%d", 31138), router)
		if err != nil {
			log.L.Error(err)
		}
		srvError <- err
	}()

	err = nil
	select {
	case <-ctx.Done():
	case err = <-srvError:
		//case <-cm.Done():
		//	return cm.Err()
	}

	(*network.WanManager).TeardownExternalAccess()
	(*network.PodNetworkManager).TeardownContainerNetworking()

	return nil
}

func StartVkubelet(ctx context.Context, s *provider.Store, c Opts) error {
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	if c.PodSyncWorkers == 0 {
		return errdefs.InvalidInput("pod sync workers must be greater than 0")
	}

	var taint *corev1.Taint
	if !c.DisableTaint {
		var err error
		taint, err = getTaint(c)
		if err != nil {
			return err
		}
	}

	mux := http.NewServeMux()
	newProvider := func(cfg nodeutil.ProviderConfig) (nodeutil.Provider, node.NodeProvider, error) {
		rm, err := manager.NewResourceManager(ctx, cfg.Pods, cfg.Secrets, cfg.ConfigMaps, cfg.Services)
		if err != nil {
			return nil, nil, errors.Wrap(err, "could not create resource manager")
		}
		p, err := getProviderWithConfig(c, rm, s)
		if err != nil {
			return nil, nil, err
		}
		p.ConfigureNode(ctx, cfg.Node)
		cfg.Node.Status.NodeInfo.KubeletVersion = c.Version
		return p, nil, nil
	}

	apiConfig, err := getAPIConfig(c)
	if err != nil {
		return err
	}

	cm, err := nodeutil.NewNode(c.NodeName, newProvider, func(cfg *nodeutil.NodeConfig) error {
		cfg.KubeconfigPath = c.KubeConfigPath
		cfg.Handler = mux
		cfg.InformerResyncPeriod = c.InformerResyncPeriod

		if taint != nil {
			cfg.NodeSpec.Spec.Taints = append(cfg.NodeSpec.Spec.Taints, *taint)
		}
		cfg.NodeSpec.Status.NodeInfo.Architecture = runtime.GOARCH
		cfg.NodeSpec.Status.NodeInfo.OperatingSystem = c.OperatingSystem

		cfg.HTTPListenAddr = apiConfig.Addr
		cfg.StreamCreationTimeout = apiConfig.StreamCreationTimeout
		cfg.StreamIdleTimeout = apiConfig.StreamIdleTimeout
		cfg.DebugHTTP = true

		cfg.NumWorkers = c.PodSyncWorkers

		return nil
	},
		setAuth(c.NodeName, apiConfig),
		nodeutil.WithTLSConfig(
			nodeutil.WithKeyPairFromPath(apiConfig.CertPath, apiConfig.KeyPath),
			maybeCA(apiConfig.CACertPath),
		),
		nodeutil.AttachProviderRoutes(mux),
	)
	if err != nil {
		return err
	}

	if err := setupTracing(ctx, c); err != nil {
		return err
	}

	ctx = log.WithLogger(ctx, log.G(ctx).WithFields(log.Fields{
		"provider":         c.Provider,
		"operatingSystem":  c.OperatingSystem,
		"node":             c.NodeName,
		"watchedNamespace": c.KubeNamespace,
	}))

	go cm.Run(ctx) //nolint:errcheck

	defer func() {
		log.G(ctx).Debug("Waiting for controllers to be done")
		cancel()
		<-cm.Done()
	}()

	log.G(ctx).Info("Waiting for controller to be ready")
	if err := cm.WaitReady(ctx, c.StartupTimeout); err != nil {
		return err
	}

	log.G(ctx).Info("Ready")

	select {
	case <-ctx.Done():
	case <-cm.Done():
		return cm.Err()
	}
	return nil
}

func getProviderWithConfig(c Opts, rm *manager.ResourceManager, s *provider.Store) (provider.Provider, error) {
	initConfig := provider.InitConfig{
		ConfigPath:        c.ProviderConfigPath,
		NodeName:          c.NodeName,
		OperatingSystem:   c.OperatingSystem,
		ResourceManager:   rm,
		DaemonPort:        c.ListenPort,
		InternalIP:        os.Getenv("VKUBELET_POD_IP"),
		KubeClusterDomain: c.KubeClusterDomain,
	}
	pInit := s.Get(c.Provider)
	if pInit == nil {
		return nil, errors.Errorf("provider %q not found", c.Provider)
	}

	p, err := pInit(initConfig)
	if err != nil {
		return nil, errors.Wrapf(err, "error initializing provider %s", c.Provider)
	}
	return p, nil
}

func setAuth(node string, apiCfg *apiServerConfig) nodeutil.NodeOpt {
	if apiCfg.CACertPath == "" {
		return func(cfg *nodeutil.NodeConfig) error {
			cfg.Handler = api.InstrumentHandler(nodeutil.WithAuth(nodeutil.NoAuth(), cfg.Handler))
			return nil
		}
	}

	return func(cfg *nodeutil.NodeConfig) error {
		auth, err := WebhookAuth(cfg.Client, node, func(cfg *nodeutil.WebhookAuthConfig) error {
			var err error
			cfg.AuthnConfig.ClientCertificateCAContentProvider, err = dynamiccertificates.NewDynamicCAContentFromFile("ca-cert-bundle", apiCfg.CACertPath)
			return err
		})
		if err != nil {
			return err
		}
		cfg.Handler = api.InstrumentHandler(nodeutil.WithAuth(auth, cfg.Handler))
		return nil
	}
}

func maybeCA(p string) func(*tls.Config) error {
	if p == "" {
		return func(*tls.Config) error { return nil }
	}
	return nodeutil.WithCAFromPath(p)
}
