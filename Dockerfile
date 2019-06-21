FROM chainer/chainer:v5.4.0-python2

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics,display

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y --no-install-recommends \
    less git mesa-utils emacs vim \
    pkg-config python-pip \
    libglvnd-dev libgl1-mesa-dev libegl1-mesa-dev libgles2-mesa-dev \
    libglvnd-dev:i386 libgl1-mesa-dev:i386 libegl1-mesa-dev:i386 libgles2-mesa-dev:i386 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /chainer

RUN git clone https://github.com/chainer/chainerrl.git
RUN git clone https://github.com/openai/gym.git

RUN pip install --upgrade pip
RUN cd gym; pip install -e .

WORKDIR /chainer
RUN cd chainerrl && \
    python setup.py install && \
    pip install -r requirements.txt

RUN apt-get update && apt-get install -y \
    python3-dev zlib1g-dev libjpeg-dev cmake \
    swig python-pyglet python3-opengl libboost-all-dev libsdl2-dev \
    libosmesa6-dev patchelf ffmpeg xvfb && \
    rm -rf /var/lib/apt/lists/*

#
# install original environment for openai/gym
#
COPY gym-twowheels /chainer
WORKDIR /chainer/gym-twowheels
RUN pip install -e .

####
# install ROS
####
### ROS installl
# install packages
RUN apt-get update -q -qq && apt-get install -q -qq -y \
    dirmngr gnupg2 lsb-release \
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

# bootstrap rosdep
RUN rosdep init && rosdep update

# install ros packages
ENV ROS_DISTRO melodic
RUN apt-get update -q -qq && apt-get install -q -qq --no-install-recommends -y \
    ros-${ROS_DISTRO}-desktop-full \
    && rm -rf /var/lib/apt/lists/*
### ROS install(end)
