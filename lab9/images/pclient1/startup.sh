#!/bin/bash

macchanger -r eth0
source /home/ttm4200/.bashrc

service ssh restart

su -s /bin/bash ttm4200





