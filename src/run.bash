#!/bin/bash

source "$(dirname "$0")"/bash-utils/log.sh

set -e
set -o nounset

replace_ssh_key_cloud_config() {
  local cloud_config_file="$1"
  local ssh_public_key_file="$2"

  if [[ -z "$cloud_config_file" || -z "$ssh_public_key_file" ]]; then
    echo "Error: Both cloud config file and SSH public key must be provided."
    return 1
  fi

  if [[ ! -f "$cloud_config_file" ]]; then
    echo "Error: The file '$cloud_config_file' does not exist."
    return 1
  fi

  local ssh_public_key="$(cat $ssh_public_key_file)"

  local temp_file
  temp_file=$(mktemp)
  local in_ssh_block=false

  while IFS= read -r line; do
    if [[ "$line" =~ ssh_authorized_keys: ]]; then
      echo "ssh_authorized_keys:" >> "$temp_file"
      echo "  - $ssh_public_key" >> "$temp_file"
      in_ssh_block=true
    elif $in_ssh_block && [[ "$line" =~ ^[[:space:]]*- ]]; then
      # Skip existing SSH key lines
      continue
    else
      echo "$line" >> "$temp_file"
      in_ssh_block=false
    fi
  done < "$cloud_config_file"

  mv "$temp_file" "$cloud_config_file"
}


SOURCE="$OS_GUEST"

rm -rf ./build/

if [ "$CLOUD_IMAGE" = "true" ]; then
  SOURCE="cloud"

  mkdir -p /work/.ssh
  ssh-keygen -t ed25519 -N '' -f "/work/.ssh/id"
  replace_ssh_key_cloud_config "./provisions/cloud-init/user-data" "/work/.ssh/id.pub"
fi

python3 provisioners.py "./templates/build.pkr.hcl" "/output/vars.json" "$OS_GUEST"
 
packer build -var-file=/output/vars.json -only "$OS_GUEST.qemu.$SOURCE" ./templates;

chmod 666 ./build/*
cp ./build/* /output
