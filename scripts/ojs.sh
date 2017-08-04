sudo -i
echo "Installing OJS 2.4.x"
cd ~

# Set up the OJS database
echo "CREATE DATABASE ojs DEFAULT CHARSET utf8" | mysql -uroot -pojs
echo "CREATE USER 'ojs'@'localhost' IDENTIFIED BY 'ojs'" | mysql -uroot -pojs
echo "GRANT ALL ON ojs.* TO 'ojs'@'localhost'" | mysql -uroot -pojs
echo "FLUSH PRIVILEGES" | mysql -uroot -pojs

cd /var/www/html

# Clone the OJS repository
 git clone -b ojs-stable-2_4_8 --single-branch https://github.com/pkp/ojs
 cd ojs
 git submodule update --init --recursive

# mkdir ojs
# cp -ra /vagrant/ojsdata/ojsfiles/ojs2/* /ojs

cp /vagrant/ojsdata/config_OJS2.inc.php config.inc.php
mkdir ~/files
chgrp -R www-data cache public ~/files config.inc.php
chmod -R ug+w cache public ~/files config.inc.php


# Install Composer dependencies
# cd lib/pkp
# curl -sS https://getcomposer.org/installer | php
# php composer.phar update

# Install OJS
# wget -O - --post-data="adminUsername=admin&adminPassword=admin&adminPassword2=admin&adminEmail=ojs@mailinator.com&locale=en_US&additionalLocales[]=en_US&clientCharset=utf-8&connectionCharset=utf8&databaseCharset=utf8&filesDir=%2fhome%2fojs%2ffiles&encryption=sha1&databaseDriver=mysql&databaseHost=localhost&databaseUsername=ojs&databasePassword=ojs&databaseName=ojs&oaiRepositoryId=ojs2.localhost" "http://localhost/ojs/index.php/index/install/install"
mkdir /home/ojs
mkdir /home/ojs/files

cp -ra /vagrant/ojsdata/ojsfiles/* /home/ojs/files
cp -ra /vagrant/ojsdata/public/* /var/www/html/ojs/public

mysql -uroot -pojs ojs < /vagrant/ojsdata/installationPhase248DataImport.sql

# Import 
cd /var/www/html/ojs/tools
php importExport.php NativeImportExportPlugin import /vagrant/ojsdata/test.xml ojs admin

# Installing OJS3
echo "Installing OJS 3.x"
cd /var/www/html

# Clone the OJS repository
git clone -b ojs-stable-3_0_2 --single-branch https://github.com/pkp/ojs ojs3
cd ojs3
git submodule update --init --recursive

# mkdir ojs3
# cp -ra /vagrant/ojsdata/ojsfiles/ojs3/* /ojs3

cp /vagrant/ojsdata/config_OJS3.inc.php config.inc.php
mkdir ~/files3
chgrp -R www-data cache public ~/files3 config.inc.php
chmod -R ug+w cache public ~/files3 config.inc.php


# Install Composer dependencies
cd lib/pkp
curl -sS https://getcomposer.org/installer | php
php composer.phar update

# Import 
cd /var/www/html/ojs3/tools
php upgrade.php upgrade
mysql -N -uroot -pojs ojs -e "select GROUP_CONCAT(issue_id SEPARATOR ' ') from issues" >> /vagrant/ojsdata/exportScriptParameters.txt
sh /vagrant/ojsdata/exportScriptParameters.txt