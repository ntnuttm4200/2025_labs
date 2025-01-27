#!/bin/bash

echo "Saving configuration files....."

mysql_root_password=ttm4200
# echo "saving mysql databases to /home/ttm4200/work_dir/config_files/mysql_databases/dump.sql "
# mysqldump  -u root -p${mysql_root_password} --all-databases > /home/ttm4200/work_dir/config_files/mysql_databases/dump.sql

if [ -f "/etc/nginx/sites-available/ttm4200" ]; then
    echo "Saving /etc/nginx/sites-available/ttm4200"
    cp /etc/nginx/sites-available/ttm4200 /home/ttm4200/work_dir/config_files/etc/nginx/sites-available/ttm4200
fi

# if [ -d "/var/www/" ]; then
#     echo "Saving /var/www/"
#     cp -Tr /var/www/ /home/ttm4200/work_dir/config_files/var/www/
# fi

if [ -d "/var/mail/vmail/" ]; then
    echo "saving /var/mail/vmail/"
    cp -Tr /var/mail/vmail/ /home/ttm4200/work_dir/config_files/var/mail/vmail/
    chmod -R go+rx /home/ttm4200/work_dir/config_files/var/mail/vmail/
fi

echo "saving postfix database to /home/ttm4200/work_dir/config_files/mysql_databases/postfixdb.sql"
mysqldump  -u root -p${mysql_root_password} postfix > /home/ttm4200/work_dir/config_files/mysql_databases/postfixdb.sql
