#!/bin/bash

curl -s https://deb.frrouting.org/frr/keys.asc | apt-key add -
echo deb https://deb.frrouting.org/frr $(lsb_release -s -c) "frr-stable" | tee -a /etc/apt/sources.list.d/frr.list
apt-get update && apt-get install -y frr frr-pythontools nftables isc-dhcp-server isc-dhcp-client
usermod -a -G frr,frrvty ttm4200
sed -i '/ospfd=no/c\ospfd=yes' /etc/frr/daemons
sed -i '/#net.ipv4.ip_forward=1/c\net.ipv4.ip_forward=1' /etc/sysctl.conf
