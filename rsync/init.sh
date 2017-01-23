#!/usr/bin/bash

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
  useradd -u $USERID -g $curr_group docker
  exec sudo -u docker $@
fi
