#!/usr/bin/env bash

export UNAME=${UNAME:-cloudshell}

export curr_group=${UNAME}
if [[ "${GROUPID:-""}" =~ ^[0-9]+$ ]]; then
  check_group=$(getent group ${GROUPID})
  if [[ $? -eq 0 ]]; then
    export curr_group=${check_group%%:*}
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
  mkdir -p /home/${UNAME}
  useradd -u $USERID -g $curr_group -d /home/${UNAME} -s /bin/bash ${UNAME}
  ! test -e /home/${UNAME}/.bash_profile && echo ". /etc/profile.d/cloudshell" >> /home/${UNAME}/.bash_profile
  chown ${UNAME}: /home/${UNAME} -R
  cd /home/${UNAME}
  exec sudo -H -u ${UNAME} $@
fi
