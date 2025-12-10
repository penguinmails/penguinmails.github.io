---
title: "Two-Factor Authentication (2FA)"
description: "TOTP-based two-factor authentication"
---

# Two-Factor Authentication (2FA)

## Overview

**Priority**: P2 (Post-MVP)
**Effort**: Medium (2 weeks)
**Timeline**: Q2 2026

**Description**:
Implement TOTP-based two-factor authentication (Google Authenticator, Authy).

**Features**:

- **TOTP Setup**: QR code generation, secret key display.
- **Verification**: Code entry during login.
- **Recovery Codes**: Generate and download backup codes.
- **Enforcement**: Optional for users, mandatory for admins.
- **Remember Device**: "Trust this device for 30 days" option.

**Dependencies**:

- Auth service
- TOTP library
