#!/bin/sh

rm -rf ./build;
packer init ./templates;
PACKER_LOG=1 packer build -var-file=vars/windows.pkrvars.hcl ./templates;
