#!/bin/bash

set -e;

# Source shtdlib
. /usr/local/bin/shtdlib.sh

echo "Waiting for PHP-FPM to come up..."
if wait_for_success "/etc/init.d/php7.2-fpm status"; then
    echo "PHP-FPM started!"

    echo "Waiting for PostgreSQL to come up..."
    if [[ /usr/bin/php${PHP_VERSION} -f /opt/moodle/check_db.php ]]; then
        echo "PostgreSQL started!"

        # Try to upgrade if config.php found
        if [[ -s /opt/moodle/moodle-${MOODLE_VERSION}/config.php ]]; then
            echo "Attempting to upgrade Moodle"
            /usr/bin/php${PHP_VERSION} /opt/moodle/moodle-${MOODLE_VERSION}/admin/cli/upgrade.php --non-interactive

            echo "Upgrade complete!"
        else
            echo "Configuring Moodle ${MOODLE_VERSION}"
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
                --upgradekey=${MOODLE_UPGRADE_KEY} \
                --wwwroot=${MOODLE_WWWROOT}

            echo "Adding optimization configuration for static files"
                cat >> /opt/moodle/moodle-${MOODLE_VERSION}/config.php <<MDL_CONFIG

// Performance optimization for Nginx static content
\$CFG->xsendfile = 'X-Accel-Redirect';     // Nginx {@see http://wiki.nginx.org/XSendfile}
\$CFG->xsendfilealiases = array(
    '/dataroot/' => \$CFG->dataroot,
);

MDL_CONFIG

            echo "Updating permission on the newly created config file"
            chown --reference=/opt/moodle/moodle-${MOODLE_VERSION}/config-dist.php /opt/moodle/moodle-${MOODLE_VERSION}/config.php
            chmod --reference=/opt/moodle/moodle-${MOODLE_VERSION}/config-dist.php /opt/moodle/moodle-${MOODLE_VERSION}/config.php

            echo "Enabling Moove theme"
            /usr/bin/php${PHP_VERSION} /opt/moodle/moodle-${MOODLE_VERSION}/admin/cli/cfg.php --name=theme --set=moove

            echo "Skipping Moodle registration"
            /usr/bin/php${PHP_VERSION} /opt/moodle/moodle-${MOODLE_VERSION}/admin/cli/cfg.php --name=registrationpending --set=0

            echo "Installation complete!"
        fi
    fi
fi
