#!/usr/bin/env bash

function cleanup {
  kill `pidof tail` 2>/dev/null
  kill `pidof java` 2>/dev/null
}
trap cleanup EXIT
trap cleanup INT

cleanup

STATE_DIR=/opt/app/state

# Create the subsonic user using provided uid. 
SUBSONIC_UID=${SUBSONIC_UID:-${1:-1000}}
SUBSONIC_GID=${SUBSONIC_GID:-${2:-1000}}
UNAME=`id -u -n ${SUBSONIC_UID} 2>/dev/null`
if [[ $? -ne 0 ]]; then
  echo "INFO: Creating subsonic user with uid and gid: ${SUBSONIC_UID}:${SUBSONIC_GID}"
  groupadd -g $SUBSONIC_GID subsonic
  useradd -g $SUBSONIC_GID -u $SUBSONIC_UID subsonic
  UNAME=subsonic
fi

chown -R ${UNAME}:${UNAME} /opt/app/state

# Copy the transcode binaries
if [[ ! -d ${STATE_DIR}/transcode ]]; then
  sudo -u ${UNAME} mkdir -p ${STATE_DIR}/transcode
fi
echo "INFO: Copying transcode binaries to state dir"
sudo -u ${UNAME} cp -Rf /opt/ffmpeg/* ${STATE_DIR}/transcode/

echo "INFO: Updating /etc/default/subsonic"

cat > /etc/default/subsonic << EOM
SUBSONIC_ARGS="--max-memory=${SUBSONIC_MAX_MEMORY:-512} --home=${STATE_DIR} --port=4040 --default-music-folder=/mnt/music --context-path=${SUBSONIC_CONTEXT_PATH}"
SUBSONIC_USER=${UNAME}
export LANG=${LANG}
export LANGUAGE=${LANG}
export LC_ALL=${LANG}
EOM

service subsonic start

RES=$?
if [[ ! ${RES} -eq 0 ]]; then
  echo "ERROR: Exit code was ${RES}"
  exit 1
fi

TAIL_FILES="${STATE_DIR}/subsonic.log ${STATE_DIR}/subsonic_sh.log"

for WATCH_FILE in $TAIL_FILES; do
  while ! stat ${WATCH_FILE} >/dev/null 2>&1; do
    echo "Waiting for ${WATCH_FILE}"
    sleep 1
  done
done

tail -f $TAIL_FILES &

while kill -0 `pidof java` 2>/dev/null; do
  sleep 0.5
done
