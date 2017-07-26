#!/bin/bash
## set -e

# setup ros environment
#source "/opt/ros/$ROS_DISTRO/setup.bash"
source "${WORKHOME}/catkin_ws/devel/setup.bash"

export PATH=`rospack find openrave`/bin:$PATH
export PYTHONPATH=/opt/ros/indigo/bin:`openrave-config --python-dir`:$PYTHONPATH
export OPENRAVE_HOME=/home/choreonoid/user_programs

export ROS_IP=$(hostname -i)
export ROS_HOSTNAME=$(hostname -i)

exec "$@"
