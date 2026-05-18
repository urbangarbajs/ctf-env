.PHONY: up down rebuild logs clean

up:
	docker compose up -d --build

down:
	docker compose down -v --remove-orphans

rebuild:
	docker compose down -v --remove-orphans
	docker compose up -d --build

logs:
	docker compose logs -f

clean: down
	docker system prune -f
