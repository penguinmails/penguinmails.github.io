---
title: "Webhook Routes - Creation & Configuration"
description: "Detailed guide for creating and configuring webhooks, including user stories, event categories, and security settings."
last_modified_date: "2026-02-24"
level: "2"
persona: "Developers"
---

# Webhook Routes - Creation & Configuration

### `/dashboard/settings/webhooks/create` - Create Webhook

**User Story**: *"As a developer, I want to create a webhook to receive real-time notifications, so I can integrate PenguinMails with my application."*

#### Step 1: Basic Information

- **Webhook Name**: Descriptive name (e.g., "CRM Contact Sync").
- **Endpoint URL**: Must be a valid HTTPS URL.
- **Status Toggle**: Enable/Disable webhook on creation.

#### Step 2: Event Subscriptions

Select which events trigger the webhook:

**Email Events**:

- ☑ **email.sent** - Email successfully handed off to MTA
- ☑ **email.delivered** - MTA received successful delivery report
- ☑ **email.opened** - Recipient opened email
- ☑ **email.clicked** - Recipient clicked link
- ☑ **email.bounced** - Email bounced (hard or soft)
- ☐ **email.spam_reported** - Marked as spam
- ☐ **email.unsubscribed** - Recipient unsubscribed

**Campaign Events**:

- ☐ **campaign.launched** - Campaign started sending
- ☐ **campaign.completed** - Campaign finished
- ☐ **campaign.paused** - Campaign paused by user

**Contact Events**:

- ☐ **contact.created** - New contact added
- ☐ **contact.updated** - Contact details changed
- ☐ **contact.deleted** - Contact removed

#### Step 3: Event Filters (Advanced)

Define JSON-based filters to only receive events that match specific criteria.

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
- **Retry Strategy**:
  - ○ **Standard** (3 attempts, 10 min intervals)
  - ○ **Aggressive** (5 attempts, 1 min intervals)
  - ○ **Exponential** (Default: 5 attempts with backoff)

**"Create Webhook" Button**: Saves webhook configuration.

#### Webhook Created Success

**Success Modal**:

- **Title**: "Webhook Created Successfully"
- **Webhook ID**: `wh_abc123`
- **Secret Key**: `whsec_def456...` (shown once)
- **Warning**: "⚠️ Save this secret key. You won't be able to see it again."

**Copy Buttons**:

- Copy Webhook ID
- Copy Secret Key
