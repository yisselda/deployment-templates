# Deployment Templates

Docker Compose and Kubernetes configurations for deploying the Creole Translation Platform.

## Quick Start

### Docker Compose (Development)

```bash
docker-compose -f docker-compose.dev.yml up
```

### Docker Compose (Production)

```bash
docker-compose -f docker-compose.prod.yml up -d
```

### Kubernetes

```bash
kubectl apply -f kubernetes/
```

## Configurations

- `docker-compose.dev.yml` - Development environment with hot reload
- `docker-compose.prod.yml` - Production-ready configuration
- `kubernetes/` - Kubernetes manifests for cloud deployment

## License
MIT
