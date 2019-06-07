#!/bin/bash

set -e

command -v docker >/dev/null || (echo "ERROR: docker not installed" && exit 1)

DEST=/usr/local/bin/pcoip-client

echo "INFO: Installing /usr/local/bin/pcoip-client"

curl -sfLO https://raw.githubusercontent.com/danisla/dockerfiles/master/pcoip-client/pcoip-client.sh | \
  sudo tee > ${DEST}
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
