#!/bin/bash

source container-config

docker run --rm -it --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    -v $PWD/zephyr:/home/build/ \
    -w /home/build/zephyr \
    $DOCKER_USER_NAME/$DOCKER_IMAGE_NAME
