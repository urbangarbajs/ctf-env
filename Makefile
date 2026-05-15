.PHONY: up down rebuild clean

up:
	docker compose up -d --build

down:
	docker compose down -v

rebuild:
	docker compose down -v
	docker compose up -d --build

clean: down
	docker system prune -f
