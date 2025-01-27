#!/bin/bash

sh /home/ttm4200/work_dir/restore.sh

# ip route del 0/0
# ip route add default via 10.20.30.100
macchanger -r eth0
echo "nameserver 10.20.30.2" > /etc/resolv.conf

ln -s /opt/postfixadmin/public/ /var/www/ttm4200/postfixadmin
ln -s /usr/share/phpmyadmin /var/www/ttm4200/phpmyadmin
chown -R vmail:vmail /var/mail/vmail
chown -R www-data:www-data /var/www/ttm4200/webmail/
chmod 755 /var/www/ttm4200/webmail/temp/ /var/www/ttm4200/webmail/logs/

# on unix, connecting to socket requires write permission on that socket
# but you  also need search (execute) permission on the directory
chmod o+rx /var/run/mysqld

# I got the following error: su: warning: cannot change directory to /nonexistent: No such file or directory
# one suggestion: mysql user is looking for a home directory, which seems to have not been assigned (https://stackoverflow.com/questions/62987154/mysql-wont-start-error-su-warning-cannot-change-directory-to-nonexistent)
usermod -d /var/lib/mysql/ mysql

service mysql start
service saslauthd restart
service nginx restart
service php8.3-fpm start
service postfix restart
service dovecot restart

mysql_root_password=ttm4200
if [ -f "/home/ttm4200/work_dir/config_files/mysql_databases/postfixdb.sql" ]; then
    echo "Restoring postfix database"
    mysql -u root -p${mysql_root_password} postfix <  /home/ttm4200/work_dir/config_files/mysql_databases/postfixdb.sql
fi

# if [ -f "/home/ttm4200/work_dir/config_files/mysql_databases/dump.sql" ]; then
#     echo "Restoring mysql_databases"
#     mysql -u root -p${mysql_root_password} <  /home/ttm4200/work_dir/config_files/mysql_databases/dump.sql
# fi

dpkg-reconfigure openssh-server
service ssh restart

source ~/.bashrc
su -s /bin/bash ttm4200
