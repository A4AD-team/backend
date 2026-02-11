![A4AD Backend](https://img.shields.io/badge/A4AD-Backend-blue?style=for-the-badge&logo=kubernetes)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Go](https://img.shields.io/badge/Go-00ADD8?style=for-the-badge&logo=go&logoColor=white)
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Build](https://img.shields.io/badge/Build-Passing-brightgreen?style=for-the-badge)
![Coverage](https://img.shields.io/badge/Coverage-80%25-brightgreen?style=for-the-badge)

# A4AD Backend

A production-grade microservices-based business process engine built with modern technology stacks. This repository uses **Git submodules** to organize all backend services that power the A4AD platform, handling everything from authentication to workflow orchestration. All services are designed to run in **Kubernetes** with proper orchestration and scaling.

## 🏗️ Architecture Overview

### Services

| Service | Technology | Database | Responsibility |
|---------|------------|----------|----------------|
| **api-gateway** | Go + Fiber | - | Entry point, routing, auth, rate limiting |
| **auth-service** | Java + Spring Boot | PostgreSQL | IAM, JWT tokens, roles, permissions |
| **workflow-service** | Go + Neo4j | Neo4j | Graph-based workflow engine |
| **request-service** | Go + GORM | PostgreSQL | Core request management |
| **comment-service** | TypeScript + NestJS | MongoDB | Comments and discussions |
| **notification-service** | TypeScript + NestJS | Redis | Email/push notifications |
| **audit-service** | Go + ClickHouse | ClickHouse | Append-only audit logging |
| **scheduler-service** | Go | PostgreSQL | Timeout/reminder scheduling |

### System Flow

```mermaid
graph TD
    A[Client] --> B[API Gateway]
    B --> C[Auth Service]
    B --> D[Request Service]
    B --> E[Workflow Service]
    B --> F[Comment Service]
    B --> G[Notification Service]
    
    D --> H[PostgreSQL]
    E --> I[Neo4j]
    F --> J[MongoDB]
    G --> K[Redis]
    
    L[Scheduler Service] --> G
    M[Audit Service] --> N[ClickHouse]
    
    E -.-> |Events| G
    E -.-> |Events| L
    D -.-> |Events| M
```

## 🚀 Quick Start

### Prerequisites

- **Git** with submodule support
- **Docker** & **Docker Compose**
- **Node.js** 18+ (for TypeScript services)
- **Go** 1.21+ (for Go services)
- **Java** 17+ (for auth-service)
- **Maven** 3.8+ (for auth-service)

### Repository Structure

This is a **Git submodule-based repository**, not a traditional monorepo. Each service is an independent Git repository:

```bash
backend/
├── .gitmodules          # Git submodule configuration
├── api-gateway/         # Go + Fiber (submodule)
├── auth-service/        # Java + Spring Boot (submodule)
├── workflow-service/    # Go + Neo4j (submodule)
├── request-service/     # Go + PostgreSQL (submodule)
├── comment-service/     # TypeScript + NestJS + MongoDB (submodule)
├── notification-service/ # TypeScript + NestJS + Redis (submodule)
├── audit-service/       # Go + ClickHouse (submodule)
├── scheduler-service/   # Go + PostgreSQL (submodule)
├── k8s/                # Kubernetes manifests
├── docker-compose.yml   # Local development
└── README.md
```

### Setup

1. **Clone with submodules**
   ```bash
   git clone --recurse-submodules git@github.com:A4AD-team/backend.git
   cd backend
   ```

2. **Update submodules (if needed)**
   ```bash
   git submodule update --init --recursive
   ```

3. **Navigate to service directories**
   ```bash
   cd api-gateway          # For gateway service
   cd ../auth-service      # For auth service
   cd ../workflow-service  # For workflow service
   # etc...
   ```

3. **Start infrastructure**
   ```bash
   docker compose up -d postgres mongodb redis neo4j clickhouse kafka
   ```

4. **Install dependencies** (run in each service directory)
   ```bash
   # TypeScript services
   cd notification-service && npm install
   cd ../comment-service && npm install
   
   # Java service
   cd ../auth-service && mvn clean install
   
   # Go services
   cd ../api-gateway && go mod download
   cd ../workflow-service && go mod download
   cd ../request-service && go mod download
   cd ../audit-service && go mod download
   cd ../scheduler-service && go mod download
   ```

5. **Start all services**
   ```bash
   # Local development with Docker Compose
   docker compose up -d
   
   # Or for development with hot reload
   docker compose -f docker-compose.dev.yml up
   ```

## 🛠️ Development

### Running Individual Services

#### Go Services
```bash
cd api-gateway
go run ./cmd/gateway

cd workflow-service  
go run ./cmd/workflow

cd request-service
go run ./cmd/request

cd audit-service
go run ./cmd/audit

cd scheduler-service
go run ./cmd/scheduler
```

#### Java Service
```bash
cd auth-service
mvn spring-boot:run -Dspring.profiles.active=local
```

#### TypeScript Services
```bash
cd notification-service
npm run start:dev

cd comment-service
npm run start:dev
```

### Testing

```bash
# Go services
go test ./...
go test -v ./internal/handler
go test -run TestSpecificFunction ./internal/service

# Java service
mvn test
mvn test -Dtest=AuthServiceTest

# TypeScript services  
npm test
npm run test:watch
npm test -- src/auth/auth.service.spec.ts
```

### Code Quality

```bash
# Go services
go fmt ./...
go vet ./...
goimports -w .
golangci-lint run

# Java service
mvn spotless:apply
mvn checkstyle:check

# TypeScript services
npm run lint
npm run format
npm run lint:fix
npx tsc --noEmit
```

## 📋 API Documentation

### Gateway Endpoints

- **Authentication**: `/api/v1/auth/*`
- **Requests**: `/api/v1/requests/*`  
- **Workflows**: `/api/v1/workflows/*`
- **Comments**: `/api/v1/comments/*`
- **Notifications**: `/api/v1/notifications/*`

### Health Checks

All services expose health endpoints:
- `/health` - Basic liveness check
- `/ready` - Readiness check (dependencies)
- `/metrics` - Prometheus metrics

### API Documentation

- **Swagger UI**: Available at `/docs` for each service
- **OpenAPI specs**: Available at `/docs-json`

## 🔧 Configuration

### Environment Variables

Create `.env` file in each service directory:

```bash
# Database URLs
POSTGRES_URL=postgresql://user:pass@localhost:5432/dbname
MONGODB_URL=mongodb://localhost:27017/dbname
REDIS_URL=redis://localhost:6379
NEO4J_URL=bolt://localhost:7687
CLICKHOUSE_URL=clickhouse://localhost:9000/dbname

# Kafka
KAFKA_BROKERS=localhost:9092

# JWT
JWT_SECRET=your-super-secret-key
JWT_EXPIRES_IN=24h

# Observability
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
LOG_LEVEL=info

# Kubernetes specific
KUBERNETES_NAMESPACE=a4ad-backend
KUBERNETES_SERVICE_ACCOUNT=a4ad-service-account
```

### Docker Profiles (Local Development)

```bash
# Development with hot reload
docker compose --profile dev up

# Production build
docker compose --profile prod build

# Testing
docker compose --profile test up --abort-on-container-exit
```

### Kubernetes Configuration

Configuration in Kubernetes is managed through:
- **ConfigMaps**: Application configuration
- **Secrets**: Sensitive data (passwords, tokens)
- **Environment variables**: Service-specific settings

```bash
# Create ConfigMap
kubectl create configmap app-config --from-env-file=.env -n a4ad-backend

# Create Secret
kubectl create secret generic app-secrets --from-literal=jwt-secret=your-secret -n a4ad-backend
```

## 📊 Monitoring & Observability

### Metrics
- **Prometheus**: Scrapes metrics from all services
- **Grafana**: Pre-built dashboards for system monitoring
- **Custom Metrics**: Request latency, error rates, business KPIs

### Logging
- **Structured Logging**: JSON format with correlation IDs
- **Log Levels**: DEBUG, INFO, WARN, ERROR
- **Centralization**: All logs aggregated to centralized system

### Tracing
- **OpenTelemetry**: Distributed tracing across services
- **Jaeger**: Trace visualization and analysis
- **Correlation IDs**: End-to-end request tracking

## 🔒 Security

### Authentication & Authorization
- **JWT Tokens**: Access and refresh token pattern
- **Role-Based Access Control**: Granular permissions system
- **API Keys**: Service-to-service authentication

### Security Best Practices
- **Input Validation**: All inputs validated using schemas
- **Rate Limiting**: Configurable per endpoint/user
- **CORS**: Proper cross-origin resource sharing
- **SQL Injection Prevention**: Parameterized queries
- **Secrets Management**: Environment variables only

## 🚀 Deployment

### Kubernetes (Production Environment)

All services are designed for **Kubernetes deployment** with proper orchestration, scaling, and resilience.

#### Prerequisites
- **Kubernetes cluster** (minikube, k3s, or cloud provider)
- **kubectl** configured
- **Helm 3+** (for advanced deployments)

#### Deploy to Kubernetes

```bash
# Create namespace
kubectl create namespace a4ad-backend

# Deploy all services
kubectl apply -f k8s/

# Deploy infrastructure components
kubectl apply -f k8s/infrastructure/

# Deploy services
kubectl apply -f k8s/services/

# Deploy ingress and networking
kubectl apply -f k8s/networking/
```

#### Individual Service Deployment

```bash
# Deploy specific service
kubectl apply -f k8s/services/api-gateway.yaml
kubectl apply -f k8s/services/auth-service.yaml

# Watch deployment
kubectl rollout status deployment/api-gateway -n a4ad-backend
kubectl get pods -n a4ad-backend
```

#### Kubernetes Features

- **Horizontal Pod Autoscaler**: Automatic scaling based on CPU/memory
- **Pod Disruption Budgets**: High availability during updates
- **Resource Limits**: CPU and memory constraints
- **Health Probes**: Liveness and readiness checks
- **ConfigMaps & Secrets**: Configuration management
- **Persistent Volumes**: Database storage
- **Service Mesh**: Istio/Linkerd integration ready
- **Network Policies**: Pod-to-pod communication control

#### Helm Deployment (Advanced)

```bash
# Deploy with Helm charts
helm repo add a4ad https://charts.a4ad.com
helm install a4ad-backend a4ad/backend -n a4ad-backend

# Upgrade deployment
helm upgrade a4ad-backend a4ad/backend -n a4ad-backend

# Custom values
helm install a4ad-backend a4ad/backend -n a4ad-backend -f values.prod.yaml
```

### Local Development

```bash
# Docker Compose for local development
docker compose up -d

# Development with hot reload
docker compose -f docker-compose.dev.yml up
```

### CI/CD Pipeline for Kubernetes

- **GitHub Actions**: Automated building, testing, and deployment
- **ArgoCD**: GitOps continuous delivery
- **Environments**: dev, staging, production namespaces
- **Rolling Updates**: Zero-downtime deployments with Kubernetes
- **Health Checks**: Automatic rollback on pod failures
- **Canary Deployments**: Gradual traffic shifting for new releases

## 🧪 Testing Strategy

### Test Types
- **Unit Tests**: 80%+ coverage target
- **Integration Tests**: Database operations, API contracts
- **E2E Tests**: Critical user journeys
- **Load Tests**: Performance under load
- **Security Tests**: Vulnerability scanning

### Test Data
- **Fixtures**: Predefined test datasets
- **Factories**: Dynamic test data generation
- **Isolation**: Test databases isolated from production

## 🤝 Contributing

### Development Workflow

1. **Create feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Navigate to service submodule**
   ```bash
   cd auth-service  # or any other service
   ```

3. **Make changes**
   ```bash
   # Write code, add tests
   npm test  # or go test ./... or mvn test
   npm run lint  # or go fmt ./... or mvn spotless:apply
   ```

4. **Commit changes in submodule**
   ```bash
   git add .
   git commit -m "feat: add new authentication endpoint"
   git push origin feature/your-feature-name
   ```

5. **Update submodule reference in main repo**
   ```bash
   cd ..  # Back to main backend repo
   git add auth-service
   git commit -m "chore: update auth-service submodule"
   git push origin feature/your-feature-name
   ```

6. **Create PR**
   ```bash
   # Create pull request for main backend repository
   ```

### Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):
```
<type>[optional scope]: <description>

Examples:
feat(auth): add JWT token validation
fix: resolve memory leak in rate limiter
docs(api): update authentication endpoints
```

## 📚 Documentation

- **API Documentation**: `/docs` endpoint on each service
- **Service Architecture**: See individual service READMEs
- **Database Schemas**: Available in service documentation
- **Deployment Guides**: Check `docs/deployment/`

## 🆘 Troubleshooting

### Common Issues

**Submodule not found:**
```bash
git submodule update --init --recursive
```

**Port conflicts:**
```bash
# Check port usage
lsof -i :8080
# Update ports in docker-compose.yml
```

**Database connection issues:**
```bash
# Check if databases are running
docker compose ps
# Check logs
docker compose logs postgres
```

### Getting Help

- **Issues**: [GitHub Issues](https://github.com/A4AD-team/backend/issues)
- **Discussions**: [GitHub Discussions](https://github.com/A4AD-team/backend/discussions)
- **Team Chat**: Slack channel #backend-devs
- **Kubernetes Issues**: Check pod logs with `kubectl logs -f deployment/service-name -n a4ad-backend`

## 📄 License

This project is licensed under the MIT license - see the [LICENSE](LICENSE) file for details.

## 🌟 Acknowledgments

- **Fiber**: High-performance Go web framework
- **NestJS**: Progressive Node.js framework
- **Spring Boot**: Java application framework
- **Neo4j**: Graph database technology
- **PostgreSQL**: Reliable relational database
- **MongoDB**: Flexible document database
- **Redis**: High-performance caching
- **ClickHouse**: Fast analytical database
- **Kafka**: Distributed streaming platform

---

**Built with ❤️ by A4AD Team**  
**Designed for ☸️ Kubernetes**
