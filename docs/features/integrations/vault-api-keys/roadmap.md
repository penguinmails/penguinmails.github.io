---
title: "Roadmap"
description: "Future enhancements and roadmap"
level: "3"
keywords: "roadmap, future, enhancements"
---

# Roadmap

## Roadmap

### MVP (Current)

**Status:** PLANNED - P0 Critical

**Features:**

- ✅ API key generation with bcrypt hashing

- ✅ Vault storage for API keys

- ✅ Permission scopes (send_email, read_analytics, manage_contacts)

- ✅ Tier-based rate limiting (60/300/1000 req/min)

- ✅ Frontend UI for key management

- ✅ Usage tracking (requests, errors, last used)

- ✅ Audit logging

- ✅ API documentation with code examples

**Timeline:** 2 weeks

**Priority:** P0 - Critical (blocks all programmatic integrations)

### Post-MVP (Q1 2026)

**Features:**

- IP whitelisting (restrict API key usage to specific IPs)

- Webhook notifications for API key events (created, revoked, rate limit exceeded)

- Advanced usage analytics (geographic distribution, endpoint popularity)

- API key expiration dates (auto-revoke after X days)

- Team-level API keys (shared across team members)

- API key templates (pre-configured permission sets)

### Future (Q2 2026+)

**Features:**

- OAuth 2.0 support (alternative to API keys)

- API key rotation policies (auto-rotate every 90 days)

- API key usage quotas (max requests per month)

- API key cost tracking (charge per API request)

- API key analytics dashboard (real-time monitoring)

- API key security scanning (detect compromised keys)

---

## Related Documentation

### Route Specifications

- **[API Key Management Routes](/docs/design/routes/api-key-management)** - Complete UI route specifications

- **[API Access Routes](/docs/design/routes/api-access)** - API key management interface

- **[Settings Routes](/docs/design/routes/settings)** - General settings navigation

### Feature Documentation

- **[API Access](/docs/features/integrations/api-access)** - General API access overview

- **[Webhook System](/docs/features/integrations/webhook-system)** - Event notifications

- **[Vault SSH Management](/docs/features/infrastructure/vault-ssh-management)** - VPS SSH key management

- **[Vault SMTP Credentials](/docs/features/infrastructure/vault-smtp/overview)** - SMTP credentials storage

### API Documentation

- **[Platform API](/docs/implementation-technical/api/platform-api)** - Platform-level API endpoints

- **[Tenant API](/docs/implementation-technical/api/tenant-api)** - Tenant-level API endpoints

- **[API Reference](/docs/implementation-technical/api/README)** - Complete API documentation

### Architecture & Security

- **[Vault Integration Architecture](/.kiro/specs/feature-completeness-review/findings/vault-integration-architecture)** - Comprehensive Vault architecture

- **[Enterprise Security](/docs/compliance-security/enterprise/overview)** - Enterprise security features

- **[Security Monitoring](/docs/operations/security-monitoring)** - Security monitoring and alerting

### Planning & Review

- **[Integrations Review](/.kiro/specs/feature-completeness-review/findings/integrations)** - Integration completeness review

- **[Feature Completeness Review - Requirements](/.kiro/specs/feature-completeness-review/requirements)** - Requirements document

- **[Feature Completeness Review - Design](/.kiro/specs/feature-completeness-review/design)** - Design document

### Implementation Tasks

- **[Task 11.3 - Vault Integration Architecture](/.kiro/specs/feature-completeness-review/tasks#113-document-vault-integration-architecture)** - Architecture documentation

- **[Task 11.6 - Tenant API Key System](/.kiro/specs/feature-completeness-review/tasks#116-implement-tenant-api-key-system-with-vault)** - API key system implementation

- **Epic 5: Infrastructure Management** - Internal task reference for infrastructure work

### External References

- **[HashiCorp Vault Documentation](https://www.vaultproject.io/docs)** - Official Vault docs

- **[bcrypt Documentation](https://github.com/kelektiv/node.bcrypt.js)** - Password hashing library

- **[Token Bucket Algorithm](https://en.wikipedia.org/wiki/Token_bucket)** - Rate limiting algorithm

---

**Last Updated:** November 26, 2025
**Document Version:** 1.0
**Status:** PLANNED
**Priority:** P0 - Critical
**Next Review:** December 26, 2025

*This feature documentation provides comprehensive guidance for implementing the Tenant API Key System with Vault integration. All implementation must reference the [Vault Integration Architecture](/.kiro/specs/feature-completeness-review/findings/vault-integration-architecture) for secret structure, access policies, and security requirements.*
