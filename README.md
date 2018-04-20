# Moodle Docker Container

## Setup

1. Install Docker on your system.
    ##### On CentOS 7
    ```
    yum install -y yum-utils device-mapper-persistent-data lvm2
    
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum install docker-ce
    systemctl enable docker.service
    systemctl start docker.service
    systemctl status docker.service
    
    yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    yum install python2-pip
    pip install docker-compose
    ```

2. Copy dockerfiles from the moodle-docker repository and build the containers
    ```
    git clone git@agra.sdelements.com:deployment/moodle-docker.git
    
    cd moodle-docker && ./build.sh
    ```

3. Copy your SSL certificate and key into the `conf/etc/nginx/ssl/` dir. See below for instructions for generating a self-signed certificate pair for testing. 

4. Build postgres container from the Dockerfile
    ```
    git clone git@agra.sdelements.com:deployment/docker-postgres.git && cd docker-postgres/9.6/alpine && docker build -t moodle-postgres .
    ```
    NOTE: You may need to set the execute bit on `docker-entrypoint.sh` before building the container. E.g. `chmod +x docker-entrypoint.sh`

5. Configure and start the docker containers with the docker-compose file
    ```
    docker-compose up -d
    ```

## Misc.

* Generate self-signed certificate (TESTING ONLY)

    ```
    openssl req -x509 -newkey rsa:4096 -keyout moodle.key -out moodle.crt -days 365 -nodes -subj "/C=CA/ST=ON/L=Toronto/O=SC/OU=Org/CN=www.example.com"
    ```
