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
    # Remove the Kubernetes Apt source file in `/etc/apt/sources.list.d` or add the Apt key if you require it
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6A030B21BA07F4FB

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

    # Pull submodules into local repo
    git submodule update --init

    # Postgres entrypoint has to be executable. Git holds the executable bit but sometimes the file is created with incorrect permissions.
    chmod +x moodle-docker/docker-postgres/9.6/alpine/docker-entrypoint.sh
    ```

3. Copy your SSL certificate and key into the `conf/etc/nginx/ssl/` dir as `moodle.crt` and `moodle.key`. The included pair are self-signed and can be used (TESTING ONLY).

    Instructions below to generate your own self-signed certificate pair.

4. Create data directory for Moodle (on the host VM)
    ```bash
    mkdir -p /opt/moodle/moodledata
    chmod 777 /opt/moodle/moodledata
    ```

5. Customize `.env` according to your environment. Most notably `MOODLE_VERSION` and `MOODLE_WWWROOT` (based on your instance IP/FQDN)

6. Build, configure and start the docker containers with docker-compose.
    * `-d` toggles foreground/background
    * `-V` recreates anonymous docker volumes (DATA LOSS!)

    Here are some ways to run these containers:

    ##### Build containers
    ```bash
    cd moodle-docker
    docker-compose -f docker-compose.yml -f dc.build.yml build --no-cache
    ```

    ##### Deploy locally (Full stack)
    ```bash
    cd moodle-docker
    docker-compose -f docker-compose.yml -f dc.local.yml up --force-recreate --always-recreate-deps -d -V
    ```
    * Nginx ports: `8443/8080`
    * Postgres port: `N/A`

    ##### Deploy in production (Full stack)
    ```bash
    cd moodle-docker
    docker-compose -f docker-compose.yml -f dc.prod.yml up --force-recreate --always-recreate-deps -d -V
    ```
    * Nginx ports: `443/80`
    * Postgres port: `N/A`

    ##### Deploy Web server and DB separately (separate servers)
    ```bash
    cd moodle-docker
    docker-compose -f docker-compose.yml -f dc.prod-dbonly.yml up --force-recreate -d -V postgres
    docker-compose -f docker-compose.yml -f dc.prod.yml up --force-recreate --no-deps -d -V nginx-php-moodle
    ```
    * Nginx ports: `8443/8080`
    * Postgres port: `5432`

7. Follow these instructions to setup the Moodle app:
    https://securitycompass.atlassian.net/wiki/spaces/DEP/pages/204046339/Moodle+Docker+Deployment

## Misc.

* Generate self-signed certificate (TESTING ONLY)

    ```bash
    openssl req -x509 -newkey rsa:4096 -keyout moodle.key -out moodle.crt -days 365 -nodes -subj "/C=CA/ST=ON/L=Toronto/O=SC/OU=Org/CN=www.example.com"
    ```
