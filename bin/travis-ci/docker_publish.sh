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

set -x

repository="$(docker images | grep nginx-php-moodle | awk '{print $1}')"

echo "Tagging container"
docker tag "${repository}:latest" "${repository}:${TRAVIS_TAG}"

# Push images
docker push "${repository}:latest"
docker push "${repository}:${TRAVIS_TAG}"
