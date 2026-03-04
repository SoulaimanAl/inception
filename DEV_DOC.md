**DEV_DOC.md**

```markdown
# DEV_DOC.md

*This project has been created as part of the 42 curriculum by salahian.*

## Introduction

This document is aimed at developers who need to understand, modify, or extend the Inception project. It covers the prerequisites, the build process, useful commands, and the data persistence strategy.

## Prerequisites

- A Linux‑based host (or VM) with **Docker** (version 20.10+) and **Docker Compose** (version 1.29+ or the newer `docker compose` plugin).
- **Make** utility (optional but recommended).
- Git to clone the repository.
- Basic knowledge of Docker, shell scripting, and the involved services.

## Setting Up the Environment from Scratch

### 1. Clone the Repository
```bash
git clone https://github.com/SoulaimanAl/inception.git inception
cd inception

2. Prepare Configuration Files

All configuration is driven by environment variables. Copy the example file and edit it to suit your needs:
bash

Create the .env.example and copy the lines below, and copy it to file .env and adjust the values (passwords, domain name, etc.):

    # # Domain
    # DOMAIN_NAME=
    # # MariaDB Configuration 
    # MYSQL_ROOT_PASSWORD=
    # MYSQL_DATABASE=
    # MYSQL_USER=
    # MYSQL_PASSWORD=
    # MYSQL_HOST=
    # # WordPress Configuration   
    # WP_TITLE=
    # WP_ADMIN_USER=
    # WP_ADMIN_PASSWORD=
    # WP_ADMIN_EMAIL=
    # # WordPress Second User
    # WP_USER=
    # WP_USER_EMAIL=
    # WP_USER_PASSWORD=
    # # FTP server
    # FTP_USER=
    # FTP_PASSWORD=

cp srcs/.env.example srcs/.env

Edit srcs/.env with your preferred editor. At minimum, change the passwords and ensure the domain name matches your setup.
3. (Optional) Adjust Service Configurations

Each service has its own configuration files inside srcs/requirements/<service>/conf/. For example:

    nginx/conf/nginx.conf – Nginx server block.

    mariadb/conf/my.cnf – MariaDB configuration.

    ftp/conf/vsftpd.conf – FTP server settings (if used).

    Any bonus service configuration.

Modify these files if you need to change ports, behaviours, or security settings.
Building and Launching the Project
Using the Makefile (Recommended)

The root Makefile provides convenient targets:

    make or make up – builds and starts all containers.

    make down – stops all containers.

    make clean – stops containers, removes volumes and networks.

    make fclean – also removes all built images.

    make re – performs a full rebuild (fclean then up).

Manual Docker Compose Commands

All operations can also be done directly from the srcs directory:
bash

cd srcs
docker-compose up --build -d   # build and start
docker-compose down            # stop
docker-compose down -v         # stop and delete volumes
docker-compose logs -f         # follow logs

Building Individual Services
bash

docker-compose build mariadb   # rebuild only MariaDB
docker-compose up -d mariadb   # restart it

Managing Containers and Volumes
Useful Docker Commands
Command	Description
docker ps	List running containers.
docker ps -a	List all containers (including stopped).
docker logs <container>	Show logs of a specific container.
docker exec -it <container> bash	Open a shell inside a running container.
docker volume ls	List all Docker volumes.
docker volume inspect <name>	Show detailed information about a volume.
docker network ls	List networks.
docker network inspect inception	See which containers are attached to the project network.
Accessing Container Internals

Example – connect to MariaDB:
bash

docker exec -it mariadb mysql -u root -p
# enter password from .env

Example – run WP‑CLI commands:
bash

docker exec -it wordpress wp plugin list --allow-root

Data Persistence

All persistent data is stored in named Docker volumes. The volumes are defined in docker-compose.yml and are not deleted unless you pass the -v flag to docker-compose down or use make clean.
Volume Name	Mounted Inside Container	Purpose
mariadb_data	/var/lib/mysql	Database files
wordpress_data	/var/www/html	WordPress core, uploads, plugins, themes
portainer_data	/data	Portainer database (if used)
redis_data	/var/redis/6379	Redis dump (if used)
ftp_data	(varies)	FTP user home (if used)

Volumes are managed by host and stored on the host under /home/salahian/data/. To back up a volume:
bash

docker run --rm -v <volume-name>:/source -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz -C /source .

Adding a New Service

    Create a new folder under srcs/requirements/ with the service name (e.g., mybonus/).

    Inside, place a Dockerfile, any configuration files in a conf/ directory, and an entrypoint.sh if needed.

    Add the service definition to srcs/docker-compose.yml. Include build, container_name, networks, volumes, depends_on, and restart as appropriate.

    If the service needs environment variables, add them to the .env file and reference them in the compose file.

    Run docker-compose build mybonus and docker-compose up -d mybonus to test.

Troubleshooting Common Issues
Permission Denied on Volumes

If MariaDB fails to start with permission errors on /var/lib/mysql, the volume ownership might be wrong. The container runs as UID 999. Ensure the host directory (if using bind mounts) has the correct owner, or use named volumes which Docker handles automatically.
WordPress Cannot Connect to MariaDB

    Verify that MariaDB is healthy: docker inspect mariadb | grep Health.

    Check the database credentials in .env match those in wp-config.php (you can view them with docker exec wordpress cat /var/www/html/wp-config.php).

    Ensure both containers are on the same network (inception).

Port Already in Use

If a host port is already occupied (e.g., 443, 9000, 8080), either stop the conflicting service or change the published port in docker-compose.yml.
Container Exits Immediately

Check the logs: docker logs <container>. Common causes:

    Missing environment variables.

    Incorrect entrypoint script (e.g., missing exec).

    Database not ready (healthcheck may be failing).

For further assistance, consult the official documentation of Docker and the respective services.