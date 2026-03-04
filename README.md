# Inception

*This project has been created as part of the 42 curriculum by salahian.*

## Description

**Inception** is a system administration project that introduces you to the world of containerization using Docker. The goal is to set up a small infrastructure composed of several services, each running in its own Docker container. The project emphasizes the use of Docker Compose to orchestrate multiple containers, manage persistent data, and establish secure communication between them.

The final setup includes:
- A **MariaDB** database container.
- A **WordPress** container with PHP-FPM.
- An **Nginx** container serving HTTPS.
- Optional bonus services such as Redis cache, FTP server, static website, Adminer, and monitoring tools (Portainer).

All services are isolated in their own containers but communicate through a dedicated Docker network. Data persistence is ensured via Docker volumes. The entire environment is reproducible with a single `docker-compose up` command.

## Instructions

### Prerequisites
- A Linux-based host (or VM) with Docker and Docker Compose installed.
- Make utility (optional, for using the provided Makefile).
- Git to clone the repository.

### Installation and Execution

1. **Clone the repository**  
   ```bash
   git clone https://github.com/SoulaimanAl/inception.git inception
   cd inception

    Configure environment variables
    Create the .env.example and copy the lines below, and copy it to file .env and adjust the values (passwords, domain name, etc.):

    "# Domain
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
    FTP_PASSWORD="

    bash

    cp srcs/.env.example srcs/.env

    Build and start the containers
    Use the Makefile at the root:
    bash

    make

    Or manually with Docker Compose:
    bash

    docker-compose -f srcs/docker-compose.yml up --build -d

    Access the services

        WordPress site: https://salahian.42.fr (ensure the domain resolves to your host IP).

        Adminer (if enabled): http://<host-ip>:8080.

        Portainer (if enabled): http://<host-ip>:9000.


    Stop and clean up
    bash

    make down        # stops containers
    make clean       # stops and removes containers, volumes, and networks
    make fclean      # also removes images

Project Structure

    srcs/ – Contains all service definitions and configuration files.

        docker-compose.yml – Orchestrates the multi‑container application.

        .env – Environment variables used by the containers.

        requirements/ – Each service has its own folder with Dockerfile and configuration files.

    Makefile – Simplifies common Docker Compose commands.

Resources
Documentation & Tutorials

    Docker Documentation

    Docker Compose Documentation

    MariaDB Official Docs

    WordPress Developer Resources

    Nginx Beginner’s Guide

    Redis Documentation

    vsftpd – Secure FTP server

    Adminer – Database management in a single PHP file

    Portainer – Container management UI

    Netdata – Real‑time performance monitoring

AI Assistance

During this project, AI tools (deepseek) were used for the following tasks:

    Debugging and explaining error messages encountered during the setup (e.g., permission issues, container networking problems).

    Clarifying concepts such as Unix sockets vs TCP, namespaces, and Docker internals.

    Assisting in writing parts of the README and documentation.

Docker and the Sources

This project leverages Docker to package each service into a lightweight, isolated container. The sources are organized per service under srcs/requirements/. Each service has:

    A Dockerfile defining its build process.

    A conf/ directory with configuration files (e.g., nginx.conf, my.cnf, vsftpd.conf).

    An entrypoint.sh script inside tools/ for runtime initialisation (e.g., setting up databases, downloading WordPress, configuring users).

Main Design Choices

    Separation of concerns: Each service runs in its own container, improving modularity and scalability.

    Docker Compose: Used to define and run the multi‑container application, handling dependencies, networks, and volumes.

    Healthchecks: Implemented to ensure containers are fully ready before dependent services start.

    Environment variables: Used for configuration (database credentials, domain names) to keep the setup flexible and secure (secrets are not hard‑coded).

    Volume mounts: Persistent data (database files, WordPress uploads) is stored in named volumes, surviving container restarts and removals.

Comparison of Key Concepts:

    Virtual Machines vs Docker:

    Aspect	        Virtual Machines	                Docker Containers

    Architecture	Includes a full guest OS            Shares the host OS kernel
                    (kernel, system libraries)          only packages the application and its dependencies.

    Isolation	    Hardware‑level virtualization       Process‑level isolation
                            (hypervisor)	            (namespaces, cgroups).

    Startup time	Minutes                             Seconds.

    Image size	    Gigabytes                           Megabytes to a few hundred megabytes.

    Resource usage	Heavy (dedicated RAM,               Lightweight, shares
                        CPU for each VM)	            resources with host.
    
    Use case	    Running multiple OSes,              Microservices, development, CI/CD,
                    full isolation requirements	        scalable applications.

Secrets vs Environment Variables

Both methods are used to pass sensitive configuration to containers, but they differ in security and complexity.

    Environment Variables are the simplest way: you define variables in a .env file or pass them directly with -e in docker run. They are widely supported and easy to use. However, they are less secure because the values can be exposed in docker inspect output, container logs, or through the command line. In a development or isolated environment, this is acceptable.

    Secrets are a Docker Swarm feature (or can be managed with external tools like HashiCorp Vault). They are encrypted both at rest and in transit, and access can be controlled with granular permissions. This is the recommended approach for production systems, but it adds complexity and requires a swarm cluster.

For this project, environment variables are sufficient because the environment is isolated and not exposed to the public. In a production deployment, secrets would be recommended.

Docker Network vs Host Network

Docker offers different networking modes to connect containers.

    Bridge Network (default) creates an internal virtual network where each container gets its own IP address. Containers can communicate with each other using their service names (thanks to Docker's embedded DNS). This mode provides good isolation and is ideal for multi‑container applications that need to discover each other by name – exactly our setup.

    Host Network removes network isolation and makes the container share the host’s network stack directly. The container then binds to the host's IP addresses and ports without any NAT. This can improve performance and is useful when port conflicts are not an issue, but it sacrifices isolation.

Our project uses a custom bridge network named inception to isolate containers while allowing them to communicate via service names (e.g., mariadb, wordpress).

Docker Volumes vs Bind Mounts

Both are ways to persist data outside the container's ephemeral filesystem.

    Named Volumes are stored in a dedicated directory on the host (/home/username/data/) and are referenced by name. They are easy to back up, restore, and are platform‑independent. The main disadvantage is that is fully managed by the host.

    Bind Mounts map an existing host directory directly into the container. This gives you direct access to the files from the host, which is great for development (you can edit files on the fly). However, they are path‑dependent, can cause permission issues, and are less portable across different host environments.

In this project, we use named volumes for database files and WordPress data to ensure persistence, portability, and avoid permission problems.


For any questions or issues, refer to the official documentation or contact the author.