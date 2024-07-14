#!/bin/bash
#
# script for shutting down all host interfaces if the vpn connection is down
# used to exclude source IP leakage from tools that were running while the VPN was active
#
# usage:
# openvpn --down vpn-down.sh --config <OPENVPN_CONFIG>
#

NOCOLOR="\e[0m"
LIGHT_BLUE="\e[36m"

echo -e "${LIGHT_BLUE}[*]${NOCOLOR} The VPN is down. Disabling network interfaces..."
systemctl stop network-manager
killall -9 dhclient
for i in $(ifconfig | grep - iEo '^[a-z0-9]+:' | grep -v '^lo:$' | cut -d ':' -f 1)
do
    ifconfig $i 0.0.0.0 down
done
