#!/bin/bash

macchanger -r eth0
echo "nameserver 10.20.30.2" > /etc/resolv.conf

if [ -f "/etc/nginx/sites-available/ttm4200" ]; then
    ln -s /etc/nginx/sites-available/ttm4200 /etc/nginx/sites-enabled/ttm4200
fi
if [ -f "/etc/nginx/sites-available/teamsite" ]; then
    ln -s /etc/nginx/sites-available/teamsite /etc/nginx/sites-enabled/teamsite
fi
if [ -d "/etc/ssl" ]; then
    chmod -R go+xr /etc/ssl
fi

service nginx restart
service php8.3-fpm start

service ssh restart

source /home/ttm4200/.bashrc
su -s /bin/bash ttm4200
