.PHONY: help build up down logs clean test lint fmt

# Default target
help:
	@echo "A4AD Backend Development Commands"
	@echo ""
	@echo "Docker Compose:"
	@echo "  make up          - Start all services with Docker Compose"
	@echo "  make down        - Stop all services"
	@echo "  make logs        - View logs (all services)"
	@echo "  make clean       - Remove all containers and volumes"
	@echo ""
	@echo "Development:"
	@echo "  make test        - Run all tests"
	@echo "  make lint        - Run linters"
	@echo "  make fmt         - Format code"
	@echo ""
	@echo "Kubernetes:"
	@echo "  make k8s-apply   - Apply k8s manifests"
	@echo "  make k8s-logs    - View k8s logs"
	@echo "  make k8s-status  - Check k8s deployment status"

# Docker Compose commands
up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

clean:
	docker compose down -v
	docker system prune -f

# Build all Docker images
build:
	docker build -t a4ad/api-gateway:latest ./api-gateway/
	docker build -t a4ad/auth-service:latest ./auth-service/
	docker build -t a4ad/post-service:latest ./post-service/
	docker build -t a4ad/comment-service:latest ./comment-service/
	docker build -t a4ad/notification-service:latest ./notification-service/

# Test commands
test:
	@echo "Running Go tests..."
	cd api-gateway && go test ./... || true
	cd post-service && go test ./... || true
	cd profile-service && go test ./... || true
	@echo "Running NestJS tests..."
	cd comment-service && pnpm test || true
	cd notification-service && pnpm test || true

# Lint commands
lint:
	@echo "Linting Go services..."
	cd api-gateway && go fmt ./... && go vet ./... || true
	cd post-service && go fmt ./... && go vet ./... || true
	cd profile-service && go fmt ./... && go vet ./... || true
	@echo "Linting NestJS services..."
	cd comment-service && pnpm lint || true
	cd notification-service && pnpm lint || true

# Format commands
fmt:
	@echo "Formatting Go services..."
	cd api-gateway && gofmt -w . || true
	cd post-service && gofmt -w . || true
	cd profile-service && gofmt -w . || true
	@echo "Formatting NestJS services..."
	cd comment-service && pnpm format || true
	cd notification-service && pnpm format || true

# Kubernetes commands
k8s-apply:
	kubectl apply -k k8s/base

k8s-logs:
	kubectl logs -n a4ad -l app.kubernetes.io/part-of=a4ad -f

k8s-status:
	kubectl get pods,svc -n a4ad

k8s-delete:
	kubectl delete -k k8s/base
