#!/bin/bash

set -eo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

###########################################
# INTERNAL FUNCTIONS
###########################################

function isodate() {
    date --iso-8601=seconds
}

function log() {
    echo "$(isodate): $@"
}

log "## Add user ${USER} to user group 'docker'"
sudo groupadd docker
sudo gpasswd -a "${USER}" docker

log "## Setup users under 'docker' group"
newgrp docker<<SETUP_ENV
sudo ${SCRIPT_DIR}/setup_env.sh
SETUP_ENV