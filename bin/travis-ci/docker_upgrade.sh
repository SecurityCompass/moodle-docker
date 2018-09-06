#!/bin/bash

# Update docker
sudo apt-get update
sudo apt-get --yes install docker-ce

# Update docker-compose
sudo rm /usr/local/bin/docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify
docker version && docker-compose --version
