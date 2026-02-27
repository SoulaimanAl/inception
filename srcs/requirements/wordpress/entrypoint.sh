#!/bin/bash

echo "=== WordPress Entrypoint Started ==="

# Download WP-CLI
if [ ! -f /usr/local/bin/wp ]; then
    echo "Downloading WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Wait for MariaDB
echo "Waiting for MariaDB to be ready..."
max_tries=30
count=0
while [ $count -lt $max_tries ]; do
    if mysql -h mariadb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "SELECT 1" 2>/dev/null; then
        echo "✓ MariaDB is ready!"
        break
    fi
    count=$((count + 1))
    echo "Attempt $count/$max_tries: MariaDB not ready..."
    sleep 2
done

if [ $count -eq $max_tries ]; then
    echo "✗ Could not connect to MariaDB. Exiting."
    exit 1
fi

# Install WordPress if not already installed
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Downloading WordPress core..."
    wp core download --allow-root
    
    echo "Creating wp-config.php..."
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb" \
        --allow-root
    
    echo "Installing WordPress..."
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root
    
    echo "Creating additional user..."
    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root
    
    echo "✓ WordPress installation complete!"
fi

# Fix permissions
chown -R www-data:www-data /var/www/html

# CRITICAL: Configure PHP-FPM to listen on TCP port 9000
echo "Configuring PHP-FPM to listen on port 9000..."
sed -i 's|^listen = /run/php/php8.2-fpm.sock|listen = 9000|g' /etc/php/8.2/fpm/pool.d/www.conf
sed -i 's/^listen.allowed_clients/;listen.allowed_clients/g' /etc/php/8.2/fpm/pool.d/www.conf

# Verify configuration
echo "PHP-FPM listening on:"
grep ^listen /etc/php/8.2/fpm/pool.d/www.conf

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm8.2 -F
