FROM debian:12

ENV	DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && \
    apt install -y nginx && \
    rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/sites-available/default

COPY tools/ /usr/share/nginx/html/

EXPOSE 80

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]