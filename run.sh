#!/bin/sh

rm -rf ./build;
packer build -var-file=vars/debian2.pkrvars.hcl ./templates;
