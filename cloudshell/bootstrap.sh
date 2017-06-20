#!/bin/bash

set -xe

apt-get update

# Install named packages from packages.txt
apt-get install -y -q $(grep -vE "^\s*#" /opt/cloudshell/packages.txt  | tr "\n" " ")

# Install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update && apt-get install -y docker-ce

# Google Cloud SDK
curl -sSL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-158.0.0-linux-x86_64.tar.gz | tar zxf -
./google-cloud-sdk/install.sh

# AWS Command Line Tools
pip install --upgrade awscli

# Cleanup
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*