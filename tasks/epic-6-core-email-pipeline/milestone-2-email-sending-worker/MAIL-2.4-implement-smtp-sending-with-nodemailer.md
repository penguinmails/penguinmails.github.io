
# MAIL-2.4: Implement SMTP Sending with Nodemailer

**Ticket ID:** MAIL-2.4  
**Milestone:** Milestone 2 - The Email Sending Worker  
**Priority:** High  
**Status:** Not Started

## Description

Install `nodemailer`. Create a function `sendEmail(emailObject, smtpSettings)` that configures a Nodemailer transport using the user's SMTP settings (`host`, `port`, `user`, `password`) stored in `email_accounts` and dispatches the message.

## Acceptance Criteria

1. [ ] `nodemailer` is added as a dependency.
2. [ ] The function correctly configures the Nodemailer transport with DB-provided SMTP settings.
3. [ ] It can send an email to a test inbox (e.g., Ethereal/Mailtrap) in development.

## Notes

- Use connection pooling when appropriate for throughput.
- Store minimal logs for each send (messageId, status).

## Related documentation

- [Technical Architecture — Overview](../../docs/technical/architecture/overview)
- [Development Standards (external integrations & secrets)](../../docs/implementation-technical/development-guidelines/development-standards)
- [Quick Setup / Getting Started](../../docs/quick-setup)
