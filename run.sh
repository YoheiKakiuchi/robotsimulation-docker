#!/bin/bash

OPT=${DOCKER_OPTION:-"-it"} ## -it --cpuset-cpus 0-2
iname=${DOCKER_IMAGE:-"physx_test"} ## name of image (should be same as in build.sh)
cname=${DOCKER_CONTAINER:-"physx_cont"} ## name of container (should be same as in exec.sh)

DEFAULT_USER_DIR="$(pwd)"

VAR=${@:-"bash"}
#VAR=${@:-"bash --rcfile /my_entryrc"}
## --net=mynetworkname
## docker inspect -f '{{.NetworkSettings.Networks.mynetworkname.IPAddress}}' choreonoidsim
## docker inspect -f '{{.NetworkSettings.Networks.mynetworkname.Gateway}}'   choreonoidsim

if [ "$DOCKER_ROS_IP" == "" ]; then
#    export DOCKER_ROS_IP=127.0.0.1
    export DOCKER_ROS_IP=localhost
fi

NET_OPT="--net=host --env=DOCKER_ROS_IP --env=DOCKER_ROS_MASTER_URI"
# for gdb
#NET_OPT="--net=host --env=DOCKER_ROS_IP --env=DOCKER_ROS_MASTER_URI --cap-add=SYS_PTRACE --security-opt=seccomp=unconfined"
#NET_OPT="--net=host --env=NVIDIA_DRIVER_CAPABILITIES --env=NVIDIA_VISIBLE_DEVICES"

##xhost +local:root
xhost +si:localuser:root

docker rm ${cname}

docker run ${OPT}    \
    --privileged     \
    --runtime=nvidia \
    ${NET_OPT}       \
    --env="NVIDIA_VISIBLE_DEVICES=all" \
    --env="NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics,display" \
    --env="DISPLAY"  \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --name=${cname} \
    --volume="${PROG_DIR:-$DEFAULT_USER_DIR}:/userdir" \
    -w="/userdir" \
    ${iname} ${VAR}

##xhost -local:root
