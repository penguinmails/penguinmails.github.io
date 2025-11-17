---
title: "Executive Security & RBAC Journey (BF-004, BF-012)"
description: "Documentation for Executive Security & RBAC Journey (BF-004, BF-012) - Security Exec Auth Rbac"
last_modified_date: "2025-11-17"
level: 2
persona: "Documentation Users"
---

# Executive Security & RBAC Journey (BF-004, BF-012)

Document Level: Implementation-Technical (UX Contract)  
Primary Personas: C-Suite Executives, Security Officer, Platform Admin  
Related Stories: BF-004, BF-005, BF-006, BF-010, BF-012  

## 1. Overview

This journey defines how executive users securely access sensitive views and how the system communicates security, RBAC, and audit guarantees at the UX level.

Objectives:

- Make it clear to executives that access is protected by stronger controls.
- Ensure high-sensitivity surfaces are only reachable under correct roles and MFA.
- Align UX with documented constraints: NileDB-managed auth, Loop-based OTP, internal RBAC and audit logging.

This is a UX contract: all implementations must express these behaviors consistently.

## 2. Persona & Preconditions

- Personas:
  - C-Suite executives (CEO, CFO, COO, CTO, etc.).
  - Security / Compliance Officer.
  - Platform Admin with permissions to manage roles (where applicable).
- Preconditions:
  - Core authentication via NileDB configured.
  - Executive RBAC model implemented per BF-004.
  - Loop-based OTP as second factor for high-risk actions (2025 commitment).
  - Admin audit logging wired (BF-012 / `admin_audit_log`).

## 3. Step-by-step Flow

### 3.1 Executive Access to Protected Areas

1. User navigates to executive area (e.g. Executive Overview).
2. System checks:
   - Authenticated session.
   - Executive role + scopes.
3. If requirements not met:
   - Show clear “Access restricted” UX:
     - Explains this area is limited to specific roles.
     - No leakage of underlying data.
4. If allowed:
   - User proceeds to requested executive surface (Overview, Revenue Protection, etc.).

### 3.2 MFA / OTP for Sensitive Actions

1. When user attempts sensitive operations:
   - Examples:
     - Changing executive roles or scopes.
     - Viewing cross-tenant consolidated views.
     - Exporting executive-level or audit data.
2. System:
   - Prompts for OTP (Loop-delivered) or equivalent second factor.
   - Clearly explains:
     - Why an extra check is required.
3. On success:
   - Action continues.
4. On failure/timeout:
   - Action is blocked.
   - User sees a clear, non-technical error explanation.

UX must show that elevated access is deliberate and auditable.

## 4. Expected UX & Data Behavior

- Clarity:
  - Executive-only areas labeled as such (e.g. “Executive View”, “Restricted”).
  - When blocked:
    - Explain “You do not have executive access” rather than generic errors.
- Feedback:
  - On OTP prompts:
    - Provide progress and retry guidance.
  - On role-governed actions:
    - Indicate that changes are logged and may require approval (maker-checker).
- Auditability (visible hints):
  - For sensitive actions, UX may briefly indicate:
    - “This action is logged for security and compliance.”
    - Without exposing raw audit log contents to unauthorized parties.

## 5. Constraints & Guardrails

- Must:
  - Enforce:
    - No unauthenticated access to executive routes.
    - No non-executive → executive escalation via UI alone.
  - Keep messaging aligned with:
    - NileDB as identity provider,
    - Loop as OTP delivery channel (not decision engine),
    - Internal app as policy and audit authority.
- Must not:
  - Claim:
    - Control over NileDB’s internal security beyond documented configuration.
  - Expose:
    - Secrets, tokens, or sensitive identifiers in URLs, errors, or screens.
  - Provide:
    - “Hidden” URLs that bypass MFA/RBAC.

## 6. Story & Documentation Mapping

- Backlog:
  - BF-004: Executive Authentication and Security.
  - BF-010: Integration testing/story ensuring these flows are verifiable.
  - BF-012: Compliance and Audit Trail.
- Docs:
  - [`business-leaders-database-migration-guide.md`](docs/implementation-technical/database-infrastructure/business-leaders-database-migration-guide.md:1)
  - [`executive-api.md`](docs/implementation-technical/api/executive-api.md:1)
  - [`posthog-business-events-specification.md#security--compliance`](docs/implementation-technical/analytics-integration/posthog-business-events-specification.md:1)