#!/bin/bash

repo=bit-pipeline
version=1.0.1
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push "${DOCKER_USERNAME}/${repo}:${version}"
