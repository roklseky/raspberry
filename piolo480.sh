#!/bin/bash

# Static IP /etc/dhcpcd.conf
echo "interface eth0" | sudo tee -a touch /etc/dhcpcd.conf
echo "static ip_address=10.0.0.111/24" | sudo tee -a touch /etc/dhcpcd.conf
echo "static routers=10.0.0.1" | sudo tee -a touch /etc/dhcpcd.conf
echo "static domain_name_servers=10.0.0.1" | sudo tee -a touch /etc/dhcpcd.conf


# https://tailscale.com/kb/1019/subnets/
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf
sudo tailscale up --advertise-routes=10.0.0.0/24 --advertise-exit-node --ssh
