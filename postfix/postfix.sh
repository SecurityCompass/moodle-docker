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

echo "Configuring postfix with any environment variables that are set"
if [[ -n "${POSTFIX_MYNETWORKS}" ]]; then
    echo "Setting custom 'mynetworks'"
    postconf mynetworks="${POSTFIX_MYNETWORKS}"
else
    echo "Revert 'mynetworks' to default"
    postconf -# mynetworks
fi

if [[ -n "${POSTFIX_RELAYHOST}" ]]; then
    echo "Setting 'custom relayhost'"
    postconf relayhost="${POSTFIX_RELAYHOST}"
else
    echo "Revert 'relayhost' to default"
    postconf -# mynetworks
fi

echo "Disable chroot for the smtp service"
postconf -F smtp/inet/chroot=n
postconf -F smtp/unix/chroot=n

echo "Starting postfix in the foreground"
postfix start-fg
