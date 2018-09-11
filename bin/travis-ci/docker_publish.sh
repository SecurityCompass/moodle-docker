#!/bin/bash
set -e 
set -o pipefail

# Log into our Docker registry
echo "${DOCKER_REGISTRY_PASSWORD}" | docker login -u "${DOCKER_REGISTRY_USER}" --password-stdin "${DOCKER_REGISTRY_URL}"

# Push image
docker-compose --file docker-compose.yml --file dc.build.yml push nginx-php-moodle
