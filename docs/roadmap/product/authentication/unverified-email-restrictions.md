---
title: "Unverified Email Restrictions"
description: "Limit access for unverified users"
---

# Unverified Email Restrictions

## Overview

**Priority**: P0 (MVP blocker)
**Effort**: Small (1-2 days)
**Timeline**: Q1 2026

**Description**:
Enforce restrictions on unverified users to prevent platform abuse. Users must verify email before accessing core features like sending campaigns.

**Acceptance Criteria**:

- Block unverified users from sending campaigns
- Block unverified users from adding team members
- Block unverified users from accessing billing settings
- Display persistent banner: "Please verify your email to unlock all features"
- Implement 24-hour grace period before hard restrictions

**Dependencies**:

- Email verification status
