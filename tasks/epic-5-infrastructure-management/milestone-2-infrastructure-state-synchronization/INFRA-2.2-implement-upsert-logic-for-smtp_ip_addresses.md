
# INFRA-2.2: Implement "Upsert" Logic for smtp_ip_addresses

**Ticket ID:** INFRA-2.2  
**Milestone:** Milestone 2 - Infrastructure State Synchronization  
**Priority:** Medium  
**Status:** Not Started

## Description

Create `syncSmtpIps(ipArray)` in `/lib/services/infra.service.ts` that accepts IP objects (optionally fetched per VPS) and performs upserts into `smtp_ip_addresses`. Ensure `vps_instance_id` foreign key is correctly linked.

## Acceptance Criteria

1. [ ] Inserts new IP address records when they don't exist.
2. [ ] Updates existing IP address records when they do.
3. [ ] Ensures `vps_instance_id` is correctly linked and indexed.

## Notes

- You may need an additional Hostwind API call to fetch IPs per VPS.
- Ensure IP uniqueness constraints (e.g., unique on provider IP ID or address + vps id).

## Related documentation

- [Technical Architecture — Overview](../../docs/technical/architecture/overview)
- [Development Standards (DB operations & indexing)](../../docs/implementation-technical/development-guidelines/development-standards)
