#!/bin/bash

OPT=${DOCKER_OPTION} ## -it --cpuset-cpus 0-2
cname=${DOCKER_CONTAINER:-"aerosim"} ## name of container (should be same as in run.sh)

VAR=${@:-"bash"}

NET_OPT="--env=ROS_IP --env=ROS_HOSTNAME --env=DOCKER_CLIENT_IP"

docker exec ${OPT}          \
       --privileged         \
       --runtime=nvidia     \
       ${NET_OPT}           \
       --env="DISPLAY"      \
       --env="QT_X11_NO_MITSHM=1" \
       --workdir="/userdir" \
       ${cname} ${VAR}
