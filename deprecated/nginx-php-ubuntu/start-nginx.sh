#!/usr/bin/with-contenv sh
set -e;

# Wait 5s for PHP-FPM to come up
sleep 5

envsubst '${MOODLE_DATAROOT} ${MOODLE_VERSION}' < /etc/nginx/conf.d/moodle.template > /etc/nginx/conf.d/moodle.conf && nginx -g 'daemon off;'
