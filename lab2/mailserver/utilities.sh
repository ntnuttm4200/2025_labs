#!/bin/bash
#Uncomment "set -e" for fast failure on error detection
#set -e

#Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d

#Software Packages in "jammy", Subsection php: https://packages.ubuntu.com/it/jammy/ppc64el/php/
apt-get update && apt-get install -y \
    mysql-server \
    php-imap php-mbstring php8.3-imap php8.3-mbstring \
    postfix postfix-mysql sasl2-bin \
    dovecot-imapd dovecot-mysql dovecot-managesieved \
    mailutils tree \
    phpmyadmin php-net-ldap3 php-intl 

# wget -P /opt https://github.com/postfixadmin/postfixadmin/archive/postfixadmin-3.2.tar.gz
wget -P /opt https://github.com/postfixadmin/postfixadmin/archive/refs/tags/postfixadmin-3.3.13.tar.gz
cd /opt && tar xf postfixadmin-3.3.13.tar.gz
mv postfixadmin-postfixadmin-3.3.13/ postfixadmin && rm postfixadmin-3.3.13.tar.gz
#ln -s /opt/postfixadmin/public/ /var/www/ttm4200/pfa

# passwors for mysql, postfix, roundcube and phpmyadmin
# TODO: use hashes instead of plain text
mysql_root_password=ttm4200
postfix_db_password=ttm4200
roundcube_db_password=ttm4200
phpmyadmin_db_password=ttm4200


# Unable to start mysql service inside container unless I touch files first: touch -c -a: -c does not create any files; -a updates access time: this will only change the access time if the file already exists. (https://github.com/moby/moby/issues/34390)
# mysql -e : execute the following command and exit
# ALTER USER 'root'@'localhost': change the password of the root user, which is the default user created by the mysql-server package
# localhost: when you use localhost, the socket connector is used. Whereas, when you use 127.0. 0.1, TCP/IP connector is used.
# IDENTIFIED WITH mysql_native_password BY: use the mysql_native_password authentication plugin to authenticate the user. 
#It uses unix_socket authentication, and allows login to users on the local machine only (works only with socket connections, not TCP/IP connections)
# Running the last command results in an update of the mysql.user table.
find /var/lib/mysql/mysql -exec touch -c -a {} + && mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${mysql_root_password}';"

# mysql -u root -p${mysql_root_password}: login as root user with the password set above
# <<EOF: read from standard input until EOF is encountered
# CREATE DATABASE postfix: create a database named postfix
# CREATE USER 'postfix'@'localhost' IDENTIFIED BY '${postfix_db_password}': create a user named postfix with the password set above
# GRANT ALL PRIVILEGES ON postfix.* TO 'postfix'@'localhost': grant all privileges on the postfix database to the postfix user
# FLUSH PRIVILEGES: flush privileges to make changes effective
# exit: exit from mysql
mysql -u root -p${mysql_root_password} <<EOF
CREATE DATABASE postfix;
CREATE USER 'postfix'@'localhost' IDENTIFIED BY '${postfix_db_password}';
GRANT ALL PRIVILEGES ON postfix.* TO 'postfix'@'localhost';
FLUSH PRIVILEGES;
exit
EOF

# edit /opt/postfixadmin/config.inc.php to set the database type, user, password and name
# "cat >" writes standard input to a file, overwriting the file if it already exists
# "cat >>" appends standard input to a file
# the setup_passwod hash is generated from /opt/postfixadmin/setup.php
# \$CONF['setup_password'] = '6d40029eeaed0de4cfe4bf2f223609ba:5ed68e7927f9889f03154b03d1d77434be353222';
cat >/opt/postfixadmin/config.local.php <<EOL
<?php
\$CONF['database_type'] = 'mysqli';
\$CONF['database_user'] = 'postfix';
\$CONF['database_password'] = '${postfix_db_password}';
\$CONF['database_name'] = 'postfix';
\$CONF['configured'] = true;
\$CONF['setup_password'] = '\$2y\$10\$HbIwnCDp/NDhxYh09/FF6ePQZcvvxj8swb857STOCYQjBCo0jUjye';
\$CONF['emailcheck_resolve_domain']='NO';
?>
EOL

# creat the templates_c directory and set the permissions
mkdir /opt/postfixadmin/templates_c && chmod 755 -R /opt/postfixadmin/templates_c
# change the owner and group of the templates_c directory to www-data (the user and group used by the web server)
chown -R www-data:www-data /opt/postfixadmin/templates_c

# sed -ri: -r: use extended regular expressions in the script; -i: edit files in place
# s/^START=.*/START=yes/: replace the line that starts with START= with START=yes
sed -ri 's/^START=.*/START=yes/' /etc/default/saslauthd
groupadd -g 5000 vmail && mkdir -p /var/mail/vmail
useradd -u 5000 vmail -g vmail -s /usr/sbin/nologin -d /var/mail/vmail
chown -R vmail:vmail /var/mail/vmail
mkdir -p /etc/postfix/sql

cat >/etc/postfix/sql/mysql_virtual_domains_maps.cf <<EOL
user = postfix
password = ${postfix_db_password}
hosts = 127.0.0.1
dbname = postfix
query = SELECT domain FROM domain WHERE domain='%s' AND active = '1'
EOL
postconf -e virtual_mailbox_domains=mysql:/etc/postfix/sql/mysql_virtual_domains_maps.cf

cat >/etc/postfix/sql/mysql_virtual_mailbox_maps.cf <<EOL
user = postfix
password = ${postfix_db_password}
hosts = 127.0.0.1
dbname = postfix
query = SELECT maildir FROM mailbox WHERE username='%s' AND active = '1'
EOL
postconf -e virtual_mailbox_maps=mysql:/etc/postfix/sql/mysql_virtual_mailbox_maps.cf

cat >/etc/postfix/sql/mysql_virtual_alias_maps.cf <<EOL
user = postfix
password = ${postfix_db_password}
hosts = 127.0.0.1
dbname = postfix
query = SELECT goto FROM alias WHERE address='%s' AND active = '1'
EOL
postconf -e virtual_alias_maps=mysql:/etc/postfix/sql/mysql_virtual_alias_maps.cf
chgrp postfix /etc/postfix/sql/mysql_*.cf

# encryption configuration (if you have key and TLS certificate, you can add them here)
cat >> /etc/postfix/main.cf <<EOL
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_auth_enable = yes
smtpd_sasl_security_options = noanonymous
smtpd_sasl_local_domain = \$myhostname
smtpd_tls_security_level = may
smtpd_tls_auth_only = no
smtpd_recipient_restrictions = permit_mynetworks permit_sasl_authenticated reject_unauth_destination
EOL

#enable submission service in postfix (so that email clients can send email to the postfix smtp server)
# at least one whitespace before the -o option is required (meanns: this line is a continuation of the previous line)
cat >> /etc/postfix/master.cf <<EOL
submission inet n       -       y       -       -       smtpd
   -o syslog_name=postfix/submission
   -o smtpd_tls_security_level=encrypt
   -o smtpd_sasl_auth_enable=yes
   -o smtpd_client_restrictions=permit_sasl_authenticated,reject
   -o milter_macro_daemon_name=ORIGINATING
 smtps     inet  n       -       y       -       -       smtpd
   -o syslog_name=postfix/smtps
   -o smtpd_tls_wrappermode=yes
   -o smtpd_sasl_auth_enable=yes
   -o smtpd_client_restrictions=permit_sasl_authenticated,reject
   -o milter_macro_daemon_name=ORIGINATING
EOL

#Configuration of dovecot
sed -ri 's/^auth_mechanisms\s+.*/auth_mechanisms = plain login/' /etc/dovecot/conf.d/10-auth.conf
sed -ri 's/^!include auth-system.conf.ext/#!include auth-system.conf.ext/' /etc/dovecot/conf.d/10-auth.conf
sed -ri 's/^#!include auth-sql.conf.ext/!include auth-sql.conf.ext/' /etc/dovecot/conf.d/10-auth.conf

#This made me lose a whole afternooon Allow insecure IMAP/SMTP connections without STARTTLS
cat >> /etc/dovecot/conf.d/10-auth.conf <<EOL
disable_plaintext_auth=no
ssl=no
EOL

cat > /etc/dovecot/conf.d/auth-sql.conf.ext <<EOL
passdb {
  driver = sql
  args = /etc/dovecot/dovecot-sql.conf.ext
}
userdb {
  driver = static
  args = uid=vmail gid=vmail home=/var/mail/vmail/%d/%n
}
EOL
cat >> /etc/dovecot/dovecot-sql.conf.ext <<EOL
driver = mysql
connect = host=127.0.0.1 dbname=postfix user=postfix password=${postfix_db_password}
password_query = SELECT username,domain,password FROM mailbox WHERE username='%u';
default_pass_scheme = MD5-CRYPT
EOL

# configure mailbox location
sed -ri 's/^mail_location\s+.*/mail_location = maildir:\/var\/mail\/vmail\/%d\/%n\/Maildir/' /etc/dovecot/conf.d/10-mail.conf


cat >> /etc/dovecot/conf.d/10-master.conf <<EOL
service auth {
  unix_listener auth-userdb {
    mode = 0600
    user = vmail
  }

  unix_listener /var/spool/postfix/private/auth {
    mode = 0660
    user = postfix
    group = postfix
  }

  user = dovecot
}
EOL
sed -ri 's/#mail_plugins\s+.*/mail_plugins = \$mail_plugins sieve/' /etc/dovecot/conf.d/15-lda.conf
chgrp vmail /etc/dovecot/dovecot.conf

#Integrate dovecot to postfix
cat >> /etc/postfix/master.cf <<EOL
dovecot   unix  -       n       n       -       -       pipe
  flags=DRhu user=vmail:vmail argv=/usr/lib/dovecot/deliver -f \${sender} -d \${user}@\${nexthop}
EOL
cat >> /etc/postfix/main.cf <<EOL
virtual_transport = dovecot
dovecot_destination_recipient_limit = 1
EOL

#RoundCube
mkdir /var/www/ttm4200 && cd /var/www/ttm4200
wget https://github.com/roundcube/roundcubemail/releases/download/1.6.0/roundcubemail-1.6.0-complete.tar.gz
tar xf roundcubemail-1.6.0-complete.tar.gz
mv roundcubemail-1.6.0 webmail
rm roundcubemail-1.6.0-complete.tar.gz && cd webmail

mysql -u root -p${mysql_root_password} <<EOF
CREATE DATABASE roundcubedb;
CREATE USER 'roundcube'@'localhost' IDENTIFIED BY '${roundcube_db_password}';
GRANT ALL PRIVILEGES ON roundcubedb.* TO 'roundcube'@'localhost';
FLUSH PRIVILEGES;
exit
EOF

mysql -u root -p${mysql_root_password} roundcubedb < /var/www/ttm4200/webmail/SQL/mysql.initial.sql


# Local configuration for Roundcube Webmaill

# cat >> /var/www/ttm4200/webmail/config/config.inc.php << EOF
# <?php 
# \$config['db_dsnw'] = 'mysql://roundcube:${roundcube_db_password}@localhost/roundcubedb';
# \$config['default_host'] = 'localhost';
# \$config['des_key'] = 'tKNjKFcyY85ixi7xO9FIAw7K';
# \$config['support_url'] = '';
# \$config['plugins'] = array();
# EOF
#config.inc.php



cat >> /var/www/ttm4200/webmail/config/config.inc.php << EOF
<?php

/* Local configuration for Roundcube Webmail */

// ----------------------------------
// SQL DATABASE
// ----------------------------------
// Database connection string (DSN) for read+write operations
// Format (compatible with PEAR MDB2): db_provider://user:password@host/database
// Currently supported db_providers: mysql, pgsql, sqlite, mssql, sqlsrv, oracle
// For examples see http://pear.php.net/manual/en/package.database.mdb2.intro-dsn.php
// Note: for SQLite use absolute path (Linux): 'sqlite:////full/path/to/sqlite.db?mode=0646'
//       or (Windows): 'sqlite:///C:/full/path/to/sqlite.db'
// Note: Various drivers support various additional arguments for connection,
//       for Mysql: key, cipher, cert, capath, ca, verify_server_cert,
//       for Postgres: application_name, sslmode, sslcert, sslkey, sslrootcert, sslcrl, sslcompression, service.
//       e.g. 'mysql://roundcube:@localhost/roundcubemail?verify_server_cert=false'
\$config['db_dsnw'] = 'mysql://roundcube:ttm4200@localhost/roundcubedb';

// ----------------------------------
// IMAP
// ----------------------------------
// The IMAP host (and optionally port number) chosen to perform the log-in.
// Leave blank to show a textbox at login, give a list of hosts
// to display a pulldown menu or set one host as string.
// Enter hostname with prefix ssl:// to use Implicit TLS, or use
// prefix tls:// to use STARTTLS.
// If port number is omitted it will be set to 993 (for ssl://) or 143 otherwise.
// Supported replacement variables:
// %n - hostname (\$_SERVER['SERVER_NAME'])
// %t - hostname without the first part
// %d - domain (http hostname \$_SERVER['HTTP_HOST'] without the first part)
// %s - domain name after the '@' from e-mail address provided at login screen
// For example %n = mail.domain.tld, %t = domain.tld
// WARNING: After hostname change update of mail_host column in users table is
//          required to match old user data records with the new host.
\$config['imap_host'] = 'localhost:143';

// provide an URL where a user can get support for this Roundcube installation
// PLEASE DO NOT LINK TO THE ROUNDCUBE.NET WEBSITE HERE!
\$config['support_url'] = '';

// This key is used for encrypting purposes, like storing of imap password
// in the session. For historical reasons it's called DES_key, but it's used
// with any configured cipher_method (see below).
// For the default cipher_method a required key length is 24 characters.
\$config['des_key'] = 'n2UhUwuL2LS4x9d1SgL7u7FW';

// ----------------------------------
// PLUGINS
// ----------------------------------
// List of active plugins (in plugins/ directory)
\$config['plugins'] = [];

// ----------------------------------
// SMTP
// ----------------------------------

// SMTP server host (and optional port number) for sending mails.
// Enter hostname with prefix ssl:// to use Implicit TLS, or use
// prefix tls:// to use STARTTLS.
// If port number is omitted it will be set to 465 (for ssl://) or 587 otherwise.
// Supported replacement variables:
// %h - user's IMAP hostname
// %n - hostname (\$_SERVER['SERVER_NAME'])
// %t - hostname without the first part
// %d - domain (http hostname \$_SERVER['HTTP_HOST'] without the first part)
// %z - IMAP domain (IMAP hostname without the first part)
// For example %n = mail.domain.tld, %t = domain.tld
// To specify different SMTP servers for different IMAP hosts provide an array
// of IMAP host (no prefix or port) and SMTP server e.g. ['imap.example.com' => 'smtp.example.net']
\$config['smtp_host'] = 'localhost:25';

EOF



#phpmyadmin (maybe be remove it)

mysql -u root -p${mysql_root_password} <<EOF
DROP DATABASE phpmyadmin;
CREATE DATABASE phpmyadmin;
CREATE USER 'pma'@'localhost' IDENTIFIED BY '${phpmyadmin_db_password}';
GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'pma'@'localhost';
FLUSH PRIVILEGES;
exit
EOF
mysql -u root -p${mysql_root_password} phpmyadmin < /usr/share/phpmyadmin/sql/create_tables.sql
cat >> /etc/phpmyadmin/config.inc.php <<EOF
\$cfg['Servers'][1]['pmadb'] = 'phpmyadmin';
\$cfg['Servers'][1]['controluser'] = 'pma';
\$cfg['Servers'][1]['controlpass'] = '${phpmyadmin_db_password}';
EOF
# # pay attention to the following line, I commented it out. I had no idea what it was doing, but it was causing an error: can't read /usr/share/phpmyadmin/libraries/sql.lib.php: No such file or directory
# sudo sed -i "s/|\s*\((count(\$analyzed_sql_results\['select_expr'\]\)/| (\1)/g" /usr/share/phpmyadmin/libraries/sql.lib.php
