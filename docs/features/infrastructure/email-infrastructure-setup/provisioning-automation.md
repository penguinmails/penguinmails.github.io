---
title: "Provisioning & Automation"
description: "Technical details of VPS provisioning via Hostwind API and automated SMTP stack installation."
last_modified_date: "2026-02-24"
level: "2"
persona: "Infrastructure Engineers"
---

# Provisioning & Automation

**End-to-end automation for launching production-ready email sending infrastructure.**

---

## 1. VPS Provisioning Lifecycle

Provisioning is handled via the Hostwind API integration, focusing on speed and reliability.

### Automated Process (2-3 Minutes)

1. **API Call**: Request new VPS with `ubuntu-22.04-email-optimized` image.
2. **Polling**: Wait for VPS status to reach `active`.
3. **Connectivity**: Verify SSH availability on the management port.
4. **Initialization**: Execute `bootstrap.sh` to apply initial security hardening.

### Server Sizing

- **Starter**: 1 CPU, 2GB RAM (5K emails/day)
- **Professional**: 2 CPU, 4GB RAM (25K emails/day)
- **Business**: 4 CPU, 8GB RAM (100K emails/day)

---

## 2. SMTP Server Installation

PenguinMails leverages the **MailU** stack, installed and configured automatically via SSH.

### MailU Configuration

- **Standard Ports**: 25 (SMTP), 465 (SMTPS), 587 (Submission), 993 (IMAP).
- **Hardening**:
  - `TLS 1.2+` enforcement.
  - Fail2ban protection against brute-force attacks.
  - SMTP authentication required for all outgoing mail.
  - Webmail interface auto-installed at `mail.yourdomain.com`.

---

## 3. Account Provisioning

Individual mailboxes are created via the infrastructure management API, with quotas and rate limits enforced at the MTA level.

```typescript
async function createEmailAccount(address: string, password: string) {
  // 1. Generate hash
  const hash = await bcrypt.hash(password, 10);
  // 2. Add to MTA virtual users table
  await ssh.exec(`mailu-admin user-create ${address} ${hash}`);
  // 3. Persist in PenguinMails DB
  await db.emailAccounts.create({ address, hash });
}
```
