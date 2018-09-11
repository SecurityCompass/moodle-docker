#!/bin/bash
#
# Copyright (c) 2018 SD Elements Inc.
#
#  All Rights Reserved.
#
# NOTICE:  All information contained herein is, and remains
# the property of SD Elements Incorporated and its suppliers,
# if any.  The intellectual and technical concepts contained
# herein are proprietary to SD Elements Incorporated
# and its suppliers and may be covered by U.S., Canadian and other Patents,
# patents in process, and are protected by trade secret or copyright law.
# Dissemination of this information or reproduction of this material
# is strictly forbidden unless prior written permission is obtained
# from SD Elements Inc..
# Version

set -eo pipefail

sudo apt-get --yes install tree

# Build DEB package
docker-compose --file dc.deb.yml up

# Verify DEB file content
DEB_FILE="$(ls ./*.deb)"
ls -la "${DEB_FILE}"
dpkg -e "${DEB_FILE}" /tmp/moodle_deb
dpkg -x "${DEB_FILE}" /tmp/moodle_deb
tree /tmp/moodle_deb
