#!/bin/ash

[ ! -z $DEBUG ] && [ $DEBUG -eq 1 ] && set -x

if [ -z $GOOSE_COMMAND ]; then
    echo "$$GOOSE_COMMAND has not been set"
    exit 1
fi

if [ -z $GOOGLE_APPLICATION_CREDENTIALS ]; then
    echo "$$GOOGLE_APPLICATION_CREDENTIALS has not been set, cannot connect to CloudSQL"
    exit 1
fi

goose_version=${1:-"latest"}
cloud_sql_instance=${2:?"cloud-sql-instance is not set"}
conn_retries=${3:-5}

res=1
current_try=
csp_pid=/tmp/gceproxy.pid

run_w_retry() {
    local ret=${1:-5}
    local success=1
    current_try=1

    until [ ${current_try} -gt ${ret} ] || [ ${success} -eq 0 ]; do
        echo "trying (${current_try}/${ret})"
        eval "goose ${GOOSE_COMMAND}"
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

#install goose
go install github.com/pressly/goose/v3/cmd/goose@${goose_version}
if [ $? -gt 0 ]; then
    echo "could not install goose@${goose_version}, exiting"
    exit 1
fi

# Start a headless cloudsql proxy and capture pid
/cloud_sql_proxy \
    -credential_file ${GOOGLE_APPLICATION_CREDENTIALS} \
    -instances=${cloud_sql_instance} &
echo $! >${csp_pid}

# Run goose command with retry and capture result
run_w_retry ${conn_retries}
res=$?

# shut down cloudsql pid
kill -s TERM $(cat ${csp_pid})

# Exit with goose retry result
exit $res
