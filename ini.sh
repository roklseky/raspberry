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

# compare SN to assign hostname
git clone https://github.com/roklseky/pi_install.git
PISN=$(cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2)
PTH=`eval echo ~$USER`
SN=$(grep "$PISN" $PTH/pi_sn.txt)
HST=$(echo $SN | cut -d' ' -f2)
sudo raspi-config nonint do_hostname $HST

#reboot
PTH=`eval echo ~$USER`
echo "$(tput setaf 1)$(tput setab 7)\
"Reboot to change hostname and execute "$PTH/pi.sh" after reboot to finish installation\
Press [ENTER] to continue"$(tput sgr 0)"
read continue

sudo reboot now

