---
title: "Vault SMTP Credentials Management"
description: "Secure credential storage and rotation with HashiCorp Vault integration"
level: "3"
keywords: "vault, SMTP credentials, security, credential rotation, HashiCorp"
---

# Vault SMTP Credentials Management

Secure credential storage and rotation with HashiCorp Vault integration.

## Documentation Structure

Comprehensive guide organized by functional area:

### Core Architecture
- [Architecture](/docs/features/infrastructure/vault-smtp/architecture) - System architecture and design
- [Storage Workflow](/docs/features/infrastructure/vault-smtp/storage-workflow) - Credential storage process
- [Retrieval](/docs/features/infrastructure/vault-smtp/retrieval) - Credential retrieval mechanisms

### User Features
- [Secure Viewing UI](/docs/features/infrastructure/vault-smtp/viewing-ui) - Web interface for viewing credentials
- [Credential Rotation](/docs/features/infrastructure/vault-smtp/rotation) - Automated rotation procedures
- [Emergency Reset](/docs/features/infrastructure/vault-smtp/emergency-reset) - Emergency credential reset

### Operations & Security
- [Audit Logging](/docs/features/infrastructure/vault-smtp/audit-logging) - Audit trail and monitoring
- [Disaster Recovery](/docs/features/infrastructure/vault-smtp/disaster-recovery) - Recovery procedures
- [API Endpoints](/docs/features/infrastructure/vault-smtp/api-endpoints) - API documentation
- [Security Considerations](/docs/features/infrastructure/vault-smtp/security) - Security best practices
- [Compliance](/docs/features/infrastructure/vault-smtp/compliance) - Compliance requirements
- [Implementation Checklist](/docs/features/infrastructure/vault-smtp/implementation) - Implementation guide

---

## Overview

This document describes the secure storage and management of MailU SMTP admin credentials in HashiCorp Vault. All SMTP credentials are encrypted before storage, automatically rotated every 180 days, and protected with comprehensive audit logging.

### Purpose

Traditional approaches to storing SMTP credentials create security vulnerabilities:

- Credentials stored in ENV files on VPS are exposed if VPS is compromised

- Manual credential rotation is error-prone and often neglected

- No centralized audit trail for credential access

- Difficult to recover credentials after VPS failure

Vault-based SMTP credential storage provides:

- **Centralized Storage** - Credentials stored in Vault, not on VPS

- **Encryption at Rest** - AES-256-GCM encryption before Vault storage

- **Automated Rotation** - 180-day rotation policy with zero downtime

- **Audit Trail** - All credential access logged with timestamp and user

- **Disaster Recovery** - Rapid credential recovery from Vault backups

### Key Benefits

1. **VPS Compromise Protection** - If VPS is compromised, credentials can be rotated immediately

2. **Zero-Downtime Rotation** - Automated rotation without service interruption

3. **Admin Troubleshooting** - PenguinMails admins can retrieve credentials for support

4. **Emergency Reset** - Rapid credential reset in case of security incident

5. **Compliance** - Audit trail supports SOC 2, ISO 27001, and GDPR requirements

