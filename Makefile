.PHONY: help up down prune

help:
	@echo Usage:
	@echo   make up    - Pull (if new image exists) and start all services
	@echo   make down  - Stop and remove all services and volumes
	@echo   make prune - Stop and remove all services, volumes, and images
	@echo   make help  - Show this help message

up:
	podman compose -f docker/docker-compose.shared-infrastructure.yaml --env-file env/shared-infrastructure.env up -d --wait

	podman compose -f docker/docker-compose.authentication-service.yaml --env-file env/authentication-service.env up -d --pull always
	podman compose -f docker/docker-compose.gateway-service.yaml --env-file env/gateway-service.env up -d --pull always
	podman compose -f docker/docker-compose.core-service.yaml --env-file env/core-service.env up -d --pull always

down:
	podman compose -f docker/docker-compose.gateway-service.yaml --env-file env/gateway-service.env down -v
	podman compose -f docker/docker-compose.authentication-service.yaml --env-file env/authentication-service.env down -v
	podman compose -f docker/docker-compose.core-service.yaml --env-file env/core-service.env down -v
	podman compose -f docker/docker-compose.shared-infrastructure.yaml --env-file env/shared-infrastructure.env down -v

prune:
	podman compose -f docker/docker-compose.gateway-service.yaml --env-file env/gateway-service.env down -v --rmi all
	podman compose -f docker/docker-compose.authentication-service.yaml --env-file env/authentication-service.env down -v --rmi all
	podman compose -f docker/docker-compose.core-service.yaml --env-file env/core-service.env down -v --rmi all
	podman compose -f docker/docker-compose.shared-infrastructure.yaml --env-file env/shared-infrastructure.env down -v --rmi all
	podman system prune -f