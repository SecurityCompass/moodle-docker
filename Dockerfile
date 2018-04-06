FROM centos:7

RUN yum install https://centos7.iuscommunity.org/ius-release.rpm -y

# Install dependencies
RUN yum install nginx wget git vim -y
RUN yum install php72u-fpm-nginx php72u-pgsql php72u-cli.x86_64 php72u-json.x86_64 php72u-xml.x86_64 php72u-gd.x86_64 php72u-intl.x86_64 php72u-xmlrpc.x86_64 php72u-soap.x86_64 php72u-mbstring.x86_64 php72u-opcache.x86_64 -y

# Configure PHP
ADD php.ini /etc/php.ini

# Copy Moodle nginx config
ADD nginx.conf /etc/nginx/nginx.conf
ADD moodle.conf /etc/nginx/conf.d/
RUN chown nginx:nginx /etc/nginx/conf.d/moodle.conf

VOLUME /opt/moodle
VOLUME /etc/nginx/ssl

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
