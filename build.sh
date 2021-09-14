#!/bin/bash

source container-config
source tools-versions

echo "Building fonbail-sdk with:"
echo "  NRF commandline tools $NRF_CMDLINE_VER"
echo "  Zephyr SDK v$ZEPHYR_SDK_VER"
echo "  Zephyr $ZEPHYR_VER"
echo "  Segger JLink $SEGGER_JLINK_VER"

SEGGER_JLINK_VER=${SEGGER_JLINK_VER//./}
NRF_VERSION_MAJOR="${NRF_CMDLINE_VER%%\.*}"
NRF_CMDLINE_VER_DOTS=$NRF_CMDLINE_VER
NRF_CMDLINE_VER=${NRF_CMDLINE_VER//./_}
NRF_CMDLINE_VER_DASH=${NRF_CMDLINE_VER//_/-}

cat Dockerfile | \
	sed "s/{{ZEPHYR_SDK_VER}}/$ZEPHYR_SDK_VER/g" | \
	sed "s/{{ZEPHYR_VER}}/$ZEPHYR_VER/g" | \
	sed "s/{{SEGGER_JLINK_VER}}/$SEGGER_JLINK_VER/g" | \
	sed "s/{{NRF_CMDLINE_VER}}/$NRF_CMDLINE_VER/g" | \
	sed "s/{{NRF_CMDLINE_VER_DASH}}/$NRF_CMDLINE_VER_DASH/g" | \
	sed "s/{{NRF_VERSION_MAJOR}}/$NRF_VERSION_MAJOR/g" | \
	sed "s/{{NRF_CMDLINE_VER_DOTS}}/$NRF_CMDLINE_VER_DOTS/g" | \
	docker build -t $DOCKER_USER_NAME/$DOCKER_IMAGE_NAME:latest -
