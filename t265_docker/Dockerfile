##FROM
FROM osrf/ros:kinetic-desktop-full

SHELL ["/bin/bash", "-c"]

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE

RUN apt-get update -q -qq && apt-get install -q -qq -y \
    software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
#(kinetic)
RUN add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo xenial main" -u
#(melodic)
#RUN add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo bionic main" -u

RUN apt-get update -q -qq && apt-get install -q -qq -y \
    mesa-utils python-pip \
    ros-${ROS_DISTRO}-catkin python-wstools python-catkin-tools \
    librealsense2-dkms librealsense2-utils librealsense2-dev librealsense2-dbg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
## apt-get install librealsense2-dkms librealsense2-utils=2.29.0-0~realsense0.1579 librealsense2-dev=2.29.0-0~realsense0.1579 librealsense2-dbg=2.29.0-0~realsense0.1579 librealsense2=2.29.0-0~realsense0.1579 librealsense2-gl=2.29.0-0~realsense0.1579
## ROS wrapper のパッケージをビルドすると,ROSから実行ができます.

##
WORKDIR /catkin_ws/src
RUN git clone https://github.com/IntelRealSense/realsense-ros.git

WORKDIR /catkin_ws
RUN source /opt/ros/${ROS_DISTRO}/setup.bash && \
    apt-get update -q -qq && \
    rosdep install -q -y -r --from-paths src --ignore-src || echo 'Ignore rosdep error' && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /catkin_ws/src/realsense-ros
RUN git checkout `git tag | sort -V | grep -P "^\d+\.\d+\.\d+" | tail -1`

WORKDIR /catkin_ws
RUN source /opt/ros/${ROS_DISTRO}/setup.bash && \
    catkin build

#その後,以下のlaunchファイルで実行
#$ roslaunch realsense2_camera demo_t265.launch

## ### create environment
RUN echo -e '#!/bin/bash\n\
set -e\n\
source /my_entryrc\n\
exec "$@"\n' >> /my_entrypoint.sh
RUN chmod a+x /my_entrypoint.sh

RUN echo -e '# setup ros environment\n\
if [ -e "${DOCKER_ROS_SETUP}" ]; then\n\
    source "${DOCKER_ROS_SETUP}"\n\
else\n\
    source "/opt/ros/$ROS_DISTRO/setup.bash"\n\
fi\n\
MY_IP=${DOCKER_ROS_IP:-$(hostname -i)}\n\
if [ "$ROS_IP" == "" ]; then\n\
    export ROS_IP=${MY_IP}\n\
fi\n\
if [ "$ROS_HOSTNAME" == "" ]; then\n\
    export ROS_HOSTNAME=${MY_IP}\n\
fi\n\
if [ "${DOCKER_ROS_MASTER_URI}" != "" ]; then\n\
    export ROS_MASTER_URI=${DOCKER_ROS_MASTER_URI}\n\
fi\n\
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64\n\
export PATH=$PATH:/usr/local/cuda/bin\n' >>  /my_entryrc

ENTRYPOINT ["/my_entrypoint.sh"]
CMD ["bash"]
