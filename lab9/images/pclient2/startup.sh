#!/bin/bash

macchanger -r eth0

if [ -f "/etc/nftables.conf" ]; then
    nft -f /etc/nftables.conf
fi

if [ -f "/etc/wireguard/wg0.conf" ]; then
     wg-quick up /etc/wireguard/wg0.conf
fi

source /home/ttm4200/.bashrc

service ssh restart

su -s /bin/bash ttm4200





