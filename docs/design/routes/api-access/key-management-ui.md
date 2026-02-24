---
title: "API Key Management UI"
description: "Design specifications for the API key cards, generation modal, and permission matrix."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers, Designers"
---

# API Key Management UI

**User interface specifications for managing secure programmatic access.**

---

## 1. API Key Display

The primary interface for viewing and interacting with active keys.

### API Key Cards

- **Masking**: Keys are displayed as `pm_live_abc...xyz` (first 8 and last 3 chars visible).
- **Copy Button**: Single-click copy to clipboard.
- **Sudo Mode**: Require re-authentication before revealing the full key or editing permissions.

### Status Indicators

| Status | Visual | Meaning |
|--------|--------|---------|
| **Active** | Green Badge | Currently valid for API requests. |
| **Revoked** | Red Badge | Permanently disabled. |
| **Expired** | Gray Badge | Past its user-defined expiration date. |

---

## 2. Key Generation Modal

A multi-step modal for creating new secure credentials.

### Step 1: Basic Info

- **Name**: Required (e.g., "Production App").
- **Environment**: Production (`pm_live_...`) or Test (`pm_test_...`).

### Step 2: Permission Matrix

An expandable grid showing categories:

- **Campaigns**: Read, Write, Delete.
- **Contacts**: Read, Write, Delete.
- **Analytics**: Read, Export.
- **Emails**: Send, Send Bulk (requires approval).

### Step 3: Restrictions

- **IP Allowlist**: Optional CIDR ranges or single IPs.
- **Expiration**: Optional TTL (30 days, 1 year, Never).

---

## 3. Revocation & Rotation

- **Rotation**: Generates a new key while keeping the old one active for a 24-hour "grace period" to prevent downtime.
- **Revocation**: Immediate invalidation of the key across all global edge locations.
- **Audit Log**: Every key generation and revocation event is logged with the user's IP and timestamp.
