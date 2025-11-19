---
title: "MAIL-2.1: Set Up Standalone Worker Project"
description: "Documentation for MAIL-2.1: Set Up Standalone Worker Project - MAIL 2.1 Set Up Standalone Worker Project"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# MAIL-2.1: Set Up Standalone Worker Project

**Ticket ID:** MAIL-2.1  
**Milestone:** Milestone 2 - The Email Sending Worker  
**Priority:** High  
**Status:** Not Started

## Description

Create a new Node.js/TypeScript project in a `/worker` sub-directory of the repository. The worker should have its own `tsconfig.json` and entry point (`index.ts`) and be able to connect to PostgreSQL (Drizzle) and Redis.

## Acceptance Criteria

1. [ ] A `/worker` directory exists with a separate entry point.
2. [ ] The worker can be started with a script like `npm run worker:start`.
3. [ ] The worker successfully connects to both the database and Redis upon startup.

## Notes

- Share dependencies via the main `package.json` where appropriate.
- Keep the worker lightweight; fewer web dependencies and more job-processing libraries.

## Related documentation

- [Operations: Infrastructure Operations Management (running workers)](../../docs/operations-analytics/operations-management/infrastructure-operations-management)
- [Technical Architecture — Overview](../../docs/technical/architecture/overview)
- [Development Standards (project layout & scripts)](../../docs/implementation-technical/development-guidelines/development-standards)
