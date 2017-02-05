echo "Installing OJS"
cd /home/vagrant/ojswww

# Clone the OJS repository
git clone https://github.com/pkp/ojs .
git checkout ojs-stable-3_0_2
git submodule update --init --recursive

# Prepare OJS environment
cp /vagrant/ojs_config.inc.php config.inc.php
chmod o+w config.inc.php
mkdir /home/vagrant/ojsfiles
chmod 777 /home/vagrant/ojsfiles
sudo chgrp -R www-data cache public /home/vagrant/ojsfiles config.inc.php
sudo chmod -R ug+w cache public /home/vagrant/ojsfiles config.inc.php

# Install Composer dependencies
cd lib/pkp
/usr/bin/composer update

# Set up the OJS database
echo "CREATE DATABASE ojs DEFAULT CHARSET utf8" | mysql -uroot -pojs
echo "CREATE USER 'ojs'@'localhost' IDENTIFIED BY 'ojs'" | mysql -uroot -pojs
echo "GRANT ALL ON ojs.* TO 'ojs'@'localhost'" | mysql -uroot -pojs
echo "FLUSH PRIVILEGES" | mysql -uroot -pojs

# Install OJS
cd /home/vagrant/ojswww
php tools/install.php < /vagrant/ojs_install_input.txt

# Install PKP PLN plugin
cd plugins/generic
git clone https://github.com/defstat/PKP-PLN.git 
cd PKP-PLN
/usr/bin/composer install
