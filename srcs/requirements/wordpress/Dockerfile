FROM debian:12

ENV	DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y

RUN apt install -y \
	php8.2 \
	php8.2-fpm \
	php8.2-mysql \
    php8.2-mysqli \
	curl \
	mariadb-client \
	php

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 9000

ENTRYPOINT [ "/entrypoint.sh" ] 
