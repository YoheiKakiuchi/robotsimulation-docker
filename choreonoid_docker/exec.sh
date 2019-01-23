#!/bin/bash

OPT=${DOCKER_OPTION} ## -it --cpuset-cpus 0-2
cname=${DOCKER_CONTAINER:-"trans_robot_container"} ## name of container (should be same as in run.sh)

VAR=${@:-"bash"}

docker exec ${OPT}          \
       --privileged         \
       --runtime=nvidia     \
       --env="DISPLAY"      \
       --env="QT_X11_NO_MITSHM=1" \
       --workdir="/userdir" \
       ${cname} ${VAR}
