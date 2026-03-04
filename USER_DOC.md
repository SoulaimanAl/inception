# USER_DOC.md

*This project has been created as part of the 42 curriculum by salahian.*

## Overview

This project provides a complete web hosting stack based on Docker containers. It includes the following services:

- **MariaDB** – Relational database for WordPress.
- **WordPress** – Content management system (CMS) with PHP‑FPM.
- **Nginx** – Web server that serves the site over HTTPS.

Additional bonus services may be present (if enabled):
- **Redis** – In‑memory cache for WordPress.
- **FTP server** – Allows file management via FTP.
- **Static website** – A simple HTML/CSS/JS site.
- **Adminer** – Web‑based database administration.
- **Portainer** – Docker management UI.

All services run in separate containers but are interconnected through an internal Docker network. Persistent data (database, WordPress files) is stored in Docker volumes, so your data remains safe even when containers are restarted or recreated.

## Starting and Stopping the Project

All operations are done from the **root directory** of the repository using the provided `Makefile`.

### First Start

1. Ensure **Docker** and **Docker Compose** are installed on your machine.
2.Create the .env.example and copy the lines below, and copy it to file .env and adjust the values (passwords, domain name, etc.):
    <!-- # Domain
    DOMAIN_NAME=
    # MariaDB Configuration 
    MYSQL_ROOT_PASSWORD=
    MYSQL_DATABASE=
    MYSQL_USER=
    MYSQL_PASSWORD=
    MYSQL_HOST=
    # WordPress Configuration   
    WP_TITLE=
    WP_ADMIN_USER=
    WP_ADMIN_PASSWORD=
    WP_ADMIN_EMAIL=
    # WordPress Second User
    WP_USER=
    WP_USER_EMAIL=
    WP_USER_PASSWORD=
    # FTP server
    FTP_USER=
    FTP_PASSWORD= -->

   ```bash
   cp srcs/.env.example srcs/.env

3. Build and launch all containers:
bash

make

This will create the necessary Docker images, start the containers, and set up the network and volumes.

4. Stop the Project
bash

make down

This stops all containers but keeps the volumes (your data) and images.

5. Restart the Project
bash

make start

6. Completely Remove Everything
bash

make clean      # stops containers, removes volumes and networks
make fclean     # also removes all built images

7. Accessing the Services
WordPress Website

    URL: https://salahian.42.fr

    The domain must point to your host machine (add an entry in /etc/hosts if testing locally).

    The site uses a self‑signed SSL certificate; your browser will show a warning – you can safely accept it.

8. WordPress Admin Panel

    https://salahian.42.fr/wp-admin

    Use the admin credentials set in the .env file (see below).

9. Bonus Services (if enabled)
Service	URL	Notes
    Adminer	http://<host-ip>:8080	Login with your MariaDB credentials.
    Portainer	http://<host-ip>:9000	First visit will ask for an admin user.
    FTP	ftp://<host-ip>	Use FTP client with credentials from .env.

Replace <host-ip> with the actual IP address of the machine running Docker.

10. Managing Credentials

All sensitive data (passwords, database names, users) are stored in the srcs/.env file. Never commit this file to Git! An example file .env.example is provided.

Key variables:

    MYSQL_ROOT_PASSWORD – root password for MariaDB.

    MYSQL_DATABASE – name of the WordPress database.

    MYSQL_USER / MYSQL_PASSWORD – WordPress database user.

    WP_ADMIN_USER / WP_ADMIN_PASSWORD – WordPress administrator account.

    WP_USER / WP_USER_PASSWORD – second WordPress user (author role).

    Bonus services: FTP_USER, FTP_PASSWORD, etc.

To change a password, edit the .env file and restart the containers with make re (or rebuild the relevant service).
Checking That Services Are Running

11. List Running Containers
bash

docker ps

*View Logs
bash

make logs          # logs from all services
make logs mariadb  # logs from a specific service

12. Check Volume Data

Persistent data is stored in Docker volumes:

    mariadb_data – database files.

    wordpress_data – WordPress core, uploads, plugins, themes.

List volumes:
bash

docker volume ls

Inspect a volume:
bash

docker volume inspect <volume-name>

Verify WordPress Functionality

    Visit the site and confirm pages load.

    Log into the admin panel and try to create a post or upload a media file.

    If Redis is enabled, check cache status:
    bash

    docker exec -it wordpress wp redis status --allow-root

For more technical details, refer to the developer documentation (DEV_DOC.md).