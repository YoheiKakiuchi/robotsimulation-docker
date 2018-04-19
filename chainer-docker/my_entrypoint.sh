#!/bin/bash
set -e

# setup ros environment
if [ -e "/catkin_ws/devel/setup.bash" ]; then
    source "/catkin_ws/devel/setup.bash"
else
    source "/opt/ros/kinetic/setup.bash"
fi

MY_IP=${DOCKER_CLIENT_IP:-$(hostname -i)}

if [ "$ROS_IP" == "" ]; then
    export ROS_IP=${MY_IP}
fi

if [ "$ROS_HOSTNAME" == "" ]; then
    export ROS_HOSTNAME=${MY_IP}
fi

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
export PATH=$PATH:/usr/local/cuda/bin

exec "$@"
