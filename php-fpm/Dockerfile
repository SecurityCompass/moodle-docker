FROM php:7.2.4-fpm

RUN apt-get update &&\
    apt-get install -y postgresql-server-dev-9.6 --no-install-recommends &&\
    docker-php-ext-install pgsql
