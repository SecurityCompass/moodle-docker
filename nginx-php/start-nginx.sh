#!/usr/bin/with-contenv sh
set -e;

#/bin/wait-for-it.sh -t 120 127.0.0.1:9000
sleep 5

envsubst '${MOODLE_DATAROOT} ${MOODLE_VERSION}' < /etc/nginx/conf.d/moodle.template > /etc/nginx/conf.d/moodle.conf && nginx -g 'daemon off;'
