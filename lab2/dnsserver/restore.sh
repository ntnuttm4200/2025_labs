#!/bin/bash

echo "Restoring configuration files....."

# if compgen -G "/home/ttm4200/work_dir/config_files/etc/bind/*.zone" > /dev/null; then
#     cp /home/ttm4200/work_dir/config_files/etc/bind/*.zone /etc/bind/
# fi
# does not work when starting the container, it works in bash but not in sh


if ls /home/ttm4200/work_dir/config_files/etc/bind/*.zone 1> /dev/null 2>&1; then
    cp /home/ttm4200/work_dir/config_files/etc/bind/*.zone /etc/bind/
fi

if [ -f "/home/ttm4200/work_dir/config_files/etc/bind/named.conf.options" ]; then
    cp /home/ttm4200/work_dir/config_files/etc/bind/named.conf.options /etc/bind/named.conf.options
fi

if [ -f "/home/ttm4200/work_dir/config_files/etc/bind/named.conf.local" ]; then
    cp /home/ttm4200/work_dir/config_files/etc/bind/named.conf.local /etc/bind/named.conf.local
fi

