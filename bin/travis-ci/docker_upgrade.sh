#!/bin/bash

# Update docker/docker-compose
sudo apt-get update
sudo apt-get --yes install docker-ce
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker version && docker-compose --version
