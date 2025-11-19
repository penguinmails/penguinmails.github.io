# MAIL-1.2: Define Zod Schema for Job Payloads

**Ticket ID:** MAIL-1.2  
**Milestone:** Milestone 1 - Job Enqueueing and Campaign Scheduling  
**Priority:** Medium  
**Status:** Not Started

## Description

In `/lib/schemas`, create a `jobs.schemas.ts` file. Define and export a Zod schema (`emailJobPayloadSchema`) for the JSON payload of an email sending job. Required fields include `tenantId`, `campaignId`, `leadId`, `stepId`, `emailAccountId`, and any scheduling metadata.

## Acceptance Criteria

1. [ ] The `jobs.schemas.ts` file is created.
2. [ ] The `emailJobPayloadSchema` is defined and correctly validates a sample job object.

## Notes

- Keep the schema minimal and stable; avoid including large nested objects — include IDs and necessary small metadata only.
- Add example payloads for unit tests.

## Related documentation

- [Development Standards (validation & schemas)](../../docs/implementation-technical/development-guidelines/development-standards)
- [Technical Architecture — Overview](../../docs/technical/architecture/overview)
