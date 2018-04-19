FROM nvidia/cuda:8.0-cudnn6-devel ## equal chainer/chainer
# FROM nvidia/cuda:9.0-cudnn7-devel ## up_version

# RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1
# ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/usr/local/cuda/lib64:/usr/local/cuda/lib64/stubs
ENV PATH ${PATH}:/usr/local/cuda/bin

RUN apt-get -q -qq update -y && \
    apt-get -q -qq install -y --no-install-recommends \
    python-dev python-pip python-wheel python-setuptools

RUN pip install --no-cache-dir cupy-cuda80==4.0.0 chainer==4.0.0  ## equal chainer/chainer
# RUN pip install --no-cache-dir cupy-cuda90==4.0.0 chainer==4.0.0 ## up_version

#
# ROS
#
RUN apt-get -q -qq update && apt-get -q -qq install -y --no-install-recommends \
    dirmngr gnupg2

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list

# install bootstrap tools
RUN apt-get -q -qq update && apt-get -q -qq install --no-install-recommends -y \
    python-rosdep python-rosinstall python-vcstools

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros packages
ENV ROS_DISTRO kinetic
RUN apt-get -q -qq update && apt-get -q -qq install -y \
    ros-kinetic-ros-base=1.3.1-0* \
    ros-kinetic-jsk-recognition \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

#
# chainercv
#
RUN pip install -U matplotlib
RUN pip install -U numpy
RUN pip install -U chainercv

# setup entrypoint
COPY ./my_entrypoint.sh /

ENTRYPOINT ["/my_entrypoint.sh"]

CMD ["bash"]
