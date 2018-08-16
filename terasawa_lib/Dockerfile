FROM osrf/ros:kinetic-desktop-full

ENV WORKHOME /userdir
WORKDIR /catkin_ws

### for choreonoid
RUN apt-get -q -qq update -y
RUN apt-get -q -qq install -y libyaml-dev mesa-utils python-pip libgsl-dev ros-kinetic-catkin python-catkin-tools

## private directory
COPY rtmros_hrp2-master.zip /tmp

## ros pkg
RUN wstool init src && \
    wstool set -y -t src rtmros_tutorials https://github.com/start-jsk/rtmros_tutorials.git --git && \
    wstool set -y -t src rtmros_common https://github.com/start-jsk/rtmros_common.git --git && \
    wstool set -y -t src jsk_model_tools https://github.com/jsk-ros-pkg/jsk_model_tools.git --git && \
    wstool set -y -t src jsk_control https://github.com/jsk-ros-pkg/jsk_control.git --git && \
    wstool set -y -t src jsk_roseus https://github.com/jsk-ros-pkg/jsk_roseus.git --git && \
    wstool set -y -t src multisense_ros https://bitbucket.org/crl/multisense_ros -v 3.4.9 --hg && \
#    wstool set -y -t src rtmros_choreonoid https://github.com/start-jsk/rtmros_choreonoid.git --git && \
#    wstool set -y -t src euslisp/Euslisp https://github.com/euslisp/Euslisp.git --git && \
#    wstool set -y -t src euslisp/jskeus  https://github.com/euslisp/jskeus.git --git && \        
#    wstool set -y -t src hrpsys https://github.com/fkanehiro/hrpsys-base.git --git && \
    wstool update -t src && \
## remove hrpsys_gazebo, hironx, hrpsys, opnehrp3 tutorials because it cause to install ros-indigo-hrpsys
    (cd src/rtmros_tutorials; rm -rf hrpsys_gazebo_tutorials hironx_tutorial hrpsys_tutorials openhrp3_tutorials) && \
    ./src/jsk_roseus/setup_upstream.sh -w .
##    
RUN unzip /tmp/rtmros_hrp2-master.zip -d src
##
RUN rosdep install -y -r --from-paths src --ignore-src || echo 'IGNORE rosdep fail'

## build ros packages
RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && catkin build hrpsys_ros_bridge_tutorials eus_nlopt eus_qpoases eus_qp --no-status --no-notify -j 4 -p 1"

## TODO

ADD ./my_entrypoint.sh /

ENTRYPOINT ["/my_entrypoint.sh"]
CMD ["bash"]
