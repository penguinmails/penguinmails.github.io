# MAIL-3.1: Implement Tracking Token Generation

**Ticket ID:** MAIL-3.1  
**Milestone:** Milestone 3 - Engagement Tracking  
**Priority:** High  
**Status:** Not Started

## Description

When assembling an email in the worker (MAIL-2.3), generate a secure JWT for each trackable link and the open-tracking pixel. The token must include metadata (`tenantId`, `leadId`, `campaignId`, `stepId`).

## Acceptance Criteria

1. [ ] A JWT library (e.g., `jsonwebtoken`) is installed.
2. [ ] A secret key for signing tokens is added to environment variables.
3. [ ] The email assembly logic embeds links like `/api/track/click?token=[JWT]` and an image tag like `<img src="/api/track/open?token=[JWT]">`.

## Notes

- Use short-lived tokens where possible to reduce misuse risk.
- Ensure tokens are URL-safe and reasonably small.

## Related documentation

- [Compliance & Security Framework](../../docs/compliance-security/enterprise/security-framework)
- [Development Standards (JWT & token handling)](../../docs/implementation-technical/development-guidelines/development-standards)
