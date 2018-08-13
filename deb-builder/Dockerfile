FROM ubuntu:xenial

RUN apt-get update \
    && apt-get install -y \
        gcc \
        make \
        ruby \
        ruby-dev \
    && rm -rf /var/lib/apt/lists/*

RUN gem install fpm --no-ri --no-rdoc

VOLUME [ "/package" ]
WORKDIR "/package"

ENTRYPOINT [ "/usr/local/bin/fpm" ]
CMD [ "--help" ]
