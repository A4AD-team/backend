# AGENTS.md - A4AD Forum Backend

Guidelines for AI coding agents working in this microservices repository.

## Repository Overview

Multi-service backend with Git submodules:
- **api-gateway** (Go 1.23+, Fiber) - JWT validation, rate limiting, routing
- **auth-service** (Java 21, Spring Boot 3.3+) - Authentication, JWT, roles
- **profile-service** (Go 1.23+) - User profiles, avatars, stats
- **post-service** (Go 1.23+) - Posts CRUD, counters
- **comment-service** (NestJS 10+, TypeScript, MongoDB) - Threaded comments
- **notification-service** (NestJS 10+, TypeScript, Redis) - Real-time notifications

## Build/Test/Lint Commands

### Go Services (api-gateway, profile-service, post-service)

```bash
# Build
go build -o bin/<service> ./cmd/<service>

# Test - single test
go test -run TestFunctionName ./path/to/package
go test -v -run TestFunctionName ./...

# Test with race detection
go test -race ./...

# Lint/Format
go fmt ./...
go vet ./...
goimports -w .
```

### Java Service (auth-service)

```bash
# Build
mvn clean package

# Test - single test class/method
mvn test -Dtest=ClassNameTest
mvn test -Dtest=ClassNameTest#methodName

# Lint/Format
mvn spotless:check
mvn spotless:apply

# Run
mvn spring-boot:run -Dspring.profiles.active=local
```

### NestJS Services (comment-service, notification-service)

```bash
# Install
pnpm install

# Build
pnpm run build

# Test - single test
pnpm test -- --testNamePattern="TestName"

# Lint/Format
pnpm run lint
pnpm run lint -- --fix
pnpm run format:write
pnpm run type-check

# Run
pnpm run start:dev
```

## Code Style Guidelines

### Go

- **Formatting**: `go fmt`, `goimports` for import organization
- **Imports**: Group: standard library, third-party, internal packages
- **Naming**: `CamelCase` exported, `camelCase` unexported; avoid abbreviations
- **Interfaces**: Small, suffix with `-er` (e.g., `Reader`, `Writer`)
- **Error Handling**: Explicit returns, wrap with `fmt.Errorf`, never panic for flow control
- **Tests**: `TestFunctionName`, `TestType_Method` patterns, use table-driven tests

### Java

- **Formatting**: Spotless with Google Java Format
- **Package**: `com.company.auth.*`
- **Naming**: `PascalCase` classes, `camelCase` methods/variables, `SCREAMING_SNAKE_CASE` constants
- **Immutability**: Use `final` for fields and parameters
- **Injection**: Constructor injection with `@RequiredArgsConstructor`
- **Exceptions**: Custom exceptions extend `RuntimeException`, use `@ControllerAdvice` for handling

### TypeScript/NestJS

- **Formatting**: ESLint + Prettier
- **Naming**: `PascalCase` classes/interfaces/types, `camelCase` variables/functions
- **Files**: `.controller.ts`, `.service.ts`, `.module.ts`, `.dto.ts`, `.entity.ts`, `.spec.ts`
- **Imports**: Group by external/internal, alphabetical within groups
- **Types**: Prefer `interface` over `type` for object shapes
- **Decorators**: Use `@Controller`, `@Injectable`, etc.

### General

- No `console.log` in production (use proper logging)
- No secrets in code (use environment variables)
- Write tests for new features
- Validate input with appropriate annotations/libraries

## Git Workflow

### Branch Naming
- `feature/<description>`, `bugfix/<description>`, `hotfix/<description>`
- `release/<version>`, `test/<description>`, `docs/<description>`

### Commit Messages (Conventional Commits)
```
<type>[optional scope]: <description>
```
Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`

Example: `feat(auth): add JWT token validation`

### Pre-commit Hooks
```bash
lefthook install
```
Pre-commit runs formatters, linters, tests on staged files.

## Architecture Notes

- API Gateway: `/auth/*` (no JWT), `/api/v1/*` (JWT required)
- Services communicate via Kafka events
- PostgreSQL: auth, profile, post services | MongoDB: comments | Redis: rate limiting, notifications

## Quick Reference

```bash
# Start infrastructure
docker compose up -d postgres mongodb redis kafka

# Initialize submodules
git submodule update --init --recursive
```
