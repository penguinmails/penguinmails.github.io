---
title: "CAPTCHA Protection"
description: "Bot prevention for sensitive forms"
level: "2"
last_modified_date: "2026-02-24"
---

# CAPTCHA Protection

## Overview

**Priority**: P0 (MVP blocker)
**Effort**: Small (2-3 days)
**Timeline**: Q1 2026

**Description**:
Implement CAPTCHA protection for registration, password reset, and after failed login attempts using Cloudflare Turnstile or hCaptcha.

**Acceptance Criteria**:

- CAPTCHA on registration form
- CAPTCHA on password reset form
- CAPTCHA after 3 failed login attempts
- Invisible CAPTCHA for low-risk users
- Audio CAPTCHA alternative for accessibility

**Dependencies**:

- Cloudflare Turnstile / hCaptcha
