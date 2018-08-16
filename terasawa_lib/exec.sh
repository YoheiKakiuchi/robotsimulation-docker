#!/bin/bash

OPT=${DOCKER_OPTION} ## -it --cpuset-cpus 0-2
cname=${DOCKER_CONTAINER:-"terasawa_lib"} ## name of container (should be same as in exec.sh)

VAR=${@:-"bash"}

docker exec ${OPT} \
       --privileged \
       --env="DISPLAY" \
       --env="QT_X11_NO_MITSHM=1" \
       --workdir="/userdir" \
       ${cname} ${VAR}
