---
title: "API Key Best Practices"
description: "Best practices for API key management"
level: "3"
keywords: "best practices, guidelines, recommendations"
---

# API Key Best Practices

## API Key Best Practices

### For Developers

#### 1. Store Keys Securely

- âœ… Store in environment variables (`.env` file)

- âœ… Use secret management tools (AWS Secrets Manager, Vault)

- âŒ Never commit keys to version control

- âŒ Never hardcode keys in source code

- âŒ Never share keys via email or chat

#### 2. Use Minimal Permissions

- âœ… Create separate keys for different applications

- âœ… Grant only required permission scopes

- âŒ Don't use full-access keys for single-purpose applications

#### 3. Rotate Keys Regularly

- âœ… Rotate keys every 90 days (recommended)

- âœ… Rotate immediately if key compromised

- âœ… Test new key before revoking old key

#### 4. Monitor Usage

- âœ… Review API key usage regularly

- âœ… Set up alerts for unusual activity

- âœ… Investigate unexpected errors

#### 5. Handle Errors Gracefully

- âœ… Implement exponential backoff for rate limit errors

- âœ… Log authentication failures

- âœ… Retry failed requests with backoff

### For PenguinMails Administrators

#### 1. Enforce Security Policies

- âœ… Require HTTPS for all API requests

- âœ… Implement rate limiting per tier

- âœ… Monitor for suspicious activity

#### 2. Audit Regularly

- âœ… Review audit logs weekly

- âœ… Investigate anomalies

- âœ… Revoke unused keys

#### 3. Educate Users

- âœ… Provide security best practices documentation

- âœ… Send reminders for key rotation

- âœ… Offer security training

---
