---
title: "In-House Transactional Email System"
description: "Central SMTP server for transactional emails"
level: "2"
last_modified_date: "2026-02-24"
---

# In-House Transactional Email System

## Overview

**Priority**: P3 (Post-MVP)
**Effort**: High (2-3 weeks)
**Timeline**: Q3 2026

**Description**:
Replace Loop.so with central SMTP server for transactional emails (report delivery) to optimize costs at scale.

**Acceptance Criteria**:

- Build central SMTP server for transactional emails
- Implement template management system
- Add delivery tracking and analytics
- Migrate scheduled report delivery to in-house system
- Implement bounce and complaint handling
- Add email authentication (SPF, DKIM, DMARC)

**Dependencies**:

- Infrastructure readiness
- Volume threshold reached (>50K emails/month)
