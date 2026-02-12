![A4AD Forum](https://img.shields.io/badge/A4AD-Forum-blue?style=for-the-badge&logo=discourse&logoColor=white)
![Go](https://img.shields.io/badge/Go-1.23+-00ADD8?style=for-the-badge&logo=go&logoColor=white)
![Java](https://img.shields.io/badge/Java-21-blue?style=for-the-badge&logo=openjdk&logoColor=white)
![NestJS](https://img.shields.io/badge/NestJS-10+-E0234E?style=for-the-badge&logo=nestjs&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Early%20Development-yellow?style=for-the-badge)

# A4AD Forum Backend

Microservices backend for a modern, lightweight forum — perfect for communities, hobby groups, internal discussions, or open projects.

Built with simplicity, performance, and future scalability in mind.

## 🏗️ Architecture Overview

### Services

| Service                  | Language / Framework      | Database               | Responsibility                                      |
|--------------------------|---------------------------|------------------------|-----------------------------------------------------|
| **api-gateway**          | Go + Fiber                | —                      | Single entry point, JWT validation, rate limiting, CORS |
| **auth-service**         | Java + Spring Boot        | PostgreSQL             | Registration, login, JWT, roles (user/mod/admin)    |
| **profile-service**      | Go                        | PostgreSQL             | User profiles, avatars, bio, stats (posts, comments, reputation) |
| **post-service**         | Go                        | PostgreSQL             | Posts CRUD, view/like/comment counters              |
| **comment-service**      | NestJS + TypeScript       | MongoDB                | Threaded comments, replies, likes                   |
| **notification-service** | NestJS + TypeScript       | Redis + PostgreSQL/MongoDB | Notifications (comments, replies, likes, mentions) |

### High-level Flow

```mermaid
graph TD
    A[Client / Browser] --> B[API Gateway]
    B --> C[Auth Service]
    B --> D[Profile Service]
    B --> E[Post Service]
    B --> F[Comment Service]
    B --> G[Notification Service]

    E --> H[PostgreSQL]
    F --> I[MongoDB]
    G --> J[Redis]

    E -.->|events| G
    F -.->|events| G
```

### 🚀 Quick Start

Requirements

Git (with submodule support)
Docker + Docker Compose
Go 1.23+
Java 21 + Maven
Node.js 18+ + npm

### Repository Structure

Submodule-based layout — each service lives in its own repository.

```bash
forum-backend/
├── .gitmodules
├── api-gateway/
├── auth-service/
├── profile-service/
├── post-service/
├── comment-service/
├── notification-service/
├── docker-compose.yml
└── README.md
```

### Setup Steps

1. Clone with submodules

```bash
git clone --recurse-submodules https://github.com/A4AD-team/forum-backend.git
cd forum-backend
```

2. Start infrastructure

```bash
docker compose up -d postgres mongodb redis
```

3. Install dependencies (run in each service folder)
   
   Go services:

   ```bash
   cd api-gateway && go mod download
   cd ../profile-service && go mod download
   cd ../post-service && go mod download
   ```

   Java:

   ```bash
   cd ../auth-service && mvn clean install
   ```

   TypeScript:

   ```bash
   cd ../comment-service && npm install
   cd ../notification-service && npm install
   ```

4. Run everything

```bash
docker compose up
```

API available at: <http://localhost:8080>
