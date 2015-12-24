#!/usr/bin/env bash

function cleanup {
  kill `pidof sshd` 2>/dev/null
}
trap cleanup EXIT SIGINT SIGTERM

cleanup

SSH_GID=${SSH_GID:-1000}
SSH_UID=${SSH_UID:-1000}
SSH_USER=${SSH_USER:-git}

DATA_DIR=${DATA_DIR:-/git}
KEYS_DIR=${KEYS_DIR:-/etc/ssh/keys}

[[ ! -d ${DATA_DIR} ]] && mkdir -p ${DATA_DIR}
[[ ! -d ${KEYS_DIR} ]] && mkdir -p ${KEYS_DIR}

userdel ${SSH_USER} 2>/dev/null
groupdel ${SSH_USER} 2>/dev/null

groupdel `getent group ${SSH_GID} | awk -F: '{print $1}'` 2>/dev/null
userdel `getent passwd ${SSH_UID} | awk -F: '{print $1}'` 2>/dev/null

echo "INFO: Creating group: ${SSH_USER}:${SSH_GID}"
groupadd -g ${SSH_GID} ${SSH_USER}

echo "INFO: Creating user: ${SSH_USER}:${SSH_GID}"
useradd --shell /usr/bin/git-shell --home-dir ${DATA_DIR} --no-create-home -g ${SSH_GID} -u ${SSH_UID} ${SSH_USER}

chown ${SSH_UID}:${SSH_GID} ${DATA_DIR} -R 

/usr/sbin/sshd -e -D
