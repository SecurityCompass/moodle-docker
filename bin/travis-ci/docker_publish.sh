#!/bin/bash

# shellcheck disable=SC1091
source .env.example

# Log into our Docker registry
echo "$DOCKER_REGISTRY_PASSWORD" | docker login -u "$DOCKER_REGISTRY_USER" --password-stdin "${DOCKER_REGISTRY_URL}"

# Push the images
docker push "${DOCKER_REGISTRY_URL}/moodle/nginx-php-moodle:${PHP_VERSION}-${MOODLE_VERSION}"
docker push "${DOCKER_REGISTRY_URL}/moodle/nginx-php-moodle:latest"
docker images
