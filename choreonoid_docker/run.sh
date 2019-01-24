#!/bin/bash

OPT=${DOCKER_OPTION} ## -it --cpuset-cpus 0-2
iname=${DOCKER_IMAGE:-"yoheikakiuchi/choreonoidsim:16.04"} ## name of image (should be same as in build.sh)
cname=${DOCKER_CONTAINER:-"choreonoidsim"} ## name of container (should be same as in exec.sh)

DEFAULT_USER_DIR="$(pwd)"

#VAR=${@:-"bash"}
#VAR=${@:-"rtmlaunch hrpsys_choreonoid_tutorials jaxon_jvrc_choreonoid.launch"}
#VAR=${@:-"rtmlaunch hrpsys_choreonoid_tutorials jaxon_jvrc_choreonoid.launch LOAD_OBJECTS:=true ENVIRONMENT_YAML:=/choreonoid/catkin_ws/src/rtmros_choreonoid/hrpsys_choreonoid_tutorials/config/footsal.yaml"}
VAR=${@:-"rtmlaunch hrpsys_choreonoid_tutorials jaxon_jvrc_choreonoid.launch LOAD_OBJECTS:=true ENVIRONMENT_YAML:=/userdir/footsal.yaml"}

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
    --env="ROBOT=JAXON_RED" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --name=${cname} \
    --volume="${PROG_DIR:-$DEFAULT_USER_DIR}:/userdir" \
    -w="/userdir" \
    ${iname} ${VAR}

##xhost -local:root
