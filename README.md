# Moodle Docker Container

## Summary
This project deploys the Moodle (Modular Object-Oriented Dynamic Learning Environment) course management system using one Docker container that runs both Nginx and PHP/PHP-FPM services

## Local Environment Setup

1. Install Docker on your system.
    ```bash
    ./setup.sh
    ```

2. Copy/clone dockerfiles from the `moodle-docker` repository and build the containers. Note: `docker-postgres` is a Git submodule in `moodle-docker`.
    ```bash
    # Moodle repo
    git clone https://github.com/SecurityCompass/moodle-docker.git

    # Pull submodules into local repo
    git submodule update --init
    ```

3. Copy your SSL certificate and key into the `conf/etc/nginx/ssl/` dir as `moodle.crt` and `moodle.key`. The included pair are self-signed and can be used (TESTING ONLY).

    Instructions below to generate your own self-signed certificate pair.

4. Customize `.env` according to your environment. Most notably `MOODLE_WWWROOT` (based on your instance IP/FQDN)

5. Build, configure and start the docker containers with docker-compose.
    * `-d` toggles foreground/background

    Here are some ways to run these containers:

    ##### Build containers
    ```bash
    cd moodle-docker
    docker-compose --file docker-compose.yml --file dc.build.yml build --no-cache
    ```

    ##### Deploy locally (Full stack)
    Modify these lines in `.env` to match your local environment
    
    * `HTTP_PORT`
    * `HTTPS_PORT`
    * `MOODLE_WWWROOT`
    * `MOODLE_DATAROOT`
        
    Then start the containers with:
    ```bash
    cd moodle-docker
    docker-compose --file docker-compose.yml --file up --force-recreate --always-recreate-deps --detach
    ```
    
    * Nginx ports: `8443/8080`
    * Postgres port: `N/A`
    
    ##### Deploy in production (Full stack)
    ```bash
    cd moodle-docker
    docker-compose --file docker-compose.yml up --force-recreate --always-recreate-deps --detach
    ```
    * Nginx ports: `443/80`
    * Postgres port: `N/A`

    ##### Deploy Web server and DB separately (separate servers)
    ```bash
    cd moodle-docker
    docker-compose --file docker-compose.yml --file dc.prod-dbonly.yml up --force-recreate --detach postgres
    docker-compose --file docker-compose.yml up --force-recreate --no-deps --detach nginx-php-moodle
    ```
    * Nginx ports: `8443/8080`
    * Postgres port: `5432`

## Misc.

* Generate self-signed certificate (TESTING ONLY)

    ```bash
    openssl req -x509 -newkey rsa:4096 -keyout moodle.key -out moodle.crt -days 365 -nodes -subj "/C=CA/ST=ON/L=Toronto/O=SC/OU=Org/CN=www.example.com"
    ```
