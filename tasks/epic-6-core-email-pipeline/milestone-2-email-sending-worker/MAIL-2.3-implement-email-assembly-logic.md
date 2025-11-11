# MAIL-2.3: Implement Email Assembly Logic

**Ticket ID:** MAIL-2.3  
**Milestone:** Milestone 2 - The Email Sending Worker  
**Priority:** High  
**Status:** Not Started

## Description

Create a function `assembleEmail(jobPayload)` that queries the database for the full lead, template, and email_account details, performs variable replacement (e.g., `{{firstName}}`) in the template's subject and body, and returns a composed email object with `from`, `to`, `subject`, and `html`.

## Acceptance Criteria

1. [ ] The function successfully fetches all required data from the database.
2. [ ] It correctly replaces variables in the subject and body with the lead's data.
3. [ ] It returns a final email object with `from`, `to`, `subject`, and `html` fields.

## Notes

- Sanitize values to avoid HTML injection.
- Support simple templating (handle missing values gracefully).

## Related documentation

- [Development Standards (templating & sanitization)](../../docs/implementation-technical/development-guidelines/development-standards.md)
- [Technical Architecture — Overview](../../docs/technical/architecture/overview.md)