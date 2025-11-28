---
title: "ESP Integration"
description: "External Email Service Provider integration for PenguinMails - Postmark and Mailgun"
last_modified_date: "2025-11-24"
level: "2"
persona: "Operations Teams, Developers"
status: "ACTIVE"
category: "Integrations"
---


# ESP Integration

**Connect external Email Service Providers (ESPs) for enhanced deliverability and specialized sending.**

---

## Overview

While PenguinMails has built-in email sending capabilities via your own SMTP infrastructure, you can optionally integrate with premium ESPs like **Postmark** and **Mailgun** for:

- Higher deliverability rates

- Dedicated IP addresses

- Advanced sending infrastructure

- Specialized transactional or bulk email handling

### Supported ESPs

| ESP | Best For | Pricing | Setup Time |
|-----|----------|---------|------------|
| **[Postmark](https://postmarkapp.com)** | Transactional emails | Pay-as-you-go | 5 min |
| **[Mailgun](https://www.mailgun.com)** | Bulk marketing emails | Monthly plans | 10 min |

---

## Level 1: ESP Integration Basics

### Why Use an ESP?

**Built-in SMTP** (via Hostwind VPS):

- ✅ Full control over infrastructure

- ✅ No per-email costs

- ✅ Custom configuration

- ⚠️ Requires warmup and IP reputation management

- ⚠️ Shared IP reputation risk

**External ESP** (Postmark/Mailgun):

- ✅ Pre-warmed infrastructure

- ✅ Dedicated deliverability team

- ✅ Advanced analytics and tracking

- ✅ Better inbox placement rates

- ⚠️ Per-email costs

- ⚠️ Less direct control

**Recommendation:** Use both for different purposes:

- **Postmark** → Transactional emails (password resets, receipts, alerts)

- **Mailgun** → Marketing campaigns (newsletters, promotions)

- **Built-in SMTP** → High-volume cold outreach, custom scenarios

---

### Postmark Integration

**Premium transactional email delivery** with99.96% deliverability.

#### When to Use Postmark

- ✅ **Password resets** - Critical delivery required

- ✅ **Account notifications** - Must reach inbox

- ✅ **Order confirmations** - Transactional content

- ✅ **Welcome emails** - First impression matters

- ⚠️ NOT for bulk marketing (use Mailgun or built-in)

#### Postmark Setup

**Step 1: Create Postmark Account**

1. Sign up at [postmarkapp.com](https://postmarkapp.com)

2. Verify your email

3. Create a "Server" (sending environment)

**Step 2: Get API Key**

1. Go to **Servers** → **API Tokens**

2. Copy **Server API Token**

3. Save for PenguinMails configuration

**Step 3: Configure in PenguinMails**

```text
Settings → Integrations → ESP Integration

ESP Provider: Postmark
API Token: [paste token]
Default Sender: noreply@yourdomain.com
Track Opens: ☑ Yes
Track Links: ☑ Yes

[Save Configuration]


```

**Step 4: Verify Domain**

1. Postmark provides DNS records (DKIM, Return-Path)

2. Add records to your DNS

3. Wait for verification (~hour)

4. Start sending!

#### Postmark Features

- **Fast delivery** - Sub-second sending

- **Detailed analytics** - Open/click/bounce tracking

- **Bounce categorization** - Hard vs soft bounces

- **Spam analysis** - Why emails might be flagged

- **Templates** - HTML templates with variables

- **Webhooks** - Real-time delivery notifications

**Pricing:**

- $1.25 per 1,000 emails

- First 100 emails/month free

- Volume discounts available

---

### Mailgun Integration

**Powerful bulk email delivery** for marketing campaigns.

#### When to Use Mailgun

- ✅ **Marketing campaigns** - Newsletters, promotions

- ✅ **High volume** - Thousands of emails per campaign

- ✅ **Advanced segmentation** - A/B testing, targeting

- ✅ **Email validation** - List cleaning and verification

- ⚠️ NOT for transactional (use Postmark)

#### Mailgun Setup

**Step 1: Create Mailgun Account**

1. Sign up at [mailgun.com](https://www.mailgun.com)

2. Choose US or EU region data center

3. Verify email and billing info

**Step 2: Add Sending Domain**

1. Go to **Sending** → **Domains**

2. Click **Add New Domain**

3. Enter your domain (e.g., `mail.yourdomain.com`)

4. Add provided DNS records (SPF, DKIM, CNAME)

5. Wait for verification

**Step 3: Get API Credentials**

1. Go to **Settings** → **API Keys**

2. Copy **Private API Key**

3. Note your **Domain Name**

**Step 4: Configure in PenguinMails**

```text
Settings → Integrations → ESP Integration

ESP Provider: Mailgun
API Key: [paste private key]
Domain: mail.yourdomain.com
Region: US / EU
Track Opens: ☑ Yes
Track Clicks: ☑ Yes
Unsubscribe Handling: ☑ Automatic

[Save Configuration]


```

#### Mailgun Features

- **Powerful API** - Full programmatic control

- **Email validation** - Pre-send list verification

- **A/B testing** - Test subject lines, content

- **Scheduled sending** - Time-zone optimized delivery

- **Tagging & segmentation** - Organize campaigns

- **Route filtering** - Advanced email routing logic

**Pricing:**

- **Flex Plan:** $35/month base +$1/1,000 emails

- **Foundation:** $55/month for 50k emails

- **Volume discounts** for >100k emails/month

---

## Level 2: Advanced Configuration

### Routing Rules

**Send different email types through different providers:**

```yaml
Email Routing Configuration:

Transactional Emails:
  Provider: Postmark
  Types:


    - Password Reset


    - Email Verification


    - Order Confirmation


    - Account Alerts
  
Marketing Emails:
  Provider: Mailgun
  Types:


    - Newsletters


    - Product Announcements


    - Promotional Campaigns
    
Cold Outreach:
  Provider: Built-in SMTP
  Types:


    - Sales outreach


    - Lead generation


    - Custom campaigns


```

**Configuration:**

```text
Settings → Integrations → ESP Routing

Default Provider: Built-in SMTP
Override Rules:
  ☑ Transactional → Postmark
  ☑ Marketing → Mailgun
  ☐ All emails → [ESP]

[Save Routing Rules]


```

---

### Webhook Integration

**Receive real-time delivery events** from ESPs.

**Postmark Webhooks:**

```javascript
// Webhook Endpoint
POST https://api.penguinmails.com/webhooks/postmark

// Event Types
{
  "RecordType": "Delivery", // or "Bounce", "Open", "Click"
  "MessageID": "abc123",
  "Recipient": "user@example.com",
  "DeliveredAt": "2025-11-24T10:30:00Z"
}


```

**Mailgun Webhooks:**

```javascript
// Webhook Endpoint
POST https://api.penguinmails.com/webhooks/mailgun

// Event Types
{
  "event": "delivered", // or "failed", "opened", "clicked"
  "message": {
    "headers": {
      "message-id": "abc123"
    }
  },
  "recipient": "user@example.com",
  "timestamp": 1700830200
}


```

**Webhook Configuration in PenguinMails:**

1. ESPs automatically send events to PenguinMails

2. Events update campaign analytics in real-time

3. Bounce handling triggers suppression list updates

4. Open/click tracking updates engagement metrics

---

### Deliverability Monitoring

**Compare ESP performance:**

```text
Deliverability Dashboard

Provider      | Delivered | Bounced | Opened | Clicked
──────────────┼───────────┼─────────┼────────┼────────
Postmark      | 99.2%     | 0.8%    | 45.3%  | 12.1%
Mailgun       | 98.5%     | 1.5%    | 38.2%  | 9.7%
Built-in SMTP | 94.1%     | 5.9%    | 31.5%  | 7.3%

Recommendation: Use Postmark for critical emails


```

---

## Level 3: Technical Implementation

### API Integration

**Send via ESP programmatically:**

```javascript
// Postmark API Example
POST /api/v1/emails/send
Authorization: Bearer {api_key}

{
  "provider": "postmark",
  "from": "noreply@yourdomain.com",
  "to": "user@example.com",
  "subject": "Welcome to PenguinMails",
  "html_body": "<h1>Welcome!</h1><p>Thanks for signing up.</p>",
  "track_opens": true,
  "track_links": true
}


```

```javascript
// Mailgun API Example
POST /api/v1/emails/send
Authorization: Bearer {api_key}

{
  "provider": "mailgun",
  "from": "newsletter@yourdomain.com",
  "to": ["user1@example.com", "user2@example.com"],
  "subject": "Monthly Newsletter",
  "html_body": "<html>...</html>",
  "tags": ["newsletter", "november"],
  "campaign_id": "camp_abc123"
}


```

---

### Failover Configuration

**Automatic failover** if primary ESP fails.

```yaml
Failover Strategy:

Primary: Postmark
Fallback: Mailgun
Final Fallback: Built-in SMTP

Retry Logic:


  - Primary fails → Wait 30s → Retry


  - Primary fails again → Switch to Fallback


  - Fallback fails → Switch to Final Fallback


  - All fail → Queue for later retry


```

**Configuration:**

```text
Settings → Integrations → ESP Failover

Enable Failover: ☑ Yes

Priority Order:


1. Postmark (transactional)


2. Mailgun (marketing)


3. Built-in SMTP (final fallback)

Retry Attempts: 3
Retry Delay: 30 seconds

[Save Failover Config]


```

---

### Cost Optimization

**Smart ESP routing to minimize costs:**

**Strategy:**

- **Free tier first** - Use Postmark's 100 free emails/month

- **Volume tiers** - Route high-volume through cheapest provider

- **Priority routing** - Critical emails through premium ESP

- **Batch processing** - Combine sends to reduce API calls

**Cost Comparison:**

```text
Scenario: 100,000 emails/month

Built-in SMTP: $0 (infrastructure cost only)
Postmark: $125/month ($1.25/1k)
Mailgun: $135/month (Foundation plan)

Hybrid Approach:


- 5,000 transactional via Postmark: $5


- 95,000 marketing via Mailgun: $55 (Foundation)
Total: $60/month

Savings: $70/month vs all-Postmark


```

---

## Best Practices

### ESP Selection Guide

**Choose the right ESP for each use case:**

| Email Type | Recommended ESP | Reason |
|------------|-----------------|--------|
| Password reset | Postmark | Critical delivery, fast |
| Welcome email | Postmark | First impression |
| Weekly newsletter | Mailgun | Bulk pricing, A/B testing |
| Promotional campaign | Mailgun | List segmentation |
| Automated drip | Either | Depends on volume |
| Cold outreach | Built-in | Cost-effective, control |

### Deliverability Tips

1. **Warm up gradually** - Start small, increase volume

2. **Authenticate everything** - SPF, DKIM, DMARC for all domains

3. **Monitor reputation** - Check ESP dashboards daily

4. **Clean lists** - Remove bounces immediately

5. **Segment sends** - Don't mix transactional + marketing

6. **Test thoroughly** - Send tests before campaigns

7. **Track metrics** - Monitor open, click, bounce rates

---

## Troubleshooting

### Common Issues

**Issue:** ESP rejects API call
**Solution:** Verify API key, check domain verification

**Issue:** Emails not delivering
**Solution:** Check DNS records, verify sender domain

**Issue:** High bounce rate
**Solution:** Clean email list, check for typos

**Issue:** Low open rates
**Solution:**Improve subject lines, verify tracking enabled

---

## Related Documentation

### Route Specifications

- **[ESP Integration Routes](/docs/design/routes/esp-integration)** - Complete ESP UI routes

- **[Webhook System Routes](/docs/design/routes/webhook-system)** - Webhook configuration

- **[Settings Routes](/docs/design/routes/settings)** - General settings navigation

### Feature Documentation

- **[API Access](/docs/features/integrations/api-access)** - REST API and authentication

- **[Webhook System](/docs/features/integrations/webhook-system)** - Event notifications

- **[CRM Integration](/docs/features/integrations/crm-integration/overview)** - Salesforce, HubSpot integration

- **[Integrations Overview](/docs/features/integrations/README)** - All third-party integrations

### Email Infrastructure

- **[Campaign Management](/docs/features/campaigns/campaign-management/overview)** - Creating campaigns

- **[Email Warmups](/docs/features/warmup/email-warmups/overview)** - Infrastructure warmup

- **[Domain Management](/docs/features/domains/sender-authentication)** - SPF, DKIM, DMARC

- **[Email Infrastructure Setup](/docs/features/infrastructure/email-infrastructure-setup)** - SMTP setup

### API Documentation

- **[Tenant API](/docs/implementation-technical/api/tenant-api)** - ESP configuration endpoints

- **[Platform API](/docs/implementation-technical/api/platform-api)** - Platform-level endpoints

- **[API Reference](/docs/implementation-technical/api/README)** - Complete API documentation

### Architecture & Implementation

- **[Integrations Review](/.kiro/specs/feature-completeness-review/findings/integrations.md)** - Integration completeness review

- **[Epic 6: Core Email Pipeline](/tasks/epic-6-core-email-pipeline/)** - Email pipeline tasks

### User Journeys

- **[Operations Team Journeys](/user-journeys/internal-users/operations-journeys)** - ESP setup workflows

- **[Technical Teams Journeys](/user-journeys/internal-users/technical-teams-journeys)** - API integration

---

## Support Resources

### ESP Documentation

- **Postmark Docs** - <https://postmarkapp.com/developer>

- **Mailgun Docs** - <https://documentation.mailgun.com>

### PenguinMails Support

- **Help Center** - ESP integration guides

- **Support Email** - <integrations@penguinmails.com>

- **Community Forum** - ESP best practices

---

**Last Updated:** November 24, 2025  
**Supported ESPs:** Postmark, Mailgun  
**Coming Soon:** SendGrid, Amazon SES

*ESP integration is optional but recommended for critical transactional emails and high-volume marketing campaigns.*
