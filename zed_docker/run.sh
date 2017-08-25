#!/bin/bash

RUNDOC=${DOCKER:-nvidia-docker}
OPT=${DOCKER_OPTION} ## -it --cpuset-cpus 0-2
DEFAULT_USER_DIR="$(pwd)"
VAR=${@:-"bash"}
xhost +local:root

${RUNDOC} rm zed_test_run

#${RUNDOC} run -u 1000:1000 ${OPT} \
${RUNDOC} run ${OPT} \
    --privileged \
    --name="zed_test_run" \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="${PROG_DIR:-$DEFAULT_USER_DIR}:/home/zed/user_programs" \
    -w="/home/zed" \
    zed_test ${VAR}

xhost -local:root
