#!/bin/bash
#
# This is a bash script to scan all TCP/UDP ports on the machine and give nice browser-based output
# It runs nmap 2 times:
# First to get all ports on the machine
# Second for deeper scan of the ports found
# Used with nmap-bootstrap https://github.com/honze-net/nmap-bootstrap-xsl
#
# Usage:
# $ ./fnmap.sh ip/hostname

if [[ $# != 1 ]]
then
    echo -e "\e[0;31m[!]\e[0m Not specified a host or incorrect use."
    exit 1
fi

echo -n "Scan UDP ports (y/N)? "
read udp_answer
UDP=""

if [ "$udp_answer" != "${udp_answer#[Yy]}" ] ; then
    UDP="-sU"
fi

ports=$(sudo nmap -p- $UDP -sS -Pn --min-rate=500 $1 | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
echo "Ports found:
$ports
"
filename="$1_scan" 
sudo mkdir nmap
sudo nmap -p$ports $UDP -sS -T4 -Pn --open -sC -sV \
    -oA "nmap/$filename" --stylesheet https://raw.githubusercontent.com/honze-net/nmap-bootstrap-xsl/master/nmap-bootstrap.xsl $1
