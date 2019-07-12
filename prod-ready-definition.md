# Containerization
Managed by docker / docker compose during a CI build. Can be called as a maven plugin or as a direct shell command.

### Docker

### ACR (Azure Container Registry)
- https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-prepare-acr
- https://docs.microsoft.com/en-us/azure/container-registry/container-registry-geo-replication
- https://docs.microsoft.com/en-us/azure/aks/operator-best-practices-container-image-management

# Versioning
Docker containers produced by different builds based on different source code versions should be tagged differently. One solution is to use versioning to increment version each time code was changed and tag produced container with this version.

# High availability

### Multi-region traffic routing
- https://docs.microsoft.com/en-us/azure/aks/operator-best-practices-multi-region#use-azure-traffic-manager-to-route-traffic

### Multi-region deployment
- https://docs.microsoft.com/en-us/azure/aks/operator-best-practices-multi-region

### Multi-region ACR geo replication
Premium, mirroring.
script to create ACR with efficient configuration
- https://docs.microsoft.com/en-us/azure/container-registry/container-registry-geo-replication

### Single AKS level
Running multiple pods on multiple nods.
- https://kubernetes.io/docs/tutorials/kubernetes-basics/create-cluster/cluster-intro/

> "A Kubernetes cluster that handles production traffic should have a minimum of three nodes."

Things to setup:
- scaling nodes
- scaling pods
- pods resource limits
- pods distribution over nodes cluster

# Performance requirements

### AKS setup
- https://docs.microsoft.com/en-us/azure/aks/best-practices

### Pod resource limits
- https://kubernetes.io/docs/tasks/configure-pod-container/
- https://docs.microsoft.com/en-us/azure/aks/developer-best-practices-resource-management#define-pod-resource-requests-and-limits

### Ingress-controller configuration

# Helm
Use helm to customize deployment templates and install 3rd party charts.

# Networking

### AKS setup
- https://docs.microsoft.com/en-us/azure/aks/operator-best-practices-network

### Public DNS configuration
Use traffic manager to setup DNS.

### Single service DNS configuration, static IP address
Managed by Ingress k8s component. Setup a DNS name for a given ingress-controller IP address.
- https://docs.microsoft.com/en-us/azure/aks/ingress-tls#configure-a-dns-name

### Whitelisting source IP addresses
First, use LB source IP ranges to specify whitelisted IP ranges - in Azure NSG:
```bash
helm install stable/nginx-ingress \
    --set controller.replicaCount=2 \
    --set controller.service.externalTrafficPolicy=Local \
    --set controller.service.loadBalancerSourceRanges={${COMMA_SEPARATED_CIDR_LIST}}
```

Second, setup on ingress-controller level.
In nginx-based ingress controller whitelisting is configured via annotations on ingress level.
- https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/
```yaml
nginx.ingress.kubernetes.io/whitelist-source-range: "185.5.121.222/32"
```

### SSL/TLS termination
Managed by Ingress k8s component. Installed to AKS cluster as a secret and used later during k8s deployment for a given application.
- https://docs.microsoft.com/en-us/azure/aks/ingress-own-tls
- https://docs.microsoft.com/en-us/azure/aks/ingress-tls


# Monitoring, logging
- https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-analyze

# Scaling

# SSH Jump / Remote control

# Recovering

# Healthcheck
- https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/

# Security management (keys, passwords, certificates)

### AKS cluster isolation
- https://docs.microsoft.com/en-us/azure/aks/operator-best-practices-cluster-isolation

### RBAC
- https://kubernetes.io/docs/reference/access-authn-authz/rbac/
- https://docs.microsoft.com/en-us/azure/aks/kubernetes-dashboard#for-rbac-enabled-clusters

### Storing secrets

# Read-only lock on deployed components
Use Azure Locks to prohibit accidental modifications of running systems.