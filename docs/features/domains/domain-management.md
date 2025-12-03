---
title: "Domain Management"
description: "Custom domain configuration, DNS verification, and sender authentication"
last_modified_date: "2025-11-24"
level: "2"
persona: "IT Admins, Marketing Ops"
status: "ACTIVE"
category: "Domains"
---

# Domain Management

## Securely manage sending domains, verify ownership, and configure authentication protocols

---

## Overview

Domain Management allows you to connect your own custom domains to PenguinMails for sending emails. Proper domain configuration is critical for deliverability, brand identity, and security.

### Key Features

- **Custom Sending Domains** - Send from `marketing.yourbrand.com`

- **Automated Verification** - DNS record checking

- **Authentication Protocols** - SPF, DKIM, DMARC setup

- **Link Tracking Domains** - Branded tracking links (CNAME)

- **Multi-Domain Support** - Manage multiple domains per workspace

---

## Level 1: Adding a Domain

### The Setup Process

1. **Add Domain**: Enter your domain name in the dashboard.

2. **Get DNS Records**: PenguinMails generates required DNS records.

3. **Update DNS**: Add these records to your domain registrar (GoDaddy, Namecheap, Cloudflare, etc.).

4. **Verify**: Click "Verify" in PenguinMails.

5. **Ready**: Once verified, you can send emails from this domain.

### Required DNS Records

| Type | Host/Name | Value | Purpose |
|------|-----------|-------|---------|
| **TXT** | `@` (or subdomain) | `v=spf1 include:spf.penguinmails.com ~all` | **SPF**: Authorizes PenguinMails to send |
| **TXT** | `pm._domainkey` | `k=rsa; p=MIGfMA0GCSq...` | **DKIM**: Signs emails cryptographically |
| **TXT** | `_dmarc` | `v=DMARC1; p=none; rua=...` | **DMARC**: Policy for failed checks |
| **CNAME**| `track` | `track.penguinmails.com` | **Tracking**: Branded link tracking |
| **MX** | `reply` | `inbound.penguinmails.com` | **Inbound**: Handling replies (optional) |

---

## Level 2: Sender Authentication

### SPF (Sender Policy Framework)

**What it is:** A list of IP addresses authorized to send email for your domain.
**Why it matters:** Prevents spammers from spoofing your domain.
**Configuration:** PenguinMails provides an `include` mechanism to automatically cover all our sending IPs.

### DKIM (DomainKeys Identified Mail)

**What it is:** A digital signature attached to every email.
**Why it matters:** Proves the email wasn't tampered with in transit.
**Configuration:** We generate a 2048-bit RSA key pair. You publish the public key in your DNS; we sign with the private key.

### DMARC (Domain-based Message Authentication, Reporting, and Conformance)

**What it is:** A policy that tells receivers what to do if SPF/DKIM fail.
**Why it matters:** Protects your brand reputation.

## Policies

- `p=none`: Monitor mode (Recommended for starting).

- `p=quarantine`: Send failures to spam folder.

- `p=reject`: Reject failures completely (Ultimate goal).

---

## Level 3: Advanced Configuration

### Link Tracking Domains

By default, tracking links (opens/clicks) use a shared domain. For better deliverability, use a **Custom Tracking Domain**.

- **Setup**: Create a CNAME record (e.g., `link.yourdomain.com`) pointing to our tracking server.

- **SSL**: PenguinMails automatically provisions an SSL certificate (Let's Encrypt) for your tracking subdomain.

### Domain Reputation Monitoring

We continuously monitor your domain's health:

- **Blacklist Checks**: Is your domain on URIBL or SURBL?

- **Google Postmaster Tools**: Integration to track reputation with Gmail.

- **DMARC Reports**: Analysis of DMARC reports to identify unauthorized senders.

### API Management

```javascript
// Add a new domain
POST /api/v1/domains
{
  "domain": "newsletter.acme.com",
  "workspace_id": "ws_abc123"
}

// Get DNS records for verification
GET /api/v1/domains/{id}/dns

```

---

## Related Documentation

### Compliance

- **[CAN-SPAM Compliance](/docs/features/compliance/can-spam-compliance)** - Legal requirements for senders

### Infrastructure

- **[Email Warmups](/docs/features/warmup/email-warmups/overview)** - Warming up new domains

---

**Last Updated:** November 24, 2025
**Verification Time:** < 1 hour (TTL dependent)

*Proper domain authentication is the single most important factor in email deliverability.*
