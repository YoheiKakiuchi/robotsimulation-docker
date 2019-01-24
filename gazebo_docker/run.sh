#!/bin/bash

OPT=${DOCKER_OPTION} ## -it --cpuset-cpus 0-2
iname=${DOCKER_IMAGE:-"yoheikakiuchi/aero-ros-pkg:18.04"} ## name of image (should be same as in build.sh)
cname=${DOCKER_CONTAINER:-"aerosim"} ## name of container (should be same as in exec.sh)

DEFAULT_USER_DIR="$(pwd)"

#VAR=${@:-"bash"}
VAR=${@:-"roslaunch aero_gazebo aero_gazebo.launch"}

if [ "$DOCKER_CLIENT_IP" == "" ]; then
#    export DOCKER_CLIENT_IP=127.0.0.1
    export DOCKER_CLIENT_IP=localhost
fi
NET_OPT="--net=host --env=ROS_IP --env=ROS_HOSTNAME --env=DOCKER_CLIENT_IP"

##xhost +local:root
xhost +si:localuser:root

docker rm ${cname}

docker run ${OPT}    \
    --privileged     \
    --runtime=nvidia \
    ${NET_OPT}       \
    --env="DISPLAY"  \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --name=${cname} \
    --volume="${PROG_DIR:-$DEFAULT_USER_DIR}:/userdir" \
    -w="/userdir" \
    ${iname} ${VAR}

##xhost -local:root
