#!/bin/bash
VAR=$(ip a | grep 10.20.40.3/29 | sed 's/.*\(eth*\)/\1/'); ip link set $VAR down; ip link set $VAR name ether0; ip link set ether0 up
VAR=$(ip a | grep 10.20.30.3/29 | sed 's/.*\(eth*\)/\1/'); ip link set $VAR down; ip link set $VAR name ether1; ip link set ether1 up

ip route del 0/0
ip route add default via 10.20.40.1
macchanger -r eth0
source ~/.

dpkg-reconfigure openssh-server
service ssh restart

su -s /bin/bash ttm4200





