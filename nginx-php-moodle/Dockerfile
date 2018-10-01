FROM ubuntu:xenial

LABEL name="nginx-php-moodle"
LABEL version="latest"

# Disable frontend dialogs
ENV DEBIAN_FRONTEND noninteractive

ARG MOODLE_DOWNLOAD_FILE
ARG MOODLE_TRACK
ARG MOODLE_VERSION
ARG NGINX_VERSION
ARG ONELOGIN_PLUGIN_VER
ARG PHP_VERSION

# Print ARGs and install utility packages
RUN echo "Moodle track:     $MOODLE_TRACK" \
    && echo "Moodle filename:  ${MOODLE_DOWNLOAD_FILE}" \
    && echo "Moodle version:   ${MOODLE_VERSION}" \
    && echo "Nginx version:    ${NGINX_VERSION}" \
    && echo "OneLogin version: ${ONELOGIN_PLUGIN_VER}" \
    && echo "PHP version:      ${PHP_VERSION}" \
    && echo "Starting util packages install..." \
    && apt-get update\
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
    && apt-get purge -y software-properties-common \
    && apt-get --purge -y autoremove \
    && apt-get -y clean \
    && rm -rf /etc/apt/sources.list.d/temp.list /var/lib/apt/lists/*

# Install Moodle App
RUN echo "Starting Moodle App install..." \
    && apt-get update \
    && apt-get install -y wget \
    && mkdir -v /opt/moodle \
    && wget -q https://download.moodle.org/download.php/direct/${MOODLE_TRACK}/${MOODLE_DOWNLOAD_FILE} -O /opt/moodle/moodle-${MOODLE_VERSION}.tgz \
    && tar -xzf /opt/moodle/moodle-${MOODLE_VERSION}.tgz -C /opt/moodle \
    && mv /opt/moodle/moodle /opt/moodle/moodle-${MOODLE_VERSION} \
    && rm /opt/moodle/moodle-${MOODLE_VERSION}.tgz \
    && apt-get --purge -y remove wget \
    && apt-get --purge -y autoremove \
    && apt-get -y clean \
    && rm -rf /etc/apt/sources.list.d/temp.list /var/lib/apt/lists/*

# Install Moodle theme
RUN echo "Starting Moodle theme install..." \
    && apt-get update \
    && apt-get install -y git \
    && cd /opt/moodle/moodle-${MOODLE_VERSION}/theme \
    && git clone https://github.com/SecurityCompass/moodle-theme_moove.git moove \
    && find /opt/moodle/moodle-${MOODLE_VERSION}/theme/moove -type d -exec chmod 755 {} \; \
    && find /opt/moodle/moodle-${MOODLE_VERSION}/theme/moove -type f -exec chmod 644 {} \; \
    && apt-get --purge -y remove git \
    && apt-get --purge -y autoremove \
    && apt-get -y clean \
    && rm -rf /etc/apt/sources.list.d/temp.list /var/lib/apt/lists/*

# Install OneLogin auth plugin
RUN echo "Starting OneLogin auth plugin install..." \
    && curl -L -o /tmp/onelogin_saml.tar.gz https://github.com/onelogin/moodle-saml/archive/${ONELOGIN_PLUGIN_VER}.tar.gz \
    && tar -xvzf /tmp/onelogin_saml.tar.gz -C /opt/moodle/moodle-${MOODLE_VERSION}/auth --strip-components=2 \
    && chown -R --reference /opt/moodle/moodle-${MOODLE_VERSION}/auth/index.html /opt/moodle/moodle-${MOODLE_VERSION}/auth/onelogin_saml \
    && find /opt/moodle/moodle-${MOODLE_VERSION}/auth/onelogin_saml -type d -exec chmod 755 {} \; \
    && find /opt/moodle/moodle-${MOODLE_VERSION}/auth/onelogin_saml -type f -exec chmod 644 {} \;

# Install Opcache admin (PHP cache monitoring)
RUN echo "Starting Opcache admin install..." \
    && curl -o /tmp/opcache.zip https://moodle.org/plugins/download.php/16894/tool_opcache_moodle35_2018052400.zip \
    && unzip /tmp/opcache.zip -d /opt/moodle/moodle-${MOODLE_VERSION}/admin/tool/ \
    && find /opt/moodle/moodle-${MOODLE_VERSION}/admin/tool/opcache/ -type d -exec chmod 755 {} \; \
    && find /opt/moodle/moodle-${MOODLE_VERSION}/admin/tool/opcache/ -type f -exec chmod 644 {} \; \
    && rm -fv /tmp/opcache.zip

# Setup Moosh
RUN echo "Starting Moosh install..." \
    && curl -o /root/moosh_setup.zip https://moodle.org/plugins/download.php/16504/moosh_moodle35_2018042500.zip \
    && unzip -q /root/moosh_setup.zip -d /opt \
    && ln -s /opt/moosh/moosh.php /usr/local/bin/moosh

# Copy NGINX service script
COPY bin/start-nginx.sh /etc/services.d/nginx/run
RUN chmod 755 /etc/services.d/nginx/run

# Copy PHP-FPM service script
COPY bin/start-fpm.sh /etc/services.d/php_fpm/run
RUN chmod 755 /etc/services.d/php_fpm/run

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
