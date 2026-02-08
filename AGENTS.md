# AGENTS.md

This file contains guidelines for agentic coding agents working in this A4AD Team backend monorepo.

## Project Overview

This is a microservices-based business process engine with git submodules:
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
go test ./...                        # All tests
go test -v ./internal/handler        # Specific package
go test -run TestSpecificFunction ./internal/service  # Specific function
go test -race ./...                  # Race condition detection

# Lint/Format (automatically run via lefthook pre-commit)
go fmt ./...
go vet ./...
goimports -w .
golangci-lint run                    # if configured

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
mvn test -Dtest=AuthServiceTest      # Specific test class

# Lint/Format
mvn spotless:apply                   # if configured
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
npm test -- src/auth/auth.service.spec.ts  # Specific test file

# Lint/Format
npm run lint
npm run format
npm run lint:fix

# Type checking
npm run type-check
npx tsc --noEmit
```

## Git Hooks & Automation

This monorepo uses Lefthook for Git automation:
- **Pre-commit**: Auto-formats code, runs linting, executes tests on staged files
- **Commit-msg**: Validates conventional commit format (feat/fix/docs/etc)
- **Pre-push**: Runs full test suite, race condition tests, validates branch names

Branch naming follows Git Flow: `feature/description`, `bugfix/description`, `hotfix/description`

## Code Style Guidelines

### Go Services
- **Imports**: Group standard library, third-party, then internal packages
- **Formatting**: Use `gofmt` and `goimports`
- **Naming**: Package names lowercase; Functions `CamelCase`/`camelCase`; Variables `camelCase`; Constants `UPPER_SNAKE_CASE`
- **Error Handling**: Always handle errors, use fmt.Errorf for wrapping, avoid panic
- **Structure**: Follow Standard Go Project Layout
- **Interfaces**: Keep small, accept interfaces return structs
- **Testing**: Table-driven tests, use testify for assertions

### Java Service
- **Imports**: Group static imports, then javax, then org, then com
- **Formatting**: Use Google Java Style or Spotless
- **Naming**: Classes `PascalCase`; Methods/variables `camelCase`; Constants `UPPER_SNAKE_CASE`; Packages `lowercase.with.dots`
- **Spring Boot**: Use constructor injection, @Service/@Repository/@Controller annotations
- **Testing**: Use @SpringBootTest for integration, @WebMvcTest for web layer
- **JPA**: Use repositories, proper entity mapping with @Entity annotations

### TypeScript Services
- **Imports**: Use `import type` for types only, organize: node_modules, then @/, then relative
- **Formatting**: Prettier with ESLint configuration
- **Naming**: Classes/interfaces `PascalCase`; Functions/variables `camelCase`; Constants `UPPER_SNAKE_CASE`; Files `kebab-case.ts`
- **NestJS**: Use dependency injection, proper module structure
- **TypeScript**: Strict mode enabled, prefer explicit types, avoid `any`
- **Testing**: Use Jest, mock external dependencies, test both happy path and error cases

## Database Guidelines

### Databases by Service
- **PostgreSQL** (auth, request): UUID primary keys, timestamps, JSONB metadata, proper indexes
- **Neo4j** (workflow): Cypher queries, explicit relationships, APOC procedures, indexed properties
- **MongoDB** (comments): Mongoose schemas, compound indexes, aggregation pipelines
- **ClickHouse** (audit): Time partitioning, appropriate data types, materialized views

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