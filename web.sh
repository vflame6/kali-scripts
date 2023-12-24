#!/bin/bash
#
# This is a bash script for quickly setting up a web server.
# It generates a random not busy port if it is not specified. Then, it sets up a Python web server to that port.
# Also, it enumerates all network interfaces to print all possible http links to that web server with specified port.
#
# Usage:
# web.sh [PORT]
#

NOCOLOR="\e[0m"
LIGHT_BLUE="\e[36m"

if [[ $# -eq 0 ]]
then
  while
    port=$(shuf -n 1 -i 4000-10000)
    netstat -atun | grep -q "$port"
  do
    continue
  done
elif [[ $# -eq 1 ]]
then
  port=$1
else
  echo "usage: web.sh [PORT]"
  exit 1
fi

echo -e "${LIGHT_BLUE}[*]${NOCOLOR} Starting web server on port $port"

while read -r interface address
do
  addr=$(echo $address | cut -d '/' -f 1)  
  if [[ $port -eq 80 ]]
  then
    echo "    $interface: http://$addr/"
  else
    echo "    $interface: http://$addr:$port/"
  fi
done < <(ip -o a show | cut -d ' ' -f 2,7 | grep -v '::')

python3 -m http.server $port > /dev/null
