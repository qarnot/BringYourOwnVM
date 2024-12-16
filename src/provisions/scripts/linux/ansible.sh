#!/bin/sh

# sudo apt -y install python3-ansible-compat python3-ansible-pygments python3-ansible-runner

sudo apt update
sudo apt -y install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt -y install ansible
