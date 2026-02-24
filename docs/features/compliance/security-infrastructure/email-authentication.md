---
title: "Email Authentication (SPF, DKIM, DMARC)"
description: "Detailed guide to securing your email domains with SPF, DKIM, and DMARC."
last_modified_date: "2026-02-24"
level: "2"
persona: "Administrators, Developers"
---

# Email Authentication

In the cold email ecosystem, proper domain authentication is the single most important factor for inbox placement. PenguinMails automates the technical heavy lifting while providing you with the transparency needed for enterprise-grade compliance.

## 1. SPF (Sender Policy Framework)

**What It Does**: Specifies which mail servers (IP addresses) are authorized to send email on behalf of your domain.

**Standard PenguinMails Record**:

```text
TXT Record: @ (or yourdomain.com)
Value: v=spf1 ip4:YOUR_VPS_IP ~all
```

*Note: We use `~all` (soft fail) during the onboarding phase and recommend switching to `-all` (hard fail) only after verifying all legitimate senders are accounted for.*

## 2. DKIM (DomainKeys Identified Mail)

**What It Does**: Adds a cryptographic signature to every outgoing email, proving that the content has not been tampered with and that it truly originated from your server.

**Implementation**:

- PenguinMails generates a unique 2048-bit RSA key pair for every domain.
- The private key is stored securely in our Vault.
- You must add the public key to your DNS.

**Example Record**:

```text
Host: penguin._domainkey
Type: TXT
Value: v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...
```

## 3. DMARC (Domain-based Message Authentication, Reporting, and Conformance)

**What It Does**: Provides instructions to receiving mail servers on what to do if an email fails SPF or DKIM checks. It also enables reporting of authentication results back to the domain owner.

**Recommended Rollout Strategy**:

1. **Monitor (p=none)**: `v=DMARC1; p=none; rua=mailto:dmarc@yourdomain.com`
2. **Quarantine (p=quarantine)**: `v=DMARC1; p=quarantine; pct=10; ...`
3. **Reject (p=reject)**: `v=DMARC1; p=reject; ...`

## Best Practices

- **Alignment**: Ensure your `From` address domain matches the SPF and DKIM domains.
- **Reporting**: Always set up a dedicated `rua` email to monitor for potential spoofing attempts.
- **Automation**: PenguinMails provides a "Check DNS Status" tool in the Domain Detail view to verify these records in real-time.
