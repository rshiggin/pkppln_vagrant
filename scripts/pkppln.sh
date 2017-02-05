echo "Installing the PKP PLN staging server"

# Set up the PKP PLN staging server database
# echo "CREATE DATABASE pln DEFAULT CHARSET utf8" | mysql -uroot -pojs
# echo "CREATE USER 'pln'@'localhost' IDENTIFIED BY 'pln'" | mysql -uroot -pojs
# echo "GRANT ALL ON pln.* TO 'pln'@'localhost'" | mysql -uroot -pojs
# echo "FLUSH PRIVILEGES" | mysql -uroot -pojs

echo "CREATE DATABASE symfony DEFAULT CHARSET utf8" | mysql -uroot

cd ~
cd pkppln
git clone https://github.com/ubermichael/pkppln-php.git .
cp /vagrant/pkppln_parameters.yml.dist app/config/parameters.yml.dist
/usr/bin/composer install

chmod -R 777 /var/www/html/pkppln/app/cache
chmod -R 777 /var/www/html/pkppln/app/logs
php app/console doctrine:schema:update --force
php app/console fos:user:create --super-admin admin@example.com admin Admin Example.com

echo "Log into the PKP PLN staging server at http://localhost:8000/pkppln/web/app.php/login with admin@example.com / admin"
