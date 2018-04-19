#!/bin/bash

iname=${DOCKER_IMAGE:-"yoheikakiuchi/chainer:8.0"} ## name of image

xhost +local:root

docker build --pull=true -f Dockerfile --tag=${iname} .

xhost -local:root
