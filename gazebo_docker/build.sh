#!/bin/bash
set -e

if [ ! -e ./aero-ros-pkg ]; then
    git clone https://github.com/seed-solutions/aero-ros-pkg.git
fi
#(cd aero_ros_pkg; git checkout -b for_docker origin/fix_travis)

cp aero-ros-pkg/Dockerfile.melodic Dockerfile.aero
##sed -i -e 's@FROM ros:kinetic-robot@FROM yoheikakiuchi/ros_gl:16.04@' Dockerfile.aero
## change build type
sed -i -e 's@./setup.sh typeF@./setup.sh typeFCESy@' Dockerfile.aero
cat <<EOF >> Dockerfile.aero
ADD ./my_entrypoint.sh /
ENTRYPOINT ["/my_entrypoint.sh"]
CMD ["bash"]

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
        ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
        ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,compat32,utility

# Required for non-glvnd setups.
ENV LD_LIBRARY_PATH /usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
EOF

cp my_entrypoint.sh aero-ros-pkg

#docker build -f Dockerfile.ros_gl  --tag=yoheikakiuchi/ros_gl:16.04 .
docker build -f Dockerfile.aero    --tag=yoheikakiuchi/aero-ros-pkg:18.04 aero-ros-pkg

### TODO add Dockerfile.aero_eus for euslisp interface
