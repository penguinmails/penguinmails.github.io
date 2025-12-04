---
title: "Architecture"
description: "System architecture and design for Vault SMTP credential management"
level: "3"
keywords: "architecture, design, system design, Vault integration"
---

# Architecture

## Architecture

### Vault Secret Structure

SMTP credentials are stored in Vault at the following path:

```text

vault/smtp/{tenant_id}/admin/
â”œâ”€â”€ username          # MailU admin username
â”œâ”€â”€ password          # Encrypted password (AES-256-GCM)
â”œâ”€â”€ webmail_url       # MailU webmail URL (https://mail.example.com)
â”œâ”€â”€ created_at        # ISO 8601 timestamp
â”œâ”€â”€ last_rotated      # ISO 8601 timestamp
â””â”€â”€ rotation_policy   # "180_days"

```

**Path Parameters:**

- `{tenant_id}` - UUID v4 format (e.g., `550e8400-e29b-41d4-a716-446655440000`)

**Secret Fields:**

- `username` - MailU admin username (typically `admin@domain.com`)

- `password` - Encrypted password (AES-256-GCM with random IV)

- `webmail_url` - Full URL to MailU webmail interface

- `created_at` - Timestamp when credentials were first created

- `last_rotated` - Timestamp of last password rotation

- `rotation_policy` - Rotation frequency (`180_days`)

### Encryption Specification

**Algorithm:** AES-256-GCM (Galois/Counter Mode)

**Key Derivation:**

- Master encryption key stored in Vault's encryption backend

- Per-tenant encryption keys derived using HKDF (HMAC-based Key Derivation Function)

- Salt: Tenant ID + timestamp

- Iterations: 100,000 (PBKDF2)

**Encryption Process:**

```typescript
// Generate random IV (Initialization Vector)
const iv = crypto.randomBytes(16);

// Derive encryption key from master key
const encryptionKey = deriveKey(masterKey, tenantId, salt);

// Encrypt password with AES-256-GCM
const cipher = crypto.createCipheriv('aes-256-gcm', encryptionKey, iv);
const encryptedPassword = Buffer.concat([
  cipher.update(password, 'utf8'),
  cipher.final()
]);

// Get authentication tag
const authTag = cipher.getAuthTag();

// Store: IV + authTag + encryptedPassword
const storedValue = Buffer.concat([iv, authTag, encryptedPassword]).toString('base64');

```

