FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y mariadb-server

COPY conf/my.cnf /etc/mysql/my.cnf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306

CMD ["./usr/local/bin/entrypoint.sh"]
