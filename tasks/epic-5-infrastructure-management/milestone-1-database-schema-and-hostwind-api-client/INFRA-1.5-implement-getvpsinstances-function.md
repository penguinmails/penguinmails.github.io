---
title: "INFRA-1.5: Implement getVpsInstances() Function in API Client"
description: "Documentation for INFRA-1.5: Implement getVpsInstances() Function in API Client - INFRA 1.5 Implement Getvpsinstances Function"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# INFRA-1.5: Implement getVpsInstances() Function in API Client

**Ticket ID:** INFRA-1.5  
**Milestone:** Milestone 1 - Database Schema and Hostwind API Client  
**Priority:** Medium  
**Status:** Not Started

## Description

Within the Hostwind client (`/lib/hostwind.ts`), implement `getVpsInstances()` that makes a GET request to the Hostwind endpoint returning all VPSes in the account. It should authenticate via `HOSTWIND_API_KEY` and return a typed array of VPS objects.

## Acceptance Criteria

1. [ ] `getVpsInstances()` is defined and exported.
2. [ ] When called, it authenticates and fetches data from Hostwind.
3. [ ] It returns a structured array of VPS instance objects with appropriate TypeScript types.

## Notes

- Add unit tests or small integration test helpers if there is a test infra for API clients.
- Consider rate limits and add basic retry/backoff if needed.

## Related documentation

- [Technical Architecture — Overview](../../docs/technical/architecture/overview)
- [Development Standards (HTTP clients, retries)](../../docs/implementation-technical/development-guidelines/development-standards)
