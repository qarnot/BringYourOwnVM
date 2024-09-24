#!/bin/sh

rm -rf ./build
packer build -var-file=vars/debian.pkrvars.hcl ./templates
