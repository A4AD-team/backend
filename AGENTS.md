# AGENTS.md - A4AD Forum Backend

Guidelines for AI coding agents working on this microservices repository.

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
make build                    # or: go build ./...

# Test
make test                     # or: go test ./...
go test -v ./...              # verbose
go test -race ./...           # race detection
go test -run TestFunc ./...   # single test

# Lint/Format
make lint                     # or: go vet ./...
go fmt ./...                  # format
goimports -w .                # organize imports

# Run
go run ./cmd/<service>
make run
```

### Java Service (auth-service)

```bash
# Build
mvn clean install
mvn clean package

# Test
mvn test                                    # all tests
mvn test -Dtest=ClassNameTest               # single test class
mvn test -Dtest=ClassNameTest#testMethod    # single method
mvn clean test jacoco:report                # with coverage
SKIP_TESTS=1 mvn test                       # skip tests

# Lint/Format
mvn spotless:check                          # check formatting
mvn spotless:apply                          # auto-fix formatting
mvn checkstyle:check                        # checkstyle validation

# Run
mvn spring-boot:run -Dspring.profiles.active=local
```

### NestJS Services (comment-service, notification-service)

```bash
# Install
pnpm install                  # preferred
npm install

# Build
pnpm run build
npm run build

# Test
pnpm test                     # all tests
pnpm test -- --testNamePattern="TestName"     # single test
pnpm test -- --bail --passWithNoTests        # staged files
pnpm run test:integration     # integration tests

# Lint/Format
pnpm run lint                 # ESLint
pnpm run lint -- --fix        # auto-fix
pnpm run format:check         # Prettier check
pnpm run format:write         # auto-format
pnpm run type-check           # TypeScript check

# Run
pnpm run start:dev            # development
pnpm run start:prod           # production
```

## Git Workflow

### Branch Naming

Allowed patterns:
- `feature/<description>` - New features
- `bugfix/<description>` - Bug fixes  
- `hotfix/<description>` - Production hotfixes
- `release/<version>` - Release prep (e.g., v1.2.0)
- `test/<description>` - Test branches (NestJS only)
- `docs/<description>` - Documentation (NestJS only)
- `chore/<description>` - Maintenance (NestJS only)
- `refactor/<description>` - Refactoring (NestJS only)
- `perf/<description>` - Performance (NestJS only)

Protected branches (no direct push): `main`, `master`, `develop`, `release/*`, `hotfix/*`

### Commit Messages

Conventional Commits format:
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`, `build`, `revert`

Rules:
- First line max 72 characters
- Description max 50 characters
- No period at end
- Use imperative mood ("add", not "added")

Examples:
- `feat(auth): add JWT token validation`
- `fix: resolve memory leak in rate limiter`
- `docs(api): update authentication endpoints`

### Git Hooks (Lefthook)

```bash
lefthook install              # install hooks
cp lefthook-local.yml.example lefthook-local.yml   # stricter local rules
```

Pre-commit runs: formatters, linters, tests on staged files
Pre-push runs: branch validation, full test suite

Bypass (not recommended): `git commit --no-verify` or `git push --no-verify`

## Code Style Guidelines

### Go

- Standard Go formatting (`go fmt`)
- Use `goimports` for import organization
- Follow [Effective Go](https://go.dev/doc/effective_go)
- Error handling: explicit error returns, wrap with context
- Naming: `CamelCase` exported, `camelCase` unexported
- Interfaces suffixed with `-er` (e.g., `Reader`, `Writer`)
- Tests: `TestFunctionName`, `TestType_Method` patterns

### Java

- Spotless formatter (Google Java Format)
- Spring Boot conventions
- Package: `com.company.auth.*`
- Naming: `PascalCase` classes, `camelCase` methods/variables, `SCREAMING_SNAKE_CASE` constants
- Use `final` for immutable fields and parameters
- Prefer constructor injection with `@RequiredArgsConstructor`

### TypeScript/NestJS

- ESLint + Prettier configuration
- Naming:
  - `PascalCase`: classes, interfaces, types, enums, decorators
  - `camelCase`: variables, functions, methods, properties
  - `SCREAMING_SNAKE_CASE`: constants
  - Files: `.controller.ts`, `.service.ts`, `.module.ts`, `.dto.ts`, `.entity.ts`, `.spec.ts`
- Imports: group by external/internal, alphabetical within groups
- Use strict TypeScript mode
- Prefer `interface` over `type` for object shapes
- Use decorators for metadata (`@Controller`, `@Injectable`, etc.)

### General

- No `console.log` in production code (use proper logging)
- No secrets in code (use environment variables)
- All commits must pass pre-commit hooks
- Write tests for new features
- Update documentation for API changes

## Quick Reference

```bash
# Start infrastructure
docker compose up -d postgres mongodb redis kafka

# Initialize all submodules
git submodule update --init --recursive

# Common shortcuts
make dev                      # run service in dev mode
make test-coverage            # generate coverage report
make lint-fix                 # auto-fix linting issues
```

## Architecture Notes

- API Gateway routes: `/auth/*` (no JWT), `/api/v1/*` (JWT required)
- Services communicate via Kafka events
- PostgreSQL: auth, profile, post services
- MongoDB: comment service
- Redis: gateway rate limiting, notifications cache
