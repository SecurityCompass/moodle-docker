#!/usr/bin/with-contenv sh
set -e;

echo "Starting PHP-FPM"

# Make unix socket for nginx/php
mkdir -p /var/run/php-fpm
touch /var/run/php-fpm/www.sock
chown -R www-data:www-data /var/run/php-fpm

# Configure Moodle (it will wait for PHP/PostgreSQL in the background)
(/usr/local/bin/configure-moodle.sh) &

# Start PHP-FPM
/usr/sbin/php-fpm${PHP_VERSION} -R -F
