#!/usr/bin/env bash

set -euo pipefail

FALSE="false"

semver=${1:-${FALSE}}
semver_file=${2:-${FALSE}}
use_v=${3:-${FALSE}}

output=""

if [ "${semver}" = "${FALSE}" ] && [ "${semver_file}" = "${FALSE}" ]; then
    echo "No value provided for either semver or semver-file"
    exit 1
fi

if [ "${use_v}" = "true" ]; then
    output="v"
fi

if [ "${semver}" != "${FALSE}" ]; then
    output="${output}${semver}"
elif [ "${semver_file}" != "${FALSE}" ]; then
    if [ -f ${semver_file} ]; then
        output="${output}$(awk -F '=' '{print $2}' ${semver_file})"
    else
        echo "Could not open ${semver_file}"
        exit 1
    fi
fi

echo "::set-output name=tag::${output}"
