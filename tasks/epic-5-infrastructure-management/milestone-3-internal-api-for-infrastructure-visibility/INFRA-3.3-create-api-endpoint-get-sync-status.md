# INFRA-3.3: Create API Endpoint to Get Sync Status (GET /api/infrastructure/status)

**Ticket ID:** INFRA-3.3  
**Milestone:** Milestone 3 - Internal API for Infrastructure Visibility  
**Priority:** Medium  
**Status:** Not Started

## Description

Create a protected GET API route at `/api/infrastructure/status/route.ts` which reads the `infra_sync_status` record from `system_config` and returns it.

## Acceptance Criteria

1. [ ] Endpoint is protected.
2. [ ] Returns `200 OK` with the JSON object containing `last_successful_sync` and current `status`.
3. [ ] Frontend can use this data to surface a notice if the sync has been failing.

## Notes

- Keep the response strictly scoped to the data necessary for the UI.
- Consider caching this value or limiting heavy queries.
