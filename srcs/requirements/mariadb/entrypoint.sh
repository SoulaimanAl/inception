#!/bin/bash

# Start MariaDB in the background
service mariadb start

# Wait for MariaDB to be ready
sleep 5

# Run the setup script
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "Database setup complete!"

# Stop the background MariaDB service and wait for it
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

# Give it a moment to fully shut down
sleep 2

# Start MariaDB in the foreground to keep container alive
exec mysqld --user=root
