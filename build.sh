#!/bin/bash

BUILD_CLOTH=no

if [ ${BUILD_CLOTH} = "yes" ]; then
    if [ ! -e PhysX4.0 ]; then
        git clone --depth=1 --branch 4.0 --single-branch https://github.com/NVIDIAGameWorks/PhysX.git PhysX4.0
    fi
    if [ ! -e NvCloth1.1.6 ]; then
        git clone --depth=1 --branch 1.1.6 --single-branch https://github.com/NVIDIAGameWorks/NvCloth.git NvCloth1.1.6
    fi
else
    if [ ! -e PhysX4.1 ]; then
        git clone --depth=1 --branch 4.1 --single-branch https://github.com/NVIDIAGameWorks/PhysX.git PhysX4.1
    fi
fi

docker build -f Dockerfile -t yoheikakiuchi/physx_test .

# bash GenerateProjectsLinux.sh
# cd /build_dir/NvCloth1.1.6/NvCloth/compiler/linux64-release-cmake
# make
