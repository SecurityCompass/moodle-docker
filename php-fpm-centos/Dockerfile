FROM centos:7

RUN echo "Starting container build..." \
    # Install repo and packages
    && yum -y install https://centos7.iuscommunity.org/ius-release.rpm --disableplugin=fastestmirror \
    && yum -y install \
        php72u-cli.x86_64 \
        php72u-fpm-nginx \
        php72u-gd.x86_64 \
        php72u-intl.x86_64 \
        php72u-json.x86_64 \
        php72u-mbstring.x86_64 \
        php72u-opcache.x86_64 \
        php72u-pecl-memcached.x86_64 \
        php72u-pgsql \
        php72u-soap.x86_64 \
        php72u-xml.x86_64 \
        php72u-xmlrpc.x86_64 \
    # Clean up repos
    && yum clean metadata \
    && yum clean all \
    # Make a log directory
    && mkdir /var/log/php

# Foward PHP log to docker
RUN ln -sf /dev/stdout /var/log/php/php_errors.log

EXPOSE 9000
CMD ["php-fpm"]
