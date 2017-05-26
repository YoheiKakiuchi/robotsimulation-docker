#!/bin/bash

VAR=${@:-"bash"}
#echo "VAR: $VAR"

RUNDOC=${DOCKER:-nvidia-docker}

${RUNDOC} exec -it \
    --privileged \
    choreonoid_simulation ${VAR}
