#!/bin/bash

# Start MariaDB in the background
service mariadb start

# Wait for MariaDB to be ready
sleep 5

# FIX: Added -h localhost to use socket connection
mysql -h localhost -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo "Database setup complete!"

# FIX: Added -h localhost here too
mysqladmin -h localhost -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

# Give it a moment to fully shut down
sleep 2

# Start MariaDB in the foreground
exec mysqld --user=mysql
