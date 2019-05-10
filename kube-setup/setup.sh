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

log "## Add user ${USER} to user group 'docker'"
sudo groupadd docker
sudo gpasswd -a "${USER}" docker

newgrp docker<<SETUP_ENV
sudo ./setup_env.sh
SETUP_ENV