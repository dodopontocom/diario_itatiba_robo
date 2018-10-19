#!/bin/bash

IMAGE=bot-itatiba

docker run --rm "${DOCKER_USERNAME}/${IMAGE}" patch
version=$(cat VERSION)
echo "version: ${version}"

chmod +x _scripts/*
_scripts/build.sh
. _scripts/push.sh

echo "${STD_MSG}"
setup_git rodolfotiago@gmail.com dodopontocom

git checkout -b docker-v1.0
git add -A
git commit -m "version ${version}"
git tag "${version}" -m "version ${version}"
upload_files

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push "${DOCKER_USERNAME}/${IMAGE}:latest"
docker push "${DOCKER_USERNAME}/${IMAGE}:${version}"
