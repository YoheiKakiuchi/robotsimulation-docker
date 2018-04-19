#!/bin/bash

OPT=${DOCKER_OPTION} ## -it --cpuset-cpus 0-2
iname=${DOCKER_IMAGE:-"yoheikakiuchi/chainer:8.0"} ## name of image (should be same as in build.sh)
cname=${DOCKER_CONTAINER:-"chainer_ros"} ## name of container (should be same as in exec.sh)

NET_OPT="--net=host --env=ROS_IP --env=ROS_HOSTNAME --env=DOCKER_CLIENT_IP"
DEFAULT_USER_DIR="$(pwd)"
VAR=${@:-"bash"}

##xhost +local:root

docker rm ${cname}

docker run ${OPT} \
    --privileged \
    --runtime=nvidia \
    ${NET_OPT} \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --name=${cname} \
    --volume="${PROG_DIR:-$DEFAULT_USER_DIR}:/userdir" \
    -w="/userdir" \
    ${iname} ${VAR}

##xhost -local:root
