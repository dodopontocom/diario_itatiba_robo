#!/bin/bash

IMAGE=bot-itatiba

docker build -t "${DOCKER_USERNAME}/${IMAGE}:latest" .
docker run --rm "${DOCKER_USERNAME}/${IMAGE}:latest"
