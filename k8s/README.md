# Kubernetes Deployment

This directory contains Kubernetes manifests for deploying the A4AD Forum Backend to a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.24+
- kubectl configured with cluster access
- kustomize (optional, for managing overlays)

## Directory Structure

```
k8s/
├── base/                    # Base Kubernetes manifests
│   ├── 00-namespace.yaml       # Namespace definition
│   ├── 01-configmaps.yaml       # ConfigMaps for non-sensitive config
│   ├── 02-secrets.yaml          # Secrets (IMPORTANT: change defaults!)
│   ├── 03-postgres.yaml         # PostgreSQL StatefulSet
│   ├── 04-mongodb.yaml          # MongoDB StatefulSet
│   ├── 05-redis.yaml            # Redis Deployment
│   ├── 06-rabbitmq.yaml         # RabbitMQ Deployment
│   ├── 10-api-gateway.yaml      # API Gateway Deployment
│   ├── 11-auth-service.yaml     # Auth Service Deployment
│   ├── 12-post-service.yaml     # Post Service Deployment
│   ├── 13-comment-service.yaml  # Comment Service Deployment
│   ├── 14-notification-service.yaml  # Notification Service Deployment
│   ├── 15-profile-service.yaml  # Profile Service Deployment
│   └── 20-ingress.yaml          # Ingress configuration
├── overlays/
│   ├── dev/                 # Development overlay
│   │   └── kustomization.yaml
│   └── prod/                # Production overlay
│       └── kustomization.yaml
└── kustomization.yaml      # Root kustomization
```

## Quick Start

### 1. Prepare Secrets

Before deploying, you must update the secrets:

```bash
# Edit the secrets file
vim base/02-secrets.yaml

# Or create secrets from environment
kubectl create secret generic a4ad-secrets \
  --namespace=a4ad \
  --from-literal=POSTGRES_PASSWORD=your-secure-password \
  --from-literal=RABBITMQ_USER=your-user \
  --from-literal=RABBITMQ_PASS=your-secure-pass \
  --from-literal=JWT_SECRET=your-super-secret-jwt-key \
  --from-literal=ACCESS_SECRET=your-access-secret \
  --from-literal=REFRESH_SECRET=your-refresh-secret \
  --dry-run=client -o yaml | kubectl apply -f -
```

### 2. Build and Push Docker Images

```bash
# Build images for each service
docker build -t a4ad/api-gateway:latest api-gateway/
docker build -t a4ad/auth-service:latest auth-service/
docker build -t a4ad/post-service:latest post-service/
docker build -t a4ad/comment-service:latest comment-service/
docker build -t a4ad/notification-service:latest notification-service/
docker build -t a4ad/profile-service:latest profile-service/

# Push to your registry
docker push your-registry/a4ad/api-gateway:latest
# ... repeat for all services
```

### 3. Deploy to Kubernetes

```bash
# Using kustomize (recommended)
kubectl apply -k k8s/base

# Or apply directly
kubectl apply -f k8s/base/

# Check deployment status
kubectl get pods -n a4ad
```

### 4. Use Overlays

```bash
# Deploy development configuration
kubectl apply -k k8s/overlays/dev

# Deploy production configuration
kubectl apply -k k8s/overlays/prod
```

## Configuration

### Environment Variables

All services use environment variables for configuration. The base ConfigMaps and Secrets provide defaults, but you should override them for your environment.

### Resource Limits

Default resource limits are set in each Deployment. Adjust these based on your cluster capacity and workload:

| Service | CPU Request | CPU Limit | Memory Request | Memory Limit |
|---------|-------------|-----------|----------------|--------------|
| api-gateway | 50m | 200m | 64Mi | 256Mi |
| auth-service | 100m | 500m | 256Mi | 1Gi |
| post-service | 50m | 200m | 64Mi | 256Mi |
| comment-service | 50m | 200m | 128Mi | 512Mi |
| notification-service | 50m | 200m | 128Mi | 512Mi |
| profile-service | 50m | 200m | 64Mi | 256Mi |
| postgres | 100m | 500m | 256Mi | 1Gi |
| mongodb | 100m | 500m | 256Mi | 1Gi |
| redis | 50m | 200m | 128Mi | 512Mi |
| rabbitmq | 100m | 500m | 256Mi | 1Gi |

## Scaling

Scale individual services based on load:

```bash
kubectl scale deployment api-gateway --replicas=5 -n a4ad
kubectl scale deployment auth-service --replicas=3 -n a4ad
```

## Troubleshooting

### Check Pod Logs

```bash
kubectl logs -n a4ad deployment/api-gateway
kubectl logs -n a4ad -f deployment/api-gateway --tail=100
```

### Check Pod Status

```bash
kubectl get pods -n a4ad
kubectl describe pod -n a4ad <pod-name>
```

### Port Forwarding for Local Testing

```bash
# API Gateway
kubectl port-forward -n a4ad svc/api-gateway 8080:80

# RabbitMQ Management UI
kubectl port-forward -n a4ad svc/rabbitmq 15672:15672
```

## Production Checklist

Before deploying to production:

- [ ] Change all default secrets (JWT_SECRET, passwords, etc.)
- [ ] Configure proper resource limits
- [ ] Set up TLS/SSL for Ingress
- [ ] Configure persistent volumes with appropriate storage class
- [ ] Set up monitoring and alerting
- [ ] Configure log aggregation
- [ ] Review and adjust replica counts
- [ ] Set up proper image pull secrets for private registry
