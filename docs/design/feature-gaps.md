# Feature Gaps & Roadmap Clarifications

**Purpose**: This document tracks features referenced in route specifications that have been clarified, deferred to the roadmap, or addressed during the frontend routing validation process.

**Status**: Updated 2025-11-21  
**Related**: [Frontend Routing Map](frontend-routing-map.md) | [Implementation Plan](file:///home/israel/.gemini/antigravity/brain/88de798e-8e79-4b8a-b72d-7673ffde78c7/implementation_plan.md)

---

## 1. Documentation Updates Completed

### Stripe Integration Documentation

**Status**: 📝 **Needs Creation**

**Location**: `docs/technical/integrations/stripe.md`

**Required Content**:

- Stripe Connect architecture overview
- Light database reference approach (Stripe manages subscriptions)
- Stripe Elements integration for Next.js
- Customer Portal implementation for tenant self-service
- Webhook endpoints and their purposes
- API consumption patterns for subscription status checks
- One-time payment and subscription handling

**Current State**: Referenced in multiple route specs but documentation file doesn't exist yet.

**Action**: Create comprehensive Stripe integration documentation (see Phase 3 in implementation plan).

---

## 2. Features Removed from Specifications

### User Impersonation

**Status**: ❌ **Not Planned**

**Previous References**:

- `/dashboard/users` route (platform-admin.md)
- 7 instances across  route specifications

**Replacement**: **Audit Trail Viewer**

- Comprehensive user action history
- Searchable timeline with filters
- Export capability for detailed analysis
- Support access logging

**Rationale**: Impersonation poses security and privacy concerns. Audit trail viewing provides debugging capabilities without direct account access.

**Updated Files**:

- ✅ `docs/design/routes/platform-admin.md`
- ✅ `docs/design/frontend-routing-map.md`

---

## 3. Authentication & Authorization

### Current Implementation ✅

**Provider**: NileDB SDK (email/password only)

- Front-end and back-end authentication functions
- HTTP-only session cookies
- CSRF protection enabled

**Email Verification**: Loop service

- Verification emails with magic links
- Fallback 6-digit codes
- 30-minute token expiration

**Updated Files**:

- ✅ `docs/design/routes/public-auth.md`
- ✅ `docs/design/routes/workspace-assets.md`

### OAuth Providers - Q4 2026 Post-MVP 📅

**User Authentication**:

- Google OAuth
- Microsoft OAuth  
- Or NileDB MFA solution (TBD)

**Email Account Integration**:

- OAuth for Gmail/Outlook email account connections
- Currently uses SMTP credentials only

**Rationale**: Email/password provides MVP authentication. OAuth adds convenience but is not core functionality.

**Roadmap Documentation**: Added to route specs with clear Q4 2026 timeline markers.

---

## 4. Queue System References

### Previous Implementation References

**Status**: ✅ **Updated**

**Old References**: Generic "BullMQ dashboard" mentions

**Actual Implementation**: Hybrid PostgreSQL + Redis queue system

- PostgreSQL for durable job state (`jobs`, `job_queues`, `job_logs` tables)
- Redis for fast processing
- Custom monitoring UI (not BullMQ Arena)
- Queue names: `queue:email-sending:high`, `queue:email-sending`, `queue:email-sending:low`, etc.

**Documentation**: [Queue System Implementation](../technical/architecture/detailed-technical/queue-system-implementation.md)

**Updated Files**:

- ✅ `docs/design/routes/platform-admin.md`
- ✅ `docs/design/routes/tenant-leads.md`
- ✅ `docs/design/routes/workspace-campaigns.md`
- ✅ `docs/design/frontend-routing-map.md`

---

## 5. Database Schema & API Verification Needed

### Audit Trail System

**Database Schema**: Requires verification

- Audit log table structure
- Retention policies
- Index optimization

**API Endpoint**: Requires verification

- Executive/Platform API audit trail retrieval endpoint
- Query parameters and response format
- Pagination and filtering capabilities

**Action Required**: Phase 4 verification (see implementation plan)

### Queue Monitoring System

**Database Tables**: Documented in queue system implementation

- `jobs` - Job state and audit trail  
- `job_queues` - Queue configuration
- `job_logs` - Execution audit trail

**API Endpoint**: Requires verification

- Executive/Platform API queue monitoring endpoint
- Real-time queue depth tracking
- Job status retrieval

**Action Required**: Phase 4 verification (see implementation plan)

---

## 6. Broken Documentation Links Fixed

### Domain Setup Reference

**Old Link**: `docs/technical/email-delivery/domain-setup.md` ❌  
**New Link**: `docs/freelancer-support/tutorials/domain-setup.md` ✅

**Updated in**: `docs/design/routes/workspace-assets.md`

### Stripe Integration Reference

**Old Link**: `docs/technical/integrations/stripe.md` ❌  
**Action**: Create documentation file (Phase 3)

**Referenced in**:

- `docs/design/routes/settings.md` (Lines 201, 205-206)
- `docs/design/routes/platform-admin.md` (Line 174)

---

## 7. Feature Timeline Summary

|Feature|Current Status|MVP Status|Post-MVP Timeline|
|---|---|---|---|
|**NileDB Email/Password Auth**|✅ Implemented|Core feature|-|
|**Loop Email Verification**|✅ Implemented|Core feature|-|
|**SMTP Email Accounts**|✅ Implemented|Core feature| -|
| **Audit Trail Viewer**|📝 Planned|Core feature|Implementation needed|
|**Hybrid Queue System**|✅ Implemented|Core feature|-|
|**Stripe Connect**|✅ Implemented|Core feature|-|
|**Google/Microsoft OAuth (Auth)**|❌ Not started|Not required|Q4 2026 post-MVP|
|**OAuth Email Accounts**|❌ Not started|Not required|Q4 2026 post-MVP|
|**NileDB MFA**|❌ Not started|Not required|Q4 2026 post-MVP (alternative to OAuth)|
|**User Impersonation**|❌ Not planned|Not planned|Never (replaced by audit trails)|

---

## 8. Outstanding Verification Tasks

- [ ] **Audit Log Schema**: Verify database table structure and indexes
- [ ] **Queue Tables**: Confirm schema documentation in queue system implementation
- [ ] **Audit Trail API**: Check if endpoint exists in executive/platform API
- [ ] **Queue Monitoring API**: Check if endpoint exists in executive/platform API
- [ ] **Stripe Documentation**: Create comprehensive integration guide

**See Also**: [Implementation Plan - Phase 4](file:///home/israel/.gemini/antigravity/brain/88de798e-8e79-4b8a-b72d-7673ffde78c7/implementation_plan.md#phase-4-database--api-verification)

---

**Last Updated**: 2025-11-21  
**Maintained By**: Product & Engineering Teams  
**Review Cycle**: Quarterly or when new features are added to roadmap

---

## 9. API Documentation Gaps Identified (Phase 2 Verification)

### System Status API

**Status**: 📝 **Needs Creation**

**Referenced in**: `docs/design/routes/public-auth.md` (`/status`)

**Requirement**: Public, unauthenticated endpoint to check system health (API, SMTP, DB, Dashboard).

**Action**: Create `docs/implementation-technical/api/public-status.md` or similar.

### Tenant Billing API

**Status**: 📝 **Needs Creation**

**Referenced in**: `docs/design/routes/settings.md` (`/dashboard/settings/billing`)

**Requirement**: Tenant-facing endpoints to view current plan, usage, and billing history (proxying Stripe).

**Action**: Create `docs/implementation-technical/api/tenant-api/billing.md` or add to `workspaces.md`.

### Tenant Domain Reputation

**Status**: ⚠️ **Clarification Needed**

**Referenced in**: `docs/design/routes/workspace-domains.md`

**Issue**: Linked to `central-smtp/reputation.md` which is an Admin API (`/api/v1/smtp/admin`). Tenants need a way to see their own domain reputation.

**Action**: Ensure `tenant-smtp/domains.md` includes reputation data in the response, or create `tenant-smtp/reputation.md`.
