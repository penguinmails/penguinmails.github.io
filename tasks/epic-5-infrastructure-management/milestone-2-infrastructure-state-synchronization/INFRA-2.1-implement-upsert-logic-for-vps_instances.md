# INFRA-2.1: Implement "Upsert" Logic for vps_instances

**Ticket ID:** INFRA-2.1  
**Milestone:** Milestone 2 - Infrastructure State Synchronization  
**Priority:** Medium  
**Status:** Not Started

## Description

Create `/lib/services/infra.service.ts` (or appropriate services directory) with `syncVpsInstances(vpsArray)` that accepts an array of VPS objects from the Hostwind client and performs upserts into `vps_instances` using Drizzle's `onConflict` or equivalent.

## Acceptance Criteria

1. [ ] Inserts a new VPS record if `hostwinds_instance_id` does not exist.
2. [ ] Updates an existing VPS record if the ID already exists.
3. [ ] Uses Drizzle's onConflict or efficient upsert strategy.

## Notes

- Consider batching for large accounts.
- Handle partial failures and log any problematic records for inspection.

## Related documentation

- [Technical Architecture — Overview](../../docs/technical/architecture/overview.md)
- [Development Standards (DB operations & upserts)](../../docs/implementation-technical/development-guidelines/development-standards.md)
- [Operations: Infrastructure Operations Management](../../docs/operations-analytics/operations-management/infrastructure-operations-management.md)
