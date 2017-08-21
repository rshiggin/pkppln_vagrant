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
mkdir /home/vagrant/ojsfiles/scheduledTaskLogs
chown -R www-data:www-data /home/vagrant/ojsfiles
sudo chgrp -R www-data cache public /home/vagrant/ojsfiles config.inc.php
sudo chmod -R ug+w cache public /home/vagrant/ojsfiles config.inc.php

# Install Composer dependencies
cd lib/pkp
/usr/bin/composer -q update

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
git clone https://github.com/defstat/pln.git
cd pln
/usr/bin/composer -q install

# Load test data
echo "Loading OJS test data"
cp -ra /vagrant/ojsdata/ojsfiles/* /home/vagrant/ojsfiles
cp -ra /vagrant/ojsdata/public/* /home/vagrant/ojswww/public
mysql -uroot -pojs ojs < /vagrant/ojsdata/ojs.sql

# OJS Upgrade script
echo "Executing OJS Upgrade script"
cd /home/vagrant/ojswww
php tools/upgrade.php upgrade
