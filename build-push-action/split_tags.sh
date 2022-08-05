#!/usr/bin/env bash

IN=${1:?"no input csv provided"}
IMAGE_NAME=${2:?"no docker image name provided"}
IMAGE_PREFIX=${3:-"gcr.io/parsley-artifacts"}

# we need an initial newline
printf '\n'

while IFS=',' read -ra TAG; do
  for t in "${TAG[@]}"; do
    printf '        %s/%s:%s\n' ${IMAGE_PREFIX} ${IMAGE_NAME} ${t}
  done
done <<<"${IN}"
