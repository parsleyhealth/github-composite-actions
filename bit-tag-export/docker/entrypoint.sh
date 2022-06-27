#!/usr/bin/env bash

set -euo pipefail

BIT_TOKEN=${1:?"no BIT_TOKEN provided"}

bit config set analytics_reporting false
bit config set anonymous_reporting false
bit config set user.token ${BIT_TOKEN}
bit install

echo "::set-output name=changes::$(bit tag --persist | grep '     > ' | sed 's/     > />/g' | tr '\n' ',' | sed 's/,/\\\\n/g')"

bit export
