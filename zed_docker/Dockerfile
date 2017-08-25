FROM nvidia/cuda:8.0-devel

ENV WORKHOME /home/zed

### ROS
RUN apt-get update && apt-get install -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros packages
ENV ROS_DISTRO kinetic
RUN apt-get update && apt-get install -y \
    ros-kinetic-desktop-full \
    && rm -rf /var/lib/apt/lists/*
### END ROS

### ZED
COPY ZED_SDK_Linux_Ubuntu16_v2.1.2.run /tmp/ZED_SDK_Linux_Ubuntu16_v2.1.2.run

### for choreonoid
RUN apt-get update -y
RUN apt-get install -y libyaml-dev mesa-utils python-pip sudo

###
RUN groupadd -g 1000 zeduser && \
    useradd -g zeduser -G sudo -m -s /bin/bash zed && \
    echo 'zed:password' | chpasswd

### ros pkg
RUN mkdir -p ${WORKHOME}/catkin_ws
RUN cd ${WORKHOME}/catkin_ws && \
    wstool init src && \
    wstool set -y -t src zed_ros https://github.com/stereolabs/zed-ros-wrapper.git --git && \
    wstool update -t src && \
    rosdep install -y -r --from-paths src --ignore-src

### install docker / not possible by dockerfile??
# RUN su -l zed && sudo bash /tmp/ZED_SDK_Linux_Ubuntu16_v2.1.2.run

## build ros packages
#RUN cd ${WORKHOME}/catkin_ws && \
#    /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && catkin build hrpsys_choreonoid_tutorials jsk_robot_startup jsk_tilt_laser pr2_navigation_self_filter --no-status --no-notify -j 1 -p 1"

ADD ./my_entrypoint.sh /

ENTRYPOINT ["/my_entrypoint.sh"]
CMD ["bash"]
