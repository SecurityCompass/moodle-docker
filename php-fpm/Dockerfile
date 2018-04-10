FROM php:7.2.4-fpm

# Install system dependencies
RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
    postgresql-server-dev-9.6 \
    zlib1g-dev \
    libpng-dev \
    libicu-dev \
    libxml2-dev \
    curl \
    libssl-dev \
    libcurl4-openssl-dev \
    g++

# Install PHP extensions
RUN docker-php-ext-install pgsql \
                           zip \
                           gd \
                           intl \
                           xmlrpc \
                           soap \
                           opcache \
                           openssl \
                           tokenizer \
                           ctype \
                           simplexml \
                           spl \
                           xml \
                           xmlreader \
                           json \
                           hash \
                           fileinfo

# Fix error when compiling some extensions https://github.com/docker-library/php/issues/233
RUN docker-php-ext-install zlib; exit 0
RUN docker-php-ext-install mbstring; exit 0
RUN docker-php-ext-install curl; exit 0
RUN docker-php-ext-install iconv; exit 0
RUN cp /usr/src/php/ext/zlib/config0.m4 /usr/src/php/ext/zlib/config.m4 && \
    cp /usr/src/php/ext/curl/config0.m4 /usr/src/php/ext/curl/config.m4 && \
    cp /usr/src/php/ext/mbstring/config0.m4 /usr/src/php/ext/mbstring/config.m4
RUN docker-php-ext-install zlib curl iconv

ADD php.ini /usr/local/etc/php/
