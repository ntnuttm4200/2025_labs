#!/bin/bash

echo "Saving configuration files....."


# if [ -f "/etc/nginx/sites-available/ttm4200" ]; then
#     echo "Saving /etc/nginx/sites-available/ttm4200"
#     cp /etc/nginx/sites-available/ttm4200 /home/ttm4200/work_dir/config_files/etc/nginx/sites-available/ttm4200
# fi

if [ -f "/etc/nginx/sites-available/teamsite.conf" ]; then
    echo "Saving /etc/nginx/sites-available/teamsite.conf"
    cp /etc/nginx/sites-available/teamsite.conf /home/ttm4200/work_dir/config_files/etc/nginx/sites-available/teamsite.conf
fi

if [ -d "/var/www/" ]; then
    echo "Saving /var/www/"
    cp -Tr /var/www/ /home/ttm4200/work_dir/config_files/var/www/
fi


