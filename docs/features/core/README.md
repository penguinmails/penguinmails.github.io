---
title: "Core Foundation"
description: "Shared foundation components: project setup, database, Redis, validation"
---

# Core Foundation

Shared technical foundation that supports all other features.

## Components

| Component | Description |
|-----------|-------------|
| **Project Setup** | Next.js, ESLint, Prettier, environment |
| **Database/ORM** | Drizzle schemas, migrations |
| **Services Layer** | Redis caching, singleton services |
| **Validation** | Zod schemas, input validation |

## Tasks

Implementation tasks for core components:

- [Project Initialization](/docs/features/core/tasks/CORE-1.1-initialize-nextjs-project)
- [ESLint Configuration](/docs/features/core/tasks/CORE-1.2-configure-eslint)
- [Prettier Configuration](/docs/features/core/tasks/CORE-1.3-configure-prettier)
- [Pre-commit Hooks](/docs/features/core/tasks/CORE-1.4-implement-pre-commit-hooks)
- [Environment Variables](/docs/features/core/tasks/CORE-1.5-setup-environment-variables)
- [Drizzle Installation](/docs/features/core/tasks/CORE-2.1-install-configure-drizzle)
- [Initial Schemas](/docs/features/core/tasks/CORE-2.2-define-initial-schemas)
- [First Migration](/docs/features/core/tasks/CORE-2.3-generate-first-migration)
- [Migration Script](/docs/features/core/tasks/CORE-2.4-implement-migration-script)
- [Redis Installation](/docs/features/core/tasks/CORE-4.1-install-configure-redis)
- [Redis Service](/docs/features/core/tasks/CORE-4.2-create-redis-service)
- [Redis Health Check](/docs/features/core/tasks/CORE-4.3-implement-redis-health-check)
- [Zod Schemas](/docs/features/core/tasks/CORE-5.1-install-zod-define-schemas)
- [Validation Endpoint](/docs/features/core/tasks/CORE-5.2-create-test-validation-endpoint)

## Related Documentation

- **Routes**: [core-app-structure](/docs/design/routes/core-app-structure)
- **API**: [API Reference](/docs/implementation-technical/api/README)
