#!/bin/bash

echo "=== WordPress Entrypoint Started ==="

if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

if [ ! -f /var/www/html/wp-config.php ]; then
    wp core download --allow-root
    
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb" \
        --allow-root
    
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root
    
    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root

    #redis conf
    wp plugin install redis-cache --activate --allow-root
    wp config set WP_REDIS_HOST "redis" --allow-root
    wp config set WP_REDIS_PORT "6379" --allow-root
    wp redis enable --allow-root
fi

chown -R www-data:www-data /var/www/html
chmod -R g+w /var/www/html
sed -i 's|^listen = /run/php/php8.2-fpm.sock|listen = 9000|g' /etc/php/8.2/fpm/pool.d/www.conf
sed -i 's/^listen.allowed_clients/;listen.allowed_clients/g' /etc/php/8.2/fpm/pool.d/www.conf
grep ^listen /etc/php/8.2/fpm/pool.d/www.conf

exec php-fpm8.2 -F