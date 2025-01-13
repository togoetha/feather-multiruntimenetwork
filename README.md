## Feather

This is a modified Feather implementation which hosts multi-runtime networking to provide pod networking capabilities between various workload runtimes. The main configuration files are present in cmd/fledge (which is the application entry point). Most options have a default value when omitted. Configuration options (cmdline or config file) of note are:

- NetworkMode: legacy/multiruntime/fullmultiruntime, from basic workload addressing (i.e. no pod addresses, no decent intrapod traffic possible) to full cross-runtime intrapod traffic including "localhost" features
- AgentMode: standalone/cluster (the latter requires Kubernetes certs/keys)
- DiskConfigDir: directory on disk from which to load deployments
- EnableWarrens: not highly relevant in this context, but will allow future networking integration with the decentralized networking concept Warrens
- UseIPv6: true/false, whether IPv6 should be used instead of default IPv4

The rest of this README contains the original information on Feather.


Feather makes extensive use of [virtual-kubelet](https://github.com/virtual-kubelet/virtual-kubelet)
to keep the code that is out of the scope of Feather to a minimum.

Because [source of the virtual-kubelet cli](https://github.com/virtual-kubelet/virtual-kubelet/tree/master/cmd/virtual-kubelet)
of is particularly useful, the code is used as a starting point.

#### Configuration

Certificates can be found on the master node at `/etc/kubernetes/pki`.

#### Building

Executing the provided script builds Feather for both `arm64` and `amd64`.
```sh
$ ./scripts/build.sh
```

#### Deployment

Feather can either be deployed temporarily, or as a systemd service.

##### Temporarily

The `scripts/deploy.sh` script builds Feather and copies it over to the worker node.
Currently the worker node is hard-coded as `worker0`, but this can be changed as required.
```
$ ./scripts/deploy.sh --log-level=info --config=default.json --provider=backend
```

##### Systemd Service

In order to persistently deploy Feather, it can be deployed as a systemd service.
An example systemd configuration for this service is shown below.
```ini
# /lib/systemd/system/feather.service
[Unit]
Description=feather virtual kubelet
After=network.target local-fs.target

[Service]
Type=simple
WorkingDirectory=/users/maxidcle/
Environment="KUBECONFIG=/users/maxidcle/.kube/kubeconfig.yml" "KUBERNETES_SERVICE_HOST=10.2.0.118" "KUBERNETES_SERVICE_PORT=6443"
ExecStart=/usr/bin/feather --log-level=info --config=default.json --provider=backend
Restart=always
RestartSec=5
LimitNPROC=infinity
LimitCORE=infinity
LimitNOFILE=infinity
TasksMax=infinity
OOMScoreAdjust=-999

[Install]
WantedBy=multi-user.target
```
