#!/usr/bin/env bash

set -eo pipefail

# Find complete Azure guides here:
# https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-prepare-acr

# Deploying k8s applications in Azure requires:
# - having configured ACR (Azure Container Registry), being able to push images into it

# Build image
mvn clean package
docker images

RG_NAME="madkubedemo"
ACR_NAME="${RG_NAME}acr"
IMAGE_NAME="kube-stateful-cache"
IMAGE_VERSION="1.0-SNAPSHOT"

echo "## Push local image ${IMAGE_NAME} to ACR ${ACR_NAME}"
ACR_LOGIN_SERVER_ADDRESS=$(az acr list --resource-group "${RG_NAME}" --query "[].{acrLoginServer:loginServer}" --output tsv)
docker tag "${IMAGE_NAME}:${IMAGE_VERSION}" "${ACR_LOGIN_SERVER_ADDRESS}/${IMAGE_NAME}:${IMAGE_VERSION}"
docker push "${ACR_LOGIN_SERVER_ADDRESS}/${IMAGE_NAME}:${IMAGE_VERSION}"

echo "## Verify image was pushed successfully"
az acr repository list --name "${ACR_NAME}" --output tsv
az acr repository show-tags --name "${ACR_NAME}" --repository "${IMAGE_NAME}" --output tsv