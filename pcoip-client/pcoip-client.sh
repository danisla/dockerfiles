#!/bin/bash

export DISPLAY=:1

xhost +

USER_ID=1000

cd ${HOME}/projects/pcoip-client
docker run -d --rm \
  -h ${HOSTNAME} \
  -v $(pwd)/.config/:/home/myuser/.config/Teradici \
  -v $(pwd)/.logs:/tmp/Teradici/$USER/PCoIPClient/logs \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /run/user/${USER_ID}/pulse:/run/user/${USER_ID}/pulse \
  -e PULSE_SERVER=unix:/run/user/${USER_ID}/pulse/native \
  -e DISPLAY=$DISPLAY \
  -u ${USER_ID} \
  danisla/pcoip-client:latest
