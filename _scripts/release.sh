#!/bin/bash

IMAGE=bot-itatiba

docker run --rm "${DOCKER_USERNAME}/bump" patch
version=$(cat VERSION)
echo "version: ${version}"

_scripts/build.sh

git add -A
git commit -m "version ${version}"
git tag "${version}" -m "version ${version}"
git push
git push --tags

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push "${DOCKER_USERNAME}/${IMAGE}:latest"
docker push "${DOCKER_USERNAME}/${IMAGE}:${version}"
