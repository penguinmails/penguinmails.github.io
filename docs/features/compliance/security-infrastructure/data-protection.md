---
title: "Data Protection & Encryption"
description: "Securing data in transit and at rest with industry-standard encryption protocols."
last_modified_date: "2026-02-24"
level: "2"
persona: "Security Team, Developers"
---

# Data Protection & Encryption

Ensuring the confidentiality and integrity of your data is a top priority. We use defense-in-depth strategies to protect sensitive information.

## 1. Data In Transit (SSL/TLS)

All communications between users, the PenguinMails dashboard, and external APIs are encrypted using TLS 1.2 or higher.

- **Automated SSL**: Certificates are automatically provisioned and renewed via Let's Encrypt.
- **HSTS (HTTP Strict Transport Security)**: Enforced to prevent downgrade attacks.
- **Email Encryption**: Outbound email uses opportunistic STARTTLS to encrypt communications with receiving mail servers where supported.

## 2. Data At Rest

All persistent data is stored in encrypted volumes using AES-256.

- **Database Encryption**: Sensitive fields (e.g., API keys, SMTP credentials) are encrypted at the application layer before being written to the database.
- **Secret Management**: We use Hashicorp Vault for secure storage of master encryption keys and system-level secrets.
- **Key Rotation**: Cryptographic keys are rotated every 90 days to minimize the impact of any potential compromise.

## 3. Advanced Encryption Features

- **Field-Level Encryption**: Specifically targets PII (Personally Identifiable Information) and credentials.
- **Customer-Managed Keys (BYOK)**: *Enterprise Only.* Allows tenants to provide their own encryption keys from a cloud KMS (AWS KMS, Google Cloud KMS, or Azure Key Vault).

## 4. Technical Snippets (Field-Level)

We use a standard Node.js `crypto` implementation for application-layer encryption:

```typescript
function encrypt(data: string, key: Buffer): { iv: string, content: string, tag: string } {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv('aes-256-gcm', key, iv);
  // ... implementation details
}
```

## 5. Persistence Backups

Backups are encrypted using the same AES-256 standards and stored in geo-redundant S3 buckets with Object Lock enabled to prevent ransomware tampering.
