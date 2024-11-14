#!/bin/sh

echo 'Hello There';
echo "${SSH_USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99'${SSH_USERNAME}';
chmod 0440 /etc/sudoers.d/99'${SSH_USERNAME}';
