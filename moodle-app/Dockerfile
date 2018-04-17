FROM debian:stretch

# Create Moodle directories
RUN mkdir -p /opt/moodle/ssl
RUN mkdir /opt/moodledata

# Get/extract Moodle
ADD https://download.moodle.org/download.php/direct/stable34/moodle-3.4.2.tgz /opt/moodle/moodle-3.4.2.tgz
RUN tar -xzvf /opt/moodle/moodle-3.4.2.tgz -C /opt/moodle
RUN mv /opt/moodle/moodle /opt/moodle/moodle-3.4.2
RUN rm /opt/moodle/moodle-3.4.2.tgz

VOLUME ["/opt/moodle/ssl", "/opt/moodledata", "/opt/moodle/moodle-3.4.2"]

ENTRYPOINT ["ls", "-la"]
CMD ["/opt/moodle"]
