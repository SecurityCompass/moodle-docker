#!/usr/bin/with-contenv sh
set -e;

mkdir -p /var/run/php-fpm
touch /var/run/php-fpm/www.sock
# Start PHP-FPM
/usr/sbin/php-fpm${PHP_VERSION} -R -F
