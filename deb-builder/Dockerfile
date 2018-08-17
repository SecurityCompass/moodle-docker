FROM ubuntu:xenial

# Disable frontend dialogs
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y \
        gcc \
        make \
        ruby \
        ruby-dev \
    && apt-get --purge -y autoremove \
    && apt-get -y clean \
    && rm -rf /etc/apt/sources.list.d/temp.list /var/lib/apt/lists/*

RUN gem install --no-ri --no-rdoc fpm

VOLUME [ "/package" ]
WORKDIR "/package"

ENTRYPOINT [ "/usr/local/bin/fpm" ]
CMD [ "--help" ]
