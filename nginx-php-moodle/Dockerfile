FROM ubuntu:xenial

LABEL name="nginx-php-moodle"
LABEL version="latest"

# Disable frontend dialogs
ENV DEBIAN_FRONTEND noninteractive

ARG MOODLE_DOWNLOAD_FILE=moodle-latest-35.tgz
ARG MOODLE_TRACK=stable35
ARG MOOVE_VERSION=v0.1.2
ARG NGINX_VERSION=1.14.0-0+xenial2
ARG ONELOGIN_PLUGIN_VER=v2.5.1
ARG PHP_VERSION

# Install utility packages
RUN apt-get update\
    && apt-get install -y vim unzip curl netbase inotify-tools \
    && apt-get --purge -y autoremove \
    && apt-get -y clean \
    && rm -rf /etc/apt/sources.list.d/temp.list /var/lib/apt/lists/*

# Install Nginx
RUN echo "Starting Nginx install..." \
    && apt-get update \
    && apt-get install -y software-properties-common \
    && apt-add-repository ppa:nginx/stable -y \
    && apt-get update \
    && apt-get install -y nginx=${NGINX_VERSION} \
    && apt-get purge -y software-properties-common \
    && apt-get --purge -y autoremove \
    && apt-get -y clean \
    && rm -rf /etc/apt/sources.list.d/temp.list /var/lib/apt/lists/*

# Install PHP
RUN echo "Starting PHP install..." \
    && apt-get update \
    && apt-get install -y software-properties-common \
    && LC_ALL=C.UTF-8 apt-add-repository ppa:ondrej/php -y \
    && apt-get update \
    && apt-get install -y \
    gettext-base \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-memcached \
    php${PHP_VERSION}-pgsql \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-xmlrpc \
    php${PHP_VERSION}-zip \
    ssmtp \
    && ln -sf /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm \
    && ln -sf /etc/init.d/php${PHP_VERSION}-fpm /etc/init.d/php-fpm \
    && apt-get purge -y software-properties-common \
    && apt-get --purge -y autoremove \
    && apt-get -y clean \
    && rm -rf /etc/apt/sources.list.d/temp.list /var/lib/apt/lists/*

# Install Moodle App
RUN echo "Starting Moodle App install..." \
    && mkdir -v /opt/moodle \
    && curl -L -o /tmp/moodle-${MOODLE_TRACK}-${MOODLE_DOWNLOAD_FILE}.tgz https://download.moodle.org/${MOODLE_TRACK}/${MOODLE_DOWNLOAD_FILE} \
    && tar -xzf /tmp/moodle-${MOODLE_TRACK}-${MOODLE_DOWNLOAD_FILE}.tgz -C /opt/moodle \
    && mv /opt/moodle/moodle /opt/moodle/app \
    && chown -R www-data:www-data /opt/moodle/app \
    && find /opt/moodle/app -type d -exec chmod 755 {} \; \
    && find /opt/moodle/app -type f -exec chmod 644 {} \; \
    && rm -fv /tmp/moodle-${MOODLE_TRACK}-${MOODLE_DOWNLOAD_FILE}.tgz

# Install Moodle theme
RUN echo "Starting Moodle theme install..." \
    && curl -L -o /tmp/moove.${MOOVE_VERSION}.tar.gz https://github.com/SecurityCompass/moodle-theme_moove/archive/${MOOVE_VERSION}.tar.gz \
    && mkdir /opt/moodle/app/theme/moove \
    && tar -xzf /tmp/moove.${MOOVE_VERSION}.tar.gz --strip-components=1 -C /opt/moodle/app/theme/moove \
    && chown -R www-data:www-data /opt/moodle/app/theme/moove \
    && find /opt/moodle/app/theme/moove -type d -exec chmod 755 {} \; \
    && find /opt/moodle/app/theme/moove -type f -exec chmod 644 {} \; \
    && rm -fv /tmp/moove.${MOOVE_VERSION}.tar.gz

# Install OneLogin auth plugin
RUN echo "Starting OneLogin auth plugin install..." \
    && curl -L -o /tmp/onelogin_saml.tar.gz https://github.com/onelogin/moodle-saml/archive/${ONELOGIN_PLUGIN_VER}.tar.gz \
    && tar -xzf /tmp/onelogin_saml.tar.gz -C /opt/moodle/app/auth --strip-components=2 \
    && chown -R www-data:www-data /opt/moodle/app/auth/onelogin_saml \
    && find /opt/moodle/app/auth/onelogin_saml -type d -exec chmod 755 {} \; \
    && find /opt/moodle/app/auth/onelogin_saml -type f -exec chmod 644 {} \; \
    && rm -fv /tmp/onelogin_saml.tar.gz

# Install Opcache admin (PHP cache monitoring)
RUN echo "Starting Opcache admin install..." \
    && curl -L -o /tmp/opcache.zip https://moodle.org/plugins/download.php/16894/tool_opcache_moodle35_2018052400.zip \
    && unzip -q /tmp/opcache.zip -d /opt/moodle/app/admin/tool/ \
    && chown -R www-data:www-data /opt/moodle/app/admin/tool/opcache \
    && find /opt/moodle/app/admin/tool/opcache/ -type d -exec chmod 755 {} \; \
    && find /opt/moodle/app/admin/tool/opcache/ -type f -exec chmod 644 {} \; \
    && rm -fv /tmp/opcache.zip

RUN echo "Starting Moodle eMailTest install..." \
    && curl -L -o /tmp/mailtest.zip https://moodle.org/plugins/download.php/16831/local_mailtest_moodle35_2018052100.zip \
    && unzip -q /tmp/mailtest.zip -d /opt/moodle/app/local/ \
    && chown -R www-data:www-data /opt/moodle/app/local/mailtest \
    && find /opt/moodle/app/local/mailtest/ -type d -exec chmod 755 {} \; \
    && find /opt/moodle/app/local/mailtest/ -type f -exec chmod 644 {} \; \
    && rm -fv /tmp/mailtest.zip

RUN echo "Starting Moodle Custom certificate module install..." \
    && curl -L -o /tmp/customcert.zip https://moodle.org/plugins/download.php/17375/mod_customcert_moodle35_2018051704.zip \
    && unzip -q /tmp/customcert.zip -d /opt/moodle/app/mod/ \
    && chown -R www-data:www-data /opt/moodle/app/mod/customcert \
    && find /opt/moodle/app/mod/customcert/ -type d -exec chmod 755 {} \; \
    && find /opt/moodle/app/mod/customcert/ -type f -exec chmod 644 {} \; \
    && rm -fv /tmp/customcert.zip

RUN echo "Starting Moodle Schedular module install..." \
    && curl -L -o /tmp/scheduler.zip https://moodle.org/plugins/download.php/16697/mod_scheduler_moodle35_2017051402.zip \
    && unzip -q /tmp/scheduler.zip -d /opt/moodle/app/mod/ \
    && chown -R www-data:www-data /opt/moodle/app/mod/scheduler \
    && find /opt/moodle/app/mod/scheduler/ -type d -exec chmod 755 {} \; \
    && find /opt/moodle/app/mod/scheduler/ -type f -exec chmod 644 {} \; \
    && rm -fv /tmp/scheduler.zip

# Setup Moosh
RUN echo "Starting Moosh install..." \
    && curl -L -o /tmp/moosh_setup.zip https://moodle.org/plugins/download.php/16504/moosh_moodle35_2018042500.zip \
    && unzip -q /tmp/moosh_setup.zip -d /opt \
    && ln -s /opt/moosh/moosh.php /usr/local/bin/moosh \
    && rm -fv /tmp/moosh_setup.zip

# Copy NGINX service script
COPY bin/start-nginx.sh /etc/services.d/nginx/run
RUN chmod 755 /etc/services.d/nginx/run

# Copy NGINX configuration files
COPY conf/etc/nginx/conf.d /etc/nginx/conf.d
COPY conf/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY conf/etc/nginx/ssl /etc/nginx/ssl

# Copy PHP-FPM service script
COPY bin/start-fpm.sh /etc/services.d/php_fpm/run
RUN chmod 755 /etc/services.d/php_fpm/run

# Copy PHP/PHP-FPM configuration
COPY conf/etc/php/7.2/fpm/php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf
COPY conf/etc/php/7.2/fpm/php.ini /etc/php/7.2/fpm/php.ini
COPY conf/etc/php/7.2/fpm/pool.d/www.conf /etc/php/7.2/fpm/pool.d/www.conf
COPY conf/etc/php/7.2/mods-available/opcache.ini /etc/php/7.2/mods-available/opcache.ini

# Copy certificate watch script
COPY bin/watch_certificate_dir.sh /etc/services.d/watch_certificate_dir/run
RUN chmod 755 /etc/services.d/watch_certificate_dir/run

# Copy Moodle config service script
COPY bin/configure-moodle.sh /usr/local/bin/configure-moodle.sh
RUN chmod 500 /usr/local/bin/configure-moodle.sh

# Copy Moodle config service script
COPY bin/check_db.php /usr/local/bin/check_db.php
RUN chmod 500 /usr/local/bin/check_db.php

# Add S6 supervisor (for graceful stop)
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar -xzf /tmp/s6-overlay-amd64.tar.gz -C /

# Copy Shell Standard Library into the container
ADD https://github.com/sdelements/shtdlib/raw/master/shtdlib.sh /usr/local/bin/shtdlib.sh

ENTRYPOINT ["/init"]
CMD []
