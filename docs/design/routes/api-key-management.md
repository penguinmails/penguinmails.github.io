---
title: "API Key Management Routes"
description: "Frontend route specifications for tenant API key creation, viewing, regeneration, and revocation with Vault integration"
last_modified_date: "2025-11-26"
level: "3"
persona: "Frontend Developers, Technical Teams"
keywords: ["routes", "API keys", "Vault", "authentication", "UI", "frontend"]
status: "PLANNED"
priority: "P0 - Critical"
---


# API Key Management Routes

## Overview

This document specifies the frontend routes for tenant API key management, enabling self-service creation, viewing, regeneration, and revocation of API keys for programmatic access to PenguinMails.

### Routes Summary

| Route | Purpose | Authentication | Permission |
|-------|---------|----------------|------------|
| `/dashboard/settings/developers/api-keys` | API key list and management | Required | Tenant user |
| `/dashboard/settings/developers/api-keys/create` | Create new API key (modal) | Required | Tenant user |
| `/dashboard/settings/developers/api-keys/{key_id}` | View API key details (modal) | Required | Tenant user |

---

## Route 1: API Key List

**Path:** `/dashboard/settings/developers/api-keys`

**Method:** GET

**Authentication:** Required (tenant user session)

**Layout:** Settings page with sidebar navigation

### Page Structure

```

┌─────────────────────────────────────────────────────────────┐
│ Settings Sidebar │ API Keys                                  │
├──────────────────┼───────────────────────────────────────────┤
│ Profile          │ ┌─────────────────────────────────────┐   │
│ Team             │ │ API Keys                            │   │
│ Billing          │ │                                     │   │
│ Infrastructure   │ │ Manage API keys for programmatic   │   │
│ > Developers     │ │ access to PenguinMails.            │   │
│   - API Keys     │ │                                     │   │
│   - Webhooks     │ │ [Create API Key]                   │   │
│ Security         │ └─────────────────────────────────────┘   │
│                  │                                            │
│                  │ ┌────────────────────────────────────────┐│
│                  │ │ Name          │ Key        │ Permissions││
│                  │ ├───────────────┼────────────┼────────────┤│
│                  │ │ Production    │ pm_live... │ [send]     ││
│                  │ │ Server        │            │ [analytics]││
│                  │ │               │            │            ││
│                  │ │ Last used: 2h ago  Requests: 15,234    ││
│                  │ │ [Copy] [Regenerate] [Revoke]           ││
│                  │ ├───────────────┼────────────┼────────────┤│
│                  │ │ Staging       │ pm_live... │ [send]     ││
│                  │ │ Environment   │            │            ││
│                  │ │ (Revoked)     │            │            ││
│                  │ │ Last used: 1d ago  Requests: 5,432     ││
│                  │ └────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘


```

### UI Components

#### 1. Page Header

**Elements:**

- Title: "API Keys"

- Description: "Manage API keys for programmatic access to PenguinMails."

- Primary action: "Create API Key" button (top right)

#### 2. API Key Table

**Columns:**

- **Name** - User-provided key name

- **Key** - Masked key value (`pm_live_abc...xyz`)

- **Permissions** - Badge list of scopes

- **Rate Limit** - Requests per minute

- **Status** - Active (green) or Revoked (red)

- **Last Used** - Relative time ("2 hours ago")

- **Actions** - Copy, Regenerate, Revoke buttons

**Row Details (expandable):**

- Created date

- Total requests (lifetime)

- Error count

- Request chart (last 7 days)

#### 3. Empty State

**Displayed when:** No API keys exist

**Content:**

- Icon: Key icon

- Title: "No API keys yet"

- Description: "Create your first API key to start using the PenguinMails API programmatically."

- Action: "Create API Key" button

#### 4. Table Actions

**Copy Button:**

- Copies masked key to clipboard

- Shows toast: "Key copied to clipboard"

- Note: Full key not available after creation

**Regenerate Button:**

- Opens confirmation modal

- Warning: "Old key will be revoked immediately"

- Generates new key with same permissions

- Displays new key once

**Revoke Button:**

- Opens confirmation modal

- Warning: "This action cannot be undone"

- Marks key as revoked

- Key remains visible but inactive

### API Calls

**Load API Keys:**

```typescript
GET /api/v1/platform/api-keys

Response:
{
  "api_keys": [
    {
      "key_id": "550e8400-e29b-41d4-a716-446655440000",
      "name": "Production Server",
      "masked_key": "pm_live_a1b...o5p6",
      "permissions": ["send_email", "read_analytics"],
      "rate_limit": 300,
      "status": "active",
      "created_at": "2025-11-26T10:00:00Z",
      "last_used": "2025-11-26T15:30:00Z",
      "request_count": 15234,
      "error_count": 42
    }
  ]
}


```

---

## Route 2: Create API Key Modal

**Trigger:** Click "Create API Key" button

**Modal Type:** Centered modal with backdrop

### Modal Structure

```

┌─────────────────────────────────────────────────┐
│ Create API Key                            [X]   │
├─────────────────────────────────────────────────┤
│                                                 │
│ Name *                                          │
│ ┌─────────────────────────────────────────────┐│
│ │ Production Server                           ││
│ └─────────────────────────────────────────────┘│
│                                                 │
│ Permissions *                                   │
│ ☑ Send emails (send_email)                     │
│ ☑ Read analytics (read_analytics)              │
│ ☑ Manage contacts (manage_contacts)            │
│ ☐ Manage campaigns (manage_campaigns)          │
│ ☐ Manage templates (manage_templates)          │
│                                                 │
│ Rate Limit                                      │
│ 300 requests per minute (Pro plan)             │
│                                                 │
│ [Cancel]                    [Generate Key]     │
└─────────────────────────────────────────────────┘


```

### Form Fields

**1. Name (required)**

- Type: Text input

- Placeholder: "e.g., Production Server, Staging Environment"

- Validation: 1-50 characters, alphanumeric and spaces

- Error: "Name is required" or "Name must be 1-50 characters"

**2. Permissions (required)**

- Type: Multi-select checkboxes

- Options:

  - `send_email` - Send emails via API

  - `read_analytics` - Read campaign and email analytics

  - `manage_contacts` - Create, update, delete contacts

  - `manage_campaigns` - Create, update, delete campaigns

  - `manage_templates` - Create, update, delete templates

  - `manage_domains` - Add, verify, delete domains

  - `read_inbox` - Read unified inbox messages

  - `manage_webhooks` - Configure webhooks

- Validation: At least one permission required

- Error: "Select at least one permission"

**3. Rate Limit (display only)**

- Shows tier-based rate limit

- Starter: 60 requests/min

- Pro: 300 requests/min

- Enterprise: 1000 requests/min

- Link: "Upgrade plan to increase rate limit"

### Modal Actions

**Cancel Button:**

- Closes modal without creating key

- No API call

**Generate Key Button:**

- Validates form fields

- Creates API key via API

- Opens "API Key Created" success modal

- Closes create modal

### API Call

```typescript
POST /api/v1/platform/api-keys

Request:
{
  "name": "Production Server",
  "permissions": ["send_email", "read_analytics", "manage_contacts"]
}

Response (201 Created):
{
  "api_key": "pm_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6",
  "key_id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Production Server",
  "permissions": ["send_email", "read_analytics", "manage_contacts"],
  "rate_limit": 300,
  "created_at": "2025-11-26T10:00:00Z",
  "warning": "Store this key securely. It will not be shown again."
}


```

---

## Route 3: API Key Created Success Modal

**Trigger:** After successful API key creation

**Modal Type:** Centered modal with backdrop (cannot close by clicking backdrop)

### Modal Structure

```

┌─────────────────────────────────────────────────┐
│ ⚠️ API Key Created                        [X]   │
├─────────────────────────────────────────────────┤
│                                                 │
│ Store this key securely. It will not be shown  │
│ again. If you lose it, you'll need to          │
│ regenerate a new key.                           │
│                                                 │
│ Your API Key                                    │
│ ┌─────────────────────────────────────────────┐│
│ │ pm_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6  📋││
│ └─────────────────────────────────────────────┘│
│                                                 │
│ [Copy Key]  [Download .env]                    │
│                                                 │
│ Quick Start                                     │
│ ┌─────────────────────────────────────────────┐│
│ │ cURL                                        ▼││
│ │ curl -X POST https://api.penguinmails.com  ││
│ │   -H "Authorization: Bearer pm_live_..."   ││
│ │   -H "Content-Type: application/json"      ││
│ │   -d '{"to": "user@example.com", ...}'     ││
│ └─────────────────────────────────────────────┘│
│                                                 │
│ [View Documentation]              [Done]       │
└─────────────────────────────────────────────────┘


```

### UI Components

**1. Warning Banner**

- Icon: ⚠️ Warning icon

- Text: "Store this key securely. It will not be shown again."

- Style: Yellow background, prominent

**2. API Key Display**

- Full API key value (plaintext)

- Copy button (clipboard icon)

- Monospace font

- Select-all on click

**3. Action Buttons**

- **Copy Key:** Copies API key to clipboard, shows toast

- **Download .env:** Downloads file with `PENGUINMAILS_API_KEY=pm_live_...`

**4. Code Examples**

- Tabbed interface: cURL, Node.js, Python, PHP

- Syntax highlighting

- Copy button for each example

- Pre-filled with actual API key

**5. Footer Actions**

- **View Documentation:** Opens API docs in new tab

- **Done:** Closes modal, returns to API key list

### Code Examples

**cURL:**

```bash
curl -X POST https://api.penguinmails.com/api/v1/emails/send \
  -H "Authorization: Bearer pm_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "recipient@example.com",
    "subject": "Test Email",
    "body": "Hello from PenguinMails API"
  }'


```

**Node.js:**

```javascript
const axios = require('axios');

const apiKey = 'pm_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';

axios.post('https://api.penguinmails.com/api/v1/emails/send', {
  to: 'recipient@example.com',
  subject: 'Test Email',
  body: 'Hello from PenguinMails API'
}, {
  headers: {
    'Authorization': `Bearer ${apiKey}`,
    'Content-Type': 'application/json'
  }
}).then(response => {
  console.log('Email sent:', response.data);
}).catch(error => {
  console.error('Error:', error.response.data);
});


```

**JavaScript/Node.js:**

```javascript
const axios = require('axios');

const apiKey = 'pm_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';

async function sendEmail() {
  try {
    const response = await axios.post(
      'https://api.penguinmails.com/api/v1/emails/send',
      {
        to: 'recipient@example.com',
        subject: 'Test Email',
        body: 'Hello from PenguinMails API'
      },
      {
        headers: {
          'Authorization': `Bearer ${apiKey}`,
          'Content-Type': 'application/json'
        }
      }
    );
    
    console.log('Email sent:', response.data);
  } catch (error) {
    console.error('Error:', error.response.data);
  }
}

sendEmail();


```

---

## Route 4: API Key Details Modal

**Trigger:** Click on API key row in table

**Modal Type:** Large centered modal with tabs

### Modal Structure

```

┌─────────────────────────────────────────────────┐
│ Production Server                         [X]   │
├─────────────────────────────────────────────────┤
│ [Overview] [Usage] [Security]                   │
├─────────────────────────────────────────────────┤
│                                                 │
│ Key ID: 550e8400-e29b-41d4-a716-446655440000   │
│ Masked Key: pm_live_a1b...o5p6          [Copy] │
│                                                 │
│ Permissions                                     │
│ [send_email] [read_analytics] [manage_contacts]│
│                                                 │
│ Rate Limit: 300 requests/min                   │
│ Status: Active                                  │
│                                                 │
│ Created: Nov 26, 2025 at 10:00 AM             │
│ Last Used: 2 hours ago                         │
│                                                 │
│ Usage Statistics                                │
│ Total Requests: 15,234                         │
│ Error Count: 42 (0.28%)                        │
│                                                 │
│ [Regenerate Key]  [Revoke Key]                 │
└─────────────────────────────────────────────────┘


```

### Tabs

**1. Overview Tab**

- Key metadata (ID, masked key, permissions, rate limit, status)

- Created and last used timestamps

- Usage statistics (total requests, error count)

- Actions (Regenerate, Revoke)

**2. Usage Tab**

- Requests per day chart (last 30 days)

- Error rate trend chart

- Top endpoints table (endpoint, request count, avg response time)

- Geographic distribution map (if available)

**3. Security Tab**

- Audit log (last 50 events)

- IP addresses used (last 10 unique IPs)

- Security recommendations

- Rotation reminder (if >90 days old)

### API Call

```typescript
GET /api/v1/platform/api-keys/{key_id}

Response (200 OK):
{
  "key_id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Production Server",
  "masked_key": "pm_live_a1b...o5p6",
  "permissions": ["send_email", "read_analytics", "manage_contacts"],
  "rate_limit": 300,
  "status": "active",
  "created_at": "2025-11-26T10:00:00Z",
  "last_used": "2025-11-26T15:30:00Z",
  "request_count": 15234,
  "error_count": 42,
  "usage_by_day": [
    { "date": "2025-11-26", "requests": 1234, "errors": 5 },
    { "date": "2025-11-25", "requests": 2345, "errors": 8 }
  ],
  "top_endpoints": [
    { "endpoint": "/api/v1/emails/send", "count": 12000, "avg_response_time_ms": 250 },
    { "endpoint": "/api/v1/analytics/campaigns", "count": 3234, "avg_response_time_ms": 150 }
  ]
}


```

---

## Route 5: Regenerate API Key Confirmation Modal

**Trigger:** Click "Regenerate" button

**Modal Type:** Small centered confirmation modal

### Modal Structure

```

┌─────────────────────────────────────────────────┐
│ ⚠️ Regenerate API Key?                    [X]   │
├─────────────────────────────────────────────────┤
│                                                 │
│ This will immediately revoke the old key and   │
│ generate a new one. Any applications using the │
│ old key will stop working until you update     │
│ them with the new key.                         │
│                                                 │
│ Key: Production Server                         │
│ Current Key: pm_live_a1b...o5p6                │
│                                                 │
│ [Cancel]                    [Regenerate Key]   │
└─────────────────────────────────────────────────┘


```

### Modal Actions

**Cancel Button:**

- Closes modal without regenerating

- No API call

**Regenerate Key Button:**

- Regenerates API key via API

- Opens "API Key Created" success modal with new key

- Closes confirmation modal

### API Call

```typescript
POST /api/v1/platform/api-keys/{key_id}/regenerate

Response (200 OK):
{
  "api_key": "pm_live_c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8",
  "key_id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Production Server",
  "permissions": ["send_email", "read_analytics", "manage_contacts"],
  "rate_limit": 300,
  "created_at": "2025-11-26T16:00:00Z",
  "warning": "Old key has been revoked. Update your application immediately."
}


```

---

## Route 6: Revoke API Key Confirmation Modal

**Trigger:** Click "Revoke" button

**Modal Type:** Small centered confirmation modal

### Modal Structure

```

┌─────────────────────────────────────────────────┐
│ ⚠️ Revoke API Key?                        [X]   │
├─────────────────────────────────────────────────┤
│                                                 │
│ This action cannot be undone. The key will be  │
│ permanently revoked and any applications using │
│ it will stop working immediately.              │
│                                                 │
│ Key: Production Server                         │
│ Current Key: pm_live_a1b...o5p6                │
│                                                 │
│ [Cancel]                         [Revoke Key]  │
└─────────────────────────────────────────────────┘


```

### Modal Actions

**Cancel Button:**

- Closes modal without revoking

- No API call

**Revoke Key Button:**

- Revokes API key via API

- Shows success toast: "API key revoked successfully"

- Refreshes API key list

- Closes confirmation modal

### API Call

```typescript
DELETE /api/v1/platform/api-keys/{key_id}

Response (200 OK):
{
  "message": "API key revoked successfully",
  "key_id": "550e8400-e29b-41d4-a716-446655440000",
  "revoked_at": "2025-11-26T16:30:00Z"
}


```

---

## State Management

### API Key List State

```typescript
interface APIKeyListState {
  apiKeys: APIKey[];
  loading: boolean;
  error: string | null;
  selectedKeyId: string | null;
  showCreateModal: boolean;
  showDetailsModal: boolean;
  showRegenerateModal: boolean;
  showRevokeModal: boolean;
}

interface APIKey {
  key_id: string;
  name: string;
  masked_key: string;
  permissions: string[];
  rate_limit: number;
  status: 'active' | 'revoked';
  created_at: string;
  last_used: string | null;
  request_count: number;
  error_count: number;
}


```

### Actions

```typescript
// Load API keys
async function loadAPIKeys(): Promise<void> {
  setState({ loading: true, error: null });
  try {
    const response = await fetch('/api/v1/platform/api-keys');
    const data = await response.json();
    setState({ apiKeys: data.api_keys, loading: false });
  } catch (error) {
    setState({ error: error.message, loading: false });
  }
}

// Create API key
async function createAPIKey(name: string, permissions: string[]): Promise<string> {
  const response = await fetch('/api/v1/platform/api-keys', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ name, permissions })
  });
  const data = await response.json();
  return data.api_key; // Return plaintext key
}

// Regenerate API key
async function regenerateAPIKey(keyId: string): Promise<string> {
  const response = await fetch(`/api/v1/platform/api-keys/${keyId}/regenerate`, {
    method: 'POST'
  });
  const data = await response.json();
  return data.api_key; // Return new plaintext key
}

// Revoke API key
async function revokeAPIKey(keyId: string): Promise<void> {
  await fetch(`/api/v1/platform/api-keys/${keyId}`, {
    method: 'DELETE'
  });
  await loadAPIKeys(); // Refresh list
}


```

---

## Error Handling

### API Errors

**401 Unauthorized:**

- Redirect to login page

- Show toast: "Session expired. Please log in again."

**403 Forbidden:**

- Show error message: "You don't have permission to manage API keys."

- Disable "Create API Key" button

**429 Too Many Requests:**

- Show error message: "Rate limit exceeded. Please try again in a few minutes."

- Disable action buttons temporarily

**500 Internal Server Error:**

- Show error message: "Something went wrong. Please try again later."

- Log error to monitoring system

### Validation Errors

**Name field:**

- Empty: "Name is required"

- Too long: "Name must be 50 characters or less"

**Permissions field:**

- None selected: "Select at least one permission"

### Network Errors

**Connection failed:**

- Show error message: "Unable to connect. Check your internet connection."

- Retry button

**Timeout:**

- Show error message: "Request timed out. Please try again."

- Retry button

---

## Security Considerations

### 1. API Key Display

**Problem:** Displaying full API key after creation exposes it to shoulder surfing.

**Solution:**

- Display key only once in modal

- Require explicit user action to view (cannot close modal accidentally)

- Warn user to store securely

- Never display full key again (only masked)

### 2. Copy to Clipboard

**Problem:** Clipboard can be accessed by malicious browser extensions.

**Solution:**

- Use secure clipboard API (`navigator.clipboard.writeText()`)

- Show toast confirmation

- Clear clipboard after 60 seconds (optional, may annoy users)

### 3. Download .env File

**Problem:** Downloaded files can be accidentally committed to version control.

**Solution:**

- Include comment in .env file: "# DO NOT COMMIT THIS FILE TO VERSION CONTROL"

- Suggest adding `.env` to `.gitignore`

- Link to security best practices documentation

### 4. Modal Security

**Problem:** User might close modal accidentally before copying key.

**Solution:**

- Disable backdrop click to close

- Require explicit "Done" button click

- Show confirmation if user tries to close without copying

### 5. Regenerate Confirmation

**Problem:** Accidental regeneration breaks existing integrations.

**Solution:**

- Require explicit confirmation

- Show warning about immediate revocation

- Display key name and masked value for verification

---

## Accessibility

### Keyboard Navigation

- Tab through all interactive elements

- Enter/Space to activate buttons

- Escape to close modals

- Arrow keys to navigate table rows

### Screen Reader Support

- ARIA labels for all buttons and inputs

- ARIA live regions for toast notifications

- ARIA descriptions for complex interactions

- Semantic HTML (table, form, button elements)

### Visual Accessibility

- High contrast colors (WCAG AA compliant)

- Focus indicators on all interactive elements

- Error messages with icons and text

- Loading states with spinners and text

---

## Related Documentation

### Planning

- [Feature Documentation - Tenant API Key System](/docs/features/integrations/vault-api-keys)

- [Vault Integration Architecture](/.kiro/specs/feature-completeness-review/findings/vault-integration-architecture.md)

### Implementation

- [Task 11.6 - Tenant API Key System](/.kiro/specs/feature-completeness-review/tasks.md#116-implement-tenant-api-key-system-with-vault)

- [API Access Feature](/docs/features/integrations/api-access)

### Reference

- [Frontend Routing Map](/docs/design/frontend-routing-map) - Master route registry

- [Component Library](/docs/design/component-library) - Reusable UI components

- [Design System](/docs/design/design-system) - Design tokens and patterns

---

**Last Updated:** November 26, 2025  
**Document Version:** 1.0  
**Status:** PLANNED  
**Priority:** P0 - Critical

*This route specification provides comprehensive UI/UX guidance for implementing the API key management interface. All implementation must reference the [Tenant API Key System feature documentation](/docs/features/integrations/vault-api-keys) for backend integration and security requirements.*
