#!/usr/bin/env bash

set -exo pipefail

# Find complete Azure guides here:
# https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-prepare-acr

# Deploying k8s applications in Azure requires:
# - configured ACR (Azure Container Registry), being able to push docker images into it
# - Azure Kubernetes Service (AKS) cluster
# - Azure service principal used by AKS cluster to access other Azure resources

RG_NAME="madkubedemo"
ACR_NAME="${RG_NAME}acr"
ACR_SP_NAME="${RG_NAME}sp"
AKS_NAME="${RG_NAME}aks"
SUBSCRIPTION_ID="$(az account show --query "id" --output tsv)"

echo "## Creating RG for Kube Demo: ${RG_NAME}"
az group create --name "${RG_NAME}" --location westeurope

echo "## Creating ACR"
az acr create --resource-group "${RG_NAME}" --name "${ACR_NAME}" --sku Basic
ACR_ID=$(az acr show --resource-group "${RG_NAME}" --name "${ACR_NAME}" --query "id" --output tsv)

echo "## Verifying ACR has been created successfully"
az acr login --name ${ACR_NAME}

echo "## Creating service principal to access ACR"
ACR_SP_CREDS=$(az ad sp create-for-rbac --name "${ACR_SP_NAME}" --subscription "${SUBSCRIPTION_ID}")
echo "${ACR_SP_CREDS}"
APP_ID=$(echo "${ACR_SP_CREDS}" | jq -r '.appId')
APP_PASSWORD=$(echo "${ACR_SP_CREDS}" | jq -r '.password')
az role assignment create --assignee "${APP_ID}" --scope "${ACR_ID}" --role acrpull

echo "## Creating AKS cluster"
az aks create \
    --resource-group "${RG_NAME}" \
    --name "${AKS_NAME}" \
    --node-count 1 \
    --service-principal "${APP_ID}" \
    --client-secret "${APP_PASSWORD}" \
    --generate-ssh-keys

echo "## Connecting kubectl to AKS cluster"
az aks get-credentials --resource-group "${RG_NAME}" --name "${AKS_NAME}"
kubectl get nodes