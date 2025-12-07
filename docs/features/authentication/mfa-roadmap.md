---
title: "Multi-Factor Authentication (MFA) Roadmap"
description: "Detailed roadmap for implementing Multi-Factor Authentication (MFA) including TOTP, backup codes, and future biometric support"
last_modified_date: "2025-12-07"
level: "2"
persona: "Product Managers, Security Teams"
status: "PLANNED"
category: "Security"
roadmap_timeline: "Q1 2026"
---

# Multi-Factor Authentication (MFA) Roadmap

## Overview

This document outlines the implementation plan for Multi-Factor Authentication (MFA) to enhance account security for PenguinMails users. MFA is a critical security feature that adds a second layer of protection beyond passwords.

**Status:** ⏳ Planned
**Target Release:** Q1 2026
**Priority:** High (Enterprise Requirement)

---

## Phase 1: TOTP Implementation (Q1 2026)

The initial release will focus on Time-based One-Time Password (TOTP) support, which is the industry standard for 2FA.

### Core Features

1. **Authenticator App Support**
    * Support for standard TOTP apps (Google Authenticator, Authy, 1Password, etc.)
    * QR code generation for easy setup
    * Secret key display for manual entry

2. **Backup Codes**
    * Generate a set of 10 one-time use backup codes upon setup
    * Required download/copy step before enabling MFA
    * UI to regenerate backup codes if lost or used

3. **Login Flow Integration**
    * MFA challenge screen after successful password validation
    * "Trust this device for 30 days" option
    * Rate limiting on MFA attempts to prevent brute force

4. **Recovery Flows**
    * Use backup code for login if device is lost
    * Admin override for manual MFA reset (with strict identity verification)

### Technical Implementation

* **Algorithm:** HMAC-based One-Time Password (HOTP) / Time-based One-Time Password (TOTP) (RFC 6238)
* **Library:** `otplib` or compatible Node.js library
* **Storage:** Encrypted TOTP secrets in `users` table (never store plain secrets)

---

## Phase 2: Organization Enforcement (Q2 2026)

Enable organization admins to enforce security policies across their teams.

### Features

1. **Enforcement Policy**
    * Tenant-level setting: "Require MFA for all users"
    * Grace period for existing users to set up MFA
    * Block access to non-compliant users after grace period

2. **Admin Visibility**
    * Dashboard showing MFA status for all team members
    * Alerts for users without MFA in enforced organizations

---

## Phase 3: Advanced Methods (Q4 2026+)

Future enhancements to support hardware keys and biometrics.

### Planned Features

1. **WebAuthn / FIDO2**
    * Support for hardware security keys (YubiKey, Titan)
    * Platform authenticators (Touch ID, Face ID, Windows Hello)

2. **SMS / Email OTP (Low Priority)**
    * *Note:* SMS is considered less secure (NIST guidelines) and will be deprioritized in favor of TOTP and WebAuthn.

---

## User Stories

### User Setup
>
> "As a user, I want to secure my account with Google Authenticator so that even if my password is stolen, my account remains safe."

### Device Loss
>
> "As a user who lost my phone, I want to use a backup code to log in and disable MFA so I can set it up on my new device."

### Enterprise Admin
>
> "As an organization admin, I want to mandate MFA for all my employees to ensure our company data is protected from compromised credentials."

---

## Dependencies

* **User Authentication System:** Must be fully stable (Phase 1 complete)
* **Database Schema:** Migration required to add `mfa_secret`, `mfa_enabled`, and `backup_codes` columns to users table
* **Frontend Components:** QR code renderer, input verification UI

## Related Documentation

* [Authentication Roadmap](/docs/features/authentication/authentication-roadmap.md)
* [Security Features](/docs/features/compliance/security-features.md)
