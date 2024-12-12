#!/bin/sh

sudo apt -y install cloud-init

echo cloud-init status... waiting
sudo cloud-init status --wait || sudo cloud-init status --long
