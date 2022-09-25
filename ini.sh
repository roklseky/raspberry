#!/bin/bash
###########################
# Raspberry Pi imager requires username and password to be configured in "advanced" menu. 
# Enable SSH
# Set username and password
# Set locale setting
# Always to use
###########################

# Update
sudo apt update && sudo apt full-upgrade && sudo rpi-update -y

# Tools installation and update - Installation 
sudo apt install python3-gpiozero python3-rpi.gpio mc \
    nmap wget git rsync unzip less sed tcpdump mc dnsutils \
    iputils-ping screen net-tools software-properties-common \
    apt-transport-https ca-certificates curl gnupg-agent neofetch -y
    
#neofetch
sudo bash -c $'echo "neofetch" >> /etc/profile.d/mymotd.sh && chmod +x /etc/profile.d/mymotd.sh'

# Generate SSH keys
PTH=`eval echo ~$USER`
USR=$( echo ${PTH##/*/} )
HST=`hostname`
mkdir $PTH/.ssh
ssh-keygen -t ecdsa -b 521 -f $PTH/.ssh/id_$HST
chown -R $USR:$USR $PTH/.ssh
cat $PTH/.ssh/id_$HST.pub

# Add pub key to git
echo "$(tput setaf 1)$(tput setab 7)\
"Add pub key to github "->" https://github.com/settings/keys for SSH git clone. \
Press [ENTER] when done"$(tput sgr 0)"
read continue

# Clone personal git repo
eval $(ssh-agent)
ssh-add $PTH/.ssh/id_$HST; 
git clone git@github.com:roklseky/dockerfile.git

# Tailscale
curl -fsSL https://pkgs.tailscale.com/stable/raspbian/bullseye.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null
curl -fsSL https://pkgs.tailscale.com/stable/raspbian/bullseye.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update
sudo apt-get install tailscale
sudo tailscale up
