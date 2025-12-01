.PHONY: up down rebuild clean

up:
	docker compose up -d --build

down:
	docker compose down

rebuild:
	docker compose down
	docker compose up -d --build

clean: down
	docker system prune -f
