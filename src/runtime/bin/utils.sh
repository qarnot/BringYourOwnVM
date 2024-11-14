LOG_FILE=/var/log/qarnot/config.log

mkdir -p $(dirname $LOG_FILE)

log() {
    if [ "$DEBUG" = "true" ]; then
        echo "$(date +"%Y-%m-%d %H:%M:%S.%N")|$0|$*" | tee -a "${LOG_FILE:-/dev/null}"
    else
        echo "$(date +"%Y-%m-%d %H:%M:%S.%N")|$0|$*" >>"${LOG_FILE:-/dev/null}"
    fi
}
