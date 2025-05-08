#!/bin/bash

# Exit on errors and unset variables
set -eu

# Function to check if MariaDB is available
wait_for_mariadb() {
    echo "Waiting for MariaDB to be ready..."
    
    for i in $(seq 1 30); do
        if mysqladmin ping -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} &>/dev/null; then
            echo "MariaDB is ready!"
            return 0
        fi
        echo "Attempt $i/30: MariaDB not ready yet, waiting..."
        sleep 2
    done
    
    echo "Failed to connect to MariaDB after 30 attempts"
    return 1
}

# Check if WordPress is already installed
if [ -e "./wordpress/wp-config.php" ]; then
    echo "WordPress is already configured"
else
    # Wait for MariaDB to be ready before proceeding
    wait_for_mariadb

    # Download and extract WordPress if not already present
    if [ ! -d "./wordpress" ]; then
        echo "Downloading and installing WordPress..."
        wget --quiet https://fr.wordpress.org/wordpress-6.6.1-fr_FR.tar.gz
        tar xzf wordpress-6.6.1-fr_FR.tar.gz
        rm wordpress-6.6.1-fr_FR.tar.gz
    fi

    # Set correct permissions
    chmod -R 755 /var/www/html
    chown -R www-data:www-data /var/www/html
fi

# Install WP-CLI if not already installed
if [ ! -e "/usr/local/bin/wp" ]; then
    echo "Installing WP-CLI..."
    wget --quiet https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Create wp-config.php if not exists
if [ ! -e "./wordpress/wp-config.php" ]; then
    echo "Creating wp-config.php..."
    # Temporarily disable trace output for sensitive information
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
    
    # Re-enable trace output
    set -x
fi

# Configure PHP-FPM
if grep -q "listen = 0.0.0.0:9000" /etc/php/7.4/fpm/pool.d/www.conf; then
    echo "PHP-FPM already configured."
else
    echo "Configuring PHP-FPM..."
    sed -i '5r /docker-entrypoint.d/php_fpm_ini_block.txt' /etc/php/7.4/fpm/pool.d/www.conf
fi

# Fix port 9000 communication
sed -i '/listen = \/run\/php\/php7.4-fpm.sock/d' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php

echo "WordPress setup complete!"

# Execute the command passed to the script
exec "$@"
