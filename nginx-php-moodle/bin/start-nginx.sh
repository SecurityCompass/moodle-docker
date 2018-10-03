#!/usr/bin/with-contenv bash
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

set -e

echo "Starting Nginx init script"

# Source shtdlib
# shellcheck disable=SC1091
source /usr/local/bin/shtdlib.sh

color_echo green "Wait for PHP-FPM to start before starting Nginx"
if wait_for_success "/etc/init.d/php7.2-fpm status"; then
    color_echo green "Starting Nginx"
    # shellcheck disable=SC2016
    envsubst '${MOODLE_DATAROOT} ${MOODLE_VERSION} ${HTTP_PORT} ${HTTPS_PORT} ${CHALLENGE_DIR} ' < /etc/nginx/conf.d/moodle.template > /etc/nginx/conf.d/moodle.conf && nginx -g 'daemon off;'
else
    color_echo red "PHP-FPM did not start in time. Aborting Nginx start up."
    exit 1
fi
