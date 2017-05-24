FROM osrf/ros:kinetic-desktop-full

ENV LD_LIBRARY_PATH /home/pointgrey/spinnaker_1_1_0_43_amd64/lib:${LD_LIBRARY_PATH}
ENV PKG_CONFIG_PATH /home/pointgrey/spinnaker_1_1_0_43_amd64/lib/pkgconfig:${PKG_CONFIG_PATH}
ENV WORKHOME /home/pointgrey
ENV POINTGREY_SDK spinnaker_1_1_0_43_amd64

RUN mkdir -p ${WORKHOME}/catkin_ws
ADD ./${POINTGREY_SDK}.tar.gz ${WORKHOME}

RUN mkdir -p ${WORKHOME}/${POINTGREY_SDK}/lib/pkgconfig

ADD ./spinnaker.pc ${WORKHOME}/${POINTGREY_SDK}/lib/pkgconfig/

RUN apt-get update && apt-get install --no-install-recommends -y \
    sudo lsb-release less vim-tiny ros-kinetic-catkin python-catkin-tools ros-kinetic-image-proc ros-kinetic-stereo-image-proc net-tools iputils-ping

RUN cd ${WORKHOME}/catkin_ws && \
    wstool init src && \
    wstool set -y -u -t src pointgrey_camera_driver https://github.com/YoheiKakiuchi/pointgrey_camera_driver.git --git -v spinnaker_test && \
    /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && catkin build pointgrey_camera_driver"

### local changes ###

RUN cp ${WORKHOME}/${POINTGREY_SDK}/bin/SFNC_GenTL* /opt/ros/kinetic/lib/nodelet/

ADD ./camera.launch ${WORKHOME}
##RUN mkdir -p ${WORKHOME}/.ros/camera_info
##ADD ./16276501.yaml ${WORKHOME}/.ros/camera_info/
ADD ./16276501.yaml ${WORKHOME}/
ADD ./my_entrypoint.sh /

ENTRYPOINT ["/my_entrypoint.sh"]
CMD ["bash"]
