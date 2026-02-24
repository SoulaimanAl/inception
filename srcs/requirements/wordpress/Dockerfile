FROM debian:12

RUN apt update && apt upgrade -y

RUN apt install -y\
	php\
	curl
COPY entrypoint.sh ./usr/local/bin/entrypoint.sh

RUN chmod +x ./usr/local/bin/entrypoint.sh

EXPOSE 9000

CMD ["./usr/local/bin/entrypoint.sh"] 
