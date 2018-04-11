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
                           tokenizer \
                           ctype \
                           simplexml \
                           xml \
                           json \
                           hash \
                           curl \
                           mbstring \
                           soap \
                           fileinfo && \
    # Need to set env var before installing xmlreader https://github.com/docker-library/php/issues/373
    CFLAGS="-I/usr/src/php" docker-php-ext-install xmlreader

# Fix error when compiling some extensions https://github.com/docker-library/php/issues/233
RUN docker-php-ext-install zlib; exit 0
RUN docker-php-ext-install iconv; exit 0
RUN docker-php-ext-install openssl; exit 0
RUN cp /usr/src/php/ext/zlib/config0.m4 /usr/src/php/ext/zlib/config.m4 && \
    cp /usr/src/php/ext/openssl/config0.m4 /usr/src/php/ext/openssl/config.m4 && \
    docker-php-ext-install zlib iconv opcache xmlrpc openssl

ADD php.ini /usr/local/etc/php/

RUN apt-get remove -y \
    postgresql-server-dev-9.6 \
    zlib1g-dev \
    libpng-dev \
    libicu-dev \
    libxml2-dev \
    curl \
    libssl-dev \
    libcurl4-openssl-dev \
    g++
