---
title: "Webhook System"
description: "Event-driven integrations with real-time webhooks for email events, campaign triggers, and external system notifications"
level: "2"
status: "PLANNED"
roadmap_timeline: "Q1 2026"
priority: "High"
related_features:

  - integrations/api-access

  - integrations/crm-integration/overview

  - queue/email-pipeline

  - campaigns/campaign-management/overview
related_tasks:

  - epic-6-core-email-pipeline
---

# Webhook System

**Quick Access**: Receive real-time notifications about email events, campaign activities, and system updates via HTTP webhooks.

## Overview

The Webhook System enables external applications to receive instant notifications when events occur in PenguinMails, powering integrations with CRMs, analytics tools, marketing automation platforms, and custom applications.

### Key Capabilities

- **Real-Time Events**: Instant HTTP POST notifications

- **Event Filtering**: Subscribe only to relevant events

- **Retry Logic**: Automatic retries on delivery failures

- **Signature Verification**: Cryptographic signatures for security

- **Event Replay**: Retrieve historical events

- **Testing Tools**: Webhook debugger and request inspector

---

## Level 1: Quick Start Guide

### Create Your First Webhook

#### Step 1: Navigate to Webhooks

```text

Dashboard â†’ Settings â†’ Integrations â†’ Webhooks â†’ Create Webhook

```

#### Step 2: Configure Webhook

**Basic Configuration:**

```text

Webhook Name: CRM Contact Sync
Endpoint URL: https://yourapp.com/webhooks/penguinmails
Description: Sync email engagement to CRM

Status: â—‹ Active  â—‹ Paused

```

#### Step 3: Select Events

**Choose which events to receive:**

```text

Email Events:
  â˜‘ email.sent
  â˜‘ email.delivered
  â˜‘ email.opened
  â˜‘ email.clicked
  â˜‘ email.bounced
  â˜‘ email.spam_reported
  â˜‘ email.unsubscribed

Campaign Events:
  â˜ campaign.launched
  â˜ campaign.completed
  â˜ campaign.paused

Contact Events:
  â˜ contact.created
  â˜ contact.updated
  â˜ contact.unsubscribed

```

#### Step 4: Test Webhook

```text

[Send Test Event]

Test payload will be sent to:
https://yourapp.com/webhooks/penguinmails

Sending test event...
âœ“ Test  successful! (Response: 200 OK)

```

#### Step 5: Save & Activate

```text

[Save Webhook]

âœ“ Webhook created and activated
Secret Key: whsec_abc123... [Copy]

Add this to your application for signature verification.

```

### Receiving Webhook Events

**Example Payload (Email Opened):**

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
    "user_agent": "Mozilla/5.0...",
    "ip_address": "192.168.1.1",
    "location": {
      "city": "New York",
      "region": "NY",
      "country": "US"
    }
  }
}

```

### Handling Webhooks in Your Application

**Node.js Example:**

```javascript
const express = require('express');
const crypto = require('crypto');

app.post('/webhooks/penguinmails', express.json(), (req, res) => {
  // 1. Verify signature
  const signature = req.headers['x-penguinmails-signature'];
  if (!verifySignature(req.body, signature)) {
    return res.status(401).send('Invalid signature');
  }

  // 2. Handle event
  const event = req.body;

  switch (event.type) {
    case 'email.opened':
      console.log(`Email opened by ${event.data.contact.email}`);
      // Update your CRM, trigger workflow, etc.
      break;

    case 'email.clicked':
      console.log(`Link clicked: ${event.data.url}`);
      break;

    // ... other events
  }

  // 3. Respond quickly (< 5 seconds)
  res.status(200).send('OK');
});

function verifySignature(payload, signature) {
  const secret = process.env.WEBHOOK_SECRET;
  const hmac = crypto.createHmac('sha256', secret);
  hmac.update(JSON.stringify(payload));
  const digest = `sha256=${hmac.digest('hex')}`;
  return crypto.timingSafeEqual(Buffer.from(digest), Buffer.from(signature));
}

```

---

## Level 2: Advanced Webhook Configuration

### Event Filtering

**Filter by workspace:**

```text

Webhook Name: Client A Events Only
Event Filters:
  Workspaces: [Client A]
  Events: [email.opened, email.clicked]

```

**Filter by campaign:**

```text

Event Filters:
  Campaign ID: camp_xyz123
  Events: [All]

```

**Custom filters (JSON):**

```json
{
  "event_types": ["email.opened", "email.clicked"],
  "filters": {
    "contact.tags": ["vip", "premium"],
    "campaign.type": "promotional"
  }
}

```

### Retry Logic & Error Handling

**Automatic Retries:**

```text

If webhook delivery fails:
  Retry #1: After 1 minute
  Retry #2: After 5 minutes
  Retry #3: After 15 minutes
  Retry #4: After 1 hour
  Retry #5: After 24 hours

After 5 failed attempts:

  - Mark webhook as "failing"

  - Send email notification to admin

  - Pause webhook after 100 consecutive failures

```

**View Failed Deliveries:**

```text

Recent Deliveries:
  âœ“ email.opened     200 OK   Nov 25, 14:30
  âœ“ email.clicked    200 OK   Nov 25, 14:29
  âœ— email.bounced    500 Error Nov 25, 14:28 [Retry #2]

[View Failed Event] [Retry Now] [Disable Webhook]

```

### Signature Verification

**Why Important:**

- Prevents spoofed webhook requests

- Ensures data integrity

- Verifies sender authenticity

**Verification Process:**

```text

1. PenguinMails generates HMAC-SHA256 signature

2. Signature sent in X-PenguinMails-Signature header

3. Your app recomputes signature with shared secret

4. Compare signatures (use timing-safe comparison)

```

**TypeScript/Node.js Example:**

```typescript
import express from 'express';
import crypto from 'crypto';
import bodyParser from 'body-parser';

const app = express();

// Middleware to get raw body for signature verification
app.use('/webhooks', bodyParser.json({
  verify: (req: any, res: any, buf: Buffer) => {
    req.rawBody = buf.toString('utf8');
  }
}));

interface WebhookEvent {
  id: string;
  type: string;
  created_at: string;
  data: unknown;
}

interface WebhookHandler {
  verifyWebhook(payload: string, signature: string, secret: string): boolean;
  handleWebhook(req: express.Request, res: express.Response): Promise<void>;
}

class WebhookHandlerImpl implements WebhookHandler {
  private webhookSecret: string;

  constructor(secret: string) {
    this.webhookSecret = secret;
  }

  verifyWebhook(payload: string, signature: string, secret: string): boolean {
    try {
      const computed = crypto
        .createHmac('sha256', secret)
        .update(payload, 'utf8')
        .digest('hex');

      const expected = `sha256=${computed}`;
      return crypto.timingSafeEqual(
        Buffer.from(expected),
        Buffer.from(signature)
      );
    } catch (error) {
      console.error('Webhook signature verification error:', error);
      return false;
    }
  }

  async handleWebhook(req: express.Request, res: express.Response): Promise<void> {
    try {
      const signature = req.headers['x-penguinmails-signature'] as string;
      const rawBody = (req as any).rawBody;

      if (!signature) {
        res.status(401).json({ error: 'Missing signature header' });
        return;
      }

      // Verify signature
      if (!this.verifyWebhook(rawBody, signature, this.webhookSecret)) {
        res.status(401).json({ error: 'Invalid signature' });
        return;
      }

      const event: WebhookEvent = req.body;

      // Process event based on type
      switch (event.type) {
        case 'email.opened':
          await this.handleEmailOpened(event);
          break;
        case 'email.clicked':
          await this.handleEmailClicked(event);
          break;
        case 'email.bounced':
          await this.handleEmailBounced(event);
          break;
        case 'email.sent':
          await this.handleEmailSent(event);
          break;
        default:
          console.log(`Unhandled event type: ${event.type}`);
      }

      res.status(200).json({ success: true });
    } catch (error) {
      console.error('Webhook processing error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  private async handleEmailOpened(event: WebhookEvent): Promise<void> {
    console.log(`Email opened by ${event.data.contact?.email}`);
    // Update your CRM, trigger workflow, etc.
    // Example: await crmService.updateContactEngagement(event.data);
  }

  private async handleEmailClicked(event: WebhookEvent): Promise<void> {
    console.log(`Link clicked: ${event.data.url}`);
    // Track click event, update analytics, etc.
  }

  private async handleEmailBounced(event: WebhookEvent): Promise<void> {
    console.log(`Email bounced: ${event.data.email_id}`);
    // Handle bounce logic - update contact status, etc.
  }

  private async handleEmailSent(event: WebhookEvent): Promise<void> {
    console.log(`Email sent: ${event.data.email_id}`);
    // Update sending status, trigger follow-up workflows, etc.
  }
}

// Usage example
const webhookSecret = process.env.WEBHOOK_SECRET || 'your-webhook-secret';
const webhookHandler = new WebhookHandlerImpl(webhookSecret);

// Express route
app.post('/webhooks', webhookHandler.handleWebhook.bind(webhookHandler));

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Webhook server listening on port ${PORT}`);
});

// Alternative: Pure JavaScript implementation
function verifyWebhookJavaScript(payload, signature, secret) {
  const computed = crypto
    .createHmac('sha256', secret)
    .update(payload, 'utf8')
    .digest('hex');

  const expected = `sha256=${computed}`;
  return crypto.timingSafeEqual(
    Buffer.from(expected),
    Buffer.from(signature)
  );
}

// Standalone verification function
function standaloneVerify(payload, signature, secret) {
  if (!payload || !signature || !secret) {
    return false;
  }

  try {
    return verifyWebhookJavaScript(payload, signature, secret);
  } catch (error) {
    console.error('Signature verification failed:', error);
    return false;
  }
}

```

### Webhook Debugging

**Request Inspector:**

```text

Last 50 Webhook Deliveries:

[Nov 25, 14:30:15] email.opened
  â†’ POST https://yourapp.com/webhooks
  Status: 200 OK
  Duration: 142ms
  [View Request] [View Response]

Request Headers:
  Content-Type: application/json
  X-PenguinMails-Signature: sha256=abc123...
  X-PenguinMails-Event: email.opened
  User-Agent: PenguinMails-Webhooks/1.0

Request Body:
  { "id": "evt_...", ... }

Response:
  200 OK
  Content-Type: text/plain
  Body: "OK"

```

**Test Mode:**

```text

[Send Test Event]

Choose test event type:
  â—‹ email.opened
  â—‹ email.clicked
  â—‹ email.bounced

Use real data from:
  Campaign: [Select Campaign â–¼]
  Contact: [Select Contact â–¼]

OR

  Use sample data â˜‘

[Send Test]

```

### Event Replay

**Replay missed events:**

```text

Replay Events

From: Nov 20, 2025  14:00
To:   Nov 25, 2025  16:00

Event Types: [email.opened, email.clicked]

Found: 1,247 matching events

[Replay All Events]

Status: Replaying... (234 / 1,247)

```

**Use Cases:**

- Recover from downtime

- Backfill data after webhook creation

- Re-sync after bug fixes

---

## Level 3: Technical Implementation

### Database Schema

```sql
-- Webhook endpoints
CREATE TABLE webhooks (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),

  -- Configuration
  name VARCHAR(255) NOT NULL,
  description TEXT,
  endpoint_url TEXT NOT NULL,
  secret_key VARCHAR(255) NOT NULL, -- For signature generation

  -- Event filtering
  event_types TEXT[], -- e.g., ['email.opened', 'email.clicked']
  event_filters JSONB, -- Additional filtering criteria

  -- Status
  is_active BOOLEAN DEFAULT TRUE,
  is_failing BOOLEAN DEFAULT FALSE,
  consecutive_failures INTEGER DEFAULT 0,
  last_success_at TIMESTAMP,
  last_failure_at TIMESTAMP,

  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Webhook delivery attempts
CREATE TABLE webhook_deliveries (
  id UUID PRIMARY KEY,
  webhook_id UUID NOT NULL REFERENCES webhooks(id),
  event_id UUID NOT NULL,

  -- Request
  event_type VARCHAR(100),
  payload JSONB,
  signature VARCHAR(255),

  -- Response
  status_code INTEGER,
  response_body TEXT,
  response_headers JSONB,

  -- Timing
  duration_ms INTEGER,
  attempted_at TIMESTAMP DEFAULT NOW(),

  -- Retry tracking
  attempt_number INTEGER DEFAULT 1,
  next_retry_at TIMESTAMP,

  -- Status
  status VARCHAR(50), -- success, failed, pending_retry
  error_message TEXT
);

CREATE INDEX idx_webhook_deliveries_webhook ON webhook_deliveries(webhook_id, attempted_at);
CREATE INDEX idx_webhook_deliveries_status ON webhook_deliveries(status, next_retry_at);

-- Events log (for replay)
CREATE TABLE webhook_events (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL,

  event_type VARCHAR(100),
  event_data JSONB,

  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_webhook_events_tenant_type ON webhook_events(tenant_id, event_type, created_at);

```

### Webhook Delivery Service

```typescript
class WebhookDeliveryService {
  async deliverEvent(event: WebhookEvent): Promise<void> {
    // Find all webhooks subscribed to this event type
    const webhooks = await this.findMatchingWebhooks(event);

    for (const webhook of webhooks) {
      await this.queueDelivery(webhook, event);
    }
  }

  private async findMatchingWebhooks(event: WebhookEvent): Promise<Webhook[]> {
    return db.webhooks.findAll({
      where: {
        tenantId: event.tenantId,
        isActive: true,
        eventTypes: { contains: [event.type] },
      },
    });
  }

  private async queueDelivery(webhook: Webhook, event: WebhookEvent): Promise<void> {
    await webhookQueue.add('deliver-webhook', {
      webhookId: webhook.id,
      eventId: event.id,
      payload: event.data,
    }, {
      attempts: 5,
      backoff: {
        type: 'exponential',
        delay: 60000, // Start with 1 minute
      },
    });
  }

  async deliver(webhookId: string, event: WebhookEvent): Promise<void> {
    const webhook = await db.webhooks.findById(webhookId);

    // Generate signature
    const payload = JSON.stringify(event);
    const signature = this.generateSignature(payload, webhook.secretKey);

    // Make HTTP request
    const startTime = Date.now();

    try {
      const response = await axios.post(webhook.endpointUrl, payload, {
        headers: {
          'Content-Type': 'application/json',
          'X-PenguinMails-Signature': signature,
          'X-PenguinMails-Event': event.type,
          'X-PenguinMails-Delivery-ID': uuidv4(),
        },
        timeout: 5000, // 5 second timeout
      });

      const duration = Date.now() - startTime;

      // Log successful delivery
      await db.webhookDeliveries.create({
        webhookId,
        eventId: event.id,
        eventType: event.type,
        payload: event.data,
        signature,
        statusCode: response.status,
        responseBody: response.data,
        responseHeaders: response.headers,
        durationMs: duration,
        status: 'success',
      });

      // Reset failure tracking
      await db.webhooks.update(webhookId, {
        consecutiveFailures: 0,
        isFailing: false,
        lastSuccessAt: new Date(),
      });

    } catch (error) {
      await this.handleDeliveryFailure(webhook, event, error);
    }
  }

  private generateSignature(payload: string, secret: string): string {
    const hmac = crypto.createHmac('sha256', secret);
    hmac.update(payload);
    return `sha256=${hmac.digest('hex')}`;
  }

  private async handleDeliveryFailure(
    webhook: Webhook,
    event: WebhookEvent,
    error: any
  ): Promise<void> {
    const failures = webhook.consecutiveFailures + 1;

    await db.webhookDeliveries.create({
      webhookId: webhook.id,
      eventId: event.id,
      status: 'failed',
      errorMessage: error.message,
    });

    await db.webhooks.update(webhook.id, {
      consecutiveFailures: failures,
      isFailing: failures >= 3,
      lastFailureAt: new Date(),
    });

    // Pause webhook after 100 failures
    if (failures >= 100) {
      await db.webhooks.update(webhook.id, {
        isActive: false,
      });

      await notificationService.send({
        tenantId: webhook.tenantId,
        type: 'webhook_paused',
        data: { webhookId: webhook.id, failures },
      });
    }
  }
}

```

### Event Emission

```typescript
// Emit webhook event when email is opened
async function handleEmailOpen(emailId: string): Promise<void> {
  const email = await db.emails.findById(emailId);
  const contact = await db.contacts.findById(email.contactId);
  const campaign = await db.campaigns.findById(email.campaignId);

  const event: WebhookEvent = {
    id: uuidv4(),
    type: 'email.opened',
    tenantId: campaign.tenantId,
    createdAt: new Date(),
    data: {
      emailId: email.id,
      campaignId: campaign.id,
      contact: {
        id: contact.id,
        email: contact.email,
        firstName: contact.firstName,
        lastName: contact.lastName,
      },
      openedAt: new Date(),
      userAgent: req.headers['user-agent'],
      ipAddress: req.ip,
    },
  };

  // Store event for replay
  await db.webhookEvents.create(event);

  // Deliver to webhooks
  await webhookDeliveryService.deliverEvent(event);
}

```

### API Endpoints

```typescript
// Create webhook
app.post('/api/webhooks', authenticate, async (req, res) => {
  const { name, endpointUrl, eventTypes, eventFilters } = req.body;

  // Generate secret key
  const secretKey = `whsec_${randomBytes(32).toString('hex')}`;

  const webhook = await db.webhooks.create({
    tenantId: req.user.tenantId,
    name,
    endpointUrl,
    secretKey,
    eventTypes,
    eventFilters,
    isActive: true,
  });

  return res.json({
    id: webhook.id,
    name: webhook.name,
    endpointUrl: webhook.endpointUrl,
    secretKey, // Only shown once
    eventTypes: webhook.eventTypes,
  });
});

// Test webhook
app.post('/api/webhooks/:id/test', authenticate, async (req, res) => {
  const webhook = await db.webhooks.findById(req.params.id);

  const testEvent = {
    id: `evt_test_${Date.now()}`,
    type: 'email.opened',
    created_at: new Date().toISOString(),
    data: {
      // Sample data
      email_id: 'msg_sample',
      contact: {
        email: 'test@example.com',
        first_name: 'Test',
      },
    },
  };

  try {
    await webhookDeliveryService.deliver(webhook.id, testEvent);
    return res.json({ success: true });
  } catch (error) {
    return res.status(400).json({ error: error.message });
  }
});

```

---

## Event Reference

### Email Events

| Event Type | Description | Payload |
|------------|-------------|---------|
| `email.sent` | Email queued for sending | emailId, campaignId, contact |
| `email.delivered` | Email successfully delivered | emailId, deliveredAt, smtpResponse |
| `email.opened` | Email opened by recipient | emailId, openedAt, location, userAgent |
| `email.clicked` | Link clicked in email | emailId, url, clickedAt |
| `email.bounced` | Email bounced | emailId, bounceType, bounceReason |
| `email.spam_reported` | Marked as spam | emailId, reportedAt |
| `email.unsubscribed` | Recipient unsubscribed | emailId, contactId, unsubscribedAt |

### Campaign Events

| Event Type | Description |
|------------|-------------|
| `campaign.launched` | Campaign started sending |
| `campaign.completed` | Campaign finished sending |
| `campaign.paused` | Campaign paused by user |

### Contact Events

| Event Type | Description |
|------------|-------------|
| `contact.created` | New contact added |
| `contact.updated` | Contact information updated |
| `contact.unsubscribed` | Contact unsubscribed from all emails |

---

## Related Documentation

### Route Specifications

- **[Webhook System Routes](/docs/design/routes/webhook-system)** - Complete webhook UI routes

- **[API Access Routes](/docs/design/routes/api-access)** - API key management routes

- **[ESP Integration Routes](/docs/design/routes/esp-integration)** - ESP webhook configuration

### Feature Documentation

- **[API Access](/docs/features/integrations/api-access)** - REST API and authentication

- **[Vault API Keys](/docs/features/integrations/vault-api-keys)** - Secure API key system

- **[ESP Integration](/docs/features/integrations/esp-integration)** - External ESP webhooks

- **[CRM Integration](/docs/features/integrations/crm-integration/overview)** - Pre-built integrations

### API Documentation

- **[Platform API](/docs/implementation-technical/api/platform-api)** - Webhook management endpoints

- **[Tenant API](/docs/implementation-technical/api/tenant-api)** - Event data endpoints

- **[Queue System](/docs/implementation-technical/api/queue)** - Event processing

### Architecture & Implementation

- **[Integrations Review](/.kiro/specs/feature-completeness-review/findings/integrations)** - Integration completeness review

- **[Email Pipeline](/docs/features/queue/email-pipeline)** - Email sending infrastructure

- **[Campaign Management](/docs/features/campaigns/campaign-management/overview)** - Campaign events

- **[Epic 6: Core Email Pipeline](/tasks/epic-6-core-email-pipeline/)** - Email pipeline tasks

### User Journeys

- **[Technical Teams Journeys](/user-journeys/internal-users/technical-teams-journeys)** - Developer workflows

- **[Developer Onboarding](/user-journeys/external-users/onboarding-flows/developer-onboarding)** - Developer setup

---

**Last Updated:** November 25, 2025
**Status:** Planned - MVP Feature (Level 2)
**Target Release:** Q1 2026
**Owner:** Integrations Team


