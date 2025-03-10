#!/bin/bash
VAR=$(ip a | grep 129.100.1.5/29 | sed 's/.*\(eth*\)/\1/'); ip link set $VAR down; ip link set $VAR name ether0; ip link set ether0 up
VAR=$(ip a | grep 129.168.1.2/29 | sed 's/.*\(eth*\)/\1/'); ip link set $VAR down; ip link set $VAR name ether1; ip link set ether1 up
VAR=$(ip a | grep 129.168.1.26/29 | sed 's/.*\(eth*\)/\1/'); ip link set $VAR down; ip link set $VAR name ether2; ip link set ether2 up

macchanger -r ether0
echo "nameserver 129.100.1.2" > /etc/resolv.conf

service frr restart
source /home/ttm4200/.bashrc

service ssh restart

if [ -f "/etc/nftables.conf"  ]; then
    nft -f /etc/nftables.conf
fi

su -s /bin/bash ttm4200





