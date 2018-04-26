# Moodle Docker Container

## Setup

1. Install Docker on your system.
    ##### On CentOS 7
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

2. Copy/clone dockerfiles from the `moodle-docker` and `docker-posgres` repository and build the containers. Both folders/repos should be in the same parent folder. 
    ```bash
    # Moodle repo
    git clone git@agra.sdelements.com:deployment/moodle-docker.git
    
    # Postgres repo. The entrypoint has to be executable
    git clone git@agra.sdelements.com:deployment/docker-postgres.git && chmod +x docker-postgres/9.6/alpine/docker-entrypoint.sh
    ```

3. Copy your SSL certificate and key into the `conf/etc/nginx/ssl/` dir as `moodle.crt` and `moodle.key`. The included pair are self-signed and can be used for testing. 

    See below for instructions for generating a self-signed certificate pair (TESTING ONLY). 

4. Create data directory for Moodle
    ```bash
    mkdir -p /opt/moodle/moodledata
    chmod 777 /opt/moodle/moodledata
    ``` 

5. Customize `.env` according to your environment. Most notably `MOODLE_VERSION` and `MOODLE_WWWROOT` (based on your instance IP/FQDN)

6. Build, configure and start the docker containers with docker-compose
    ```bash
    cd moodle-docker
    docker-compose up -d --force-recreate -V --always-recreate-deps --build
    ```

## Misc.

* Generate self-signed certificate (TESTING ONLY)

    ```bash
    openssl req -x509 -newkey rsa:4096 -keyout moodle.key -out moodle.crt -days 365 -nodes -subj "/C=CA/ST=ON/L=Toronto/O=SC/OU=Org/CN=www.example.com"
    ```
