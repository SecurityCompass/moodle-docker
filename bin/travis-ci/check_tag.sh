#!/bin/bash
set -e 
set -o pipefail

# Get the latest tag from GitHub
latest_tag=$(curl -s https://api.github.com/repos/SecurityCompass/libcloud/git/refs/tags | jq -r '.[]|.ref?' | sort -nr | cut -d"/" -f3 | head -n1)
echo "Latest tag is: ${latest_tag}"

# Get the latest tag from the CHANGELOG
changelog_ver=$(grep -oP '\[\d\.\d\.\d\]' CHANGELOG.md | tr -d '[]' | sort -nr | head -n1)
echo "Latest version in CHANGELOG: ${changelog_ver}"

# Get iteration from DEB builder configuration
iteration_ver=$(grep -A1 iteration dc.deb.yml | tail -n1 | cut -d'"' -f2)
echo "Iteration version: ${iteration_ver}"

# Validate that the versions are 
echo "${latest_tag}" | grep -P '^\d\.\d\.\d$'
echo "${changelog_ver}" | grep -P '^\d\.\d\.\d$'
echo "${iteration_ver}" | grep -P '^\d\.\d\.\d$'
