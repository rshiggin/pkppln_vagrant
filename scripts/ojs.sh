echo "Installing OJS"
cd ~
cd www

# Clone the OJS repository
git clone https://github.com/pkp/ojs .
git checkout ojs-stable-3_0_2
git submodule update --init --recursive
cp /vagrant/config.inc.php config.inc.php
chmod o+w config.inc.php
mkdir ~/files
chmod 777 ~/files
chgrp -R www-data cache public ~/files config.inc.php
chmod -R ug+w cache public ~/files config.inc.php

# Install Composer dependencies
cd lib/pkp
/usr/bin/composer update

# Set up the OJS database
# echo "CREATE DATABASE ojs DEFAULT CHARSET utf8" | mysql -uroot -pojs
# echo "CREATE USER 'ojs'@'localhost' IDENTIFIED BY 'ojs'" | mysql -uroot -pojs
# echo "GRANT ALL ON ojs.* TO 'ojs'@'localhost'" | mysql -uroot -pojs
# echo "FLUSH PRIVILEGES" | mysql -uroot -pojs
echo "CREATE DATABASE ojs DEFAULT CHARSET utf8" | mysql -uroot
echo "CREATE USER 'ojs'@'localhost' IDENTIFIED BY 'ojs'" | mysql -uroot
echo "GRANT ALL ON ojs.* TO 'ojs'@'localhost'" | mysql -uroot
echo "FLUSH PRIVILEGES" | mysql -uroot

# Install OJS
cd /home/ojs/www
php tools/install.php < /vagrant/ojs_install_input.txt

# Install PKP PLN plugin
cd plugins/generic
git clone https://github.com/defstat/PKP-PLN.git 
cd PKP-PLN
/usr/bin/composer install
