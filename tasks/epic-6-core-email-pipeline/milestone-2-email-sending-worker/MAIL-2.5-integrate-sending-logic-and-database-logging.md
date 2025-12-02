
# MAIL-2.5: Integrate Sending Logic and Database Logging

**Ticket ID:** MAIL-2.5  
**Milestone:** Milestone 2 - The Email Sending Worker  
**Priority:** High  
**Status:** Not Started

## Description

Combine the worker main loop, email assembly, and SMTP sending. After successful sends, create `inbox_message_refs` records with `direction: 'outbound'` and `status: 'sent'`. Implement basic retry logic for transient failures.

## Acceptance Criteria

1. [ ] A successfully sent email results in a new record in `inbox_message_refs`.
2. [ ] The record is correctly linked to `tenant_id`, `campaign_id`, `lead_id`, etc.
3. [ ] If an SMTP connection fails, the job is retried and not lost.

## Notes

- Consider exponential backoff for retries and a max-attempts limit.
- Log errors with enough context to debug without storing secrets.

## Related documentation

- [Development Standards (retries & logging)](../../docs/implementation-technical/development-guidelines/development-standards)
- [Operations: Infrastructure Operations Management (worker monitoring)](../../docs/operations-analytics/operations-management/infrastructure-operations-management)
