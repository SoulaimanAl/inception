#!/bin/bash

# Download WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Wait for MariaDB to be ready
echo "Waiting for MariaDB..."
while ! mysqladmin ping -h"mariadb" --silent; do
    sleep 1
done
echo "MariaDB is ready!"

# Navigate to WordPress directory
cd /var/www/html

# Check and download WordPress core
if [ ! -f wp-load.php ]; then
    wp core download --allow-root
fi

# Create wp-config.php with database connection
wp config create \
    --dbname="${MYSQL_DATABASE}" \
    --dbuser="${MYSQL_USER}" \
    --dbpass="${MYSQL_PASSWORD}" \
    --dbhost="mariadb:3306" \
    --allow-root

# Install WordPress
wp core install \
    --url="${DOMAIN_NAME}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --allow-root

# Create a second user (required by subject)
wp user create \
    "${WP_USER}" \
    "${WP_USER_EMAIL}" \
    --role=author \
    --user_pass="${WP_USER_PASSWORD}" \
    --allow-root

echo "WordPress setup complete!"

# Start PHP-FPM in foreground
exec php-fpm7.4 -F
