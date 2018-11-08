#!/bin/bash
#
# Copyright (c) 2018 SD Elements Inc.
#
#  All Rights Reserved.
#
# NOTICE:  All information contained herein is, and remains
# the property of SD Elements Incorporated and its suppliers,
# if any.  The intellectual and technical concepts contained
# herein are proprietary to SD Elements Incorporated
# and its suppliers and may be covered by U.S., Canadian and other Patents,
# patents in process, and are protected by trade secret or copyright law.
# Dissemination of this information or reproduction of this material
# is strictly forbidden unless prior written permission is obtained
# from SD Elements Inc..
# Version

set -eo pipefail

# Log into our Docker registry
echo "${DOCKER_REGISTRY_PASSWORD}" | docker login -u "${DOCKER_REGISTRY_USER}" --password-stdin "${DOCKER_REGISTRY_URL}"

echo "Tagging container"
docker tag "${DOCKER_REGISTRY_URL}/nginx-php-moodle:latest" "${DOCKER_REGISTRY_URL}/nginx-php-moodle:${TRAVIS_TAG}"

# Push images
docker push "${DOCKER_REGISTRY_URL}/nginx-php-moodle:latest"
docker push "${DOCKER_REGISTRY_URL}/nginx-php-moodle:${TRAVIS_TAG}"
docker images
