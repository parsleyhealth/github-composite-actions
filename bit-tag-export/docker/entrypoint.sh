#!/usr/bin/env bash

set -euo pipefail

BIT_TOKEN=${1:-$BIT_TOKEN_ENV}

if [ -z "$BIT_TOKEN" ]; then
  echo "Error: No BIT_TOKEN provided. Please provide the Bit token as an input to this action or set the BIT_TOKEN_ENV environment variable."
  exit 1
fi
BIT_CHANGES_OUTPUT_FILE=${GITHUB_WORKSPACE}/bit-tag.out

bit config set analytics_reporting false
bit config set anonymous_reporting false
bit config set user.token ${BIT_TOKEN}
bit install

bit tag --persist >${BIT_CHANGES_OUTPUT_FILE}

echo "BIT_CHANGES=$(cat ${BIT_CHANGES_OUTPUT_FILE} | grep '     > ' | sed 's/     > />/g' | tr '\n' ',' | sed 's/,/\\n/g')" >>${GITHUB_ENV}

cat ${BIT_CHANGES_OUTPUT_FILE}

rm -f ${BIT_CHANGES_OUTPUT_FILE}

bit export
