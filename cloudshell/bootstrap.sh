#!/bin/bash

set -xe

# Install named packages from packages.txt
apt-get install -y -q $(grep -vE "^\s*#" /opt/cloudshell/packages.txt  | tr "\n" " ")

# Install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update && apt-get install -y docker-ce

# Install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose
chmod ugo+rwx /usr/local/bin/docker-compose

# Google Cloud SDK
curl -sSL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-160.0.0-linux-x86_64.tar.gz | tar zxf -
./google-cloud-sdk/install.sh
echo y | /google-cloud-sdk/bin/gcloud components install alpha beta kubectl bigtable datalab cloud-datastore-emulator pubsub-emulator docker-credential-gcr
chmod ugo+rw -R /google-cloud-sdk/

# AWS Command Line Tools
pip install --upgrade awscli

# MP3 Renaming tools
for f in rename.sh m4a2mp3 MP3_FileRename_FromID3.py; do
    curl -L https://raw.githubusercontent.com/danisla/dockerfiles/master/mp3tools/${f} > /usr/local/bin/${f}
    chmod +x /usr/local/bin/${f}
done
pip install mutagen==1.23