#!/bin/bash

# This is a Bash script to quickly set up a netcat listener.
# It generates a random unused port if the port is not specified.
# 
# Usage:
# rev.sh [PORT]
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
  echo "usage: rev.sh [PORT]"
  exit 1
fi

echo -e "${LIGHT_BLUE}[*]${NOCOLOR} Starting netcat listener on $port"
echo "python -c 'import pty; pty.spawn(\"/bin/bash\")'" 
echo "python3 -c 'import pty; pty.spawn(\"/bin/bash\")'" 

sudo nc -lnvp $port
