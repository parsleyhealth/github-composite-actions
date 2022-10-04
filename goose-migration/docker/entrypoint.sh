#!/bin/ash

[ ! -z $DEBUG ] && [ $DEBUG -eq 1 ] && set -x

# warn if $GITHUB_WORKSPACE is not set, could result in errors
if [ -z $GITHUB_WORKSPACE ]; then
    echo "$$GITHUB_WORKSPACE has not been set"
fi

goose_version=${1:-"latest"}
gcp_creds_json=${2:?"gcp-credentials-json is not set"}
cloud_sql_instance=${3:?"cloud-sql-instance is not set"}
migrations_dir=${4:-"."}
goose_command=${5:-"-version"}
conn_retries=${6:-5}

res=1
csp_pid=
creds_files=/tmp/creds.json

run_w_retry() {
    local subcmd=${1:?"no command sent to run_w_retry"}
    local migrations_dir=${2:?"no migrations_dir setn to run_w_retry"}
    local retries=${3:-10}
    local cmd="goose -dir ${migrations_dir} ${subcmd}"
    local current_try=1
    local success=1

    echo "running ${cmd}"

    until [ ${current_try} -eq ${retries} ] || [ ${success} -eq 0 ]; do
        echo "trying (${current_try}/${retries})"
        ${cmd}
        success=$?
        if [ ${success} -eq 0 ]; then
            break
        fi
        sleep 2
        current_try=$((current_try++))
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

# Save credentials to disk
echo $gcp_creds_json >${creds_files}

# Start a headless cloudsql proxy and capture pid
/cloud_sql_proxy \
    -credential_file ${creds_files} \
    -instances=${cloud_sql_instance} &
echo $! >${csp_pid}

# Run goose command with retry and capture result
run_w_retry ${goose_command} $GITHUB_WORKSPACE/${migrations_dir} ${conn_retries}
res=$?

# shut down cloudsql pid
kill -s TERM $(cat ${csp_pid})

# Exit with goose retry result
exit $res
