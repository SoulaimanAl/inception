FROM debian:12

ENV	DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y php php-mysql wget && \
    mkdir -p /var/www/html/ && \
    wget -O index.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php

EXPOSE 8080

ENTRYPOINT [ "php", "-S", "0.0.0.0:8080" ]