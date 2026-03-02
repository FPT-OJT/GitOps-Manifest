INFRA_COMPOSE := docker/docker-compose.shared-infrastructure.yaml
INFRA_ENV := env/shared-infrastructure.env

SERVICES := authentication-service core-service gateway-service

.PHONY: help \
	up down prune \
	up-infra down-infra prune-infra \
	up-authentication-service down-authentication-service prune-authentication-service \
	up-core-service down-core-service prune-core-service \
	up-gateway-service down-gateway-service prune-gateway-service

help:
	@echo "Usage:"
	@echo "  --- All services ---"
	@echo "  make up                          - Pull and start infrastructure + all services"
	@echo "  make down                        - Stop and remove all services + infrastructure"
	@echo "  make prune                       - Full clean (services, volumes, images)"
	@echo ""
	@echo "  --- Infrastructure ---"
	@echo "  make up-infra                    - Start shared infrastructure only"
	@echo "  make down-infra                  - Stop shared infrastructure only"
	@echo "  make prune-infra                 - Remove shared infrastructure (volumes + images)"
	@echo ""
	@echo "  --- Individual services ---"
	@echo "  make up-authentication-service   - Pull and start authentication-service"
	@echo "  make down-authentication-service - Stop authentication-service"
	@echo "  make prune-authentication-service- Remove authentication-service (volumes + images)"
	@echo "  make up-core-service             - Pull and start core-service"
	@echo "  make down-core-service           - Stop core-service"
	@echo "  make prune-core-service          - Remove core-service (volumes + images)"
	@echo "  make up-gateway-service          - Pull and start gateway-service"
	@echo "  make down-gateway-service        - Stop gateway-service"
	@echo "  make prune-gateway-service       - Remove gateway-service (volumes + images)"

# ─── All ──────────────────────────────────────────────────────────────────────

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

# ─── Infrastructure ───────────────────────────────────────────────────────────

up-infra:
	@echo "--- Starting Infrastructure ---"
	podman compose -f $(INFRA_COMPOSE) --env-file $(INFRA_ENV) up -d

down-infra:
	podman compose -f $(INFRA_COMPOSE) --env-file $(INFRA_ENV) down -v

prune-infra:
	podman compose -f $(INFRA_COMPOSE) --env-file $(INFRA_ENV) down -v --rmi all

# ─── authentication-service ───────────────────────────────────────────────────

up-authentication-service:
	@echo "--- Starting authentication-service ---"
	podman compose -f docker/docker-compose.authentication-service.yaml --env-file env/authentication-service.env pull
	podman compose -f docker/docker-compose.authentication-service.yaml --env-file env/authentication-service.env up -d

down-authentication-service:
	podman compose -f docker/docker-compose.authentication-service.yaml --env-file env/authentication-service.env down -v

prune-authentication-service:
	podman compose -f docker/docker-compose.authentication-service.yaml --env-file env/authentication-service.env down -v --rmi all

# ─── core-service ─────────────────────────────────────────────────────────────

up-core-service:
	@echo "--- Starting core-service ---"
	podman compose -f docker/docker-compose.core-service.yaml --env-file env/core-service.env pull
	podman compose -f docker/docker-compose.core-service.yaml --env-file env/core-service.env up -d

down-core-service:
	podman compose -f docker/docker-compose.core-service.yaml --env-file env/core-service.env down -v

prune-core-service:
	podman compose -f docker/docker-compose.core-service.yaml --env-file env/core-service.env down -v --rmi all

# ─── gateway-service ──────────────────────────────────────────────────────────

up-gateway-service:
	@echo "--- Starting gateway-service ---"
	podman compose -f docker/docker-compose.gateway-service.yaml --env-file env/gateway-service.env pull
	podman compose -f docker/docker-compose.gateway-service.yaml --env-file env/gateway-service.env up -d

down-gateway-service:
	podman compose -f docker/docker-compose.gateway-service.yaml --env-file env/gateway-service.env down -v

prune-gateway-service:
	podman compose -f docker/docker-compose.gateway-service.yaml --env-file env/gateway-service.env down -v --rmi all