#!/bin/bash
WEB_EMAIL="denyocr.world@gmail.com"
WEB_DOMAIN="capekngoding.com"

MYSQL_ROOT_PASSWORD="Biznet123"
MYSQL_USER="rootc"
MYSQL_USER_PASSWORD="Biznet123"
MYSQL_DATABASE="master_db"

FTP_USER_NAME="denyocr"
FTP_USER_PASSWORD="Biznet123"

sudo apt-get update && sudo apt -y upgrade
sudo apt install apache2 apache2-utils mariadb-server mariadb-client git zip unzip -y
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo systemctl restart apache2
sudo systemctl restart mysql.service
sudo systemctl restart mariadb.service

# Set root password
mysql --user=root <<_EOF_
UPDATE mysql.user SET authentication_string=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
_EOF_

# Create new user with root privileges
mysql --user=root --password=$MYSQL_ROOT_PASSWORD <<_EOF_
CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_USER_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
_EOF_

# Restart MySQL service
sudo service mysql restart

# Setup PHP
sudo apt update
sudo apt -y upgrade

sudo apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg gnupg2 curl dirmngr -y
sudo apt update
# echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
# curl -fsSL  https://packages.sury.org/php/apt.gpg| sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/sury-keyring.gpg
# sudo apt update
sudo apt upgrade

# sudo apt install php8.1 libapache2-mod-php8.1 php8.1-mysql php-common php8.1-cli php8.1-xml php8.1-gd php8.1-mbstring php8.1-common php8.1-opcache php8.1-readline php8.1-curl -y
# sudo a2enmod php8.1
# curl -o /etc/php/8.1/apache2/php.ini "https://raw.githubusercontent.com/9code-id/magic_script/refs/heads/master/config/0_php.ini?$(date +%s)"
# sudo systemctl restart apache2

sudo apt install php8.2 libapache2-mod-php8.2 php8.2-mysql php-common php8.2-cli php8.2-xml php8.2-gd php8.2-mbstring php8.2-common php8.2-opcache php8.2-readline php8.2-curl -y
sudo a2enmod php8.2
curl -o /etc/php/8.2/apache2/php.ini "https://raw.githubusercontent.com/9code-id/magic_script/refs/heads/master/config/0_php.ini?$(date +%s)"
sudo systemctl restart apache2

curl -o /etc/apache2/apache2.conf "https://raw.githubusercontent.com/9code-id/magic_script/refs/heads/master/config/0_apache.conf?$(date +%s)"
sudo service apache2 restart
sudo apt-get install vsftpd -y
systemctl start vsftpd
systemctl enable vsftpd
curl -o /etc/vsftpd.conf "https://raw.githubusercontent.com/9code-id/magic_script/refs/heads/master/config/0_vsftpd.conf?$(date +%s)"

sudo systemctl restart vsftpd


# SETUP FTP
sudo useradd -m "$FTP_USER_NAME"
echo "$FTP_USER_NAME:$FTP_USER_PASSWORD" | sudo chpasswd
usermod --home /var/www/html "$FTP_USER_NAME"
sudo chown -R "$FTP_USER_NAME:$FTP_USER_NAME" /var/www/html

# Install UFW
sudo apt-get install ufw -y


# ---------------
# WORDPRESS SECTION
# ---------------

# Add .htaccess
sudo sh -c "echo '# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress' > /var/www/html/.htaccess"

# Install Wordpress
cd /var/www/html
rm -rf index.html
curl -O https://wordpress.org/latest.zip && unzip latest.zip && mv wordpress/* /var/www/html
mysql -u root -e "create database if not exists $MYSQL_DATABASE"

curl "https://raw.githubusercontent.com/9code-id/magic_script/refs/heads/master/config/0_wp_config.php?$(date +%s)" -o /var/www/html/wp-config.php
sed -i "s/define('FTP_USER', '\$FTP_USER');/define('FTP_USER', '$FTP_USER_NAME');/" /var/www/html/wp-config.php
sed -i "s/define('FTP_PASS', '\$FTP_PASS');/define('FTP_PASS', '$FTP_USER_PASSWORD');/" /var/www/html/wp-config.php
sed -i "s/define('FTP_HOST', '\$FTP_HOST');/define('FTP_HOST', '$WEB_DOMAIN');/" /var/www/html/wp-config.php
sed -i "s/define('DB_USER', '\$DB_USER');/define('DB_USER', '$MYSQL_USER');/" /var/www/html/wp-config.php
sed -i "s/define('DB_NAME', '\$DB_NAME');/define('DB_NAME', '$MYSQL_DATABASE');/" /var/www/html/wp-config.php
sed -i "s/define('DB_PASSWORD', '\$DB_PASSWORD');/define('DB_PASSWORD', '$MYSQL_USER_PASSWORD');/" /var/www/html/wp-config.php

# ---------------
# END OF WORDPRESS SECTION
# ---------------

# SETUP LETSENCRYPT
# sudo apt install snapd -y
# sudo snap install core
# sudo snap refresh core
# sudo snap install --classic certbot
# sudo ln -s /snap/bin/certbot /usr/bin/certbot
# sudo certbot --apache --email "$WEB_EMAIL" --domain "$WEB_DOMAIN" --agree-tos --non-interactive
# echo "0 3 1 * * /usr/bin/certbot renew --quiet" | crontab -