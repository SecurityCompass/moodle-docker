#!/bin/bash
set -e
set -o pipefail

# echo "Installing shtdlib"
sudo curl -s -L -o /usr/local/bin/shtdlib.sh https://github.com/sdelements/shtdlib/raw/master/shtdlib.sh
sudo chmod 775 /usr/local/bin/shtdlib.sh
# shellcheck disable=SC1091
source /usr/local/bin/shtdlib.sh
color_echo green "shtdlib.sh installed successfully"

# Get the latest tag from GitHub
latest_tag=$(git tag -l | sort --version-sort | tail -n1)
color_echo green "Latest tag: '${latest_tag}'"

# Get the latest tag from the CHANGELOG
changelog_ver=$(grep -oP '\[v\d\.\d\.\d\]' CHANGELOG.md | tr -d '[]' | sort -nr | head -n1)
color_echo green "CHANGELOG version: '${changelog_ver}'"

# Get iteration from DEB builder configuration
iteration_ver=$(grep -A1 iteration dc.deb.yml | tail -n1 | cut -d'"' -f2)
color_echo green "Iteration version: '${iteration_ver}'"

# Validate version strings
version_pattern='^v\d\.\d\.\d$'
echo "${latest_tag}" | grep -qP ${version_pattern} || ( color_echo red "Invalid tag from repo: '${latest_tag}'" && exit 1 )
echo "${changelog_ver}" | grep -qP ${version_pattern} || ( color_echo red "Invalid tag from CHANGELOG: '${changelog_ver}'" && exit 1 )
echo "${iteration_ver}" | grep -qP ${version_pattern} || ( color_echo red "Invalid iteration from DEB configuration: '${iteration_ver}'" && exit 1 )

# Ensure that we tag relevant files in each PR
if [ "${latest_tag}" = "${changelog_ver}" ] \
   || [ "${latest_tag}" = "${iteration_ver}" ] \
   || ! compare_versions "${latest_tag}" "${changelog_ver}" \
   || ! compare_versions "${latest_tag}" "${iteration_ver}"; then
    color_echo red "Error: Version in CHANGELOG.md and 'dc.deb.yml' not updated"
    exit 1
else
    color_echo green "Version bumps PASS!"
fi
