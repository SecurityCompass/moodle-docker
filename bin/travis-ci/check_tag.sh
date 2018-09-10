#!/bin/bash
set -e
set -o pipefail
set -x

echo "Installing shtdlib"
sudo curl -s -L -o /usr/local/bin/shtdlib.sh https://github.com/sdelements/shtdlib/raw/master/shtdlib.sh
sudo chmod 775 /usr/local/bin/shtdlib.sh
# shellcheck disable=SC1091
source /usr/local/bin/shtdlib.sh
color_echo green "shtdlib.sh installed successfully"

# Get the latest tag from GitHub
latest_tag=$(curl -s https://api.github.com/repos/SecurityCompass/moodle-docker/git/refs/tags | jq -r '.[]|.ref?' | sort -nr | cut -d"/" -f3 | head -n1)
echo "Latest tag is: ${latest_tag}"

# Get the latest tag from the CHANGELOG
changelog_ver=$(grep -oP '\[v\d\.\d\.\d\]' CHANGELOG.md | tr -d '[]' | sort -nr | head -n1)
echo "Latest version in CHANGELOG: ${changelog_ver}"

# Get iteration from DEB builder configuration
iteration_ver=$(grep -A1 iteration dc.deb.yml | tail -n1 | cut -d'"' -f2)
echo "Iteration version: ${iteration_ver}"

# Validate version strings
version_pattern='^v\d\.\d\.\d$'
echo "${latest_tag}" | grep -qP ${version_pattern} || ( echo "Invalid tag from repo: ${latest_tag}" && exit 1 )
echo "${changelog_ver}" | grep -qP ${version_pattern} || ( echo "Invalid tag from CHANGELOG: ${changelog_ver}" && exit 1 )
echo "${iteration_ver}" | grep -qP ${version_pattern} || ( echo "Invalid iteration from DEB configuration: ${iteration_ver}" && exit 1 )

# Ensure that we tag relevant files in each PR
if ! compare_versions "${latest_tag}" "${changelog_ver}" || ! compare_versions "${latest_tag}" "${iteration_ver}"; then
    echo "Error: Version in CHANGELOG.md and 'dc.deb.yml' not updated"
    exit 1
fi
