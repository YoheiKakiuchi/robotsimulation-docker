#!/bin/bash
set -e

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
#source "${WORKHOME}/catkin_ws/devel/setup.bash"

export ROS_IP=$(hostname -i)
export ROS_HOSTNAME=$(hostname -i)

exec "$@"
