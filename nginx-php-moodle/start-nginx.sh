#!/usr/bin/with-contenv bash
set -e;

# Source shtdlib
. /usr/local/bin/shtdlib.sh

# Wait 10s for PHP-FPM to come up
if wait_for_success "/etc/init.d/php7.2-fpm status"; then
    envsubst '${MOODLE_DATAROOT} ${MOODLE_VERSION}' < /etc/nginx/conf.d/moodle.template > /etc/nginx/conf.d/moodle.conf && nginx -g 'daemon off;'
else
    echo "Error starting PHP-FPM."
    exit 1
fi
