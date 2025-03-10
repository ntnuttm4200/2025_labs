#!/bin/bash
macchanger -r eth0
echo "nameserver 129.100.1.2" > /etc/resolv.conf

service nginx restart
service php8.3-fpm start

service ssh restart

chmod -R go+xr /var/www/
ln -s /etc/nginx/sites-available/ttm4200 /etc/nginx/sites-enabled/ttm4200

sleep 3 && service nginx restart

source /home/ttm4200/.bashrc
su -s /bin/bash ttm4200
