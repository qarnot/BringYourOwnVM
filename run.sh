#!/bin/sh

rm -rf ./build;
packer init ./templates;
packer build -var-file=vars/debian2.pkrvars.hcl ./templates;
