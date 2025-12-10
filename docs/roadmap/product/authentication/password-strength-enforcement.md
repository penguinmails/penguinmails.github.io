---
title: "Password Strength Enforcement"
description: "Strong password policies and breach checks"
---

# Password Strength Enforcement

## Overview

**Priority**: P0 (MVP blocker)
**Effort**: Small (1-2 days)
**Timeline**: Q1 2026

**Description**:
Implement server-side password validation to prevent users from choosing weak passwords. Reject passwords from common breach databases and enforce complexity requirements.

**Acceptance Criteria**:

- Server-side validation on signup, password reset, and password change
- Enforce minimum requirements: 8+ characters, uppercase, lowercase, number
- Reject passwords from Have I Been Pwned API
- Reject passwords containing user's email or name
- Return clear error messages explaining rejection reasons

**Dependencies**:

- Have I Been Pwned API
