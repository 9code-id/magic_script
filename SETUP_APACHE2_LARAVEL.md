To set the Apache2 default directory to `/var/www/investasi_server`, you need to modify the Apache configuration file. Here's how you can do it:

### Steps to Update Apache Default Directory:

1. **Open the Apache configuration file:**
   Edit the default virtual host file. This is usually found in `/etc/apache2/sites-available/000-default.conf`.

   ```bash
   sudo nano /etc/apache2/sites-available/000-default.conf
   ```

2. **Modify the DocumentRoot:**
   Find the line that starts with `DocumentRoot` and change its value to `/var/www/investasi_server`.

   Before:
   ```apache
   DocumentRoot /var/www/html
   ```

   After:
   ```apache
   DocumentRoot /var/www/investasi_server
   ```

3. **Ensure the Directory Permissions are Set Correctly:**
   You also need to update the directory permissions in the same file to match your new directory:
   
   ```apache
   <Directory /var/www/investasi_server>
       Options Indexes FollowSymLinks
       AllowOverride All
       Require all granted
   </Directory>
   ```

4. **Change Ownership (if necessary):**
   Ensure that the Apache user (`www-data`) has the right permissions for the new directory:
   
   ```bash
   sudo chown -R www-data:www-data /var/www/investasi_server
   sudo chmod -R 755 /var/www/investasi_server
   ```

5. **Restart Apache:**
   After making the changes, restart Apache to apply them:

   ```bash
   sudo systemctl restart apache2
   ```