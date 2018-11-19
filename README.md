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
    * `--detach` toggles foreground/background

    Here are some ways to run these containers:

    ##### Build containers
    ```bash
    cd moodle-docker
    docker-compose --file docker-compose.yml --file dc.build.yml build --no-cache
    ```

    ##### Deploy locally (Full stack)
    Modify these lines in `.env` to match your local environment
    
    * `MOODLE_WWWROOT` (Usually 127.0.0.1)
    * `MOODLE_DATAROOT` (Make this directory locally and use the full path)
        
    Then start the containers with:
    ```bash
    cd moodle-docker
    docker-compose --file docker-compose.yml up --force-recreate --always-recreate-deps --detach
    ```

    ##### Deploy in production (Full stack)
    Modify these lines in `.env` to match your local environment
    
    * `MOODLE_WWWROOT` (Usually the FQDN)
    * `MOODLE_DATAROOT` (Make this directory and use the full path)

    Then start the containers with:
    ```bash
    cd moodle-docker
    docker-compose --file docker-compose.yml up --force-recreate --always-recreate-deps --detach
    ```

    ##### Deploy Web server and DB separately (separate servers)
    ```bash
    cd moodle-docker
    docker-compose --file docker-compose.yml --file dc.prod-dbonly.yml up --force-recreate --detach postgres
    docker-compose --file docker-compose.yml up --force-recreate --no-deps --detach nginx-php-moodle
    ```


## E-Mail

### Configuration
There are 3 ways to configure mail in Moodle (`.../admin/settings.php?section=outgoingmailconfig`):
* Directly configure SMTP hosts/security/username/password/etc.
* Use `postfix` container by setting `smtphosts` to `postfix`
* Use "PHP default method" by leaving `smtphosts` empty and PHP will use `ssmtp` to relay the messages to the `postfix` container

### Testing email
The [Moodle eMailTest](https://moodle.org/plugins/local_mailtest) plugin is baked into the Moodle container (`.../local/mailtest/`) to allow users to test their outgoing email configuration


## Misc.

* Generate self-signed certificate (TESTING ONLY)

    ```bash
    openssl req -x509 -newkey rsa:4096 -keyout moodle.key -out moodle.crt -days 365 -nodes -subj "/C=CA/ST=ON/L=Toronto/O=SC/OU=Org/CN=www.example.com"
    ```

## Backup and Restore

### Manual backups

On systems installed from .deb package, a cronjob should be automatically setup to perform backups.  On a development system, you can manually run the same process:

```
docker-compose run postgres-backup /bin/backup_db
```

### Restoring a database backup

First, ensure you have a backup and delta to restore from!  On systems installed from .deb package, the files are stored on the docker host under /backups by default.

Pause the backup cron on the docker host by commenting the job:

```
sed -i 's/^\([^#]\)/#\1/g' /etc/cron.d/postgres-backup
```

Switch to the moodle config folder:

```
cd /etc/moodle-docker
```

Enable the site maintenance page:

```
docker-compose exec nginx-php-moodle /usr/bin/php /opt/moodle/app/admin/cli/maintenance.php --enable
```

Drop and re-create the database:

```
docker-compose run postgres-backup /bin/drop_and_create
```

Restore the DB by running the script and answering the interactive prompts regarding which backup to restore:

```
docker-compose run postgres-backup /bin/restore_db_from_delta
```

Disable the site maintenance page:

```
docker-compose exec nginx-php-moodle /usr/bin/php /opt/moodle/app/admin/cli/maintenance.php --disable
```
Unpause the backup:

```
sed -i 's/^#//g' /etc/cron.d/postgres-backup
```
