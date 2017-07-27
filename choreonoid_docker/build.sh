#!/bin/bash

#DOCKER=docker
DOCKER=nvidia-docker

${DOCKER} build --tag=openrave_test .
