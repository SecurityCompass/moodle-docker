#!/bin/bash

# Build image
docker-compose --file docker-compose.yml --file dc.build.yml build --no-cache nginx-php-moodle
docker images
