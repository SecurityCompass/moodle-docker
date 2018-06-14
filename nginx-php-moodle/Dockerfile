FROM ubuntu:xenial

# Disable frontend dialogs
ENV DEBIAN_FRONTEND noninteractive

ARG MOODLE_THEMEDIR
ARG MOODLE_TRACK
ARG MOODLE_VERSION
ARG MOOSH_PACKAGE
ARG NGINX_VERSION
ARG PHP_VERSION
# Print ARGs and install utility packages
RUN echo "Moodle theme dir: $MOODLE_THEMEDIR" \
    && echo "Moodle track:     $MOODLE_TRACK" \
    && echo "Moodle version:   ${MOODLE_VERSION}" \
    && echo "Moosh package:    ${MOOSH_PACKAGE}" \
    && echo "Nginx version:    ${NGINX_VERSION}" \
    && echo "PHP version:      ${PHP_VERSION}" \
    && echo "Starting util packages install..." \
    && apt-get update\
    && apt-get install -y vim unzip curl netbase \
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
    && apt-get purge -y software-properties-common \
    && apt-get --purge -y autoremove \
    && apt-get -y clean \
    && rm -rf /etc/apt/sources.list.d/temp.list /var/lib/apt/lists/*

# Install Moodle App
RUN echo "Starting Moodle App install..." \
    && apt-get update \
    && apt-get install -y wget \
    && mkdir -v /opt/moodle \
    && wget -q https://download.moodle.org/download.php/direct/${MOODLE_TRACK}/moodle-${MOODLE_VERSION}.tgz -O /opt/moodle/moodle-${MOODLE_VERSION}.tgz \
    && tar -xzf /opt/moodle/moodle-${MOODLE_VERSION}.tgz -C /opt/moodle \
    && mv /opt/moodle/moodle /opt/moodle/moodle-${MOODLE_VERSION} \
    && rm /opt/moodle/moodle-${MOODLE_VERSION}.tgz \
    && apt-get --purge -y remove wget \
    && apt-get --purge -y autoremove \
    && apt-get -y clean \
    && rm -rf /etc/apt/sources.list.d/temp.list /var/lib/apt/lists/*

# Copy in the Moodle config and set permissions
COPY ./config.php /opt/moodle/moodle-${MOODLE_VERSION}/config.php
RUN chown --reference=/opt/moodle/moodle-${MOODLE_VERSION}/config-dist.php /opt/moodle/moodle-${MOODLE_VERSION}/config.php \
    && chmod --reference=/opt/moodle/moodle-${MOODLE_VERSION}/config-dist.php /opt/moodle/moodle-${MOODLE_VERSION}/config.php

# Install Moodle theme
RUN echo "Starting Moodle theme install..." \
    && apt-get update \
    && apt-get install -y git \
    && mkdir -v ${MOODLE_THEMEDIR} \
    && cd ${MOODLE_THEMEDIR} \
    && git clone https://github.com/SecurityCompass/moodle-theme_moove.git moove \
    && find ${MOODLE_THEMEDIR} -type d -exec chmod 755 {} \; \
    && find ${MOODLE_THEMEDIR} -type f -exec chmod 644 {} \; \
    && apt-get --purge -y remove git \
    && apt-get --purge -y autoremove \
    && apt-get -y clean \
    && rm -rf /etc/apt/sources.list.d/temp.list /var/lib/apt/lists/*

# Install Admin presets
RUN echo "Starting Admin presets install..." \
    && curl -o /tmp/admin_presets.zip https://moodle.org/plugins/download.php/16675/block_admin_presets_moodle35_2018051201.zip \
    && unzip /tmp/admin_presets.zip -d /opt/moodle/moodle-${MOODLE_VERSION}/blocks/ \
    && find /opt/moodle/moodle-${MOODLE_VERSION}/blocks/admin_presets/ -type d -exec chmod 755 {} \; \
    && find /opt/moodle/moodle-${MOODLE_VERSION}/blocks/admin_presets/ -type f -exec chmod 644 {} \; \
    && rm -fv /tmp/admin_presets.zip

# Install Opcache admin (PHP cache monitoring)
RUN echo "Starting Opcache admin install..." \
    && curl -o /tmp/opcache.zip https://moodle.org/plugins/download.php/16894/tool_opcache_moodle35_2018052400.zip \
    && unzip /tmp/opcache.zip -d /opt/moodle/moodle-${MOODLE_VERSION}/admin/tool/ \
    && find /opt/moodle/moodle-${MOODLE_VERSION}/admin/tool/opcache/ -type d -exec chmod 755 {} \; \
    && find /opt/moodle/moodle-${MOODLE_VERSION}/admin/tool/opcache/ -type f -exec chmod 644 {} \; \
    && rm -fv /tmp/opcache.zip

# Copy NGINX service script
COPY start-nginx.sh /etc/services.d/nginx/run
RUN chmod 755 /etc/services.d/nginx/run

# Copy PHP-FPM service script
COPY start-fpm.sh /etc/services.d/php_fpm/run
RUN chmod 755 /etc/services.d/php_fpm/run

# Add S6 supervisor (for graceful stop)
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar -xzf /tmp/s6-overlay-amd64.tar.gz -C /

# Copy Shell Standard Library into the container
ADD https://github.com/sdelements/shtdlib/raw/master/shtdlib.sh /usr/local/bin/shtdlib.sh

# Setup Moosh
RUN echo "Starting Moosh install..." \
    && curl -q https://moodle.org/plugins/download.php/16504/${MOOSH_PACKAGE} -o /root/moosh_setup.zip && \
    unzip -q /root/moosh_setup.zip -d /opt && \
    ln -s /opt/moosh/moosh.php /usr/local/bin/moosh

# Set these to local ports and override in docker-compose
EXPOSE 8080
EXPOSE 8443

ENTRYPOINT ["/init"]
CMD []
