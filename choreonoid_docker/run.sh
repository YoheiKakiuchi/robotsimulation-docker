#!/bin/bash

#DOCKER=docker
DOCKER=nvidia-docker

### ???
${DOCKER} rm choreonoid_simulation

${DOCKER} run -it \
    --name="choreonoid_simulation" \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -w="/home/choreonoid" \
    choreonoidsim "$@"
