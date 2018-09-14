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

echo "Starting Nginx"

# Source shtdlib
# shellcheck disable=SC1091
source /usr/local/bin/shtdlib.sh

# Wait for PHP-FPM to start Nginx
if wait_for_success "/etc/init.d/php7.2-fpm status"; then
    # shellcheck disable=SC2016
    envsubst '${MOODLE_DATAROOT} ${MOODLE_VERSION} ${HTTP_PORT} ${HTTPS_PORT}' < /etc/nginx/conf.d/moodle.template > /etc/nginx/conf.d/moodle.conf && nginx -g 'daemon off;'
else
    echo "PHP-FPM did not start in time. Aborting Nginx start up."
    exit 1
fi
