#!/bin/bash
#
# Ensure the VPN pushed by OpenVPN is used by all the docker container running on this host
#
# Usage:
# configure-dns.sh [-d,-u]
# -d (vpn down) and -u (vpn up) are mutually exclusive and default to -d
#
# Logic:
# - use update-systemd-resolved to add the VPN pushed by OpenVPN
# - docker use its host's /run/systemd/resolve/resolv.conf as /etc/resolv.conf when using systemd-resolved.
# removing the the wan iface from the default routes list ensure its VPN is removed from /run/systemd/resolve/resolv.conf,
# and only the one provided by the VPN is used by docker
#

is_wan_default=true
while getopts "ud" opt; do
    case "${opt}" in
        u)
            # vpn up
            # remove wan DNS
            is_wan_default=false
            ;;
        d)
            # vpn down
            # set back wan DNS
            is_wan_default=true
            ;;
        *)
            echo "unknown option"
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

wan_iface=$(ip route | awk '{if($1=="default") {print $5}}')
/etc/openvpn/update-systemd-resolved "$@"
resolvectl default-route "${wan_iface}" "${is_wan_default}"