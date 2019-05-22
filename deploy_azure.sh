#!/usr/bin/env bash

set -eo pipefail

# This script assumes target AKS is running

DEPLOYMENT_NAME="mad-kube-demo"
CERTIFICATE_NAME="${DEPLOYMENT_NAME}-cert"
SECRET_NAME="${DEPLOYMENT_NAME}-secret"

DNS_NAME_LABEL="${DEPLOYMENT_NAME}-dns"

echo "## Deploying nginx-based ingress controller"
# More on that:
# https://docs.microsoft.com/en-us/azure/aks/ingress-basic
# Use Helm to deploy an NGINX ingress controller
helm install stable/nginx-ingress --set controller.replicaCount=2 --set controller.service.externalTrafficPolicy=Local

# TODO: wait until IP address is assigned, you check a state by: kubectl get services
# TODO: if empty - fail

echo "## Update public ip address with DNS name"
# Public IP address of your ingress controller
PUBLIC_IP=$(kubectl get service -l component=controller,app=nginx-ingress -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")
# Get the resource-id of the public ip
PUBLIC_IP_ID=$(az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$PUBLIC_IP')].[id]" --output tsv)
az network public-ip update --ids "${PUBLIC_IP_ID}" --dns-name "${DNS_NAME_LABEL}"

echo "## Generating and installing certificate/private key pair"
pushd $(mktemp -d)
    openssl req -x509 -newkey rsa:4096 -nodes \
        -subj "/C=NL/ST=North Holland/L=Amsterdam/O=TomTom/OU=LNS/CN=${DNS_NAME_LABEL}.westeurope.cloudapp.azure.com" \
        -keyout "${CERTIFICATE_NAME}.key" \
        -out "${CERTIFICATE_NAME}.crt"

    kubectl create secret tls "${SECRET_NAME}" \
        --key "${CERTIFICATE_NAME}.key" \
        --cert "${CERTIFICATE_NAME}.crt"
popd

## deploy stack
kubectl create -f ./kube-deploy/kube-demo.yaml