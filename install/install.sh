#!/bin/bash

# Install environment - ubuntu16.04

# Update SO
sudo apt-get update

# Install dependencies
sudo apt-get install -y apache2 libapache2-mod-php7.0 zip unzip

# Install php and and extensions
sudo apt-get install -y php7.0-cli php7.0-mbstring php7.0-mysql php7.0-xml php7.0-zip

# Install composer
sudo apt-get install -y composer

# Install laravel
composer global require "laravel/installer"

# Add laravel to path
echo "
if [ -d "$HOME/.config/composer/vendor/bin" ] ; then
	PATH="$PATH:$HOME/.config/composer/vendor/bin"
fi" >>  $HOME/.profile

# Execute  .profile
.  $HOME/.profile

# Install nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash

# Install nodejs
nvm install v7.6.0

# Copy laravel env settings
cp $HOME/sandbox/mt-backend/.env.example .env

# Generate key
php artisan key:generate
php artisan config:clear

# Setting permissions for apache
chmod -R 777 $HOME/sandbox/mt-backend/storage $HOME/sandbox/mt-backend/bootstrap/cache

# Configure apache2
sudo cp $HOME/sandbox/mt-backend/install/mtech.conf /etc/apache2/sites-available/mtech.conf
sudo a2ensite mtech.conf
sudo a2dissite 000-default.conf
sudo service apache2 restart
