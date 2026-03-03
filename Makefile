DOCKER_COMPOSE = docker-compose -f ./srcs/docker-compose.yml
DATA_PATH = /home/salahian/data
MARIADB_PATH = $(DATA_PATH)/mariadb
WORDPRESS_PATH = $(DATA_PATH)/wordpress
PORTAINER_PATH = $(DATA_PATH)/portainer

all: up

up:
	mkdir -p $(MARIADB_PATH)
	mkdir -p $(WORDPRESS_PATH)
	mkdir -p $(PORTAINER_PATH)
	$(DOCKER_COMPOSE) up --build -d

down:
	$(DOCKER_COMPOSE) down

stop:
	$(DOCKER_COMPOSE) stop

start:
	$(DOCKER_COMPOSE) start

logs:
	$(DOCKER_COMPOSE) logs

clean:
	$(DOCKER_COMPOSE) down -v
	sudo rm -rf $(MARIADB_PATH)
	sudo rm -rf $(WORDPRESS_PATH)
	sudo rm -rf $(PORTAINER_PATH)


fclean: clean
	docker system prune -af
	docker volume prune -f
	$(DOCKER_COMPOSE) down -v --rmi all

re: fclean all

.PHONY: all up down logs clean fclean re