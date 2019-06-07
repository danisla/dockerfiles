#!/bin/bash

set -e

command -v docker >/dev/null || (echo "ERROR: docker not installed" && exit 1)

# Pull the docker image to reduce initial startup time
docker pull danisla/pcoip-client:latest

DEST="/usr/local/bin/pcoip-client"

echo "INFO: Installing /usr/local/bin/pcoip-client"

curl -sfL https://raw.githubusercontent.com/danisla/dockerfiles/master/pcoip-client/pcoip-client.sh | \
  sudo tee ${DEST} >/dev/null
sudo chmod +x ${DEST}

echo "INFO: Installing launcher shortcut"

mkdir -p ${HOME}/.local/share/applications
cat > ${HOME}/.local/share/applications/PCoIP.desktop <<EOF
[Desktop Entry]
Name=PCoIP Client
Comment=PCoIP Client by Teradici
GenericName=PCoIP Client
X-GNOME-FullName=PCoIP Client
Exec=/usr/local/bin/pcoip-client
Terminal=false
Type=Application
Icon=application-default
Categories=Network;
EOF

echo "INFO: PCoIP Client Install complete, launch from Chrome Launcher menu"
