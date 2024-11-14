#!/bin/bash


my_dir="$(dirname "$0")"
source "$my_dir/utils.sh"


config_uri=http://config.task.qarnot.loc/config.json

config=$(curl -s $config_uri)
ret=$?
if [ $ret -ne 0 ]; then
    log "Failed to retrieve configuration from $config_uri"
    exit 5
fi


# NB: ssh accessibility will be used to determine that the guest is ready,
# so configuring the SSH server must be done last, after configuring shared
# folders.

export SHARED_FOLDERS=$(echo $config | jq -r '.shared_folders')

$my_dir/configure-shared-folders.sh


export SSH_USER=$(echo $config | jq -r '.user')
export SSH_PASSWORD=$(echo $config | jq -r '.password')
export SSH_AUTHORIZED_KEYS_URI=$(echo $config | jq -r '.authorized_keys_uri')

$my_dir/configure-ssh.sh
