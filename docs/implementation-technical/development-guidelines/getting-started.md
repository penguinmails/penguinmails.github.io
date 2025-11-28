---
title: "Getting Started - Developer Environment & Setup"
description: "Environment setup, first-time contributor guidance, and project structure overview"
last_modified_date: "2025-11-24"
level: "1"
persona: "New Contributors"
---


# Getting Started - Developer Environment & Setup

## Welcome to PenguinMails

Thank you for your interest in contributing to PenguinMails! We're excited to have you join our community of developers working to revolutionize email marketing through AI-powered analytics and personalization.

**What You Can Contribute:**

- Bug fixes and improvements

- New features and enhancements

- Documentation improvements

- Test coverage additions

- UI/UX improvements

- Internationalization (i18n)

- Analytics and reporting features

- AI/ML integration improvements

## First-Time Contributor Setup

### 1. Fork and Clone the Repository

```bash


# Fork the repository on GitHub, then clone your fork

git clone https://github.com/your-username/penguinmails.git
cd penguinmails


# Add the upstream repository as remote

git remote add upstream https://github.com/penguinmails/platform.git


# Install dependencies

npm install


```

### 2. Environment Configuration

```bash


# Copy environment template

cp .env.example .env


# Edit .env with your configuration

DATABASE_URL=postgresql://dev:dev@localhost:5432/penguinmails_dev
REDIS_URL=redis://localhost:6379
SECRET_KEY=your-development-secret-key
EMAIL_API_KEY=your-email-service-api-key
AI_API_ENDPOINT=http://localhost:8000/api/v1
ANALYTICS_ENDPOINT=http://localhost:8080/analytics


```

### 3. Database Setup

```bash


# Set up database connection


# Update DATABASE_URL in .env file


# Example: postgresql://dev:dev@localhost:5432/penguinmails_dev


# Run database migrations

npm run db:migrate


# Load sample data (optional)

npm run db:seed


```

### 4. Verify Installation

```bash


# Run development server

npm run dev


# In another terminal, run tests

npm test


# Run linting

npm run lint
npm run type-check


```

## Development Environment Tools

### Recommended IDE Setup

**VS Code Configuration:**

```json
{
  "python.defaultInterpreterPath": "./venv/bin/python",
  "python.linting.enabled": true,
  "python.linting.flake8Enabled": true,
  "python.linting.pylintEnabled": false,
  "python.formatting.provider": "black",
  "python.sortImports.args": ["--profile", "black"],
  "typescript.preferences.importModuleSpecifier": "relative",
  "editor.formatOnSave": true,
  "files.exclude": {
    "**/__pycache__": true,
    "**/*.pyc": true,
    "**/node_modules": true,
    "**/.pytest_cache": true
  }
}


```

**Required Extensions:**

- TypeScript

- JavaScript

- ESLint

- Prettier

- GitLens

- Docker

- REST Client

- SQLite Viewer

### Development Tools Installation

```bash


# Install pre-commit hooks

npm run install:hooks


# Install additional development tools

npm install -g @typescript-eslint/cli prettier


```

## Understanding the Project Structure

```

penguinmails/
├── app/                          # Main application code
│   ├── api/                      # REST API endpoints
│   ├── core/                     # Core business logic
│   ├── ai/                       # AI/ML features
│   ├── analytics/                # Analytics and reporting
│   ├── email/                    # Email processing
│   ├── web/                      # Web interface
│   └── mobile/                   # Mobile applications
├── docs/                         # Documentation
│   ├── api/                      # API documentation
│   ├── user/                     # User documentation
│   └── development/              # Developer documentation
├── tests/                        # Test suites
│   ├── unit/                     # Unit tests
│   ├── integration/              # Integration tests
│   └── e2e/                      # End-to-end tests
├── scripts/                      # Development scripts
├── migrations/                   # Database migrations
├── package.json                  # Node.js dependencies and scripts
├── tsconfig.json                # TypeScript configuration
├── tailwind.config.js           # CSS framework configuration
└── docker/                       # Docker configuration


```

## Next Steps

After setting up your environment:

1. **Review the contribution process** in [`code-contribution.md`](code-contribution)

2. **Understand our testing requirements** in [`testing-requirements.md`](testing-requirements)

3. **Learn our coding standards** in [`code-standards.md`](code-standards)

4. **Find an issue to work on** by checking our [GitHub Issues](https://github.com/penguinmails/platform/issues)

5. **Join our community** by introducing yourself in our [GitHub Discussions](https://github.com/penguinmails/platform/discussions)

## Getting Help

- **Documentation**: Check our [comprehensive documentation](https://docs.penguinmails.com)

- **Community**: Join our [Discord server](https://discord.gg/penguinmails)

- **Issues**: Use [GitHub Issues](https://github.com/penguinmails/platform/issues) for bugs and feature requests

- **Discussions**: Use [GitHub Discussions](https://github.com/penguinmails/platform/discussions) for questions

Welcome to the PenguinMails community!
