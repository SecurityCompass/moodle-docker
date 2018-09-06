#!/bin/bash

# Build fpm image
docker-compose --file dc.deb.yml build --no-cache deb-build
docker images
