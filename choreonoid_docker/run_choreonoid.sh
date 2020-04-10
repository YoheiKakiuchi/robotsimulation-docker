#!/bin/bash

OPT=${DOCKER_OPTION} ## -it --cpuset-cpus 0-2
iname=${DOCKER_IMAGE:-"yoheikakiuchi/choreonoid:release-1.7"} ## name of image (should be same as in build.sh)
cname=${DOCKER_CONTAINER:-"choreonoid"} ## name of container (should be same as in exec.sh)

DEFAULT_USER_DIR="$(pwd)"

VAR=${@:-"bash --rcfile /my_entryrc -c choreonoid"}
#VAR=${@:-"rtmlaunch hrpsys_choreonoid_tutorials jaxon_jvrc_choreonoid.launch"}
#VAR=${@:-"rtmlaunch hrpsys_choreonoid_tutorials jaxon_jvrc_choreonoid.launch LOAD_OBJECTS:=true ENVIRONMENT_YAML:=/choreonoid/catkin_ws/src/rtmros_choreonoid/hrpsys_choreonoid_tutorials/config/footsal.yaml"}
#VAR=${@:-"rtmlaunch hrpsys_choreonoid_tutorials jaxon_jvrc_choreonoid.launch LOAD_OBJECTS:=true ENVIRONMENT_YAML:=/userdir/footsal.yaml"}

## --net=mynetworkname
## docker inspect -f '{{.NetworkSettings.Networks.mynetworkname.IPAddress}}' choreonoidsim
## docker inspect -f '{{.NetworkSettings.Networks.mynetworkname.Gateway}}'   choreonoidsim

if [ "$DOCKER_ROS_IP" == "" ]; then
#    export DOCKER_ROS_IP=127.0.0.1
    export DOCKER_ROS_IP=localhost
fi

NET_OPT="--net=host --env=DOCKER_ROS_IP --env=DOCKER_ROS_MASTER_URI"
#NET_OPT="--net=host --env=NVIDIA_DRIVER_CAPABILITIES --env=NVIDIA_VISIBLE_DEVICES"

##xhost +local:root
xhost +si:localuser:root

docker rm ${cname}

docker run ${OPT}    \
    --privileged     \
    --gpus all \
    ${NET_OPT}       \
    --env="DOCKER_ROS_SETUP=/choreonoid_ws/devel/setup.bash" \
    --env="DISPLAY"  \
    --env="ROBOT=JAXON_RED" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --name=${cname} \
    --volume="${PROG_DIR:-$DEFAULT_USER_DIR}:/userdir" \
    -w="/userdir" \
    ${iname} ${VAR}

##xhost -local:root
