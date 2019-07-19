FROM nvidia/cuda:10.0-devel-ubuntu18.04

# ARG NVCLOTH

SHELL ["/bin/bash", "-c"]

## see https://github.com/nvidia/nvidia-container-runtime#environment-variables-oci-spec
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics,display

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt update -q -qq && \
    apt install -q -y wget emacs vim git g++ clang \
    libxxf86vm-dev libgl1-mesa-dev libglu1-mesa-dev libxmu-dev mesa-utils \
    curl unzip \
    gcc-multilib g++-multilib freeglut3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
        
WORKDIR /build_dir

#RUN git clone https://gitlab.kitware.com/cmake/cmake.git
RUN wget https://github.com/Kitware/CMake/releases/download/v3.14.5/cmake-3.14.5.tar.gz -O /tmp/cmake.tar.gz && \
    tar xvf /tmp/cmake.tar.gz && \
    rm -rf /tmp/cmake.tar.gz
    
RUN bash -c '(cd cmake-3.14.5; ./configure --prefix=/usr/local; make -j4;  make install)' && \
    rm -rf cmake

WORKDIR /build_dir

#RUN git clone --depth=1 --branch 4.1 --single-branch https://github.com/NVIDIAGameWorks/PhysX.git PhysX4.1
COPY PhysX4.1 PhysX4.1
COPY NvCloth1.1.6 NvCloth1.1.6

RUN bash -c '(cd PhysX4.1/physx; ./generate_projects.sh linux)'

WORKDIR /build_dir/PhysX4.1/physx
RUN bash -c '(cd compiler/linux-release; make -j4; make install)'

## install choreonoid
git clone --depth 1 -b release-1.7 https://github.com/s-nakaoka/choreonoid.git choreonoid
