#!/bin/bash

NOCOLOR="\e[0m"
LIGHT_BLUE="\e[36m"

sudo apt update
sudo apt -y full-upgrade
sudo apt -y autoremove

echo -e "${LIGHT_BLUE}[*]${NOCOLOR} Done"

