#!/bin/bash
#
# This is a bash script to quickly set up a netcat listener with random port
# The port is in range 4000-10000
# 
# Usage:
# $ ./listener.sh

while
  port=$(shuf -n 1 -i 4000-10000)
  netstat -atun | grep -q "$port"
do
  continue
done

ip_addr=$(ip addr show tun0 | grep 'scope global tun0' | cut -d' ' -f6 | cut -d'/' -f1)

echo -e "\e[0;36m[*]\e[0m Starting listener on port $port"

echo -e "\e[0;36m[*]\e[0m https://www.revshells.com/"

nc -lnvp $port
