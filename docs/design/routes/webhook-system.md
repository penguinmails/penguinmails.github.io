---
title: "Webhook System Routes"
description: "Route specifications for custom webhook configuration and event management"
last_modified_date: "2025-11-25"
level: "3"
persona: "Developers"
status: "PLANNED"
roadmap_timeline: "Q1 2026"
---

# Webhook System Routes

## 1. Purpose & Context (The "Why")

- **Goal**: Enable developers to configure custom webhooks for real-time event notifications from PenguinMails.

- **Feature References**:

  - [Webhook System](/docs/features/integrations/webhook-system)

  - [API Access](/docs/features/integrations/api-access)

  - [ESP Integration](/docs/features/integrations/esp-integration)

- **User Journey**: Set up once during integration, monitor regularly for delivery health.

## 2. UI Patterns & Components (The "How")

- **Core Components**:

  - `WebhookCard`: Display webhook with status, events, and quick actions.

  - `EventSelector`: Multi-select checkbox tree for event subscriptions.

  - `WebhookTester`: Send test events and view responses.

  - `DeliveryLog`: Real-time webhook delivery log with filtering.

  - `SignatureVerifier`: Code generator for signature verification.

  - `EventReplay`: Time-range selector for replaying historical events.

- **Analytics Patterns**: Delivery success rate, response times, error analysis.

- **Layout**: Settings Layout with sidebar navigation.

## 3. Route Specifications

| Route | Access | Purpose | State/Data Requirements |
|---|---|---|---|
| `/dashboard/settings/webhooks` | Admin, Developer | Webhook Overview | List of webhooks, quick stats, create button. |
| `/dashboard/settings/webhooks/create` | Admin, Developer | Create Webhook | Form: Name, URL, Events, Filters. |
| `/dashboard/settings/webhooks/:id` | Admin, Developer | Webhook Details | Configuration, delivery log, test interface. |
| `/dashboard/settings/webhooks/:id/edit` | Admin, Developer | Edit Webhook | Update configuration and event subscriptions. |
| `/dashboard/settings/webhooks/:id/deliveries` | Admin, Developer | Delivery Log | Detailed delivery history with filtering. |
| `/dashboard/settings/webhooks/:id/test` | Admin, Developer | Test Webhook | Send test events, view request/response. |
| `/dashboard/settings/webhooks/events` | Admin, Developer | Event Reference | Documentation of all available events. |

## 4. Detailed View Descriptions

### `/dashboard/settings/webhooks` - Webhook Overview

**User Story**: *"As a developer, I want to see all configured webhooks and their health status, so I can quickly identify and fix issues."*

**What You'll Find**:

#### Overview Stats

**Metrics Cards** (Top Row):

- **Active Webhooks**: "3"

- **Events Delivered Today**: "12,345"

- **Success Rate**: "99.2%"

- **Failing Webhooks**: "0" (Red if > 0)

#### Webhook List

**Webhook Cards** (Grid or List View):

Each card displays:

**Webhook Name**: "CRM Contact Sync"

- **Endpoint**: `https://yourapp.com/webhooks/penguinmails`

- **Status Badge**:

  - **Active** (Green): Receiving events successfully.

  - **Paused** (Gray): Manually disabled.

  - **Failing** (Red): Recent delivery failures.

  - **Inactive** (Gray): Auto-paused after 100 failures.

**Event Subscriptions**:

- "Subscribed to 7 events: email.opened, email.clicked, ..."

- **"View All" Link**: Expands full event list.

**Health Indicators**:

- **Success Rate**: "99.2%" (Last 24 hours)

- **Last Delivery**: "2 minutes ago"

- **Failed Deliveries**: "3 in last 24 hours"

**Quick Actions**:

- **Test** button: Send test event.

- **Pause/Resume** toggle.

- **View Details** link.

- **Delete** button (with confirmation).

**"+ Create Webhook" Button**: Navigate to webhook creation.

#### Quick Filters

**Filter Bar**:

- **Status**: All, Active, Paused, Failing.

- **Events**: Filter by subscribed event types.

- **Search**: Search by name or endpoint URL.

#### ESP Webhooks Notice

**Info Banner**:

"Looking for ESP webhooks (Postmark, Mailgun)? [Configure ESP webhooks â†’](/dashboard/settings/integrations/esp/webhooks)"

**User Journey Context**: Regular monitoring (daily/weekly) to ensure webhook health.

**Related Documentation**:

- [Webhook System Overview](/docs/features/integrations/webhook-system)

- [Event Reference](/docs/features/integrations/webhook-system#event-reference)

---

### `/dashboard/settings/webhooks/create` - Create Webhook

**User Story**: *"As a developer, I want to create a webhook to receive real-time notifications, so I can integrate PenguinMails with my application."*

**What You'll Find**:

#### Webhook Creation Form

#### Step 1: Basic Configuration

**Webhook Name**:

- **Input Field**: Text input (e.g., "CRM Contact Sync").

- **Help Text**: "Choose a descriptive name to identify this webhook."

**Description** (Optional):

- **Textarea**: Additional notes about webhook purpose.

**Endpoint URL**:

- **Input Field**: URL input (e.g., `https://yourapp.com/webhooks/penguinmails`).

- **Validation**: Must be HTTPS (HTTP allowed for localhost testing).

- **Help Text**: "Your server endpoint that will receive webhook events."

**Status**:

- **Radio Buttons**:

  - â—‹ Active (Start receiving events immediately)

  - â—‹ Paused (Create but don't send events yet)

#### Step 2: Event Selection

**Event Categories** (Expandable Sections):

**Email Events**:

- â˜‘ **email.sent** - Email queued for sending

- â˜‘ **email.delivered** - Email successfully delivered

- â˜‘ **email.opened** - Recipient opened email

- â˜‘ **email.clicked** - Recipient clicked link

- â˜‘ **email.bounced** - Email bounced (hard or soft)

- â˜ **email.spam_reported** - Marked as spam

- â˜ **email.unsubscribed** - Recipient unsubscribed

**Campaign Events**:

- â˜ **campaign.launched** - Campaign started sending

- â˜ **campaign.completed** - Campaign finished

- â˜ **campaign.paused** - Campaign paused by user

**Contact Events**:

- â˜ **contact.created** - New contact added

- â˜ **contact.updated** - Contact information updated

- â˜ **contact.unsubscribed** - Contact unsubscribed from all

**Quick Select Buttons**:

- **"Select All"**: Check all events.

- **"Email Events Only"**: Select all email events.

- **"Clear All"**: Uncheck all events.

**Event Preview**:

"You've selected 5 events. [View sample payloads â†’](/docs/design/routes/#event-samples)"

#### Step 3: Event Filters (Optional)

**Advanced Filtering Section** (Expandable):

**Filter by Workspace**:

- **Dropdown**: Select specific workspaces (default: All).

- **Multi-select**: Choose multiple workspaces.

**Filter by Campaign**:

- **Dropdown**: Select specific campaigns (default: All).

- **Help Text**: "Only receive events from selected campaigns."

**Filter by Contact Tags**:

- **Tag Input**: Enter tags (e.g., "vip", "premium").

- **Help Text**: "Only receive events for contacts with these tags."

**Custom JSON Filters** (Advanced):

```json
{
  "contact.tags": ["vip", "premium"],
  "campaign.type": "promotional",
  "email.opened_count": { "$gte": 3 }
}

```

**"Test Filter" Button**: Validate filter syntax.

#### Step 4: Security & Retry Configuration

**Signature Verification**:

- **Auto-generated Secret**: `whsec_abc123...` (shown after creation).

- **Help Text**: "Use this secret to verify webhook signatures."

**Retry Configuration**:

- **Enable Retries**: Toggle (default: On).

- **Max Retry Attempts**: Number input (1-10, default: 5).

- **Retry Delays**: "1m, 5m, 15m, 1h, 24h" (exponential backoff).

**Timeout**:

- **Response Timeout**: Number input (1-30 seconds, default: 5).

- **Help Text**: "Webhook must respond within this time."

**IP Whitelist** (Optional):

- **Webhook Source IPs**: Display PenguinMails IP ranges.

- **Copy Button**: Copy IP list for firewall configuration.

#### Step 5: Test Before Saving

**Test Webhook Section**:

- **"Send Test Event" Button**: Sends sample event to endpoint.

- **Event Type**: Dropdown (select which event to test).

- **Use Sample Data**: Checkbox (default: On).

**Test Result Display**:

```text
Sending test event to https://yourapp.com/webhooks...

âœ“ Test successful!
  Status: 200 OK
  Response Time: 142ms
  Response Body: "OK"

```

**Or Error**:

```text
âœ— Test failed
  Status: 500 Internal Server Error
  Error: Connection timeout

[Retry Test] [Save Anyway]

```

**"Create Webhook" Button**: Saves webhook configuration.

#### Webhook Created Success

**Success Modal**:

- **Title**: "Webhook Created Successfully"

- **Webhook ID**: `wh_abc123`

- **Secret Key**: `whsec_def456...` (shown once)

- **Warning**: "âš ï¸ Save this secret key. You won't be able to see it again."

**Copy Buttons**:

- Copy Webhook ID

- Copy Secret Key

**Next Steps**:

- [View Webhook Details â†’](/dashboard/settings/webhooks/wh_abc123)

- [View Code Examples â†’](/docs/design/routes/#code-examples)

- [Test Webhook â†’](/dashboard/settings/webhooks/wh_abc123/test)

**User Journey Context**: One-time setup per integration, occasional updates for new event types.

**Related Documentation**:

- [Webhook Creation Guide](/docs/features/integrations/webhook-system#create-your-first-webhook)

- [Event Reference](/docs/features/integrations/webhook-system#event-reference)

**Technical Integration**:

- **Secret Generation**: Cryptographically secure random string.

- **Signature**: HMAC-SHA256 with secret key.

- **Storage**: Secret hashed before storing in database.

---

### `/dashboard/settings/webhooks/:id` - Webhook Details

**User Story**: *"As a developer, I want to view webhook configuration and delivery history, so I can monitor and troubleshoot my integration."*

**What You'll Find**:

#### Webhook Header

**Webhook Name**: "CRM Contact Sync"

- **Status Badge**: Active (Green) or Failing (Red).

- **Actions**: Edit, Test, Pause/Resume, Delete.

**Endpoint**: `https://yourapp.com/webhooks/penguinmails`

- **Copy Button**: Copy URL to clipboard.

**Created**: "November 1, 2025 by <john@company.com>"

#### Configuration Summary

**Event Subscriptions** (Expandable):

- email.sent

- email.delivered

- email.opened

- email.clicked

- email.bounced

**"Edit Events" Link**: Navigate to edit page.

**Event Filters** (if configured):

```json
{
  "workspaces": ["Client A", "Client B"],
  "contact.tags": ["vip"]
}

```

**"Edit Filters" Link**: Navigate to edit page.

**Security Settings**:

- **Secret Key**: `whsec_...xyz` (masked, "Show" toggle requires re-auth).

- **"Rotate Secret" Button**: Generate new secret, revoke old one.

- **Retry Attempts**: "5 attempts with exponential backoff"

- **Timeout**: "5 seconds"

#### Health & Performance

**Delivery Stats** (Last 24 Hours):

- **Total Deliveries**: "1,234"

- **Successful**: "1,223 (99.1%)"

- **Failed**: "11 (0.9%)"

- **Average Response Time**: "145ms"

**Success Rate Chart** (Line Chart):

- Shows success rate over time (last 7 days).

- **Y-Axis**: Success percentage (0-100%).

- **X-Axis**: Time.

**Response Time Chart** (Line Chart):

- Shows average response time over time.

- **Warning Line**: 1000ms (yellow).

- **Critical Line**: 3000ms (red).

#### Recent Deliveries

**Delivery Log Table** (Last 50):

| Timestamp | Event Type | Status | Response Time | Actions |
|-----------|------------|--------|---------------|---------|
| 2:34 PM | email.opened | âœ“ 200 OK | 142ms | View |
| 2:33 PM | email.clicked | âœ“ 200 OK | 156ms | View |
| 2:30 PM | email.bounced | âœ— 500 Error | 5000ms | Retry |

**Filters**:

- **Status**: All, Success, Failed, Pending Retry.

- **Event Type**: Dropdown filter.

- **Date Range**: Date picker.

**"View Full Log" Link**: Navigate to detailed delivery log.

#### Quick Actions

**Test Webhook**:

- **"Send Test Event" Button**: Opens test modal.

**Pause Webhook**:

- **"Pause Webhook" Button**: Stop sending events temporarily.

**Rotate Secret**:

- **"Rotate Secret Key" Button**: Generate new secret (requires confirmation).

**Delete Webhook**:

- **"Delete Webhook" Button**: Permanently remove webhook (requires confirmation).

**User Journey Context**: Regular monitoring and troubleshooting.

**Related Documentation**:

- [Webhook Monitoring](/docs/features/integrations/webhook-system#webhook-debugging)

- [Troubleshooting Guide](/docs/features/integrations/webhook-system#retry-logic--error-handling)

---

### `/dashboard/settings/webhooks/:id/deliveries` - Detailed Delivery Log

**User Story**: *"As a developer, I want to see detailed webhook delivery logs, so I can debug integration issues."*

**What You'll Find**:

#### Delivery Log Filters

**Filter Bar**:

- **Status**: All, Success, Failed, Pending Retry.

- **Event Type**: Multi-select dropdown.

- **Date Range**: Date picker (default: Last 7 days).

- **Search**: Search by event ID or contact email.

**Export**:

- **"Export CSV" Button**: Download filtered logs.

#### Delivery Log Table

**Detailed View**:

| Timestamp | Event ID | Event Type | Status | Response Time | Attempt | Actions |
|-----------|----------|------------|--------|---------------|---------|---------|
| Nov 25, 2:34 PM | evt_abc123 | email.opened | âœ“ 200 OK | 142ms | 1/1 | View |
| Nov 25, 2:33 PM | evt_def456 | email.clicked | âœ“ 200 OK | 156ms | 1/1 | View |
| Nov 25, 2:30 PM | evt_ghi789 | email.bounced | âœ— 500 Error | 5000ms | 2/5 | Retry, View |

**Expandable Rows**:

Click row to expand and view:

**Request Details**:

```http
POST https://yourapp.com/webhooks/penguinmails
Content-Type: application/json
X-PenguinMails-Signature: sha256=abc123...
X-PenguinMails-Event: email.opened
X-PenguinMails-Delivery-ID: del_xyz789

{
  "id": "evt_abc123",
  "type": "email.opened",
  "created_at": "2025-11-25T14:34:00Z",
  "data": {
    "email_id": "msg_xyz789",
    "contact": {
      "email": "user@example.com"
    }
  }
}

```

**Response Details**:

```http
200 OK
Content-Type: text/plain
Response Time: 142ms

OK

```

**Actions**:

- **"Copy Request" Button**: Copy request payload.

- **"Copy Response" Button**: Copy response body.

- **"Retry Now" Button**: Manually retry failed delivery.

- **"View Event" Link**: Navigate to event details.

#### Failed Deliveries Section

**Failed Deliveries Summary**:

- **Total Failed**: "11 in last 24 hours"

- **Most Common Error**: "500 Internal Server Error (7 occurrences)"

- **Retry Status**: "3 pending retry, 8 exhausted retries"

**Failed Deliveries Table**:

| Timestamp | Event Type | Error | Attempts | Next Retry | Actions |
|-----------|------------|-------|----------|------------|---------|
| 2:30 PM | email.bounced | 500 Error | 2/5 | In 3 minutes | Retry |
| 2:25 PM | email.opened | Timeout | 5/5 | Exhausted | View |

**Bulk Actions**:

- **"Retry All Failed" Button**: Retry all failed deliveries.

- **"Clear Failed Log" Button**: Archive failed deliveries.

**User Journey Context**: Troubleshooting delivery issues, monitoring webhook health.

**Related Documentation**:

- [Retry Logic](/docs/features/integrations/webhook-system#retry-logic--error-handling)

- [Error Handling](/docs/features/integrations/webhook-system#webhook-debugging)

---

### `/dashboard/settings/webhooks/:id/test` - Test Webhook

**User Story**: *"As a developer, I want to test my webhook with different event types, so I can verify my integration works correctly."*

**What You'll Find**:

#### Test Configuration

**Event Type Selector**:

- **Dropdown**: Select event type to test.

  - Options: email.sent, email.delivered, email.opened, email.clicked, email.bounced, etc.

**Data Source**:

- **Radio Buttons**:

  - â—‹ Use Sample Data (default)

  - â—‹ Use Real Data from Campaign/Contact

**If "Use Real Data" selected**:

- **Campaign**: Dropdown (select campaign).

- **Contact**: Dropdown (select contact).

- **Help Text**: "Test event will use actual data from selected campaign/contact."

#### Test Payload Preview

**Payload Display** (JSON):

```json
{
  "id": "evt_test_1234567890",
  "type": "email.opened",
  "created_at": "2025-11-25T14:30:00Z",
  "data": {
    "email_id": "msg_sample",
    "campaign_id": "camp_sample",
    "contact": {
      "id": "cont_sample",
      "email": "test@example.com",
      "first_name": "Test",
      "last_name": "User"
    },
    "opened_at": "2025-11-25T14:30:00Z",
    "user_agent": "Mozilla/5.0...",
    "ip_address": "192.168.1.1"
  }
}

```

**"Edit Payload" Button**: Opens JSON editor for custom payload.

#### Send Test

**"Send Test Event" Button**: Sends test event to webhook endpoint.

**Test Progress**:

```text
Sending test event to https://yourapp.com/webhooks...
â³ Waiting for response...

```

**Test Result**:

**Success**:

```text
âœ“ Test successful!

Request:
  POST https://yourapp.com/webhooks/penguinmails
  Headers: X-PenguinMails-Signature: sha256=...

Response:
  Status: 200 OK
  Response Time: 142ms
  Body: "OK"

[View Full Request] [View Full Response]

```

**Failure**:

```text
âœ— Test failed

Error: Connection timeout after 5000ms

Possible causes:

- Endpoint is unreachable

- Firewall blocking requests

- Server not responding

[Retry Test] [Edit Webhook] [View Troubleshooting Guide]

```

#### Code Examples

**Signature Verification Code** (Tabbed):

**Node.js**:

```javascript
const crypto = require('crypto');

function verifySignature(payload, signature, secret) {
  const hmac = crypto.createHmac('sha256', secret);
  hmac.update(JSON.stringify(payload));
  const digest = `sha256=${hmac.digest('hex')}`;
  return crypto.timingSafeEqual(
    Buffer.from(digest),
    Buffer.from(signature)
  );
}

// Usage
app.post('/webhooks/penguinmails', (req, res) => {
  const signature = req.headers['x-penguinmails-signature'];
  const secret = 'whsec_...'; // Your webhook secret

  if (!verifySignature(req.body, signature, secret)) {
    return res.status(401).send('Invalid signature');
  }

  // Process event
  console.log('Event:', req.body.type);
  res.status(200).send('OK');
});

```

**TypeScript/Node.js**:

```typescript
import crypto from 'crypto';
import express, { Request, Response } from 'express';

function verifySignature(payload: string, signature: string, secret: string): boolean {
  const hmac = crypto.createHmac('sha256', secret);
  hmac.update(payload, 'utf8');
  const computed = hmac.digest('hex');
  const expected = `sha256=${computed}`;
  return crypto.timingSafeEqual(
    Buffer.from(expected),
    Buffer.from(signature)
  );
}

// Usage
const app = express();
app.use(express.json());

app.post('/webhooks/penguinmails', (req: Request, res: Response) => {
  const signature = req.headers['x-penguinmails-signature'] as string;
  const secret = 'whsec_...'; // Your webhook secret

  if (!verifySignature(JSON.stringify(req.body), signature, secret)) {
    return res.status(401).send('Invalid signature');
  }

  // Process event
  console.log('Event:', req.body.type);
  return res.status(200).send('OK');
});

```

**Copy Button**: Copy code snippet.

**User Journey Context**: Initial setup and ongoing testing during development.

**Related Documentation**:

- [Signature Verification](/docs/features/integrations/webhook-system#signature-verification)

- [Testing Guide](/docs/features/integrations/webhook-system#webhook-debugging)

---

### `/dashboard/settings/webhooks/events` - Event Reference

**User Story**: *"As a developer, I want to see all available webhook events and their payloads, so I can choose which events to subscribe to."*

**What You'll Find**:

#### Event Categories

**Sidebar Navigation**:

- Email Events (7)

- Campaign Events (3)

- Contact Events (3)

- System Events (2)

#### Event Documentation

##### Example: email.opened Event

**Event Type**: `email.opened`

**Description**: "Triggered when a recipient opens an email. Includes location and device information."

**Frequency**: "High - Can be triggered multiple times per email"

**Payload Schema**:

```json
{
  "id": "string (UUID)",
  "type": "email.opened",
  "created_at": "string (ISO 8601)",
  "data": {
    "email_id": "string (UUID)",
    "campaign_id": "string (UUID)",
    "contact": {
      "id": "string (UUID)",
      "email": "string",
      "first_name": "string",
      "last_name": "string"
    },
    "opened_at": "string (ISO 8601)",
    "user_agent": "string",
    "ip_address": "string",
    "location": {
      "city": "string",
      "region": "string",
      "country": "string"
    }
  }
}

```

**Example Payload**:

```json
{
  "id": "evt_abc123",
  "type": "email.opened",
  "created_at": "2025-11-25T14:30:00Z",
  "data": {
    "email_id": "msg_xyz789",
    "campaign_id": "camp_def456",
    "contact": {
      "id": "cont_ghi012",
      "email": "user@example.com",
      "first_name": "Sarah",
      "last_name": "Johnson"
    },
    "opened_at": "2025-11-25T14:30:00Z",
    "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)",
    "ip_address": "192.168.1.1",
    "location": {
      "city": "New York",
      "region": "NY",
      "country": "US"
    }
  }
}

```

**Copy Button**: Copy example payload.

**Related Events**:

- email.sent

- email.delivered

- email.clicked

**Use Cases**:

- Update CRM with engagement data

- Trigger follow-up workflows

- Track email performance

#### Event Comparison Table

**All Events Summary**:

| Event Type | Frequency | Retry Safe | Typical Use Case |
|------------|-----------|------------|------------------|
| email.sent | High | Yes | Track sending status |
| email.delivered | High | Yes | Confirm delivery |
| email.opened | Very High | Yes | Measure engagement |
| email.clicked | High | Yes | Track link clicks |
| email.bounced | Medium | Yes | Update contact status |
| campaign.launched | Low | Yes | Trigger notifications |
| contact.created | Medium | Yes | Sync to CRM |

**User Journey Context**: Reference during webhook setup and development.

**Related Documentation**:

- [Event Reference](/docs/features/integrations/webhook-system#event-reference)

- [Webhook System Overview](/docs/features/integrations/webhook-system)

## 5. Related API Endpoints

| Route | Related API | Description |
|---|---|---|
| `/settings/webhooks` | [Webhooks API](/docs/implementation-technical/api/platform-api/webhooks) | `GET /api/v1/platform/webhooks` (List webhooks). |
| `/settings/webhooks/create` | [Webhooks API](/docs/implementation-technical/api/platform-api/webhooks) | `POST /api/v1/platform/webhooks` (Create webhook). |
| `/settings/webhooks/:id` | [Webhooks API](/docs/implementation-technical/api/platform-api/webhooks) | `GET /api/v1/platform/webhooks/{id}` (Get details). |
| `/settings/webhooks/:id/edit` | [Webhooks API](/docs/implementation-technical/api/platform-api/webhooks) | `PUT /api/v1/platform/webhooks/{id}` (Update webhook). |
| `/settings/webhooks/:id/test` | [Webhooks API](/docs/implementation-technical/api/platform-api/webhooks) | `POST /api/v1/platform/webhooks/{id}/test` (Send test event). |
| `/settings/webhooks/:id/deliveries` | [Webhooks API](/docs/implementation-technical/api/platform-api/webhooks) | `GET /api/v1/platform/webhooks/{id}/deliveries` (Delivery log). |

## 6. Data Strategy

- **Fetching Method**:

  - **Webhook List**: Server Component (cached for 5 minutes).

  - **Delivery Log**: Client Component with real-time updates (SWR).

  - **Test Results**: Client Component with immediate feedback.

- **Caching**:

  - **Webhook Config**: Cached for 5 minutes.

  - **Delivery Stats**: Cached for 1 minute.

  - **Delivery Log**: No caching (real-time).

- **Security**:

  - **Secret Keys**: Never exposed after creation (hashed in database).

  - **Signature Verification**: Required on all webhook deliveries.

  - **Admin Only**: All webhook routes require admin or developer role.

## 7. Edge Cases & Error Handling

- **Invalid Endpoint URL**: Show "Endpoint must be a valid HTTPS URL."

- **Test Timeout**: Show "Endpoint did not respond within 5 seconds. Check your server."

- **Signature Mismatch**: Log security warning, show "Signature verification failed. Check your secret key."

- **Rate Limit Exceeded**: Show "Too many webhook deliveries. Upgrade plan for higher limits."

- **Webhook Auto-Paused**: Email notification + banner: "Webhook paused after 100 consecutive failures. [View details â†’]"

- **Duplicate Events**: Implement idempotency keys to prevent duplicate processing.

## 8. Component Architecture

### Page Components

- **`WebhookOverview`** (Server)

  - Features: Webhook list, health stats, quick actions.

- **`WebhookCreator`** (Client)

  - Features: Multi-step form, event selector, test interface.

- **`WebhookDetails`** (Server)

  - Features: Configuration display, delivery stats, recent log.

- **`DeliveryLog`** (Client)

  - Features: Real-time log, filtering, export, retry actions.

- **`WebhookTester`** (Client)

  - Features: Test event sender, payload editor, result display.

- **`EventReference`** (Server)

  - Features: Event documentation, payload schemas, examples.

### Shared Components

- **`WebhookCard`**: Reused in overview and list views.

- **`EventSelector`**: Reused in create and edit forms.

- **`SignatureVerifier`**: Reused in details and test views.

- **`DeliveryStatus`**: Reused across delivery logs and stats.

## 9. Related Documentation

### Feature Documentation

- **[Webhook System](/docs/features/integrations/webhook-system)** - Complete webhook system guide

- **[API Access](/docs/features/integrations/api-access)** - API authentication and keys

- **[ESP Integration](/docs/features/integrations/esp-integration)** - ESP webhook configuration

### Technical Documentation

- **[Webhooks API Reference](/docs/implementation-technical/api/platform-api/webhooks)** - API endpoints for webhook management

- **[Event Reference](/docs/features/integrations/webhook-system#event-reference)** - All available events

- **[Signature Verification](/docs/features/integrations/webhook-system#signature-verification)** - Security implementation

### User Journeys

- **Developer Journey** - Webhook integration workflows (internal journey reference)

- **Integration Setup** - Webhook setup for business users (internal journey reference)

---

**Last Updated:** November 25, 2025
**Status:** Planned - MVP Feature
**Target Release:** Q1 2026

*Webhook system routes provide comprehensive tools for developers to receive real-time event notifications with secure delivery, retry logic, and detailed monitoring.*
