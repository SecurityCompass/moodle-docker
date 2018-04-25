FROM debian:stretch-slim

ARG moodle_ver

RUN echo "Moodle version: $moodle_ver"

# Get/extract Moodle
RUN echo "Starting container build..." \
    # Install repo and packages
    && apt-get update \
    && apt-get install -y wget \
    # Create Moodle directories
    && mkdir -v /opt/moodle \
    && wget https://download.moodle.org/download.php/direct/stable34/moodle-$moodle_ver.tgz -O /opt/moodle/moodle-$moodle_ver.tgz \
    && tar -xzvf /opt/moodle/moodle-$moodle_ver.tgz -C /opt/moodle \
    && mv -v /opt/moodle/moodle /opt/moodle/moodle-$moodle_ver \
    && rm -v /opt/moodle/moodle-$moodle_ver.tgz \
    # Remove/purge dev packages
    && apt-get --purge -y remove wget \
    && apt-get --purge -y autoremove \
    && apt-get -y clean \
    && rm -rfv /etc/apt/sources.list.d/temp.list

COPY config.php /opt/moodle/moodle-$moodle_ver/

VOLUME ["/opt/moodle/moodle-$moodle_ver"]

CMD ["ls", "-la", "/opt/moodle"]
