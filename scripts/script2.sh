#!/bin/sh

apt-get update;
apt-get --yes dist-upgrade;
apt-get clean;
apt-get -y install neofetch;
