---
title: "INFRA-3.1: Define Drizzle Schema for domain_ip_assignments"
description: "Documentation for INFRA-3.1: Define Drizzle Schema for domain_ip_assignments - INFRA 3.1 Define Drizzle Schema For Domain Ip Assignments"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# INFRA-3.1: Define Drizzle Schema for domain_ip_assignments

**Ticket ID:** INFRA-3.1  
**Milestone:** Milestone 3 - Internal API for Infrastructure Visibility  
**Priority:** Medium  
**Status:** Not Started

## Description

Create a schema to link domains and `smtp_ip_addresses`. Add the schema file `domain_ip_assignments.ts` and generate/apply a migration.

## Acceptance Criteria

1. [ ] `domain_ip_assignments.ts` schema file is created.
2. [ ] A migration is generated and applied, creating the table.
3. [ ] For testing, a row can be manually inserted linking a domain to an IP.

## Notes

- Ensure referential integrity to both `domains` (or equivalent) and `smtp_ip_addresses`.
- Add indexes on `domain_id` and `smtp_ip_address_id` for fast lookups.

## Related documentation

- [Technical Architecture — Overview](../../docs/technical/architecture/overview)
- [Development Standards (DB design & indexing)](../../docs/implementation-technical/development-guidelines/development-standards)
