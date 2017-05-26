FROM osrf/ros:indigo-desktop-full
# nvidia-docker hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV CNOID_INSTALL_DIR /usr/local/choreonoid
ENV PATH /usr/local/nvidia/bin:${CNOID_INSTALL_DIR}/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
ENV PKG_CONFIG_PATH ${CNOID_INSTALL_DIR}/lib/pkgconfig:$PKG_CONFIG_PATH
ENV WORKHOME /home/choreonoid

### for choreonoid
RUN apt-get update -y
RUN apt-get install -y libyaml-dev mesa-utils

## ros pkg
RUN mkdir -p /home/choreonoid/catkin_ws
RUN cd /home/choreonoid/catkin_ws && \
    wstool init src && \
    wstool set -y -t src rtmros_choreonoid https://github.com/start-jsk/rtmros_choreonoid.git --git && \
    wstool set -y -t src rtmros_tutorials https://github.com/start-jsk/rtmros_tutorials.git --git && \
    wstool set -y -t src hrpsys https://github.com/fkanehiro/hrpsys-base.git --git && \
    wstool update -t src && \
    git clone https://github.com/jsk-ros-pkg/jsk_robot.git src/jsk_robot && \
    (cd src/jsk_robot; rm -rf README.md jsk_baxter_robot jsk_naoqi_robot jsk_robot doc jsk_fetch_robot jsk_pr2_robot) && \
    rosdep install -y -r --from-paths src --ignore-src

## choreonoid
RUN mkdir -p /home/choreonoid/src 
RUN cd /home/choreonoid/src && \
    git clone https://github.com/s-nakaoka/choreonoid.git && \
    mkdir -p choreonoid/build && \
    cd choreonoid/build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=${CNOID_INSTALL_DIR} -DENABLE_INSTALL_RPATH=ON -DENABLE_CORBA=ON -DBUILD_CORBA_PLUGIN=ON -DBUILD_OPENRTM_PLUGIN=ON -DBUILD_HELLO_WORLD_SAMPLE=ON -DBUILD_SPRING_MODEL_SAMPLE=ON -DOPENRTM_DIR=/opt/ros/indigo 1> /dev/null 2> /dev/null && \
    make -j4 1> /dev/null 2> /dev/null && \
    make install 1> /dev/null 2> /dev/null

##
RUN cd /home/choreonoid/catkin_ws && \
    /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && catkin build hrpsys_choreonoid_tutorials jsk_robot_startup --no-status --no-notify 1> /dev/null 2> /dev/null"

ADD ./my_entrypoint.sh /

ENTRYPOINT ["/my_entrypoint.sh"]
CMD ["bash"]
