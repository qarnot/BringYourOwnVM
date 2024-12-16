#!/bin/bash

my_dir="$(dirname "$0")"
source "$my_dir/utils.sh"

# Example of shared folder description
#
# [
#   {
#     "source": "nfs://nfs.task.qarnot.loc:/job",
#     "destination": "/job",
#     "mode": "rw"
#   },
#   {
#     "source": "nfs://nfs.task.qarnot.loc:/user-data",
#     "destination": "/user-data",
#     "mode": "ro"
#   },
#   {
#     "source": "smb://config.task.qarnot.loc/job",
#     "destination": "/job-via-samba",
#     "mode": "rw"
#   }
# ]



setup_shared_folder() {
    local src=$1
    local destination=$2
    local mode=$3


    if [[ $src =~ ^(nfs|smb)://.* ]]; then
        log "Mounting $src -> $destination ($mode)"

        local mode_option="-w"
        if [ "$mode" = "ro" ]; then
            mode_option="-r"
        fi

        mkdir -p $destination

        local remote_uri
        if [[ $src =~ ^(nfs)://.* ]]; then
            remote_uri="${src#nfs://}"

            log "mount -o nolock,nfsvers=3 $mode_option $remote_uri $destination"
            mount -o no_lock,vers=4.0 $mode_option nfs.task.qarnot.loc:/ $destination #$remote_uri
        elif [[ $src =~ ^(smb)://.* ]]; then
            remote_uri="${src#smb:}"

            log "mount -o guest,vers=3.0,file_mode=0666,dir_mode=0777 $mode_option $remote_uri $destination"
            mount -o guest,vers=3.0,file_mode=0666,dir_mode=0777 $mode_option $remote_uri $destination
        fi

        ret=$?
        if [ $ret -ne 0 ]; then
            log "Failed to mount $src -> $destination ($mode), mount returned $ret"
            exit $ret
        fi
    else
        log "Uri scheme of $src is not supported, cannot proceed"
        exit 9
    fi
}


sources=($(echo $SHARED_FOLDERS | jq -r '.[] | .source'))
destinations=($(echo $SHARED_FOLDERS | jq -r '.[] | .destination'))
modes=($(echo $SHARED_FOLDERS | jq -r '.[] | .mode'))


nb_items=${#sources[@]}

for ((i=0; i < nb_items; i++)); do
    src=${sources[$i]}
    destination=${destinations[$i]}
    mode=${modes[$i]}

    setup_shared_folder $src $destination $mode
done
