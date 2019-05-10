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
# This installs Open JDK 12
#mkdir -p /usr/lib/jvm/
#curl "https://download.oracle.com/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_linux-x64_bin.tar.gz" \
#    | tar xvz -C /usr/lib/jvm/

# This installs Oracle JDK 11
#add-apt-repository -y ppa:linuxuprising/java
#apt-get -qy update
#echo oracle-java11-installer shared/accepted-oracle-license-v1-2 select true | /usr/bin/debconf-set-selections
#apt-get -qy install oracle-java10-set-default

#add-apt-repository -y ppa:openjdk-r/ppa
#apt-get -qy update
#apt-get -qy install openjdk-8-jdk openjdk-8-jre