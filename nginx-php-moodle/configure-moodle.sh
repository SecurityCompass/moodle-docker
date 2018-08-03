#!/bin/bash

set -ex;

echo "Configuring Moodle ${MOODLE_VERSION}"

# Configure Moodle
/usr/bin/php${PHP_VERSION} /opt/moodle/moodle-${MOODLE_VERSION}/admin/cli/install.php \
    --adminemail=${MOODLE_ADMIN_EMAIL} \
    --adminpass=${MOODLE_ADMIN_PASS} \
    --agree-license \
    --dataroot=${MOODLE_DATAROOT} \
    --dbhost=${PGSQL_HOSTNAME} \
    --dbname=${PGSQL_DATABASE} \
    --dbpass=${PGSQL_PASSWORD} \
    --dbport=${PGSQL_PORT} \
    --dbtype=${MOODLE_DBTYPE} \
    --dbuser=${PGSQL_USER} \
    --fullname="${MOODLE_FULL_NAME}" \
    --non-interactive \
    --shortname=${MOODLE_SHORT_NAME} \
    --wwwroot=${MOODLE_WWWROOT}

# Update permission on the newly created config file
chown --reference=/opt/moodle/moodle-${MOODLE_VERSION}/config-dist.php /opt/moodle/moodle-${MOODLE_VERSION}/config.php
chmod --reference=/opt/moodle/moodle-${MOODLE_VERSION}/config-dist.php /opt/moodle/moodle-${MOODLE_VERSION}/config.php

# Set the theme to Moove
/usr/bin/php${PHP_VERSION} /opt/moodle/moodle-${MOODLE_VERSION}/admin/cli/cfg.php --name=theme --set=moove
