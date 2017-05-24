#!/bin/bash

source $HOME/ros/indigo/devel/setup.bash
rossetip

docker run -it --rm --privileged \
    --net=host \
    -w="/home/pointgrey" \
    --net="host" \
    --env="ROS_IP" \
    --env="ROS_HOSTNAME" \
    yoheikakiuchi/pointgrey_test "$@"
