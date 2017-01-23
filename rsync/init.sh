#!/usr/bin/env bash

export curr_group=docker
if [[ "${GROUPID:-""}" =~ ^[0-9]+$ ]]; then
  export curr_group=$(getent group ${GROUPID})
  if [[ $? -eq 0 ]]; then
    curr_group=${curr_group%%:*}
  else
    groupadd -g $GROUPID $curr_group
  fi
fi

if [[ "${USERID:-""}" =~ ^[0-9]+$ ]]; then
  curr_user=$(id -u -n ${USERID} 2>/dev/null)
  if [[ $? -eq 0 ]]; then
    userdel ${curr_user}
  fi
fi

if [[ -z "${GROUPID}" && -z "${USERID}" ]]; then
  exec $@
else
  mkdir -p /home/docker
  useradd -u $USERID -g $curr_group -d /home/docker -s /bin/bash docker
  chown docker: /home/docker -R
  cd /home/docker
  exec sudo -H -u docker $@
fi
