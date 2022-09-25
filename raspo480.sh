#!/bin/bash
# https://tailscale.com/kb/1019/subnets/

echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf

sudo tailscale up --ssh --advertise-exit-node --advertise-routes=192.168.1.0/24
