#!/usr/bin/env bash

set -euo pipefail

BIT_TOKEN=${1:?"no BIT_TOKEN provided"}

bit config set analytics_reporting false
bit config set anonymous_reporting false
bit config set user.token ${BIT_TOKEN}
bit install

BIT_CHANGES_RAW_OUTPUT=$(bit tag --persist)

echo "BIT_CHANGES_RAW_OUTPUT=${BIT_CHANGES_RAW_OUTPUT}" >>$GITHUB_ENV
echo "BIT_CHANGES=$(echo ${BIT_CHANGES_RAW_OUTPUT} | grep '     > ' | sed 's/     > />/g' | tr '\n' ',' | sed 's/,/\\n/g')" >>$GITHUB_ENV

bit export
