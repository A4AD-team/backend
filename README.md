# A4AD Forum Backend

> Modern, lightweight, and scalable forum platform built with microservices architecture

[![Go](https://img.shields.io/badge/Go-1.23+-00ADD8?style=flat-square&logo=go&logoColor=white)](https://go.dev/)
[![Java](https://img.shields.io/badge/Java-21-007396?style=flat-square&logo=openjdk&logoColor=white)](https://openjdk.org/)
[![NestJS](https://img.shields.io/badge/NestJS-10+-E0234E?style=flat-square&logo=nestjs&logoColor=white)](https://nestjs.com/)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Early%20Development-orange?style=flat-square)]()

---

## 📚 Documentation / Документация

Choose your preferred language / Выберите предпочитаемый язык:

- **[🇬🇧 English Documentation](README_EN.md)** — Complete documentation in English
- **[🇷🇺 Русская документация](README_RU.md)** — Полная документация на русском языке

---

## 🏗️ Architecture Overview

```mermaid
flowchart TB
    Client(["Client"]) --> Gateway["API Gateway<br/>Go + Fiber"]
    Gateway --> Auth["Auth Service<br/>Java + Spring Boot"]
    Gateway --> Profile["Profile Service<br/>Go"]
    Gateway --> Post["Post Service<br/>Go"]
    Gateway --> Comment["Comment Service<br/>NestJS + MongoDB"]
    Gateway --> Notification["Notification Service<br/>NestJS + Redis"]
```

---

## 🚀 Quick Start

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/A4AD-team/forum-backend.git
cd forum-backend

# Start infrastructure
docker compose up -d

# API will be available at http://localhost:8080
```

---

## 📁 Services

| Service | Tech | Port | Description |
|---------|------|------|-------------|
| [api-gateway](api-gateway/) | Go + Fiber | 8080 | API Gateway |
| [auth-service](auth-service/) | Java + Spring Boot | 8081 | Authentication |
| [profile-service](profile-service/) | Go | 8082 | User Profiles |
| [post-service](post-service/) | Go | 8083 | Posts Management |
| [comment-service](comment-service/) | NestJS + MongoDB | 8084 | Comments |
| [notification-service](notification-service/) | NestJS + Redis | 8085 | Notifications |

---

## 📄 License

MIT License — see [LICENSE](LICENSE) file for details.

---

<p align="center">
  <strong>Built with ❤️ by A4AD Team</strong>
</p>
