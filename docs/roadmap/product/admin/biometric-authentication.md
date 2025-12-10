---
title: "Biometric Authentication"
description: "WebAuthn/Passkey support for passwordless login"
---

# Biometric Authentication

## Overview

**Priority**: P3 (Future)
**Effort**: Medium (3 weeks)
**Timeline**: Q4 2026

**Description**:
Implement WebAuthn/Passkey support for passwordless login using TouchID, FaceID, or YubiKey.

**Features**:

- **Passkey Registration**: Register device authenticator.
- **Passwordless Login**: Login with biometric verification.
- **Multi-Device Support**: Sync passkeys across devices (via OS).
- **Fallback Methods**: Password or recovery code fallback.

**Dependencies**:

- Auth service
- WebAuthn library
