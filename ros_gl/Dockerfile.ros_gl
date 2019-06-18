## for using nvidia docker2
# docker build -t (imagename) .
# xhost +si:localuser:root
# docker run --runtime=nvidia -ti --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix (imagename)
# docker build -f <this_file> -t yoheikakiuchi/ros_gl:16.04 .
FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display

### ROS installl
# install packages
RUN apt-get update -q -qq && apt-get install -q -qq -y \
    dirmngr \
    gnupg2 \
    lsb-release \
    && apt-get dist-upgrade -q -qq -y \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list

# install bootstrap tools
RUN apt-get update -q -qq && apt-get install -q -qq --no-install-recommends -y \
    mesa-utils gettext less \
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
RUN apt-get update -q -qq && apt-get install -q -qq --no-install-recommends -y \
    ros-kinetic-desktop-full \
    && rm -rf /var/lib/apt/lists/*
### ROS install(end)
