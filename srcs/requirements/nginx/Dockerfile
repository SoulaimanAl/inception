FROM debian:12

ENV	DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && \
    apt install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/ssl/private && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=MA/ST=Casablanca/L=Casablanca/O=42/OU=42/CN=salahian.42.fr"

COPY conf/nginx.conf /etc/nginx/sites-available/default

RUN mkdir -p /var/www/html

EXPOSE 443

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
