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