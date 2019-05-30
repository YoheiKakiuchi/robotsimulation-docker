#!/bin/bash

OPT=${DOCKER_OPTION} ## -it --cpuset-cpus 0-2
iname=${DOCKER_IMAGE:-"yoheikakiuchi/aero-ros-pkg:kinetic"} ## name of image (should be same as in build.sh)
cname=${DOCKER_CONTAINER:-"aero_gazebo"} ## name of container (should be same as in exec.sh)

DEFAULT_USER_DIR="$(pwd)"

#VAR=${@:-"bash --rcfile /my_entryrc"}
VAR=${@:-"roslaunch aero_gazebo aero_gazebo.launch"}

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
    --runtime=nvidia \
    ${NET_OPT}       \
    --env="DOCKER_ROS_SETUP=/catkin_ws/devel/setup.bash" \
    --env="DISPLAY"  \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --name=${cname} \
    --volume="${PROG_DIR:-$DEFAULT_USER_DIR}:/userdir" \
    -w="/userdir" \
    ${iname} ${VAR}

##xhost -local:root
