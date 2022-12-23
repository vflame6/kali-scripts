#!/bin/bash
#
# This is a bash script for quickly setting up a web server.
# It generates a random not busy port and setting up a Python web server
# Also, it enumerates all network interfaces to format the http links to that web server with the port
#
# Usage:
# ./web.sh

while
  port=$(shuf -n 1 -i 4000-10000)
  netstat -atun | grep -q "$port"
do
  continue
done

echo -e "\e[0;36m[*]\e[0m Starting web server on port $port"
echo -e "\e[0;36m[*]\e[0m Links:"


while read -r interface address
do
  addr=$(echo $address | cut -d '/' -f 1)  
  echo "  $interface: http://$addr:$port/"
done < <(ip -o a show | cut -d ' ' -f 2,7 | grep -v '::')

python3 -m http.server $port > /dev/null
