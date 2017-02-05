# Update Ubuntu
apt-get -y update
apt-get -y upgrade

# Install some useful stuff
apt-get -y install openssh-server git vim wget curl

# Install LAMP server
debconf-set-selections <<< 'mysql-server mysql-server/root_password password ojs'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password ojs'
tasksel install lamp-server
apt-get -y install php5-gd php5-dev php5-xsl php5-curl php5-cli php-pear
pear install Archive_Tar
service apache2 restart

# Required by the PKP PLN staging server
apt-get install -y clamav clamav-daemon

# Install composer
curl -Ss https://getcomposer.org/installer | php
mv composer.phar /usr/bin/composer

# Create directories for our applications
sudo mkdir /var/www/html/ojs
sudo chown vagrant:vagrant /var/www/html/ojs
ln -s /var/www/html/ojs /home/vagrant/ojswww

sudo mkdir /var/www/html/pkppln
sudo chown vagrant:vagrant /var/www/html/pkppln
ln -s /var/www/html/pkppln /home/vagrant/pkppln
