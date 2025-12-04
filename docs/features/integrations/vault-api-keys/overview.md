---
title: "Vault API Keys Management"
description: "Secure API key storage, rotation, and management with HashiCorp Vault"
level: "3"
keywords: "vault, API keys, security, credential management, integration"
---

# Vault API Keys Management

## Documentation Structure

Comprehensive guide organized by topic:

### Core Functionality
- [User Workflows](/docs/features/integrations/vault-api-keys/user-workflows) - User workflows and operations
- [Technical Architecture](/docs/features/integrations/vault-api-keys/architecture) - System architecture and design
- [API Endpoints](/docs/features/integrations/vault-api-keys/api-endpoints) - API documentation

### User Interface & Security
- [Frontend UI](/docs/features/integrations/vault-api-keys/frontend-ui) - UI specifications
- [Security Considerations](/docs/features/integrations/vault-api-keys/security) - Security best practices
- [Best Practices](/docs/features/integrations/vault-api-keys/best-practices) - API key management best practices

### Implementation
- [Implementation Checklist](/docs/features/integrations/vault-api-keys/implementation) - Deployment guide
- [Compliance](/docs/features/integrations/vault-api-keys/compliance) - Compliance requirements
- [Roadmap](/docs/features/integrations/vault-api-keys/roadmap) - Future enhancements

---

## Overview

The Tenant API Key System provides secure, self-service API key generation and management for programmatic access to PenguinMails. API keys enable tenants to send emails, manage contacts, and access analytics from their applications without requiring user authentication.

### Purpose

**Problem:** Tenants need programmatic access to PenguinMails for integrations with their applications, but traditional username/password authentication is unsuitable for server-to-server communication.

**Solution:** Generate unique API keys per tenant with:

- Secure storage in HashiCorp Vault (bcrypt hashing)

- Fine-grained permission scopes (send_email, read_analytics, manage_contacts)

- Tier-based rate limiting (Starter: 60/min, Pro: 300/min, Enterprise: 1000/min)

- Usage tracking (requests, errors, last used timestamp)

- Self-service management UI (create, view, regenerate, revoke)

### Key Features

1. **Secure Key Generation** - Cryptographically secure API keys with format `pm_live_{32_random_chars}`

2. **Vault Storage** - Keys hashed with bcrypt (12 salt rounds) and stored in Vault

3. **Permission Scopes** - Granular permissions for different API operations

4. **Rate Limiting** - Tier-based rate limits prevent abuse

5. **Usage Tracking** - Monitor API key usage (requests, errors, last used)

6. **Self-Service UI** - Tenants manage keys without support intervention

7. **Audit Trail** - All key operations logged for security compliance

---

