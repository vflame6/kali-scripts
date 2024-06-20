#!/bin/bash
#
# This is a script for configuring ubuntu's Gnome desktop
# Needs to be run as current user in desktop session
#

NOCOLOR="\e[0m"
LIGHT_BLUE="\e[36m"

echo -e "${LIGHT_BLUE}[*]${NOCOLOR} Configuring Ubuntu native settings"

dconf write /org/gnome/desktop/sound/event-sounds "false"
gsettings set org.gnome.desktop.notifications show-banners false
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.wm.preferences audible-bell false
gsettings set org.gnome.desktop.wm.preferences visual-bell false
gsettings set org.gnome.desktop.interface toolbar-icons-size 'small'
gsettings set org.gnome.shell.extensions.ding icon-size 'small'
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false