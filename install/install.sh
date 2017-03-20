#!/bin/bash
# Install environment - ubuntu16.04

echo -e "\e[33m||============================================================||";
echo -e "\e[33m|| \e[92m __  __ _______     ____             _                  _  \e[33m||";
echo -e "\e[33m|| \e[92m|  \/  |__   __|   |  _ \           | |                | | \e[33m||";
echo -e "\e[33m|| \e[92m| \  / |  | |______| |_) | __ _  ___| | _____ _ __   __| | \e[33m||";
echo -e "\e[33m|| \e[92m| |\/| |  | |______|  _ < / _\` |/ __| |/ / _ \ '_ \ / _\` \e[33m| ||";
echo -e "\e[33m|| \e[92m| |  | |  | |      | |_) | (_| | (__|   <  __/ | | | (_| | \e[33m||";
echo -e "\e[33m|| \e[92m|_|  |_|  |_|      |____/ \__,_|\___|_|\_\___|_| |_|\__,_| \e[33m||";
echo -e "\e[33m||                                                            ||";
echo -e "\e[33m||===================================================|\e[92mv0.1\e[33m|===||\e[39m";


# Update SO
echo -e "\e[92m =====>\e[33m Update System\e[39m "
sudo apt-get update

# Install dependencies
echo -e "\e[92m =====>\e[33m Install Dependencies\e[39m "
sudo apt-get install -y apache2 libapache2-mod-php7.0 zip unzip

# Install php and and extensions
sudo apt-get install -y php7.0-cli php7.0-mbstring php7.0-mysql php7.0-xml php7.0-zip

# Install composer
sudo apt-get install -y composer

# Install laravel
echo -e "\e[92m =====>\e[33m Install Laravel \e[39m"
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

echo -e "\e[92m =====>\e[33m Configure Environment\e[39m "
# Copy laravel env settings
cp $HOME/sandbox/mt-backend/.env.example $HOME/sandbox/mt-backend/.env

# install composer dependencies

cd $HOME/sandbox/mt-backend
composer install

# Generate key

cd $HOME/sandbox/mt-backend
php artisan key:generate
php artisan config:clear

# Setting permissions for apache
chmod -R 777 $HOME/sandbox/mt-backend/storage $HOME/sandbox/mt-backend/bootstrap/cache

# Configure apache2
sudo cp $HOME/sandbox/mt-backend/install/mtech.conf /etc/apache2/sites-available/mtech.conf
sudo a2ensite mtech.conf
sudo a2dissite 000-default.conf
sudo service apache2 restart
