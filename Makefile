.PHONY: help up down

help:
	@echo Usage:
	@echo   make up    - Pull and start all services
	@echo   make down  - Stop and remove all services and volumes
	@echo   make help  - Show this help message

up:
	podman compose -f docker/docker-compose.shared-infrastructure.yaml --env-file env/shared-infrastructure.env up -d --wait
	
	podman compose -f docker/docker-compose.authentication-service.yaml --env-file env/authentication-service.env pull
	podman compose -f docker/docker-compose.authentication-service.yaml --env-file env/authentication-service.env up -d

down:
	podman compose -f docker/docker-compose.authentication-service.yaml --env-file env/authentication-service.env down -v
	podman compose -f docker/docker-compose.shared-infrastructure.yaml --env-file env/shared-infrastructure.env down -v