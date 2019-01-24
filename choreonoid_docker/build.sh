#!/bin/bash

if [ ! -e ./rtmros_choreonoid ]; then
    #    git clone https://github.com/start-jsk/rtmros_choreonoid.git
    git clone https://github.com/YoheiKakiuchi/rtmros_choreonoid.git
fi
##(cd rtmros_choreonoid; git checkout -b for_docker origin/for_docker)
(cd rtmros_choreonoid; git checkout -b for_docker origin/fix_travis)

cp rtmros_choreonoid/Dockerfile.kinetic Dockerfile.choreonoid
sed -i -e 's@FROM osrf/ros:kinetic-desktop-full@FROM yoheikakiuchi/ros_gl:16.04@' Dockerfile.choreonoid
cat <<EOF >> Dockerfile.choreonoid
ADD ./my_entrypoint.sh /
ENTRYPOINT ["/my_entrypoint.sh"]
CMD ["bash"]
EOF
cp my_entrypoint.sh rtmros_choreonoid

docker build -f Dockerfile.ros_gl     --tag=yoheikakiuchi/ros_gl:16.04 .
docker build -f Dockerfile.choreonoid --tag=yoheikakiuchi/choreonoidsim:16.04 rtmros_choreonoid
