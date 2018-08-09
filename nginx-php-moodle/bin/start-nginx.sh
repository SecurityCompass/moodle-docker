#!/usr/bin/with-contenv bash
set -e;

echo "Starting Nginx"

# Source shtdlib
. /usr/local/bin/shtdlib.sh

# Wait for PHP-FPM to start Nginx
if wait_for_success "/etc/init.d/php7.2-fpm status"; then
    envsubst '${MOODLE_DATAROOT} ${MOODLE_VERSION}' < /etc/nginx/conf.d/moodle.template > /etc/nginx/conf.d/moodle.conf && nginx -g 'daemon off;'
else
    echo "PHP-FPM did not start in time. Aborting Nginx start up."
    exit 1
fi
