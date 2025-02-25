#!/bin/bash

cd /var/www/html

# Télécharger WP-CLI si ce n'est pas déjà fait
if [ ! -f wp-cli.phar ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
fi

# Vérifier si WordPress est déjà installé
if [ ! -f wp-config.php ]; then
    ./wp-cli.phar core download --allow-root

    ./wp-cli.phar config create --dbname=wordpress --dbuser=wpuser --dbpass="mot_de_passe" --dbhost=mariadb --allow-root

    ./wp-cli.phar core install --url="http://localhost" --title="inception" --admin_user="admin" --admin_password="admin" --admin_email="admin@admin.com" --allow-root
fi

# Lancer PHP-FPM
php-fpm8.2 -F

