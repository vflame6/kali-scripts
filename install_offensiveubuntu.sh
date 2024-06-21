#!/bin/bash
#
# Bash script for automatic offensive tools installation and desktop configuration
#
# Tested on ubuntu 24.04 LTS
#
# usage: 
# curl https://raw.githubusercontent.com/vflame6/kali-scripts/main/install_offensiveubuntu.sh|sudo bash
#

NOCOLOR="\e[0m"
LIGHT_BLUE="\e[36m"

cd /opt/

# PACKAGES

echo -e "${LIGHT_BLUE}[*]${NOCOLOR} Updating packages"

# resolve graphics problem
sudo add-apt-repository ppa:oibaf/graphics-drivers

sudo apt update
sudo apt -y upgrade

echo -e "${LIGHT_BLUE}[*]${NOCOLOR} Installing packages"

sudo apt install -y open-vm-tools open-vm-tools-desktop
sudo apt install -y vim wget curl git unzip
sudo apt install -y apache2 postgresql tmux openvpn samba
sudo apt install -y smbclient rdesktop freerdp2-x11
sudo apt install -y python3 python3-pip
sudo apt install -y copyq

sudo apt install -y pipx
sudo pipx ensurepath
sudo -u $SUDO_USER pipx ensurepath

sudo apt-get install -y openjdk-11-jdk apt-transport-https
sudo apt-get install wget curl nano software-properties-common dirmngr apt-transport-https gnupg gnupg2 ca-certificates lsb-release ubuntu-keyring unzip -y
curl -fsSL https://debian.neo4j.com/neotechnology.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/neo4j.gpg
echo "deb [signed-by=/usr/share/keyrings/neo4j.gpg] https://debian.neo4j.com stable latest" | sudo tee -a /etc/apt/sources.list.d/neo4j.list
sudo apt-get update
sudo apt-get install neo4j -y

wget https://go.dev/dl/go1.21.11.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.11.linux-amd64.tar.gz
rm go1.21.11.linux-amd64.tar.gz

wget https://repo1.maven.org/maven2/org/python/jython-standalone/2.7.3/jython-standalone-2.7.3.jar

# DOCKER

echo -e "${LIGHT_BLUE}[*]${NOCOLOR} Installing docker"

sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $SUDO_USER

# DOCKER CONTAINERS

echo -e "${LIGHT_BLUE}[*]${NOCOLOR} Pulling containers"

sudo docker pull python:2.7.18-stretch

# TOOLS

echo -e "${LIGHT_BLUE}[*]${NOCOLOR} Installing tools"

sudo -u $SUDO_USER pipx install git+https://github.com/Pennyw0rth/NetExec
sudo -u $SUDO_USER pipx install impacket

sudo -u $SUDO_USER pip3 install impacket

go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go get github.com/ropnop/kerbrute

wget https://github.com/BloodHoundAD/BloodHound/releases/download/v4.3.1/BloodHound-linux-x64.zip
unzip BloodHound-linux-x64.zip
rm -f BloodHound-linux-x64.zip

mkdir -p /opt/wordlists
curl -fsSL https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt -o /opt/wordlists/rockyou.txt
cd /opt/wordlists/

curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall && \
  rm -f msfinstall

# CONF FILES

echo -e "${LIGHT_BLUE}[*]${NOCOLOR} Installing configuration files"

sudo curl -fsSL https://raw.githubusercontent.com/vflame6/kali-scripts/main/vimrc_example -o /etc/vim/vimrc.local

mkdir -p /opt/aliases
sudo curl -fsSL https://raw.githubusercontent.com/vflame6/kali-scripts/main/updatesys.sh -o /opt/aliases/updatesys.sh
chmod +x /opt/aliases/updatesys.sh
sudo curl -fsSL https://raw.githubusercontent.com/vflame6/kali-scripts/main/rev.sh -o /opt/aliases/rev.sh
chmod +x /opt/aliases/rev.sh
sudo curl -fsSL https://raw.githubusercontent.com/vflame6/kali-scripts/main/fnmap.sh -o /opt/aliases/fnmap.sh
chmod +x /opt/aliases/fnmap.sh
sudo curl -fsSL https://raw.githubusercontent.com/vflame6/kali-scripts/main/web.sh -o /opt/aliases/web.sh
chmod +x /opt/aliases/web.sh

echo >> /etc/bash.bashrc
echo "alias grep='grep --color=auto'" >> /etc/bash.bashrc
echo "alias ll='ls -lsah'" >> /etc/bash.bashrc
echo "alias rev='/opt/aliases/rev.sh'" >> /etc/bash.bashrc
echo "alias web='/opt/aliases/web.sh'" >> /etc/bash.bashrc
echo "alias updatesys='/opt/aliases/updatesys.sh'" >> /etc/bash.bashrc
echo "alias fnmap='/opt/aliases/fnmap.sh'" >> /etc/bash.bashrc

echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/bash.bashrc
echo 'export PATH=$PATH:$HOME/go/bin' >> /etc/bash.bashrc

echo 'export PYTHONWARNINGS=ignore' >> /etc/bash.bashrc

## SERVICES

echo -e "${LIGHT_BLUE}[*]${NOCOLOR} Stopping services"

systemctl stop apache2 && systemctl disable apache2
systemctl stop postgresql && systemctl disable postgresql
systemctl stop smbd && systemctl disable smbd

sudo -u $SUDO_USER copyq --start-server config autostart true
sudo -u $SUDO_USER copyq config tray_items 10

## DONE

sudo apt autoremove
sudo apt clean

echo -e "${LIGHT_BLUE}[*]${NOCOLOR} Done. Reboot to continue"
