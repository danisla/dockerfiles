#!/bin/bash

export DISPLAY=:1

xhost +

cd ${HOME}/projects/pcoip-client
docker run -d --rm \
  -h ${HOSTNAME} \
  -v $(pwd)/.config/:/home/myuser/.config/Teradici \
  -v $(pwd)/.logs:/tmp/Teradici/$USER/PCoIPClient/logs \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY danisla/pcoip-client:latest

