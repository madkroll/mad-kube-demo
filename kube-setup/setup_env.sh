#!/bin/bash

set -eo pipefail

###########################################
# INTERNAL FUNCTIONS
###########################################

function isodate() {
    date --iso-8601=seconds
}

function error() {
    echo "$(isodate): $@">&2
}

function log() {
    echo "$(isodate): $@"
}

log "## Updating 'apt-get'"
apt-get -qy update

log "## Installing 'java'"
add-apt-repository -y ppa:openjdk-r/ppa
apt-get -qy update
apt-get -qy install openjdk-8-jdk openjdk-8-jre

log "## Setup docker repository"
# Install packages to allow apt to use a repository over HTTPS:
apt-get install -qy \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
# Setup stable repository
add-apt-repository -y \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

log "## Installing 'docker CE'"
apt-get -qy update
apt-get install -qy docker-ce docker-ce-cli containerd.io
docker version

log "## Installing 'kubectl'"
apt-get -qy update
apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
apt-get -qy update
apt-get -qy install kubectl

log "## Installing 'kubectl autocomplete'"
kubectl completion bash >/etc/bash_completion.d/kubectl

log "## Installing 'minikube' (depends on virtualbox)"
apt-get install -qy virtualbox
curl -Lo minikube "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64" && chmod +x ./minikube
./minikube config set vm-driver virtualbox
cp ./minikube /usr/local/bin && rm ./minikube

log "## Installing 'snapd'"
# On old Ubuntu versions snapd may not be installed
# NOTE: This step may require OS reboot afterwards
# apt-get -qy install snapd

log "## Installing 'helm'"
snap install helm --classic