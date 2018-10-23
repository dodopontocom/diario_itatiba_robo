#!/bin/bash
#
IMAGE=bot-itatiba

docker build --rm -t "${DOCKER_USERNAME}/${IMAGE}:latest" .
docker run --rm "${DOCKER_USERNAME}/${IMAGE}:latest"
