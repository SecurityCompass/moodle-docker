#!/usr/bin/with-contenv sh
set -e;

# Make unix socket for nginx/php
mkdir -p /var/run/php-fpm
touch /var/run/php-fpm/www.sock
chown -R www-data:www-data /var/run/php-fpm

# Start PHP-FPM
/usr/sbin/php-fpm${PHP_VERSION} -R -F
