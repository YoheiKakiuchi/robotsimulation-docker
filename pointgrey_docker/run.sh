#!/bin/bash

docker run -it --rm --privileged --net=host -w="/home/pointgrey" yoheikakiuchi/pointgrey_test "$@"
