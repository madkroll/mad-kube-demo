#!/usr/bin/env bash

set -eo pipefail

# Start minikube
#minikube start

# Set docker env
eval $(minikube docker-env)

# Build image
mvn clean package

docker images

# Remember that unlike image deployed to Azure - minikube image does not have a repository prefix in this example.