sudo apt-get purge apache2 -y &&
sudo apt-get purge mariadb-server mariadb-client -y &&
sudo apt-get purge php* -y &&
sudo apt-get purge vsftpd -y &&
sudo apt-get purge pure-ftpd -y &&
sudo apt-get purge proftpd -y &&
sudo rm -rf /var/www/html/wordpress &&
sudo apt-get purge certbot &&
sudo rm -rf /etc/apache2 &&
sudo rm -rf /etc/mysql /var/lib/MySQL &&
sudo rm -rf /etc/php* &&
sudo rm -rf /etc/vsftpd /etc/pure-ftpd /etc/proftpd &&
sudo rm -rf /etc/letsencrypt &&
sudo apt-get autoremove &&
sudo apt-get update && sudo apt-get upgrade