---
title: "MAIL-3.2: Create the Public Tracking API Route (/api/track/[...slug])"
description: "Documentation for MAIL-3.2: Create the Public Tracking API Route (/api/track/[...slug]) - MAIL 3.2 Create The Public Tracking Api Route"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# MAIL-3.2: Create the Public Tracking API Route (/api/track/[...slug])

**Ticket ID:** MAIL-3.2  
**Milestone:** Milestone 3 - Engagement Tracking  
**Priority:** High  
**Status:** Not Started

## Description

Create a public, high-performance API route handler at `/app/api/track/[...slug]/route.ts` that captures all tracking requests. Prefer edge execution (Vercel Edge Functions) or otherwise keep the handler extremely lightweight.

## Acceptance Criteria

1. [ ] An API route at `/app/api/track/[...slug]/route.ts` is created.
2. [ ] It can handle both `/api/track/open` and `/api/track/click` requests.

## Notes

- Keep the handler minimal: validate token and enqueue job, avoid heavy DB work in the request path.
- Return proper caching and CORS headers as needed.

## Related documentation

- [Technical Architecture — Overview](../../docs/technical/architecture/overview)
- [Compliance & Security Framework](../../docs/compliance-security/enterprise/security-framework)
- [Development Standards (API & edge handlers)](../../docs/implementation-technical/development-guidelines/development-standards)
