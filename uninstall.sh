sudo apt-get purge apache2 &&
sudo apt-get purge mariadb-server mariadb-client &&
sudo apt-get purge php* &&
sudo apt-get purge vsftpd &&
sudo apt-get purge pure-ftpd &&
sudo apt-get purge proftpd &&
sudo rm -rf /var/www/html/wordpress &&
sudo apt-get purge certbot &&
sudo rm -rf /etc/apache2 &&
sudo rm -rf /etc/mysql /var/lib/MySQL &&
sudo rm -rf /etc/php* &&
sudo rm -rf /etc/vsftpd /etc/pure-ftpd /etc/proftpd &&
sudo rm -rf /etc/letsencrypt &&
sudo apt-get autoremove &&
sudo apt-get update && sudo apt-get upgrade