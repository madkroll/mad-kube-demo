#!/usr/bin/env bash

set -eo pipefail

# Start minikube
#minikube start

# Set docker env
eval $(minikube docker-env)

# Build image
mvn clean package

docker images