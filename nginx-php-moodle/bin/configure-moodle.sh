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

moodle_release=$(grep '$release' /opt/moodle/app/version.php | cut -d"'" -f2)

function moodle_init_config {
    color_echo green "Starting Moodle '${moodle_release}' installation"
    /usr/bin/php /opt/moodle/app/admin/cli/install.php \
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

    color_echo green "Adding optimization configuration for static files"
    cat >> "/opt/moodle/app/config.php" <<MDL_CONFIG

// Performance optimization for Nginx static content
\$CFG->xsendfile = 'X-Accel-Redirect';     // Nginx {@see http://wiki.nginx.org/XSendfile}
\$CFG->xsendfilealiases = array(
    '/dataroot/' => \$CFG->dataroot,
);

MDL_CONFIG

    color_echo green "Updating 'config.php' ownership and permission"
    chown --reference="/opt/moodle/app/config-dist.php" "/opt/moodle/app/config.php"
    chmod --reference="/opt/moodle/app/config-dist.php" "/opt/moodle/app/config.php"

    color_echo green "Backing up Moodle configuration"
    cp --preserve=all -v "/opt/moodle/app/config.php" /opt/moodle/backup/config.php

    # Moodle Configuration
    moodle_cfg_script="/opt/moodle/app/admin/cli/cfg.php"
    color_echo green "Enabling Moove theme"
    /usr/bin/php "${moodle_cfg_script}" --name=theme --set=moove

    color_echo green "Override default password policy to remove non-alphanumeric character requirement"
    /usr/bin/php "${moodle_cfg_script}" --name=minpasswordnonalphanum --set=0

    color_echo green "Skipping Moodle registration"
    /usr/bin/php "${moodle_cfg_script}" --name=registrationpending --set=0
}

function moodle_restore_config {
    # Check if the container already contains a `config.php`
    if [[ -s "/opt/moodle/app/config.php" ]]; then
        # Check if its different from the backup
        if ! diff -u "/opt/moodle/app/config.php" /opt/moodle/backup/config.php; then
            # This *should* never happen
            color_echo yellow "Warning: 'config.php' does not match backup"
        else
            color_echo green "'config.php' matches backup. Nothing to do"
            return
        fi
    else
        # Most likely a new container
        color_echo green "'config.php' does not exist, restoring from backup."
    fi

    color_echo yellow "Restoring Moodle configuration from backup"
    cp -fv /opt/moodle/backup/config.php "/opt/moodle/app/config.php"

    color_echo green "Updating 'config.php' ownership and permission"
    chown --reference="/opt/moodle/app/config-dist.php" "/opt/moodle/app/config.php"
    chmod --reference="/opt/moodle/app/config-dist.php" "/opt/moodle/app/config.php"
}

function moodle_upgrade {
    color_echo green "Attempting to upgrade Moodle '${moodle_release}'"
    /usr/bin/php "/opt/moodle/app/admin/cli/upgrade.php" --non-interactive
}


color_echo green "Waiting for PHP-FPM to come up..."
if wait_for_success "/etc/init.d/php-fpm status"; then
    color_echo green "PHP-FPM started!"

    color_echo green "Waiting for PostgreSQL to come up..."
    if wait_for_success "/usr/bin/php -f /usr/local/bin/check_db.php" 120 10; then
        color_echo green "PostgreSQL started!"

        color_echo green "Checking if the Moodle configuration file needs to be restored from the backup"
        if [[ -s /opt/moodle/backup/config.php ]]; then
            color_echo green "Backup configuration file found"
            moodle_restore_config
            moodle_upgrade
        else
            color_echo green "No backup configuration file found"
            moodle_init_config
        fi
    fi
fi

color_echo green "Configuration complete!"
