[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/wbsJG7Gp)
# DevOps Classroom - Docker & CI/CD Learning Resource

A complete full-stack application designed to teach Docker and CI/CD concepts through hands-on practice.

## Learning Objectives

By completing this course, you will:
- Understand containerization concepts and benefits
- Write production-ready Dockerfiles
- Orchestrate multi-service applications with Docker Compose
- Build CI/CD pipelines with GitHub Actions
- Deploy containerized applications to VMs
- Follow DevOps best practices

## Course Structure

| Module | Topic | Difficulty |
|--------|-------|------------|
| 01 | Dockerize the Backend | Beginner |
| 02 | Dockerize the Frontend | Beginner |
| 03 | Docker Compose | Intermediate |
| 04 | Multi-stage Builds | Intermediate |
| 05 | Basic CI with GitHub Actions | Intermediate |
| 06 | Complete CI/CD Pipeline | Advanced |
| 07 | VM Deployment | Advanced |

## Quick Start

### Prerequisites
- Docker Desktop 24+ installed
- Node.js 20+ (for local development)
- Git
- Code editor (VS Code recommended)

### Setup with Docker Compose
```bash
git clone <repo-url>
cd classroom-mvp
docker-compose up
```

### Access the Application
- Frontend: http://localhost
- Backend API: http://localhost:3000
- Health Check: http://localhost:3000/health

### Local Development (without Docker)

**Backend**:
```bash
cd backend
npm install
cp .env.example .env
npm run dev
```

**Frontend**:
```bash
cd frontend
npm install
cp .env.example .env
npm run dev
```

## Project Structure

```
classroom-mvp/
├── backend/          # Node.js REST API
├── frontend/         # React UI
├── docs/             # Learning materials
├── assignments/      # Student exercises
├── .github/          # CI/CD workflows
└── docker-compose.yml
```

## Running Tests

```bash
# Backend tests
cd backend && npm test

# Frontend tests
cd frontend && npm test

# All tests in Docker
docker-compose run backend npm test
docker-compose run frontend npm test
```

## Assignments

Each module includes:
- Clear learning objectives
- Starter code with TODOs
- Auto-grading tests
- Solution reference

Start with [Module 1](assignments/module-01-dockerize-backend/README.md)

## Documentation

- [Getting Started](docs/00-getting-started.md)
- [Docker Basics](docs/01-docker-basics.md)
- [Dockerfile Guide](docs/02-dockerfile-guide.md)
- [Docker Compose](docs/03-docker-compose.md)
- [CI/CD Introduction](docs/04-cicd-introduction.md)
- [Troubleshooting](docs/05-troubleshooting.md)
- [Best Practices](docs/06-best-practices.md)

## Getting Help

- Check [Troubleshooting Guide](docs/05-troubleshooting.md)
- Review [Common Mistakes](docs/01-docker-basics.md#common-mistakes)
- Ask instructor or classmates

## License

MIT License - Free for educational use
