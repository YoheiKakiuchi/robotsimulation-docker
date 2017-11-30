#!/bin/bash
set -e

# setup ros environment
if [ -e "${WORKHOME}/catkin_ws/devel/setup.bash" ]; then
    source "${WORKHOME}/catkin_ws/devel/setup.bash"
else
    source "/opt/ros/$ROS_DISTRO/setup.bash"
fi

if [ "$ROS_IP" == "" ]; then
    export ROS_IP=$(hostname -i)
fi

if [ "$ROS_HOSTNAME" == "" ]; then
    export ROS_HOSTNAME=$(hostname -i)
fi

exec "$@"
