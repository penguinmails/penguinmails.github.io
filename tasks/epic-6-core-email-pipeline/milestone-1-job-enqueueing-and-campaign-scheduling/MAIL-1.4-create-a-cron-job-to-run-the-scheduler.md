
# MAIL-1.4: Create a Cron Job to Run the Scheduler

**Ticket ID:** MAIL-1.4  
**Milestone:** Milestone 1 - Job Enqueueing and Campaign Scheduling  
**Priority:** Medium  
**Status:** Not Started

## Description

Create a protected API route at `/api/cron/scheduler/route.ts`. This endpoint will be triggered by an external scheduler (e.g., Vercel Cron Jobs). It will call `enqueueDueCampaigns()` and push each resulting payload into the `queue:email-sending` Redis list (LPUSH).

## Acceptance Criteria

1. [ ] The API route is created and protected.
2. [ ] When triggered, it successfully retrieves due jobs from the scheduler service.
3. [ ] It pushes each job payload into the correct Redis list.
4. [ ] It logs a summary (e.g., "Enqueued 150 email jobs").

## Notes

- The route must be idempotent and safe to run frequently.
- Protect the route using the project's secret header pattern to avoid unauthorized triggers.

## Related documentation

- [Operations: Infrastructure Operations Management (scheduling)](../../docs/operations-analytics/operations-management/infrastructure-operations-management)
- [Development Standards (API routes & secrets)](../../docs/implementation-technical/development-guidelines/development-standards)
