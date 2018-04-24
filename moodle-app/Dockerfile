FROM debian:stretch

ARG moodle_ver

RUN echo "Building Moodle version: $moodle_ver"

# Create Moodle directories
RUN mkdir /opt/moodle

# Get/extract Moodle
RUN apt-get update \
    && apt-get install -y wget \
    && wget https://download.moodle.org/download.php/direct/stable34/moodle-$moodle_ver.tgz -O /opt/moodle/moodle-$moodle_ver.tgz \
    && tar -xzvf /opt/moodle/moodle-$moodle_ver.tgz -C /opt/moodle \
    && mv -v /opt/moodle/moodle /opt/moodle/moodle-$moodle_ver \
#    && chown -Rv 101:101 /opt/moodle \
    && rm -v /opt/moodle/moodle-$moodle_ver.tgz \
    # Remove/purge dev packages
    && apt-get --purge -y remove wget \
    && apt-get --purge -y autoremove \
    && apt-get -y clean \
    && rm -rfv /etc/apt/sources.list.d/temp.list

VOLUME ["/opt/moodle/moodle-$moodle_ver"]

ENTRYPOINT ["ls", "-la"]
CMD ["/opt/moodle"]
