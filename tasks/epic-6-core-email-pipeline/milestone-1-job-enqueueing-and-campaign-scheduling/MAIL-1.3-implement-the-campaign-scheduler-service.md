
# MAIL-1.3: Implement the Campaign Scheduler Service

**Ticket ID:** MAIL-1.3  
**Milestone:** Milestone 1 - Job Enqueueing and Campaign Scheduling  
**Priority:** High  
**Status:** Not Started

## Description

In `/lib/services/scheduler.service.ts`, create a function `enqueueDueCampaigns()` that queries the database for active campaigns and their sequence steps, calculates which leads are due for a send based on scheduling rules and step delays, and returns a list of job payloads ready to be enqueued.

## Acceptance Criteria

1. [ ] The function correctly queries the database to find campaigns that are active and past their `scheduled_at` time.
2. [ ] It correctly calculates delays for subsequent steps (e.g., `wait_duration_hours`).
3. [ ] It returns an array of structured job payload objects, ready to be enqueued.

## Notes

- Consider batching and pagination for large data sets.
- Add unit tests for scheduling logic (edge cases: DST, timezones, lead exclusions).

## Related documentation

- [Technical Architecture — Overview](../../docs/technical/architecture/overview)
- [Development Standards (background jobs & services)](../../docs/implementation-technical/development-guidelines/development-standards)
- [Operations: Infrastructure Operations Management (queues & workers)](../../docs/operations-analytics/operations-management/infrastructure-operations-management)
