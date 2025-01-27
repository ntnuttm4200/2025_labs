#!/bin/bash

apt-get update && apt-get install -y \
    nginx \
    php-fpm php-mysql 

#nginx
rm /etc/nginx/sites-available/default && rm /etc/nginx/sites-enabled/default
rm -r /var/www/html
#php
sed -ri 's/^;?cgi.fix_pathinfo=.*/cgi.fix_pathinfo=0/' /etc/php/*/fpm/php.ini # sed: can't read /etc/php/7.2/fpm/php.ini: No such file or directory. Ubuntu 22.04 has a new version 8.1. put * to avoid this error for future versions
sed -ri 's/^;?date.timezone\s+.*/date.timezone = Europe\/Oslo/' /etc/php/*/fpm/php.ini








