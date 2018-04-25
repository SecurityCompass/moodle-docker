# Moodle Docker Container

## Setup

1. Install Docker on your system.
    ##### On CentOS 7
    ```
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

2. Copy/clone dockerfiles from the `moodle-docker` and `docker-posgres` repository and build the containers
    ```
    # Moodle repo
    git clone git@agra.sdelements.com:deployment/moodle-docker.git
    
    # Postgres repo. The entrypoint has to be executable
    git clone git@agra.sdelements.com:deployment/docker-postgres.git && cd docker-postgres/9.6/alpine && chmod +x docker-entrypoint.sh
    ```

3. Copy your SSL certificate and key into the `conf/etc/nginx/ssl/` dir as `moodle.crt` and `moodle.key`. See below for instructions for generating a self-signed certificate pair for testing. 

4. Configure and start the docker containers with the docker-compose file
    ```
    cd moodle-docker && docker-compose up -d
    ```

## Misc.

* Generate self-signed certificate (TESTING ONLY)

    ```
    openssl req -x509 -newkey rsa:4096 -keyout moodle.key -out moodle.crt -days 365 -nodes -subj "/C=CA/ST=ON/L=Toronto/O=SC/OU=Org/CN=www.example.com"
    ```
