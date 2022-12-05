#!/usr/bin/env bash

set -euo pipefail

BIT_TOKEN=${1:?"no BIT_TOKEN provided"}
BIT_CHANGES_OUTPUT_FILE=${GITHUB_WORKSPACE}/bit-tag.out

bit config set analytics_reporting false
bit config set anonymous_reporting false
bit config set user.token ${BIT_TOKEN}
bit install

bit tag --persist >${BIT_CHANGES_OUTPUT_FILE}

echo "BIT_CHANGES=$(cat ${BIT_CHANGES_OUTPUT_FILE} | grep '     > ' | sed 's/     > />/g' | tr '\n' ',' | sed 's/,/\\n/g')" >>${GITHUB_ENV}

rm -f ${BIT_CHANGES_OUTPUT_FILE}

bit export
