FROM osrf/ros:indigo-desktop-full
# nvidia-docker hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV CNOID_INSTALL_DIR /usr/local/choreonoid
ENV PATH /usr/local/nvidia/bin:${CNOID_INSTALL_DIR}/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
ENV PKG_CONFIG_PATH ${CNOID_INSTALL_DIR}/lib/pkgconfig:$PKG_CONFIG_PATH
ENV WORKHOME /home/choreonoid

### for choreonoid
RUN apt-get update
RUN apt-get install -y libyaml-dev

## ros pkg
RUN mkdir -p /home/choreonoid/catkin_ws
RUN cd /home/choreonoid/catkin_ws && \
    wstool init src && \
    wstool set -y -t src rtmros_choreonoid https://github.com/start-jsk/rtmros_choreonoid.git --git && \
    wstool set -y -t src rtmros_tutorials https://github.com/start-jsk/rtmros_tutorials.git --git && \
    wstool update -t src && \
    rosdep install -y -r --from-paths src --ignore-src

## choreonoid
RUN mkdir -p /home/choreonoid/src 
RUN cd /home/choreonoid/src && \
    git clone https://github.com/s-nakaoka/choreonoid.git && \
    mkdir -p choreonoid/build && \
    cd choreonoid/build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=${CNOID_INSTALL_DIR} -DENABLE_INSTALL_RPATH=ON -DENABLE_CORBA=ON -DBUILD_CORBA_PLUGIN=ON -DBUILD_OPENRTM_PLUGIN=ON -DBUILD_HELLO_WORLD_SAMPLE=ON -DBUILD_SPRING_MODEL_SAMPLE=ON -DOPENRTM_DIR=/opt/ros/indigo && \
    make -j4 && \
    make install

##
RUN cd /home/choreonoid/catkin_ws && \
    /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && catkin build hrpsys_choreonoid_tutorials"

ADD ./my_entrypoint.sh /

ENTRYPOINT ["/my_entrypoint.sh"]
CMD ["bash"]
