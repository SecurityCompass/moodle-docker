#!/bin/bash

# Log into our Docker registry
echo "$DOCKER_REGISTRY_PASSWORD" | docker login -u "$DOCKER_REGISTRY_USER" --password-stdin "${DOCKER_REGISTRY_URL}"

docker-compose --file docker-compose.yml --file dc.build.yml build --no-cache nginx-php-moodle
docker images

# Push the images
docker-compose --file docker-compose.yml --file dc.build.yml push nginx-php-moodle
docker images
