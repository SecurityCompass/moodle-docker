# Moodle Docker Container

## Setup

1. Install Docker on your system.
    ##### CentOS 7
    ```bash
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
    ```

    ##### Ubuntu 16.04
    ```bash
    # Dependencies
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
 
    # Apt key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    apt-key fingerprint 0EBFCD88

    # Remove legacy docker, add repo, install latest docker
    apt-get remove -y docker docker-engine docker.io
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce
    systemctl enable docker.service
    systemctl start docker.service
    systemctl status docker.service

    # Docker compose
    curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    docker-compose --version
    ```

2. Copy/clone dockerfiles from the `moodle-docker` repository and build the containers. Note: `docker-postgres` is a Git submodule in `moodle-docker`. 
    ```bash
    # Moodle repo
    git clone git@agra.sdelements.com:deployment/moodle-docker.git
    
    # Postgres entrypoint has to be executable
    chmod +x moodle-docker/docker-postgres/9.6/alpine/docker-entrypoint.sh
    ```

3. Copy your SSL certificate and key into the `conf/etc/nginx/ssl/` dir as `moodle.crt` and `moodle.key`. The included pair are self-signed and can be used (TESTING ONLY). 

    Instructions below to generate your own self-signed certificate pair.

4. Create data directory for Moodle
    ```bash
    mkdir -p /opt/moodle/moodledata
    chmod 777 /opt/moodle/moodledata
    ``` 

5. Customize `.env` according to your environment. Most notably `MOODLE_VERSION` and `MOODLE_WWWROOT` (based on your instance IP/FQDN)

6. Build, configure and start the docker containers with docker-compose. Note: `-d` toggles foreground/background and `-V` recreates docker volumes (DATA LOSS).
    ##### To start from scratch
    ```bash
    cd moodle-docker
    docker-compose up --force-recreate --always-recreate-deps --build -d -V
    ```
    
    ##### Re-crate containers/Restart services
    ```bash
    cd moodle-docker
    docker-compose up --force-recreate --always-recreate-deps --build -d
    ```

7. Follow these instructions to setup the Moodle app:
    https://securitycompass.atlassian.net/wiki/spaces/DEP/pages/204046339/Moodle+Docker+Deployment

## Misc.

* Generate self-signed certificate (TESTING ONLY)

    ```bash
    openssl req -x509 -newkey rsa:4096 -keyout moodle.key -out moodle.crt -days 365 -nodes -subj "/C=CA/ST=ON/L=Toronto/O=SC/OU=Org/CN=www.example.com"
    ```
