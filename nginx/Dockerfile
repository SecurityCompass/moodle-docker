FROM centos:7

RUN yum install https://centos7.iuscommunity.org/ius-release.rpm -y

# Install dependencies
RUN yum install -y nginx wget vim

# Copy Moodle nginx config
ADD nginx.conf /etc/nginx/nginx.conf
ADD moodle.conf /etc/nginx/conf.d/
RUN chown nginx:nginx /etc/nginx/conf.d/moodle.conf

VOLUME /opt/moodle
VOLUME /etc/nginx/ssl

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
