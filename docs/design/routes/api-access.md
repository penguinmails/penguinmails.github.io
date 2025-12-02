---
title: "API Access Routes"
description: "Route specifications for API key management and developer settings"
last_modified_date: "2025-11-25"
level: "3"
persona: "Developers"
---


# API Access Routes

## 1. Purpose & Context (The "Why")

- **Goal**: Enable developers to generate and manage API keys for programmatic access to PenguinMails.

- **Feature References**:

  - [API Access](/docs/features/integrations/api-access)

  - [API Documentation](/docs/implementation-technical/api/README)

- **User Journey**: Occasional access during integration setup and key rotation.

## 2. UI Patterns & Components (The "How")

- **Core Components**:

  - `APIKeyCard`: Display API key with masked value and copy button.

  - `KeyGenerationModal`: Create new API key with name and permissions.

  - `RateLimitIndicator`: Real-time rate limit usage display.

  - `CodeSnippet`: Syntax-highlighted code examples.

  - `PermissionMatrix`: Visual permission selector for API keys.

  - `UsageChart`: API usage analytics over time.

- **Analytics Patterns**: Request volume, endpoint usage, error rates.

- **Layout**: Settings Layout with sidebar navigation.

## 3. Route Specifications

| Route | Access | Purpose | State/Data Requirements |
|---|---|---|---|
| `/dashboard/settings/developers` | Admin, Developer | API Overview | List of API keys, rate limits, quick start guide. |
| `/dashboard/settings/developers/keys` | Admin, Developer | Key Management | Create, view, revoke API keys. |
| `/dashboard/settings/developers/docs` | Admin, Developer | API Docs | Interactive API documentation with examples. |
| `/dashboard/settings/developers/usage` | Admin, Developer | Usage Analytics | API request metrics, endpoint usage, error logs. |
| `/dashboard/settings/developers/webhooks` | Admin, Developer | Webhook Config | Webhook endpoints (links to ESP webhooks route). |

## 4. Detailed View Descriptions

### `/dashboard/settings/developers` - Developer Overview

**User Story**: *"As a developer, I want to quickly access API keys and documentation, so I can integrate PenguinMails into my application."*

**What You'll Find**:

#### Quick Start Section

**Getting Started Card**:

- **Title**: "Start Building with PenguinMails API"

- **Steps**:

  1. Generate an API key

  2. Install SDK (optional)

  3. Make your first API call

  4. Set up webhooks (optional)

**"Generate API Key" Button**: Opens key creation modal.

**Quick Links**:

- [View API Documentation →](/dashboard/settings/developers/docs)

- [Explore Code Examples →](/docs/design/routes/#code-examples)

- [Configure Webhooks →](/dashboard/settings/integrations/esp/webhooks)

#### Active API Keys

**API Keys Table** (Compact View):

- Columns: Name, Key (masked), Created, Last Used, Actions.

- **Key Display**: `pm_live_abc...xyz` (first 8 and last 3 chars visible).

- **Copy Button**: Copy full key to clipboard.

- **Actions**: View Details, Revoke.

**Example Rows**:

| Name | Key | Created | Last Used | Actions |
|------|-----|---------|-----------|---------|
| Production App | `pm_live_abc...xyz` | Nov 1, 2025 | 2 hours ago | View, Revoke |
| Staging Server | `pm_test_def...uvw` | Oct 15, 2025 | 5 days ago | View, Revoke |

**"+ Create New Key" Button**: Opens key generation modal.

**"Manage All Keys" Link**: Navigate to full key management page.

#### Rate Limit Status

**Current Usage Card**:

- **Plan**: "Professional Plan"

- **Rate Limit**: "300 requests/minute"

- **Current Usage**: Progress bar showing "45 / 300 (15%)"

- **Burst Capacity**: "500 requests"

- **Reset Time**: "Resets in 42 seconds"

**Upgrade Prompt** (if approaching limit):

- "Approaching rate limit. [Upgrade plan →](/dashboard/settings/billing) for higher limits."

#### API Documentation Quick Access

**Popular Endpoints** (Cards):

**Send Email**:

```http
POST /v1/emails/send
Authorization: Bearer pm_live_...


```

- View full docs link

**Manage Contacts**:

```http
POST /v1/contacts
Authorization: Bearer pm_live_...


```

- View full docs link

**Get Analytics**:

```http
GET /v1/analytics/campaigns/{id}
Authorization: Bearer pm_live_...


```

- View full docs link

#### SDK Installation

**Code Snippets** (Tabbed):

**Node.js**:

```bash
npm install @penguinmails/sdk


```

**Python**:

```bash
pip install penguinmails


```

**PHP**:

```bash
composer require penguinmails/sdk


```

**Status**: "Coming Q1 2026" (grayed out for unavailable SDKs).

**User Journey Context**: First stop for developers. Quick access to keys and documentation.

**Related Documentation**:

- [API Access Overview](/docs/features/integrations/api-access)

- [API Reference](/docs/implementation-technical/api/README)

---

### `/dashboard/settings/developers/keys` - API Key Management

**User Story**: *"As a developer, I want to manage multiple API keys with different permissions, so I can control access for different applications."*

**What You'll Find**:

#### API Keys List

**Filter Bar**:

- **Search**: Search by key name or ID.

- **Status Filter**: All, Active, Revoked.

- **Sort**: Created Date, Last Used, Name.

**API Key Cards** (Detailed View):

Each card displays:

**Key Name**: "Production App"

- **Key ID**: `pm_live_abc123def456...`

- **Copy Button**: Copy full key to clipboard.

- **"Show Key" Toggle**: Reveal full key temporarily (requires re-authentication).

**Status Badge**:

- **Active** (Green): Currently valid.

- **Revoked** (Red): No longer valid.

- **Expired** (Gray): Past expiration date.

**Metadata**:

- **Created**: "November 1, 2025 at 3:45 PM"

- **Created By**: "<john@company.com>"

- **Last Used**: "2 hours ago"

- **Expires**: "Never" or specific date.

**Permissions** (Expandable):

- ☑ **Read Campaigns**: View campaign data.

- ☑ **Write Campaigns**: Create and modify campaigns.

- ☑ **Read Contacts**: View contact lists.

- ☑ **Write Contacts**: Add and update contacts.

- ☑ **Send Emails**: Send transactional emails.

- ☐ **Admin Access**: Full account access (dangerous).

**Usage Stats**:

- **Total Requests**: "12,345"

- **Last 24 Hours**: "234 requests"

- **Error Rate**: "0.5%"

**Actions**:

- **"Edit Permissions" Button**: Opens permission editor.

- **"Rotate Key" Button**: Generates new key, revokes old one.

- **"Revoke Key" Button**: Permanently disables key (confirmation required).

- **"View Usage" Link**: Navigate to usage analytics for this key.

#### Create New API Key

**"+ Create API Key" Button**: Opens modal.

**Key Creation Modal**:

##### Step 1: Basic Information

- **Key Name**: Input field (e.g., "Production App", "Staging Server").

  - Help text: "Choose a descriptive name to identify this key."

- **Description** (optional): Textarea for notes.

- **Environment**: Radio buttons

  - ○ Production (`pm_live_...`)

  - ○ Test (`pm_test_...`)

##### Step 2: Permissions

**Permission Categories** (Expandable sections):

**Campaigns**:

- ☑ Read Campaigns

- ☑ Write Campaigns

- ☐ Delete Campaigns

**Contacts**:

- ☑ Read Contacts

- ☑ Write Contacts

- ☐ Delete Contacts

**Analytics**:

- ☑ Read Analytics

- ☐ Export Data

**Emails**:

- ☑ Send Emails

- ☐ Send Bulk Emails (requires approval)

**Admin** (Dangerous):

- ☐ Full Account Access

- ☐ Manage API Keys

- ☐ Manage Billing

**Preset Templates**:

- **"Read Only" Button**: Select all read permissions.

- **"Full Access" Button**: Select all permissions.

- **"Email Sending" Button**: Select email-related permissions only.

##### Step 3: Expiration (Optional)

- **Never Expire**: Radio button (default).

- **Expire After**: Radio button with date picker.

  - Options: 30 days, 90 days, 1 year, Custom date.

##### Step 4: IP Restrictions (Optional)

- **Allow All IPs**: Radio button (default).

- **Restrict to IPs**: Radio button with IP input.

  - Input: Comma-separated IP addresses or CIDR ranges.

  - Example: `203.0.113.0/24, 198.51.100.5`

**"Generate API Key" Button**: Creates key and displays it.

#### Key Generated Success

**Success Modal**:

- **Title**: "API Key Created Successfully"

- **Warning**: "⚠️ Copy this key now. You won't be able to see it again."

**Key Display**:

```text
pm_live_abc123def456ghi789jkl012mno345pqr678stu901vwx234yz


```

**Copy Button**: Copy to clipboard.

**Code Example** (Auto-generated):

```bash
curl -X GET https://api.penguinmails.com/v1/campaigns \
  -H "Authorization: Bearer pm_live_abc123..."


```

**"I've Saved My Key" Button**: Closes modal.

**User Journey Context**: Set up once per application/environment, rotate periodically for security.

**Related Documentation**:

- [API Authentication](/docs/features/integrations/api-access#authentication)

- [Security Best Practices](/docs/compliance-security/enterprise/overview)

**Technical Integration**:

- **Key Generation**: Cryptographically secure random string (64 chars).

- **Storage**: Hashed with bcrypt before storing in database.

- **Validation**: Keys validated on every API request.

---

### `/dashboard/settings/developers/docs` - Interactive API Documentation

**User Story**: *"As a developer, I want to explore API endpoints with live examples, so I can quickly understand how to integrate."*

**What You'll Find**:

#### API Documentation Browser

**Sidebar Navigation**:

- **Getting Started**

  - Authentication

  - Rate Limiting

  - Error Handling

- **Endpoints**

  - Emails

  - Campaigns

  - Contacts

  - Analytics

  - Webhooks

- **SDKs & Libraries**

- **Changelog**

#### Endpoint Documentation

##### Example: Send Email Endpoint

**Endpoint Header**:

```http
POST /v1/emails/send


```

**Authentication**: Required (Bearer Token)

**Rate Limit**: 60 requests/minute

**Description**:

"Send a single transactional or marketing email. Supports templates, variables, and tracking."

**Request Parameters**:

**Headers**:

```http
Authorization: Bearer pm_live_...
Content-Type: application/json


```

**Body** (JSON):

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `to` | string | Yes | Recipient email address |
| `from` | string | No | Sender email (defaults to account default) |
| `subject` | string | Yes* | Email subject (*required if not using template) |
| `html_body` | string | Yes* | HTML email body (*required if not using template) |
| `text_body` | string | No | Plain text version |
| `template_id` | string | No | Template ID (alternative to subject/body) |
| `variables` | object | No | Template variables |
| `track_opens` | boolean | No | Enable open tracking (default: true) |
| `track_clicks` | boolean | No | Enable click tracking (default: true) |
| `tags` | array | No | Tags for organization |

**Example Request**:

```json
{
  "to": "user@example.com",
  "template_id": "welcome-v1",
  "variables": {
    "name": "Alice",
    "company": "Acme Corp"
  },
  "tags": ["onboarding", "welcome"]
}


```

**Response** (200 OK):

```json
{
  "id": "msg_abc123",
  "status": "queued",
  "to": "user@example.com",
  "created_at": "2025-11-25T10:30:00Z"
}


```

**Error Responses**:

**401 Unauthorized**:

```json
{
  "error": "invalid_token",
  "message": "API key is invalid or expired"
}


```

**429 Too Many Requests**:

```json
{
  "error": "rate_limit_exceeded",
  "message": "Rate limit exceeded. Try again in 42 seconds.",
  "retry_after": 42
}


```

#### Try It Out

**Interactive API Tester**:

- **API Key**: Dropdown (select from your keys) or input field.

- **Request Body**: JSON editor with syntax highlighting.

- **"Send Request" Button**: Makes live API call.

- **Response Display**: Shows status code, headers, and body.

**Example**:

```json
// Request
{
  "to": "test@example.com",
  "subject": "Test Email",
  "html_body": "<h1>Hello World</h1>"
}

// Response (200 OK)
{
  "id": "msg_test123",
  "status": "queued"
}


```

#### Code Examples

**Language Tabs**: cURL, Node.js, Python, PHP, Ruby.

**cURL**:

```bash
curl -X POST https://api.penguinmails.com/v1/emails/send \
  -H "Authorization: Bearer pm_live_..." \
  -H "Content-Type: application/json" \
  -d '{
    "to": "user@example.com",
    "subject": "Hello",
    "html_body": "<h1>Hello World</h1>"
  }'


```

**Node.js** (Coming Soon):

```javascript
const penguinmails = require('@penguinmails/sdk');

const client = new penguinmails.Client('pm_live_...');

await client.emails.send({
  to: 'user@example.com',
  subject: 'Hello',
  html_body: '<h1>Hello World</h1>'
});


```

**Copy Button**: Copy code snippet to clipboard.

**User Journey Context**: Reference during integration development. Frequent visits during initial setup.

**Related Documentation**:

- [Full API Reference](/docs/implementation-technical/api/README)

- [Authentication Guide](/docs/features/integrations/api-access#authentication)

---

### `/dashboard/settings/developers/usage` - API Usage Analytics

**User Story**: *"As a developer, I want to monitor API usage and errors, so I can optimize my integration and troubleshoot issues."*

**What You'll Find**:

#### Usage Overview

**Time Range Selector**:

- Buttons: Last Hour, Last 24 Hours, Last 7 Days, Last 30 Days, Custom Range.

**Metrics Cards** (Top Row):

- **Total Requests**: "12,345"

- **Success Rate**: "99.5%"

- **Average Response Time**: "145ms"

- **Rate Limit Usage**: "15% of limit"

#### Request Volume Chart

**Line Chart**: Requests over time.

- **Y-Axis**: Number of requests.

- **X-Axis**: Time.

- **Lines**: Total, Success (200), Errors (4xx/5xx).

- **Hover**: Shows exact values at each point.

#### Endpoint Usage

**Top Endpoints Table**:

| Endpoint | Requests | Success Rate | Avg Response Time | Errors |
|----------|----------|--------------|-------------------|--------|
| `POST /v1/emails/send` | 8,234 | 99.8% | 120ms | 16 |
| `GET /v1/campaigns` | 2,456 | 100% | 85ms | 0 |
| `POST /v1/contacts` | 1,234 | 98.5% | 95ms | 18 |
| `GET /v1/analytics/campaigns/{id}` | 421 | 100% | 210ms | 0 |

**"View All Endpoints" Link**: Expands full list.

#### Error Analysis

**Error Breakdown** (Pie Chart):

- 400 Bad Request: 45%

- 401 Unauthorized: 30%

- 429 Rate Limit: 15%

- 500 Server Error: 10%

**Recent Errors Table**:

| Timestamp | Endpoint | Status | Error | Details |
|-----------|----------|--------|-------|---------|
| 2:34 PM | `POST /v1/emails/send` | 400 | `invalid_email` | "Recipient email is invalid" |
| 2:30 PM | `GET /v1/campaigns` | 401 | `invalid_token` | "API key expired" |
| 2:25 PM | `POST /v1/contacts` | 429 | `rate_limit` | "Rate limit exceeded" |

**"Export Error Log" Button**: Download CSV of errors.

#### Rate Limit Monitoring

**Rate Limit Usage Chart** (Line Chart):

- Shows rate limit usage over time.

- **Warning Line**: 80% of limit (yellow).

- **Critical Line**: 95% of limit (red).

**Rate Limit Events**:

- "Rate limit exceeded 3 times in the last 24 hours"

- "Peak usage: 285 / 300 requests/minute at 2:15 PM"

**Recommendation**:

- "Consider implementing request batching or upgrading your plan."

#### API Key Breakdown

**Usage by API Key** (Table):

| Key Name | Requests | Success Rate | Last Used |
|----------|----------|--------------|-----------|
| Production App | 10,234 | 99.8% | 2 hours ago |
| Staging Server | 2,111 | 98.2% | 5 hours ago |

**Filter**: Select specific API key to view its usage.

**User Journey Context**: Regular monitoring (daily/weekly) to ensure integration health.

**Related Documentation**:

- [Rate Limiting](/docs/features/integrations/api-access#rate-limiting)

- [Error Handling](/docs/implementation-technical/api/README#error-handling)

**Technical Integration**:

- **Data Source**: API gateway logs aggregated in real-time.

- **Caching**: Metrics cached for 1 minute.

- **Alerts**: Email alerts for high error rates or rate limit issues.

---

### `/dashboard/settings/developers/webhooks` - Webhook Configuration

**User Story**: *"As a developer, I want to configure webhooks to receive real-time event notifications."*

**What You'll Find**:

**Redirect Notice**:

"Webhook configuration has moved to [ESP Integration Settings →](/dashboard/settings/integrations/esp/webhooks)"

**Quick Links**:

- [Configure Postmark Webhooks →](/dashboard/settings/integrations/esp/webhooks#postmark)

- [Configure Mailgun Webhooks →](/dashboard/settings/integrations/esp/webhooks#mailgun)

- [View Webhook Documentation →](/docs/features/integrations/webhook-system)

**User Journey Context**: Quick redirect to centralized webhook management.

## 5. Related API Endpoints

| Route | Related API | Description |
|---|---|---|
| `/settings/developers` | [API Keys API](/docs/implementation-technical/api/platform-api/api-keys) | `GET /api/v1/platform/api-keys` (List keys). |
| `/settings/developers/keys` | [API Keys API](/docs/implementation-technical/api/platform-api/api-keys) | `POST /api/v1/platform/api-keys` (Create key), `DELETE` (Revoke). |
| `/settings/developers/usage` | [Analytics API](/docs/implementation-technical/api/tenant-api/analytics) | `GET /api/v1/tenant/analytics/api-usage` (Usage metrics). |

## 6. Data Strategy

- **Fetching Method**:

  - **API Keys List**: Server Component (sensitive data).

  - **Usage Analytics**: Client Component with SWR for real-time updates.

  - **Documentation**: Static content with interactive examples.

- **Caching**:

  - **API Keys**: No caching (always fresh).

  - **Usage Metrics**: Cached for 1 minute.

  - **Documentation**: Cached indefinitely (versioned).

- **Security**:

  - **API Keys**: Never exposed in full after creation.

  - **Key Rotation**: Old key remains valid for 24 hours after rotation.

  - **Sudo Mode**: Require re-authentication for key creation/revocation.

## 7. Edge Cases & Error Handling

- **Key Already Revoked**: Show "This key has already been revoked and cannot be used."

- **Rate Limit Exceeded**: Show "Rate limit exceeded. Upgrade plan for higher limits. [View plans →]"

- **Invalid Permissions**: Block API calls with "Insufficient permissions. Update key permissions in settings."

- **Key Expiration**: Email notification 7 days before expiration. Show warning in dashboard.

- **IP Restriction Violation**: Log security event, block request, alert admin.

## 8. Component Architecture

### Page Components

- **`DeveloperOverview`** (Server)

  - Features: Quick start, API keys summary, rate limit status.

- **`APIKeyManager`** (Client)

  - Features: Key list, create/revoke keys, permission editor.

- **`APIDocsBrowser`** (Client)

  - Features: Interactive documentation, code examples, API tester.

- **`UsageAnalytics`** (Client)

  - Features: Request charts, error analysis, rate limit monitoring.

### Shared Components

- **`APIKeyCard`**: Reused in overview and key management.

- **`CodeSnippet`**: Reused across documentation and examples.

- **`RateLimitIndicator`**: Reused in overview and usage analytics.

## 9. Related Documentation

### Feature Documentation

- **[API Access](/docs/features/integrations/api-access)** - API access overview and authentication

- **[Webhook System](/docs/features/integrations/webhook-system)** - Webhook configuration and events

- **[Rate Limiting](/docs/features/integrations/api-access#rate-limiting)** - Rate limit details

### Technical Documentation

- **[API Reference](/docs/implementation-technical/api/README)** - Complete API documentation

- **[Authentication](/docs/implementation-technical/api/platform-api/authentication)** - API authentication details

- **[API Keys API](/docs/implementation-technical/api/platform-api/api-keys)** - API key management endpoints

### User Journeys

- **[Developer Journey](/user-journeys/internal-users/technical-teams-journeys)** - API integration workflows

- **[Integration Setup](/user-journeys/external-users/business-owner-journeys#api-integration)** - API setup for business users

---

**Last Updated:** November 25, 2025
**API Version:** v1
**SDKs:** Coming Q1 2026

*API access routes provide comprehensive tools for developers to integrate PenguinMails programmatically with secure key management and real-time usage monitoring.*
