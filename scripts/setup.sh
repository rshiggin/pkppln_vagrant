# Update Ubuntu
apt-get -y update
apt-get -y upgrade

# Install some useful stuff
apt-get -y install openssh-server git vim wget curl

# Install LAMP server
# debconf-set-selections <<< 'mysql-server mysql-server/root_password password ojs'
# debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password ojs'
debconf-set-selections <<< 'mysql-server mysql-server/root_password password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password'
tasksel install lamp-server
apt-get -y install php5-gd php5-dev php5-xsl php5-curl php5-cli php-pear
pear install Archive_Tar
service apache2 restart

# For the PKP PLN staging server
apt-get install -y clamav clamav-daemon

curl -Ss https://getcomposer.org/installer | php
mv composer.phar /usr/bin/composer

# Create a user
adduser --gecos "" --disabled-password ojs
usermod -a -G www-data ojs

mkdir /var/www/html/ojs
chown ojs:ojs /var/www/html/ojs
ln -s /var/www/html/ojs /home/ojs/www

mkdir /var/www/html/pkppln
chown ojs:ojs /var/www/html/pkppln
ln -s /var/www/html/pkppln /home/ojs/pkppln

su -c "sh /vagrant/scripts/ojs.sh" ojs
su -c "sh /vagrant/scripts/pkppln.sh" ojs
