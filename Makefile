INFRA_COMPOSE := docker/docker-compose.shared-infrastructure.yaml
INFRA_ENV := env/shared-infrastructure.env

SERVICES := authentication-service core-service gateway-service

.PHONY: help up down prune

help:
	@echo "Usage:"
	@echo "  make up    - Pull and start all services"
	@echo "  make down  - Stop and remove all services"
	@echo "  make prune - Full clean (services, volumes, images)"

up:
	@echo "--- Starting Infrastructure ---"
	podman compose -f $(INFRA_COMPOSE) --env-file $(INFRA_ENV) up -d
	
	@echo "--- Waiting for Infrastructure to be ready ---"
	sleep 5 

	@for svc in $(SERVICES); do \
		echo "--- Starting $$svc ---"; \
		podman compose -f docker/docker-compose.$$svc.yaml --env-file env/$$svc.env pull; \
		podman compose -f docker/docker-compose.$$svc.yaml --env-file env/$$svc.env up -d; \
	done

down:
	@for svc in $(SERVICES); do \
		podman compose -f docker/docker-compose.$$svc.yaml --env-file env/$$svc.env down -v; \
	done
	podman compose -f $(INFRA_COMPOSE) --env-file $(INFRA_ENV) down -v

prune:
	@for svc in $(SERVICES); do \
		podman compose -f docker/docker-compose.$$svc.yaml --env-file env/$$svc.env down -v --rmi all; \
	done
	podman compose -f $(INFRA_COMPOSE) --env-file $(INFRA_ENV) down -v --rmi all
	podman system prune -f