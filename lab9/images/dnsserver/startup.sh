#!/bin/bash
macchanger -r eth0
echo "nameserver 10.20.30.2" > /etc/resolv.conf

named-checkconf
service named restart
source /home/ttm4200/.bashrc

service ssh restart

su -s /bin/bash ttm4200





