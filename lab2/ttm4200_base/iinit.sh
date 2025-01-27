#!/bin/bash
macchanger -r eth0
source ~/.bashrc

dpkg-reconfigure openssh-server
service ssh restart

su -s /bin/bash ttm4200
/bin/bash
