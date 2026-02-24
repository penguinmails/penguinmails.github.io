---
title: "Email ESP Compliance Integration"
description: "Technical specifications for GDPR-compliant integration with SendGrid and Postmark, including automated unsubscribe and bounce processing."
last_modified_date: "2026-02-24"
level: "3"
persona: "Documentation Users"
---

# Email ESP Compliance Integration

## Email Service Provider Integration

### Compliant Integrations

PenguinMails integrates with leading Email Service Providers (ESPs) in a GDPR-compliant manner, ensuring that personal data is handled securely throughout the email delivery process.

#### SendGrid Integration

SendGrid is used for high-volume marketing campaigns, with data processing agreements (DPAs) in place to ensure GDPR compliance.

- **Data Encryption**: TLS for all communications between PenguinMails and SendGrid
- **IP Reputation**: Dedicated IP addresses for reputation management
- **Bounce Handling**: Automated processing of bounce notifications

#### Postmark Integration

Postmark is used for transactional emails, providing high deliverability and secure data handling.

- **Transactional Focus**: Isolated transactional email traffic
- **Retention Policies**: Configurable data retention for transactional logs
- **Security Features**: Two-factor authentication and detailed audit logs

### Automated Unsubscribe Processing

PenguinMails automatically includes unsubscribe links in all marketing emails and processes unsubscribe requests in real-time.

```javascript
// Example of unsubscribe processing
async function processUnsubscribe(userId, tenantId) {
  await db.query('UPDATE user_consents SET status = $1 WHERE user_id = $2 AND tenant_id = $3', ['withdrawn', userId, tenantId]);
  await esp.updateSuppressionList(userId, 'unsubscribed');
  await logAuditAction('unsubscribe', userId, tenantId);
}
```

### Bounce and Complaint Handling

Automated systems handle email bounces and spam complaints, updating user records and ensuring that problematic addresses are removed from future campaigns.

- **Hard Bounces**: Immediate removal from all mailing lists
- **Soft Bounces**: Automated retry logic with eventual removal
- **Spam Complaints**: Immediate removal and audit log entry
- **Suppression Lists**: Shared suppression lists across tenants (optional)
