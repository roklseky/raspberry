#!/bin/bash

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

# Docker installation
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker rokl

#Docker-compose https://docs.docker.com/compose/install/
sudo curl -L \
    "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
#uninstall -> sudo rm /usr/local/bin/docker-compose

# Docker API
#ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock -H tcp://0.0.0.0:2375
sleep 20
sudo sed -i 's*--containerd=/run/containerd/containerd.sock*--containerd=/run/containerd/containerd.sock -H tcp://0.0.0.0:2375*' \
/lib/systemd/system/docker.service
sudo systemctl daemon-reload
sudo systemctl restart docker.service
