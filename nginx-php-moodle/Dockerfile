FROM ubuntu:xenial

ARG MOODLE_TRACK
ARG MOODLE_VERSION
ARG MOOSH_PACKAGE
ARG PHP_VERSION
RUN echo "Moodle track: $MOODLE_TRACK"
RUN echo "Moodle version: ${MOODLE_VERSION}"
RUN echo "Moosh package: ${MOOSH_PACKAGE}"
RUN echo "PHP version: ${PHP_VERSION}"

# Disable frontend dialogs
ENV DEBIAN_FRONTEND noninteractive

# Add ppa, curl and syslogd
RUN apt-get update && apt-get install -y software-properties-common curl inetutils-syslogd && \
    apt-add-repository ppa:nginx/stable -y && \
    LC_ALL=C.UTF-8 apt-add-repository ppa:ondrej/php -y && \
    apt-get update && apt-get install -y \
    gettext-base \
    nginx \
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
    vim \
    unzip && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# Get/extract Moodle
RUN echo "Starting container build..." \
    # Install repo and packages
    && apt-get update \
    && apt-get install -y wget \
    # Create Moodle directories
    && mkdir -v /opt/moodle \
    && wget https://download.moodle.org/download.php/direct/${MOODLE_TRACK}/moodle-${MOODLE_VERSION}.tgz -O /opt/moodle/moodle-${MOODLE_VERSION}.tgz \
    && tar -xzvf /opt/moodle/moodle-${MOODLE_VERSION}.tgz -C /opt/moodle \
    && mv -v /opt/moodle/moodle /opt/moodle/moodle-${MOODLE_VERSION} \
    && rm -v /opt/moodle/moodle-${MOODLE_VERSION}.tgz \
    # Remove/purge dev packages
    && apt-get --purge -y remove wget \
    && apt-get --purge -y autoremove \
    && apt-get -y clean \
    && rm -rfv /etc/apt/sources.list.d/temp.list

# Copy in the Moodle config and set permissions
COPY ./config.php /opt/moodle/moodle-${MOODLE_VERSION}/config.php
RUN chown --reference=/opt/moodle/moodle-${MOODLE_VERSION}/config-dist.php /opt/moodle/moodle-${MOODLE_VERSION}/config.php \
    && chmod --reference=/opt/moodle/moodle-${MOODLE_VERSION}/config-dist.php /opt/moodle/moodle-${MOODLE_VERSION}/config.php

# Copy NGINX service script
COPY start-nginx.sh /etc/services.d/nginx/run
RUN chmod 755 /etc/services.d/nginx/run

# Copy PHP-FPM service script
COPY start-fpm.sh /etc/services.d/php_fpm/run
RUN chmod 755 /etc/services.d/php_fpm/run

# Add S6 supervisor (for graceful stop)
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar -vxzf /tmp/s6-overlay-amd64.tar.gz -C /

# Setup Moosh
RUN curl https://moodle.org/plugins/download.php/16504/${MOOSH_PACKAGE} -o /root/moosh_setup.zip && \
    unzip /root/moosh_setup.zip -d /opt && \
    ln -s /opt/moosh/moosh.php /usr/local/bin/moosh

ENTRYPOINT ["/init"]
CMD []
