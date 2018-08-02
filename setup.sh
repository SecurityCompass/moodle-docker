#!/usr/bin/env bash

# Version
version='0.1'

# Set strict mode
set -euo pipefail

# Default verbosity, common levels are 0,1,5,10
verbosity="${verbosity:-1}"

# Include stdlib from the lib directory
source lib/shtdlib/shtdlib.sh

# Print some useful information
color_echo cyan "Detected OS type:          ${os_type}"
color_echo cyan "Detected OS family:        ${os_family}"
color_echo cyan "Detected OS name:          ${os_name}"
color_echo cyan "Detected OS major version: ${major_version}"
color_echo cyan "Detected OS minor version: ${minor_version}"

color_echo cyan "Setting up Docker host"
case ${os_family} in
    "RedHat")
        if [ "${major_version}" -ge 7 ] ; then
            # Optional
            yum install -y yum-utils device-mapper-persistent-data lvm2

            yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            yum install -y docker-ce
            systemctl enable docker.service
            systemctl start docker.service
            systemctl status docker.service

            yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
            yum install -y python2-pip
            pip install docker-compose
        fi
    ;;
    "Debian")
        if [ "${major_version}" -ge 16 ] ; then
            # Remove baked in kubernetes apt repo if it exists
            [[ -f /etc/apt/sources.list.d/apt_kubernetes_io.list ]] && rm /etc/apt/sources.list.d/apt_kubernetes_io.list
            # OR add the apt key if you need it
            # [[ -f /etc/apt/sources.list.d/apt_kubernetes_io.list ]] && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6A030B21BA07F4FB

            # Dependencies
            apt-get update
            apt-get install -y apt-transport-https ca-certificates curl software-properties-common

            # Apt key
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
            apt-key fingerprint 0EBFCD88

            # Remove legacy docker, add repo, install latest docker
            apt-get remove -y docker docker-engine docker.io
            add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
            apt-get update
            apt-get install -y docker-ce
            systemctl enable docker.service
            systemctl start docker.service

            # Docker compose
            curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
            chmod +x /usr/local/bin/docker-compose
            docker-compose --version
        fi
    ;;
    *)
        color_echo red "Unable to determine operating system or OS family (${os_family}) is not supported yet!"
        exit 1
    ;;
esac

# Create Moodle data directory
if [ ! -d opt/moodle/moodledata ]; then
    echo "Creating Moodle data directory"
    mkdir -p /opt/moodle/moodledata
    chmod 777 /opt/moodle/moodledata
else
    echo "Moodle data directory already exists"
fi

# Postgres entrypoint has to be executable. Git holds the executable bit but sometimes the file is created with incorrect permissions.
chmod +x docker-postgres/9.6/alpine/docker-entrypoint.sh
