---
title: "Attachment Support Documentation"
description: "Document how inbox attachments integrate with the existing Content Database schema"
last_modified_date: "2025-12-09"
level: "3"
persona: "Engineering Teams"
parent: "/docs/roadmap/product/inbox/README.md"
---

# Attachment Support Documentation

## Overview

**Priority**: P2 (MVP Nice-to-Have)
**Timeline**: Q1 2026
**Effort**: 1-2 days (documentation only)

**Description**:
Document how inbox attachments integrate with the existing Content Database schema. Content Database has complete `attachments` table schema, but inbox feature docs don't reference it.

## Acceptance Criteria

- Update inbox docs to reference Content DB attachments table
- Document file size limits (recommend 25 MB per attachment)
- Document virus scanning approach (ClamAV or cloud service)
- Add file upload UI specifications to route docs
- Add attachment display specifications to conversation view

## Dependencies

- None (Content DB schema already exists)
