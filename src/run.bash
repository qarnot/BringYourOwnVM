#!/bin/bash

source "$(dirname "$0")"/bash-utils/log.sh

set -e
set -o nounset

VM_BRIDGE_IFACE=virbr0
VM_NET_CIDR=24
VM_NET_GATEWAY=192.168.60.1
VM_NET_MASK=255.255.255.0
VM_IP=192.168.60.2
MAIN_IFACE=eth0
DNSMASQ_LOG_FILE=/var/log/dnsmasq.log
QEMU_MAC_ADDRESS="00:01:02:03:04:05"

setup_dnsmasq() {
    local range="$VM_IP,$VM_IP"

    cat > /etc/dnsmasq.conf << EOF
user=root
domain-needed  # don't let incomplete requests leave the LAN
bogus-priv  # prevent non-routable to be forwarded out

dhcp-range=$range
dhcp-option=option:router,$VM_NET_GATEWAY
dhcp-option=option:netmask,$VM_NET_MASK
dhcp-option=option:dns-server,$VM_NET_GATEWAY,1.1.1.1
#dhcp-option=option:dns-server,1.1.1.1
log-facility=$DNSMASQ_LOG_FILE
interface=$VM_BRIDGE_IFACE
EOF

    log_info "Starting dnsmasq with config: $(cat /etc/dnsmasq.conf)"
    dnsmasq
}

setup_nat() {
    log "Setting up bridge $VM_BRIDGE_IFACE with IP $VM_NET_GATEWAY/$VM_NET_CIDR. Currently, ifaces are: $(ip a)"
    # Create a bridge that will act as the host's presence in the network dedicated to the VM
    ip link add name "$VM_BRIDGE_IFACE" type bridge
    ip addr add "$VM_NET_GATEWAY/$VM_NET_CIDR" dev "$VM_BRIDGE_IFACE"
    ip link set dev "$VM_BRIDGE_IFACE" up

    log "Did setup bridge $VM_BRIDGE_IFACE with IP $VM_NET_GATEWAY/$VM_NET_CIDR, now setting NAT in iptables: $(ip a)"

    # Setup iptables rules allowing outbound traffic from the VM network to
    # get to the Internet
    iptables -t nat -A POSTROUTING -o "$MAIN_IFACE" -j MASQUERADE
    iptables -I FORWARD 1 -i "$VM_BRIDGE_IFACE" -j ACCEPT
    iptables -I FORWARD 1 -o "$VM_BRIDGE_IFACE" -m state --state RELATED,ESTABLISHED -j ACCEPT
    ret=$?

    log "Did setup NAT and FORWARD rules:"
    log "$(iptables -L -n -v)"
    log "$(iptables -t nat -L -n -v)"

    if [ "$ret" -ne 0 ]; then
        log "Failed to set the bridge '$VM_BRIDGE_IFACE' up, exit code: $ret"
        exit 2;
    fi

    mkdir -p /etc/qemu
    log "allow $VM_BRIDGE_IFACE" > /etc/qemu/bridge.conf

    setup_dnsmasq
    ret=$?
    if [ "$ret" -ne 0 ];then
      log "Failed to set the dnsmasq up, exit code: $ret"
      exit $ret
    fi

    log "Write config for qemu-bridge-helper"
    mkdir -p /usr/local/etc/qemu
    log "allow $VM_BRIDGE_IFACE" >>/usr/local/etc/qemu/bridge.conf
    chmod 640 /usr/local/etc/qemu/bridge.conf
}


TMP_PATH=/tmp/install_scripts.iso
BUILD="base"

rm -rf ./build/

packer init ./templates;

if [ "$OS_GUEST" = "windows" ]; then

  curl -fSL https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso -o virtio-win-0.1.217.iso

  setup_nat

  if [ ! -z "$AUTOUNATTEND_PATH" ] && [ ! -z "$INIT_SCRIPT_PATH" ] && [ ! -z "$INSTALL_SCRIPTS_PATH" ]; then
    mkdir -p "$TMP_PATH"
    cp -rav "$INSTALL_SCRIPTS_PATH"/* "$TMP_PATH"
    cp -v "$AUTOUNATTEND_PATH" "$TMP_PATH"/autounattend.xml
    cp -v "$INIT_SCRIPT_PATH" "$TMP_PATH"/bootstrap.ps1

    genisoimage -J -o ./install-scripts.iso "$TMP_PATH"
  else
    log "Some variables are not defined"
    exit 1
  fi
fi

if [ "$DISK_IMAGE" = "true" ]; then
  BUILD="overlay"
fi

PACKER_LOG=1 packer build -var-file=/output/vars.json -only "$OS_GUEST-$BUILD.qemu.$OS_GUEST" ./templates;

cp ./build/* /output
