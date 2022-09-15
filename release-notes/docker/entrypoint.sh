#!/usr/bin/env sh

set -euo pipefail

export NOTION_TOKEN=${1:?"no NOTION_TOKEN provided"}
export NOTION_DATABASE_ID=${2:?"no NOTION_DATABASE_ID provided"}
export PRODUCT=${3:?"no RELEASE_TAG provided"}
export RELEASE_TAG=${4:?"no RELEASE_TAG provided"}
export RELEASE_NOTES=${5:?"no RELEASE_NOTES provided"}

echo "::set-output name=status:: $(node /app/index.js)"