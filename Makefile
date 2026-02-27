DOCKER_COMPOSE = docker-compose -f ./srcs/docker-compose.yml
DATA_PATH = /home/salahian/data
MARIADB_PATH = $(DATA_PATH)/mariadb
WORDPRESS_PATH = $(DATA_PATH)/wordpress

all: up

up:
	mkdir -p $(MARIADB_PATH)
	mkdir -p $(WORDPRESS_PATH)
	$(DOCKER_COMPOSE) up --build -d

down:
	$(DOCKER_COMPOSE) down

logs:
	$(DOCKER_COMPOSE) logs

clean:
	$(DOCKER_COMPOSE) down -v
	docker system prune -af
	docker volume prune -f
	sudo rm -rf $(MARIADB_PATH)
	sudo rm -rf $(WORDPRESS_PATH)

fclean: clean
	$(DOCKER_COMPOSE) down -v --rmi all

re: fclean all

.PHONY: all up down logs clean fclean re