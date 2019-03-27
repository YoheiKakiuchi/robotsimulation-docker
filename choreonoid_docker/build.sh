#!/bin/bash
set -e

DOCKER_USER=yoheikakiuchi

#ROS_VERSION=kinetic
UBUNTU_VERSION=16.04 ## 18.04(not tested)
CHOREONOID_VERSION=release-1.6 ## latest

### opengl
if [ "$UBUNTU_VERSION" == 18.04 ]; then
    ### not tested
    docker build -f ../ros_gl/Dockerfile.ros_gl.melodic --tag=${DOCKER_USER}/ros_gl:${UBUNTU_VERSION} .
else
    docker build -f ../ros_gl/Dockerfile.ros_gl --tag=${DOCKER_USER}/ros_gl:${UBUNTU_VERSION} .
fi

### choreonoid
if [ "$CHOREONOID_VERSION" == latest ]; then
    ### todo
    sed -e "s/@UBUNTU_VERSION@/${UBUNTU_VERSION}/" Dockerfile.choreonoid.latest.in > Dockerfile.choreonoid.${UBUNTU_VERSION}_${CHOREONOID_VERSION}
else
    sed -e "s/@CHOREONOID_VERSION@/${CHOREONOID_VERSION}/" -e "s/@UBUNTU_VERSION@/${UBUNTU_VERSION}/" \
        Dockerfile.choreonoid.in > Dockerfile.choreonoid.${UBUNTU_VERSION}_${CHOREONOID_VERSION}
fi
docker build -f Dockerfile.choreonoid.${UBUNTU_VERSION}_${CHOREONOID_VERSION} \
       --tag=${DOCKER_USER}/choreonoid:${UBUNTU_VERSION}_${CHOREONOID_VERSION} .

### hrpsys
sed -e "s/@CHOREONOID_VERSION@/${CHOREONOID_VERSION}/" -e "s/@UBUNTU_VERSION@/${UBUNTU_VERSION}/" \
    Dockerfile.hrpsys.in > Dockerfile.hrpsys.${UBUNTU_VERSION}_${CHOREONOID_VERSION}
docker build -f Dockerfile.hrpsys.${UBUNTU_VERSION}_${CHOREONOID_VERSION} \
       --tag=${DOCKER_USER}/hrpsys:${UBUNTU_VERSION}_${CHOREONOID_VERSION} .

### simulation environment
sed -e "s/@CHOREONOID_VERSION@/${CHOREONOID_VERSION}/" -e "s/@UBUNTU_VERSION@/${UBUNTU_VERSION}/" \
    Dockerfile.choreonoidsim.in > Dockerfile.choreonoidsim.${UBUNTU_VERSION}_${CHOREONOID_VERSION}
if [ ! -e ./rtmros_choreonoid ]; then
    git clone https://github.com/start-jsk/rtmros_choreonoid.git
fi
docker build -f Dockerfile.choreonoidsim.${UBUNTU_VERSION}_${CHOREONOID_VERSION} \
       --tag=${DOCKER_USER}/choreonoidsim:${UBUNTU_VERSION}_${CHOREONOID_VERSION} .
