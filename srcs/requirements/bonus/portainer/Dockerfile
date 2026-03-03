FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y wget ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    mkdir -p /opt/portainer

RUN wget https://github.com/portainer/portainer/releases/download/2.21.5/portainer-2.21.5-linux-amd64.tar.gz

RUN tar -xzf portainer-2.21.5-linux-amd64.tar.gz -C /opt/portainer/ --strip-components=1

RUN chmod +x /opt/portainer/portainer

EXPOSE 8100

ENTRYPOINT [ "/opt/portainer/portainer", "--bind", "0.0.0.0:8100", "--data", "/data" ]