# GitOps

Local deployment for the OJT backend stack using Podman.

## Services

- **RabbitMQ** – shared message broker (`shared-infrastructure`)
- **Authentication Service** – auth API with Postgres and Redis (`authentication-service`)

## Prerequisites

- [Podman](https://podman.io/) with `podman compose` available
- [docker-compose](https://docs.docker.com/compose/) (used as the external compose provider)
- Access to `ghcr.io` (authenticate before pulling images)

## Setup

1. Copy the example env files and fill in the values:

   ```sh
   cp env/shared-infrastructure.env.example env/shared-infrastructure.env
   cp env/authentication-service.env.example env/authentication-service.env
   ```

2. Authenticate with the container registry:

   ```sh
   podman login ghcr.io -u <your-username>
   ```

## Usage

```sh
make up    # Start all services
make down  # Stop all services and remove volumes
make help  # Show available commands
```