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

- ✅ Store in environment variables (`.env` file)

- ✅ Use secret management tools (AWS Secrets Manager, Vault)

- ❌ Never commit keys to version control

- ❌ Never hardcode keys in source code

- ❌ Never share keys via email or chat

#### 2. Use Minimal Permissions

- ✅ Create separate keys for different applications

- ✅ Grant only required permission scopes

- ❌ Don't use full-access keys for single-purpose applications

#### 3. Rotate Keys Regularly

- ✅ Rotate keys every 90 days (recommended)

- ✅ Rotate immediately if key compromised

- ✅ Test new key before revoking old key

#### 4. Monitor Usage

- ✅ Review API key usage regularly

- ✅ Set up alerts for unusual activity

- ✅ Investigate unexpected errors

#### 5. Handle Errors Gracefully

- ✅ Implement exponential backoff for rate limit errors

- ✅ Log authentication failures

- ✅ Retry failed requests with backoff

### For PenguinMails Administrators

#### 1. Enforce Security Policies

- ✅ Require HTTPS for all API requests

- ✅ Implement rate limiting per tier

- ✅ Monitor for suspicious activity

#### 2. Audit Regularly

- ✅ Review audit logs weekly

- ✅ Investigate anomalies

- ✅ Revoke unused keys

#### 3. Educate Users

- ✅ Provide security best practices documentation

- ✅ Send reminders for key rotation

- ✅ Offer security training

---
