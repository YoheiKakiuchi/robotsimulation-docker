#!/bin/bash

OPT=${DOCKER_OPTION} ## -it --cpuset-cpus 0-2
cname=${DOCKER_CONTAINER:-"chainer_ros"} ## name of container (should be same as in exec.sh)

VAR=${@:-"bash"}

docker exec ${OPT} \
       --privileged \
       --workdir="/userdir" \
       ${cname} ${VAR}
