# Task Dependency Mapping

This document provides an overview of how feature tasks reference core foundation tasks and each other, creating a clear dependency graph for implementation.

## Overview

All feature implementation tasks now include properly linked dependencies, making it easy to:

- Navigate between related tasks
- Understand implementation order
- Track prerequisite requirements
- Visualize the dependency graph

## Core Foundation Tasks

The core foundation provides the base infrastructure that all features depend on:

### CORE-1.x: Project Setup

- CORE-1.1 - Initialize Next.js 15 Project
- CORE-1.2 - Configure ESLint
- CORE-1.3 - Configure Prettier
- CORE-1.4 - Implement Pre-commit Hooks
- CORE-1.5 - Setup Environment Variables

### CORE-2.x: Database/ORM

- CORE-2.1 - Install and Configure Drizzle ORM
- CORE-2.2 - Define Initial Schemas (tenants, users, system_config)
- CORE-2.3 - Generate First Migration
- CORE-2.4 - Implement Migration Script

### CORE-3.x: Authentication (NileDB)

- CORE-3.1 - Install and Configure NileDB Server SDK
- CORE-3.2 - Implement Middleware
- CORE-3.3 - Create Signup Endpoint
- CORE-3.4 - Create Login Endpoint
- CORE-3.5 - Create Protected Endpoint

### CORE-4.x: Services Layer

- CORE-4.1 - Install Redis Client and Configure Connection
- CORE-4.2 - Create Redis Service
- CORE-4.3 - Implement Redis Health Check

### CORE-5.x: Validation

- CORE-5.1 - Install Zod and Define Core Schemas
- CORE-5.2 - Create Test Validation Endpoint

## Feature Task Prefixes

Each feature has its own task prefix for easy identification:

| Prefix | Feature | Location |
|--------|---------|----------|
| **TEN** | Teams/Tenants | `docs/features/teams/tasks/` |
| **BILL** | Payments/Billing | `docs/features/payments/tasks/` |
| **AUTH** | Authentication | `docs/features/authentication/tasks/` |
| **INFRA** | Infrastructure | `docs/features/infrastructure/tasks/` |
| **MAIL** | Email Pipeline | `docs/features/campaigns/tasks/` |
| **LEAD** | Leads Management | `docs/features/leads/tasks/` |

## Dependency Patterns

### Pattern 1: Core Dependencies
Most feature tasks depend on core foundation tasks:

```markdown
## Dependencies

- CORE-2.1 - Drizzle ORM must be configured
- CORE-2.2 - Initial schemas must be defined
```

### Pattern 2: Feature-Specific Dependencies
Tasks within a feature reference each other:

```markdown
## Dependencies

- TEN-1.1 - Companies schema must be defined
- TEN-1.2 - Companies table must exist in database
```

### Pattern 3: Cross-Feature Dependencies
Some tasks depend on tasks from other features:

```markdown
## Dependencies

- CORE-3.2 - Middleware must be implemented
- BILL-2.1 - Stripe SDK must be configured
```

## Common Dependency Chains

### Database Schema Implementation
1. CORE-2.1 (Drizzle ORM) → CORE-2.2 (Initial schemas) → Feature schema definition → Migration generation → Migration application

### API Endpoint Implementation
1. CORE-1.1 (Next.js) → CORE-3.1 (NileDB) → CORE-3.2 (Middleware) → CORE-5.1 (Zod) → Feature endpoint

### Infrastructure Setup
1. CORE-1.5 (Environment variables) → CORE-2.1 (Drizzle) → INFRA-1.1 (Infrastructure schemas) → INFRA-1.2 (Migrations)

## Implementation Order

### Phase 1: Foundation (Epic 1)
Complete all CORE-1.x and CORE-2.x tasks first. These provide the base infrastructure.

### Phase 2: Authentication (Epic 2)
Complete all CORE-3.x tasks. Authentication is required for most feature endpoints.

### Phase 3: Services & Validation (Epic 1 continued)
Complete CORE-4.x and CORE-5.x tasks for caching and validation support.

### Phase 4: Feature Implementation
With the foundation in place, implement feature-specific tasks in any order, respecting their internal dependencies.

## Verification

To verify all dependencies are properly linked:

```bash
# Check for unlinked CORE dependencies
grep -r "^\- \*\*CORE-" docs/features/*/tasks/*.md

# Check for unlinked feature dependencies
grep -r "^\- \*\*[A-Z]\+-" docs/features/*/tasks/*.md

# Both should return no results if all dependencies are linked
```

## Maintenance

When adding new tasks:

1. **Use the standard format**:
   ```markdown
   ## Dependencies
   
   - [TASK-ID](relative/path/to/task.md) - Description of what this provides
   ```

2. **Use absolute paths**:
   - Same feature: `/docs/features/{feature}/tasks/TASK-ID-filename`
   - Core tasks: `/docs/features/core/tasks/TASK-ID-filename`
   - Auth tasks: `/docs/features/authentication/tasks/TASK-ID-filename`
   - Other features: `/docs/features/{feature-name}/tasks/TASK-ID-filename`

3. **Keep descriptions clear**: Explain what the dependency provides, not just what it is.

## Recent Updates

- **2024-12-08**: Added Dependencies sections to all infrastructure tasks (INFRA-1.1 through INFRA-3.3)
- **2024-12-08**: Converted all CORE task references to markdown links across 41 files
- **2024-12-08**: Converted all feature-specific task references to markdown links across 22 files
- **2024-12-08**: Created this dependency mapping documentation

## Related Documentation

- [Core Foundation README](/docs/features/core/README) - Overview of core components
- Teams Tasks README - Teams feature implementation
- Payments Tasks README - Payments feature implementation
- Infrastructure Tasks README - Infrastructure feature implementation
