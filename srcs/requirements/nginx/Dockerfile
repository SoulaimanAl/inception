FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# Generate SSL certificate
RUN mkdir -p /etc/ssl/private && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=MA/ST=Casablanca/L=Casablanca/O=42/OU=42/CN=salahian.42.fr"

# Copy NGINX config to correct location
COPY conf/nginx.conf /etc/nginx/sites-available/default

# Create web root and test file
RUN mkdir -p /var/www/html && \
    echo "<h1>NGINX is working!</h1>" > /var/www/html/index.html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
