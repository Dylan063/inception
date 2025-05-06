#!/bin/bash

# Use 'mkdir -p' to avoid raising an error if the directories already exist,
# it also creates parent directories if they do not exist.
# --allow-root, because CLI can refuse to run as root user
# --quiet,

# 'set -eux' present for : exit on errors (-e), on unset variables (-u), and print commands before executing (-x).
set -eux

sleep 8

if [ -e "./wordpress" ]; then
    echo "wordpress already installed"
else
    wget --quiet https://fr.wordpress.org/wordpress-6.6.1-fr_FR.tar.gz

    tar xzf wordpress-6.6.1-fr_FR.tar.gz

    rm wordpress-6.6.1-fr_FR.tar.gz

    # added those because ownership changed to root otherwise
    chmod -R 755 /var/www/html
    chown -R www-data:www-data /var/www/html
fi

if [ -e "/usr/local/bin/wp" ]; then
    echo "wp-cli.phar already installed as /usr/local/bin/wp"
else
    wget --quiet https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi


if [ -e "./wordpress/wp-config.php" ]; then
    echo "The 'wp-config.php' file already exists."
else
    { set +x; } 2>/dev/null
    wp --allow-root config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb:3306 \
        --path='/var/www/html/wordpress'

    # Install WordPress
    wp --allow-root core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WORDPRESS_SITE_TITLE}" \
        --admin_user=${WORDPRESS_ADMIN_NAME} \
        --admin_email=${WORDPRESS_ADMIN_EMAIL} \
        --admin_password=${WORDPRESS_ADMIN_PASS} \
        --path='/var/www/html/wordpress'

    # Create additional user
    wp --allow-root user create \
        ${WORDPRESS_USER_NAME} ${WORDPRESS_USER_EMAIL} \
        --user_pass=${WORDPRESS_USER_PASS} \
        --role=subscriber \
        --path='/var/www/html/wordpress'
    set -x
fi

if [ "$(grep "listen = 0.0.0.0:9000" /etc/php/7.4/fpm/pool.d/www.conf)" ]; then
    echo "The '/etc/php/7.4/fpm/pool.d/www.conf' file already modified."
else
    sed -i '5r /docker-entrypoint.d/php_fpm_ini_block.txt' /etc/php/7.4/fpm/pool.d/www.conf
fi

# to fix port 9000 communication, it's remove the line that listen to Unix socket
# to fix "ERROR: unable to bind listening socket for address '/run/php/php7.4-fpm.sock': No such file or directory (2)" need to "mkdir -p /run/php"
sed -i '/listen = \/run\/php\/php7.4-fpm.sock/d' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php


exec "$@"
