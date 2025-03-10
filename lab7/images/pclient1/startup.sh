#!/bin/bash
macchanger -r eth0
echo "nameserver 129.100.1.2" > /etc/resolv.conf
source /home/ttm4200/.bashrc

service ssh restart

su -s /bin/bash ttm4200





