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

# Source shtdlib
# shellcheck disable=SC1091
source /usr/local/bin/shtdlib.sh

moodle_cert='/etc/nginx/ssl/moodle.crt'
moodle_key='/etc/nginx/ssl/moodle.key'

echo "Watching ${CERT_DIR} for updated certs..."

function reload_nginx {
    echo "Detected files modified in certificate directory..."
    sleep 5 # Sleep for 5s for file operations to complete.

    echo "Linking certificate files..."
    if [ -L "${moodle_cert}" ] && [ -L "${moodle_key}" ] ; then
        echo "Certificate symlinks already exist. Continuing..."
    else
        echo "Certificate symlinks not found, creating..."
        ln -sf "${CERT_DIR}/${CERT_DOMAIN}.fullchain.pem" "${moodle_cert}"
        ln -sf "${CERT_DIR}/${CERT_DOMAIN}.key.pem" "${moodle_key}"
    fi

    echo "Reloading nginx..."
    pkill -SIGHUP nginx
    echo "Nginx reloaded."
}

add_on_mod reload_nginx "${CERT_DIR}"
