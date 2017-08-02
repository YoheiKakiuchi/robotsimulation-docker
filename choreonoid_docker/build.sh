#!/bin/bash

RUNDOC=${DOCKER:-nvidia-docker}
RUN_IMAGE=${IMAGE:-yoheikakiuchi/choreonoidsim}

${RUNDOC} build --tag=${RUN_IMAGE} .
