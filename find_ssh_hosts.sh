#!/bin/bash

if [[ $# -ne 1 ]] then
    echo "usage: $0 hosts_file"
fi

nmap -iL "$1" -p 22 --open -Pn -n \
    --min-hostgroup 4096 \
    --max-retries 2 \
    --max-rtt-timeout 500ms 2>/dev/null \
    | grep "Nmap scan report for" \
    | cut -d " " -f5

