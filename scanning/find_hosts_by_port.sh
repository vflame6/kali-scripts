#!/bin/bash
#
# This script is used to find hosts by an opened port
#

if [[ $# -ne 1 ]] then
    echo "usage: $0 hosts_file port"
fi

nmap -iL "$1" -p "$2" --open -Pn -n \
    --min-hostgroup 4096 \
    --max-retries 2 \
    --max-rtt-timeout 500ms \
    --min-rate 200 2>/dev/null \
    | grep "Nmap scan report for" \
    | cut -d " " -f5

