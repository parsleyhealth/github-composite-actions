#!/bin/bash

[ ! -z $DEBUG ] && [ $DEBUG -eq 1 ] && set -x

if [ -z $ATLAS_COMMAND ]; then
    echo "$$ATLAS_COMMAND has not been set"
    exit 1
fi

if [ -z $GOOGLE_APPLICATION_CREDENTIALS ]; then
    echo "$$GOOGLE_APPLICATION_CREDENTIALS has not been set, cannot connect to CloudSQL"
    exit 1
fi

cloud_sql_instance=$CLOUD_SQL_INSTANCE
conn_retries=${2:-5}

res=1
current_try=
csp_pid=/tmp/gceproxy.pid

run_w_retry() {
    local ret=${1:-5}
    local success=1
    current_try=1

    until [ ${current_try} -gt ${ret} ] || [ ${success} -eq 0 ]; do
        echo "trying (${current_try}/${ret})"
        eval "atlas ${ATLAS_COMMAND}"
        success=$?
        if [ ${success} -eq 0 ]; then
            break
        fi
        sleep 2
        current_try=$((current_try + 1))
    done

    # if retries is hit, success will signify exit code > 0 (error)
    return ${success}
}

#install atlas
curl -sSf https://atlasgo.sh | sh
if [ $? -gt 0 ]; then
    echo "could not install Atlas, exiting"
    exit 1
fi

# Start a headless cloudsql proxy and capture pid
if [[ -n "${cloud_sql_instance}" ]]; then
  /cloud_sql_proxy \
      -credential_file ${GOOGLE_APPLICATION_CREDENTIALS} \
      -instances=${cloud_sql_instance} &
  echo $! >${csp_pid}
fi

# Run atlas command with retry and capture result
run_w_retry ${conn_retries}
res=$?

# shut down cloudsql pid
kill -s TERM $(cat ${csp_pid})

# Exit with goose retry result
exit $res
