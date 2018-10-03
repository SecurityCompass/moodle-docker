#!/bin/bash
#
# Copyright (c) 2018 SD Elements Inc.
#
#  All Rights Reserved.
#
# NOTICE:  All information contained herein is, and remains
# the property of SD Elements Incorporated and its suppliers,
# if any.  The intellectual and technical concepts contained
# herein are proprietary to SD Elements Incorporated
# and its suppliers and may be covered by U.S., Canadian and other Patents,
# patents in process, and are protected by trade secret or copyright law.
# Dissemination of this information or reproduction of this material
# is strictly forbidden unless prior written permission is obtained
# from SD Elements Inc..
# Version

set -eo pipefail

# Source shtdlib
# shellcheck disable=SC1091
source /usr/local/bin/shtdlib.sh

echo "Waiting for PHP-FPM to come up..."
if wait_for_success "/etc/init.d/php7.2-fpm status"; then
    echo "PHP-FPM started!"

    echo "Fixing permissions on moodledata directory..."
    chown -R www-data:www-data /opt/moodle/moodledata

    echo "Waiting for PostgreSQL to come up..."
    if wait_for_success "/usr/bin/php${PHP_VERSION} -f /usr/local/bin/check_db.php" 120 10; then
        echo "PostgreSQL started!"

        # Try to upgrade if config.php found
        if [[ -s /opt/moodle/moodle-${MOODLE_VERSION}/config.php ]]; then
            echo "Attempting to upgrade Moodle"
            "/usr/bin/php${PHP_VERSION}" "/opt/moodle/moodle-${MOODLE_VERSION}/admin/cli/upgrade.php" --non-interactive
        else
            echo "Starting initial configuration for Moodle ${MOODLE_VERSION}"
            "/usr/bin/php${PHP_VERSION}" "/opt/moodle/moodle-${MOODLE_VERSION}/admin/cli/install.php" \
                --adminemail="${MOODLE_ADMIN_EMAIL}" \
                --adminpass="${MOODLE_ADMIN_PASS}" \
                --agree-license \
                --dataroot="${MOODLE_DATAROOT}" \
                --dbhost="${PGSQL_HOSTNAME}" \
                --dbname="${PGSQL_DATABASE}" \
                --dbpass="${PGSQL_PASSWORD}" \
                --dbport="${PGSQL_PORT}" \
                --dbtype="${MOODLE_DBTYPE}" \
                --dbuser="${PGSQL_USER}" \
                --fullname="${MOODLE_FULL_NAME}" \
                --non-interactive \
                --shortname="${MOODLE_SHORT_NAME}" \
                --upgradekey="${MOODLE_UPGRADE_KEY}" \
                --wwwroot="${MOODLE_WWWROOT}"

            echo "Adding optimization configuration for static files"
                cat >> "/opt/moodle/moodle-${MOODLE_VERSION}/config.php" <<MDL_CONFIG

// Performance optimization for Nginx static content
\$CFG->xsendfile = 'X-Accel-Redirect';     // Nginx {@see http://wiki.nginx.org/XSendfile}
\$CFG->xsendfilealiases = array(
    '/dataroot/' => \$CFG->dataroot,
);

MDL_CONFIG

            echo "Updating permission on the newly created config file"
            chown --reference="/opt/moodle/moodle-${MOODLE_VERSION}/config-dist.php" "/opt/moodle/moodle-${MOODLE_VERSION}/config.php"
            chmod --reference="/opt/moodle/moodle-${MOODLE_VERSION}/config-dist.php" "/opt/moodle/moodle-${MOODLE_VERSION}/config.php"

            echo "Enabling Moove theme"
            "/usr/bin/php${PHP_VERSION}" "/opt/moodle/moodle-${MOODLE_VERSION}/admin/cli/cfg.php" --name=theme --set=moove

            echo "Override default password policy to remove non-alphanumeric character requirement"
            "/usr/bin/php${PHP_VERSION}" "/opt/moodle/moodle-${MOODLE_VERSION}/admin/cli/cfg.php" --name=minpasswordnonalphanum --set=0

            echo "Skipping Moodle registration"
            "/usr/bin/php${PHP_VERSION}" "/opt/moodle/moodle-${MOODLE_VERSION}/admin/cli/cfg.php" --name=registrationpending --set=0
        fi
    fi
fi

echo "Configuration complete!"
