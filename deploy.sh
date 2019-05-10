#!/usr/bin/env bash

set -eo pipefail

# deploy stack
#kubectl create -f ./kube-deploy/kube-demo.yaml

# Authorize services to use Kubernetes API (to enable service discovery for Hazelcast)
# More info: https://github.com/hazelcast/hazelcast-kubernetes
kubectl apply -f ./kube-deploy/rbac.yaml

# delete stack
#kubectl delete -f ./kube-deploy/kube-demo.yaml

# open dashboard
#minikube dashboard

# list endpoints
#echo "## Stateless: $(minikube service kube-stateless-service --url)"
#echo "## Stateful: $(minikube service kube-stateful-cache-service --url)"

# list namespaces
#kubectl get namespace