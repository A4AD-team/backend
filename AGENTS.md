# AGENTS.md - A4AD Forum Backend

Guidelines for AI coding agents working in this microservices repository.

## Repository Overview

Multi-service backend:
- **api-gateway** (Go 1.23+, Gin) - JWT validation, rate limiting, routing
- **auth-service** (Java 21, Spring Boot 3.3+) - Authentication, JWT, roles
- **profile-service** (Go 1.23+) - User profiles, avatars, stats
- **post-service** (Go 1.23+) - Posts CRUD, counters
- **comment-service** (NestJS 11+, TypeScript, MongoDB) - Threaded comments
- **notification-service** (NestJS 11+, TypeScript, Redis) - Real-time notifications

Infrastructure: PostgreSQL (auth/profile/post), MongoDB (comments), Redis, RabbitMQ

## Build/Test/Lint Commands

### Go Services (api-gateway, profile-service, post-service)

```bash
# Build
go build -o bin/<service> ./cmd/<service>

# Test single test
go test -run TestFunctionName ./path/to/package
go test -v -run TestFunctionName ./...

# Test with race detection
go test -race ./...

# Lint/Format
go fmt ./... && goimports -w .
go vet ./...
```

### Java Service (auth-service)

```bash
# Build
mvn clean package

# Test single test class/method
mvn test -Dtest=ClassNameTest
mvn test -Dtest=ClassNameTest#methodName

# Run
mvn spring-boot:run -Dspring.profiles.active=local
```

### NestJS Services (comment-service, notification-service)

```bash
# Install dependencies
pnpm install

# Build
pnpm build

# Test single test
pnpm test -- --testNamePattern="TestName"
pnpm test -- src/comments.service.spec.ts

# Lint/Format
pnpm lint && pnpm format

# Run
pnpm start:dev
```

## Code Style Guidelines

### Go

- **Imports**: Group: stdlib, third-party, internal packages (use `goimports`)
- **Naming**: `PascalCase` exported, `camelCase` unexported; avoid abbreviations
- **Interfaces**: Small, suffix with `-er` (e.g., `Reader`, `Publisher`)
- **Error Handling**: Explicit returns, wrap with `fmt.Errorf`, never `panic` for flow control
- **Gin Context**: Use `gin.Context` as primary parameter; `c.JSON(code, data)` or `c.Status(code).JSON(data)`

### Java (Spring Boot)

- **Package**: `com.authservice.iam.{layer}` (e.g., `controller`, `service`, `repository`)
- **Naming**: `PascalCase` classes, `camelCase` methods/variables, `SCREAMING_SNAKE_CASE` constants
- **Records**: Use Java records for DTOs (e.g., `SignInRequest(String email, String password)`)
- **Immutability**: Use `final` for fields and parameters
- **Injection**: Constructor injection (explicit, not `@RequiredArgsConstructor`)
- **Exceptions**: Use `ResponseStatusException` for HTTP errors; `@ControllerAdvice` for global handling
- **Validation**: Use `jakarta.validation` annotations (`@Valid`, `@NotBlank`, etc.)

### TypeScript/NestJS

- **Files**: `kebab-case.ts` (e.g., `comments.service.ts`)
- **Naming**: `PascalCase` classes/interfaces/types, `camelCase` variables/functions
- **Interfaces**: Prefer `interface` over `type` for object shapes; no `I` prefix
- **DTOs**: Use class-validator decorators; suffix with `Dto`
- **Decorators**: Use `@Controller`, `@Injectable`, etc.
- **Imports**: Group: external (`@nestjs/*`), internal (`src/*`), relative

### General

- No `console.log` (use proper logging with correlation IDs)
- No secrets in code (use environment variables)
- Write tests for new features
- Validate all input

## Git Workflow

### Branch Naming
- `feature/<description>`, `bugfix/<description>`, `hotfix/<description>`
- `release/<version>`, `test/<description>`, `docs/<description>`

### Commit Messages (Conventional Commits)
```
<type>[optional scope]: <description>
```
Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`

### Pre-commit Hooks
```bash
lefthook install
```
Each service has lint, format, and test checks on staged files.

## Quick Reference

```bash
# Start infrastructure
docker compose up -d postgres mongodb redis rabbitmq

# Initialize submodules
git submodule update --init --recursive
```

## Kubernetes Deployment

```bash
# Deploy to k8s using kustomize
kubectl apply -k k8s/base

# Deploy with dev overlay
kubectl apply -k k8s/overlays/dev

# Deploy with prod overlay
kubectl apply -k k8s/overlays/prod
```

## Service-Specific Docs

Each service has detailed guidelines in its own `AGENTS.md`:
- `auth-service/AGENTS.md` - Java conventions, Spring patterns, Flyway migrations
- `comment-service/AGENTS.md` - NestJS patterns, MongoDB schemas, RabbitMQ
- `notification-service/AGENTS.md` - NestJS patterns, Redis/BullMQ queues
- `api-gateway/AGENTS.md` - Go/Gin patterns, middleware, observability
