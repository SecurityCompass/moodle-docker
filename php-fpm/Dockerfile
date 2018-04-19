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
    g++ \
    # Install PHP extensions
    && docker-php-ext-install \
            ctype \
            curl \
            fileinfo \
            gd \
            hash \
            iconv \
            intl \
            json \
            mbstring \
            pgsql \
            simplexml \
            soap \
            tokenizer \
            xml \
            zip \
    # Need to set env var before installing xmlreader https://github.com/docker-library/php/issues/373
    && CFLAGS="-I/usr/src/php" docker-php-ext-install xmlreader \
    && echo "Starting sketchy part" \
    # Fix error when compiling some extensions https://github.com/docker-library/php/issues/233
    && (docker-php-ext-install zlib || cp -v /usr/src/php/ext/zlib/config0.m4 /usr/src/php/ext/zlib/config.m4 && docker-php-ext-install zlib) \
    && (docker-php-ext-install openssl || cp -v /usr/src/php/ext/openssl/config0.m4 /usr/src/php/ext/openssl/config.m4 && docker-php-ext-install openssl) \
    && echo "Made it!" \
    # Remove/purge dev packages
    && apt-get --purge -y remove \
            curl \
            g++ \
            libcurl4-openssl-dev \
            libicu-dev \
            libpng-dev \
            libssl-dev \
            libxml2-dev \
            postgresql-server-dev-9.6 \
            zlib1g-dev \
    && apt-get --purge -y autoremove \
    && apt-get -y clean \
    && rm -rfv /etc/apt/sources.list.d/temp.list
