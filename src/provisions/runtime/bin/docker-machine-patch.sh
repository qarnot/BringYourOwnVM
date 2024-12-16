#!/bin/sh

# "Short" explanation of why this service is needed:

# When a Linux VM is launched using docker-machine,
# docker-machine tries to connect to the VM's docker
# socket using the forwarder port retrieved by the
# API and not the application port (2376 for the docker socket).
# Let's say that the forwarder port is 35422, for the
# explanation's sake. docker-machine then creates an
# override config file for the docker service telling
# docker to start on port 35422 of the VM.

# However, in order for the TCP request to reach the VM,
# we must forward it through the container. But we
# cannot simply map port 2376 of the container to
# port 35422 of the VM because the mapping is done
# when the payload is launched and the forwarder port
# is only retrieved later. Thus, we have to statically
# map the port 2376 of the container to the port 2376
# of the VM, and only then, at runtime, map the port
# 2376 of the VM to the port 35422 of the VM,
# where the docker socket will be running.
# We do this by waiting for the override config
# to be written (see the if condition) and then
# retrieving the forwarder port from it.
# Finally, we map the two ports using socat.

# Note that we also need to restart the docker
# service after the config is overridden because
# docker-machine does not do it.

while true; do
  if [ -e /etc/systemd/system/docker.service.d/10-machine.conf ]; then
      port=$(tr ' ' '\n' < /etc/systemd/system/docker.service.d/10-machine.conf | grep tcp://0.0.0.0:[0-9]* | sed 's_tcp://0.0.0.0:\([0-9]*\)_\1_')
      systemctl daemon-reload
      systemctl restart docker
      socat TCP4-LISTEN:2376,fork TCP4:localhost:$port
    break
  fi
done
