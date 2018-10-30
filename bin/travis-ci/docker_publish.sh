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

# Check if a tag triggered a build
if [[ -n "${TRAVIS_TAG}" ]]; then
    echo "New tag (${TRAVIS_TAG}) detected. Attempting to push new container"

    version_pattern='^v\d+\.\d+\.\d+$'
    echo "${TRAVIS_TAG}" | grep -qP ${version_pattern} || ( color_echo red "Invalid tag name created: '${TRAVIS_TAG}'" && exit 1 )

    # Log into our Docker registry
    echo "${DOCKER_REGISTRY_PASSWORD}" | docker login -u "${DOCKER_REGISTRY_USER}" --password-stdin "${DOCKER_REGISTRY_URL}"

    # Push image
    docker-compose --file docker-compose.yml --file dc.build.yml push nginx-php-moodle
else
    echo "Nothing to do, only tag creation pushes a new container to the registry"
fi
