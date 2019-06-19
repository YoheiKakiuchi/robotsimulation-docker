#!/bin/bash

OPT=${DOCKER_OPTION:-"--no-cache --pull"} ## -it --cpuset-cpus 0-2
iname=${DOCKER_IMAGE:-"chainer_rl:latest"} ## name of image (should be same as in build.sh)

git clone https://github.com/openai/gym.git        openai_gym
git clone https://github.com/chainer/chainerrl.git chainerrl

docker build ${OPT} -f Dockerfile -t ${iname} .
