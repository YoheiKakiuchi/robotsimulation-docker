#!/bin/bash

OPT=${DOCKER_OPTION:-"--no-cache --pull"} ## -it --cpuset-cpus 0-2
iname=${DOCKER_IMAGE:-"chainer_rl_ros:latest"} ## name of image (should be same as in build.sh)

if [ ! -e openai_gym ]; then
    git clone https://github.com/openai/gym.git        openai_gym
fi
if [ ! -e openai_gym ]; then
    git clone https://github.com/chainer/chainerrl.git chainerrl
fi

docker build ${OPT} -f Dockerfile -t ${iname} .
