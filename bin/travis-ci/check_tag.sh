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

echo "Installing shtdlib"
shtdlib_local_path="/usr/local/bin/shtdlib.sh"
sudo curl -s -L -o "${shtdlib_local_path}" https://github.com/sdelements/shtdlib/raw/master/shtdlib.sh
sudo chmod 775 "${shtdlib_local_path}"
# shellcheck disable=SC1091,SC1090
source "${shtdlib_local_path}"
color_echo green "shtdlib.sh installed successfully"

# Get the latest tag from GitHub
latest_tag="$(git fetch -t && git tag -l | sort --version-sort | tail -n1)"
color_echo green "Latest Git tag: '${latest_tag}'"

# Get the latest tag from the CHANGELOG
changelog_ver="$(grep -oP '\[v\d\.\d\.\d\]' CHANGELOG.md | tr -d '[]' | sort -nr | head -n1)"
color_echo green "CHANGELOG version: '${changelog_ver}'"

# Get iteration from DEB builder configuration
build_ver="$(grep BUILD_VERSION .env | cut -d'=' -f2)"
color_echo green "Container/DEB iteration version: '${build_ver}'"

# Validate version strings
version_pattern='^v\d\.\d\.\d$'
echo "${latest_tag}" | grep -qP ${version_pattern} || ( color_echo red "Invalid tag from repo: '${latest_tag}'" && exit 1 )
echo "${changelog_ver}" | grep -qP ${version_pattern} || ( color_echo red "Invalid tag from CHANGELOG: '${changelog_ver}'" && exit 1 )
echo "${build_ver}" | grep -qP ${version_pattern} || ( color_echo red "Invalid build version: '${build_ver}'" && exit 1 )

# Ensure tags in CHANGELOG and iteration are greater than highest repo tag
if [ "${latest_tag}" = "${changelog_ver}" ] \
   || [ "${latest_tag}" = "${build_ver}" ] \
   || [ ! "${changelog_ver}" = "${build_ver}" ] \
   || ! compare_versions "${latest_tag}" "${changelog_ver}" \
   || ! compare_versions "${latest_tag}" "${build_ver}"; then
    color_echo red "Error: Incorrect version update in 'CHANGELOG.md' and '.env'"
    exit 1
else
    color_echo green "Version bumps PASS!"
fi
