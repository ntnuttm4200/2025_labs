#!/bin/bash
VAR=$(ip a | grep 10.20.50.100 | sed 's/.*\(eth*\)/\1/'); ip link set $VAR down; ip link set $VAR name ether0; ip link set ether0 up
VAR=$(ip a | grep 129.168.1.18/29 | sed 's/.*\(eth*\)/\1/'); ip link set $VAR down; ip link set $VAR name ether1; ip link set ether1 up

macchanger -r ether0
service frr restart

if [ -f "/etc/nftables.conf"  ]; then
    nft -f /etc/nftables.conf
fi
source /home/ttm4200/.bashrc

service ssh restart

su -s /bin/bash ttm4200





