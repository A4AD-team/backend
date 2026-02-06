# AGENTS.md

This file contains guidelines for agentic coding agents working in this A4AD Team backend monorepo.

## Project Overview

This is a microservices-based business process engine with the following services:
- **api-gateway** (Go + Fiber) - Entry point, routing, auth, rate limiting
- **auth-service** (Java + Spring Boot) - IAM, JWT, roles, permissions  
- **workflow-service** (Go + Neo4j) - Graph-based workflow engine
- **request-service** (Go + PostgreSQL) - Core request management
- **comment-service** (TypeScript + NestJS + MongoDB) - Comments and discussions
- **notification-service** (TypeScript + NestJS) - Email/push notifications
- **audit-service** (Go + ClickHouse) - Append-only audit logging
- **scheduler-service** (Go) - Timeout/reminder scheduling

## Build/Test Commands

### Go Services (api-gateway, workflow-service, request-service, audit-service, scheduler-service)
```bash
# Build
go build -o bin/service ./cmd/server

# Run locally
go run ./cmd/server

# Test
go test ./...
go test -v ./internal/handler   # Run specific package tests
go test -run TestSpecificFunction ./internal/service

# Lint
go fmt ./...
go vet ./...
golangci-lint run  # if configured

# Dependencies
go mod tidy
go mod download
```

### Java Service (auth-service)
```bash
# Build
mvn clean compile
mvn clean package

# Run locally
mvn spring-boot:run -Dspring.profiles.active=local

# Test
mvn test
mvn test -Dtest=AuthServiceTest   # Run specific test class

# Lint/Format
mvn spotless:apply   # if configured
mvn checkstyle:check

# Dependencies
mvn clean install
```

### TypeScript Services (comment-service, notification-service)
```bash
# Install dependencies
npm install

# Build
npm run build

# Run locally
npm run start:dev

# Test
npm test
npm run test:watch
npm run test:e2e
npm test -- src/auth/auth.service.spec.ts  # Run specific test file

# Lint/Format
npm run lint
npm run format
npm run lint:fix

# Type checking
npm run type-check
npx tsc --noEmit
```

## Code Style Guidelines

### Go Services
- **Imports**: Group standard library, third-party, then internal packages
- **Formatting**: Use `gofmt` and `goimports`
- **Naming**: 
  - Package names: lowercase, single words when possible
  - Functions: `CamelCase` for exported, `camelCase` for unexported
  - Variables: `camelCase`, abbreviate sparingly
  - Constants: `UPPER_SNAKE_CASE` or `camelCase` for typed constants
- **Error Handling**: Always handle errors, use fmt.Errorf for wrapping, avoid panic
- **Structure**: Follow Standard Go Project Layout
- **Interfaces**: Keep small, accept interfaces return structs
- **Testing**: Table-driven tests, use testify for assertions

### Java Service
- **Imports**: Group static imports, then javax, then org, then com
- **Formatting**: Use Google Java Style or Spotless
- **Naming**:
  - Classes: `PascalCase`
  - Methods/variables: `camelCase`
  - Constants: `UPPER_SNAKE_CASE`
  - Packages: `lowercase.with.dots`
- **Spring Boot**: Use constructor injection, @Service/@Repository/@Controller annotations
- **Testing**: Use @SpringBootTest for integration, @WebMvcTest for web layer
- **JPA**: Use repositories, proper entity mapping with @Entity annotations

### TypeScript Services
- **Imports**: Use `import type` for types only, organize: node_modules, then @/, then relative
- **Formatting**: Prettier with ESLint configuration
- **Naming**:
  - Classes/interfaces: `PascalCase`
  - Functions/variables: `camelCase`
  - Constants: `UPPER_SNAKE_CASE`
  - Files: `kebab-case.ts`
- **NestJS**: Use dependency injection, proper module structure
- **TypeScript**: Strict mode enabled, prefer explicit types, avoid `any`
- **Testing**: Use Jest, mock external dependencies, test both happy path and error cases

## Database Guidelines

### PostgreSQL (auth-service, request-service)
- Use UUID for primary keys
- Add `created_at`, `updated_at` timestamps
- Use JSONB for flexible metadata
- Add proper indexes for query performance
- Use migrations (Liquibase/Flyway for Java, manual SQL files for Go)

### Neo4j (workflow-service)
- Use Cypher queries, avoid N+1 problems
- Model relationships explicitly
- Use APOC procedures for complex operations
- Index frequently queried properties

### MongoDB (comment-service)
- Use Mongoose schemas with validation
- Add compound indexes for common query patterns
- Use aggregation pipelines for complex queries

### ClickHouse (audit-service)
- Use appropriate data types (DateTime, UInt64, etc.)
- Partition by time for efficient queries
- Use materialized views for pre-aggregations

## Observability Standards

- **Logging**: Structured JSON logging with correlation IDs
- **Tracing**: OpenTelemetry with proper span naming
- **Metrics**: Prometheus client libraries, use standard metric names
- **Health**: Implement `/health` and `/ready` endpoints

## Security Guidelines

- Validate all inputs, never trust user data
- Use parameterized queries to prevent SQL injection
- Implement rate limiting at API gateway level
- Never log sensitive data (passwords, tokens, PII)
- Use environment variables for configuration, never hardcode secrets

## Docker Standards

- Multi-stage builds for Go services
- Use specific image tags, avoid `latest`
- Include HEALTHCHECK instructions
- Set proper USER directive for security
- Use .dockerignore files

## Testing Strategy

- Unit tests: 80%+ coverage target
- Integration tests: Test database operations
- Contract tests: Test service boundaries
- E2E tests: Critical user journeys
- Load tests: Performance testing for key endpoints

## Git Workflow

- Feature branches: `feature/service-name-description`
- Commit messages: Conventional Commits format
- PR reviews: Required for all changes
- Semantic versioning: Apply tags for releases

## Environment Management

- Use environment-specific configuration
- Local development: Docker Compose
- CI/CD: GitHub Actions or similar
- Secrets: Use vault or secret manager in production