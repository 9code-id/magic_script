# ---------------
# MYSQL
# ---------------

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

# ---------------
# PHP
# ---------------

sudo apt update 
sudo apt upgrade 

sudo apt install -y apt-transport-https lsb-release ca-certificates wget 
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list 

sudo apt update 
sudo apt install php8.2 libapache2-mod-php8.2 php8.2-mysql php-common php8.2-cli php8.2-xml php8.2-gd php8.2-mbstring php8.2-common php8.2-opcache php8.2-readline php8.2-curl -y
sudo a2enmod php8.2
curl -o /etc/php/8.2/apache2/php.ini "https://raw.githubusercontent.com/9code-id/magic_script/refs/heads/master/config/0_php.ini?$(date +%s)"
sudo systemctl restart apache2

# ---------------
# INSTALL COMPOSER
# ---------------

curl -sS https://getcomposer.org/installer -o composer-setup.php | php && sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# ---------------
# VSFTPD
# ---------------

curl -o /etc/apache2/apache2.conf "https://raw.githubusercontent.com/9code-id/magic_script/refs/heads/master/config/0_apache.conf?$(date +%s)"
sudo service apache2 restart
sudo apt-get install vsftpd -y
systemctl start vsftpd
systemctl enable vsftpd
curl -o /etc/vsftpd.conf "https://raw.githubusercontent.com/9code-id/magic_script/refs/heads/master/config/0_vsftpd.conf?$(date +%s)"

sudo systemctl restart vsftpd

# ---------------
# SETUP FTP USER
# ---------------

sudo useradd -m "$FTP_USER_NAME"
echo "$FTP_USER_NAME:$FTP_USER_PASSWORD" | sudo chpasswd
usermod --home /var/www/html "$FTP_USER_NAME"
sudo chown -R "$FTP_USER_NAME:$FTP_USER_NAME" /var/www/html

# ---------------
# SETUP UFW
# ---------------
sudo apt-get install ufw -y
sudo ufw allow 8000
sudo ufw allow 4000
sudo ufw allow 3000
sudo ufw enable -y