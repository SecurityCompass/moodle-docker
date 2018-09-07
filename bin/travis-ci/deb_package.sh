#!/bin/bash
set -e 
set -o pipefail

sudo apt-get --yes install tree

# Build DEB package
docker-compose --file dc.deb.yml up

# Verify DEB file content
DEB_FILE=$(ls ./*.deb)
ls -la "${DEB_FILE}"
dpkg -e "${DEB_FILE}" /tmp/moodle_deb
dpkg -x "${DEB_FILE}" /tmp/moodle_deb
tree /tmp/moodle_deb
