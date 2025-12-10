---
title: "Two-Factor Authentication (2FA)"
description: "TOTP, backup codes, and future biometric support"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Teams"
parent: "/docs/roadmap/product/authentication/README.md"
---

# Two-Factor Authentication (2FA)

## Overview

**Priority**: High (Enterprise Requirement)
**Timeline**: Q1 2026 (Phase 1)
**Effort**: Medium

**Description**:
Implementation of Multi-Factor Authentication (MFA) to enhance account security, starting with TOTP and expanding to hardware keys.

## Phase 1: TOTP Implementation (Q1 2026)

### Core Features

- **Authenticator App Support**: Google Authenticator, Authy, etc.
- **QR Code Setup**: Easy scanning for setup.
- **Backup Codes**: 10 one-time use codes for recovery.
- **Login Integration**: MFA challenge after password.
- **Trusted Devices**: "Trust this device for 30 days".
- **Recovery Flows**: Admin override and backup code usage.

### Technical Implementation

- **Algorithm**: TOTP (RFC 6238)
- **Storage**: Encrypted secrets in `users` table.

## Phase 2: Organization Enforcement (Q2 2026)

### Features

- **Enforcement Policy**: Tenant-level "Require MFA" setting.
- **Grace Period**: Configurable transition time.
- **Admin Visibility**: Dashboard of MFA status.

## Phase 3: Advanced Methods (Q4 2026+)

### Planned Features

- **WebAuthn / FIDO2**: Hardware keys (YubiKey) and platform authenticators (Touch ID).
- **SMS / Email OTP**: Deprioritized due to security concerns.

## User Stories

- "As a user, I want to secure my account with Google Authenticator."
- "As a user who lost my phone, I want to use a backup code."
- "As an admin, I want to mandate MFA for all employees."

## Dependencies

- User Authentication System
- Database Schema Migration (`mfa_secret`, `mfa_enabled`, `backup_codes`)
