FROM debian:12

ENV	DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y redis-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/redis/6379 /var/log/redis

# Configure Redis for Docker networking - THESE LINES ARE CRITICAL
RUN sed -i \
    -e 's/^bind 127.0.0.1 -::1/bind 0.0.0.0/' \
    -e 's/^protected-mode yes/protected-mode no/' \
    -e 's/^daemonize yes/daemonize no/' \
    -e 's|^dir ./|dir /var/redis/6379|' \
    -e 's/^# logfile ""/logfile \/var\/log\/redis.log/' \
    /etc/redis/redis.conf

EXPOSE 6379

CMD [ "redis-server", "/etc/redis/redis.conf" ]