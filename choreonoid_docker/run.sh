#!/bin/bash

nvidia-docker run -it \
    --name="choreonoid_simulation" \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -w="/home/choreonoid" \
    rosnvidia "$@"
