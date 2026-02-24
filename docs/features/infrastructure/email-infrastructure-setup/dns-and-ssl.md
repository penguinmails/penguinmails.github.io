---
title: "DNS & SSL Configuration"
description: "Managing SPF, DKIM, DMARC records and automated SSL lifecycle for email infrastructure."
last_modified_date: "2026-02-24"
level: "2"
persona: "Infrastructure Engineers, Security Specialists"
---

# DNS & SSL Configuration

**Ensuring high deliverability and secure transmission through automated record management.**

---

## 1. Automated DNS Management

PenguinMails generates and monitors all required DNS records for authentication.

### Required Records

| Type | Host | Value (Example) |
|------|------|-----------------|
| **A** | `mail` | `[VPS_IP]` |
| **MX** | `@` | `mail.yourdomain.com` (Pri: 10) |
| **TXT** | `@` | `v=spf1 ip4:[VPS_IP] ~all` |
| **TXT** | `default._domainkey` | `v=DKIM1; k=rsa; p=[PUBLIC_KEY]` |
| **TXT** | `_dmarc` | `v=DMARC1; p=quarantine; rua=mailto:postmaster@...` |

### Provider Integration

For supported providers (Cloudflare, Route53, GoDaddy), PenguinMails can apply these records automatically via their respective APIs, reducing setup time and manual error.

---

## 2. SSL/TLS Certificate Lifecycle

All SMTP and Webmail traffic is secured using Let's Encrypt SSL certificates.

### Auto-Installation

Certificates are requested during the provisioning phase using `certbot` with the `nginx` plugin.

### Automated Renewal

A daily cron job on the VPS checks for certificates expiring within 30 days and triggers an automatic renewal.

```bash
# Cron on VPS
0 0 * * * /usr/bin/certbot renew --quiet
```

---

## 3. DMARC Policy Progression

We recommend a staged approach to DMARC enforcement:

1. **Phase 1: Monitor** (`p=none`) - Identify legitimate senders.
2. **Phase 2: Quarantine** (`p=quarantine`) - Send suspicious mail to spam.
3. **Phase 3: Reject** (`p=reject`) - Block unauthenticated mail entirely.
