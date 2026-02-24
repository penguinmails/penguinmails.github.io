---
title: "Profile & Preferences"
description: "User profile management, account settings, and regional preferences."
last_modified_date: "2026-02-24"
level: "2"
persona: "Developers"
---

# Profile & Preferences

Users can manage their individual identity and platform experience through profile settings and preference configurations.

## 1. Profile Management

View and update core user information.

**Fetch Profile:**

```javascript
GET /api/v1/users/me
Authorization: Bearer {access_token}

Response:
{
  "user_id": "user_abc123",
  "email": "user@example.com",
  "name": "John Doe",
  "tenant_id": "tenant_xyz789",
  "role": "owner",
  "email_verified": true,
  "created_at": "2025-11-01T10:00:00Z",
  "preferences": {
    "timezone": "America/Los_Angeles",
    "date_format": "MM/DD/YYYY"
  }
}
```

**Update Profile:**

```javascript
PUT /api/v1/users/me
{
  "name": "John Smith",
  "preferences": {
    "timezone": "America/New_York",
    "date_format": "YYYY-MM-DD"
  }
}
```

**Changing Email:**
Requires confirming the current password and re-verifying the new email address.
`POST /api/v1/users/me/change-email`

## 2. User Preferences

Granular control over the platform experience.

```javascript
{
  "preferences": {
    "timezone": "America/Los_Angeles",
    "date_format": "MM/DD/YYYY",
    "time_format": "12h",
    "language": "en",
    "email_notifications": true,
    "campaign_alerts": true,
    "weekly_reports": true,
    "billing_alerts": true,
    "default_workspace": "ws_abc123",
    "theme": "dark"
  }
}
```

## 3. Password Management (Authenticated)

Users can update their password while logged in by providing their current credentials.

```javascript
POST /api/v1/auth/change-password
{
  "current_password": "OldPass123!",
  "new_password": "NewPass456!"
}
```

**Requirements:**

- Minimum 8 characters.
- Uppercase, lowercase, number, and special character suggested.
