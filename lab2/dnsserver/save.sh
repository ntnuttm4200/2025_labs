#!/bin/bash

echo "Saving configuration files....."


if ls /etc/bind/*.zone 1> /dev/null 2>&1; then
    cp  /etc/bind/*.zone /home/ttm4200/work_dir/config_files/etc/bind/
fi


if [ -f "/etc/bind/named.conf.options" ]; then
    cp  /etc/bind/named.conf.options /home/ttm4200/work_dir/config_files/etc/bind/named.conf.options
fi
if [ -f "/etc/bind/named.conf.local" ]; then
    cp  /etc/bind/named.conf.local /home/ttm4200/work_dir/config_files/etc/bind/named.conf.local
fi







