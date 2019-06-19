FROM chainer/chainer:v5.4.0-python2

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics,display

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y --no-install-recommends \
    less git mesa-utils \
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

#####
#
# install ROS
#
####
