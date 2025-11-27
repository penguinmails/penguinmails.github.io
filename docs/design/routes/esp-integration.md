---
title: "ESP Integration Routes"
description: "Route specifications for External Email Service Provider (ESP) configuration and management"
last_modified_date: "2025-11-25"
level: "3"
persona: "Developers, Operations Teams"
---

# ESP Integration Routes

## 1. Purpose & Context (The "Why")

- **Goal**: Configure and manage external Email Service Provider (ESP) integrations for enhanced deliverability.
- **Feature References**:
  - [ESP Integration](/docs/features/integrations/esp-integration)
  - [Email Infrastructure](/docs/features/infrastructure/email-infrastructure-setup)
- **User Journey**: Occasional access during initial setup and when adding new ESPs.

## 2. UI Patterns & Components (The "How")

- **Core Components**:
  - `Form`: Configuration forms with validation.
  - `ConnectionTest`: Test ESP connection with real-time feedback.
  - `ProviderCard`: Visual card for each ESP with status indicators.
  - `RoutingRulesBuilder`: Drag-and-drop interface for email routing logic.
  - `WebhookEndpoint`: Display webhook URLs with copy button.
  - `DeliverabilityChart`: Comparative analytics across providers.
- **Analytics Patterns**: Provider performance comparison, delivery metrics.
- **Layout**: Settings Layout with sidebar navigation.

## 3. Route Specifications

| Route | Access | Purpose | State/Data Requirements |
|---|---|---|---|
| `/dashboard/settings/integrations/esp` | Admin | ESP Overview | List of configured ESPs with status, quick actions. |
| `/dashboard/settings/integrations/esp/postmark` | Admin | Postmark Config | Form: API Token, Default Sender, Tracking Options. |
| `/dashboard/settings/integrations/esp/mailgun` | Admin | Mailgun Config | Form: API Key, Domain, Region, Tracking Options. |
| `/dashboard/settings/integrations/esp/routing` | Admin | Routing Rules | Visual builder for email type → ESP mapping. |
| `/dashboard/settings/integrations/esp/webhooks` | Admin | Webhook Config | Webhook URLs, event subscriptions, delivery logs. |
| `/dashboard/settings/integrations/esp/analytics` | Admin | ESP Analytics | Comparative deliverability metrics across providers. |

## 4. Detailed View Descriptions

### `/dashboard/settings/integrations/esp` - ESP Integration Overview

**User Story**: *"As an admin, I want to see all configured ESPs at a glance and quickly add new providers, so I can manage my email delivery infrastructure efficiently."*

**What You'll Find**:

#### Configured Providers Section

**Provider Cards** (Grid Layout):

Each card displays:

- **Provider Logo**: Postmark, Mailgun, or Built-in SMTP icon.
- **Status Badge**:
  - **Active** (Green): Connected and sending.
  - **Configured** (Blue): Set up but not actively used.
  - **Error** (Red): Connection issue or invalid credentials.
  - **Not Configured** (Gray): Available but not set up.

- **Quick Stats**:
  - Emails sent today: "1,234"
  - Delivery rate: "99.2%"
  - Last used: "2 hours ago"

- **Actions**:
  - **Configure** button (if not configured).
  - **Test Connection** button.
  - **View Settings** link.
  - **Disable** toggle.

**Available Providers**:

- Postmark (Transactional)
- Mailgun (Marketing)
- Built-in SMTP (Always available)
- SendGrid (Coming Soon - grayed out)
- Amazon SES (Coming Soon - grayed out)

#### Quick Actions Bar

- **"+ Add ESP" Button**: Opens provider selection modal.
- **"Configure Routing" Button**: Navigate to routing rules.
- **"View Analytics" Button**: Navigate to ESP analytics.

#### Routing Summary

**Current Routing Configuration** (Collapsed by default):

```text
Transactional Emails → Postmark
Marketing Emails → Mailgun
Cold Outreach → Built-in SMTP
Default → Built-in SMTP
```

**"Edit Routing Rules" Link**: Opens routing configuration.

**User Journey Context**: First stop for ESP management. Quick overview before diving into specific configurations.

**Related Documentation**:

- [ESP Integration Overview](/docs/features/integrations/esp-integration)
- [Email Infrastructure Setup](/docs/features/infrastructure/email-infrastructure-setup)

---

### `/dashboard/settings/integrations/esp/postmark` - Postmark Configuration

**User Story**: *"As an admin, I want to configure Postmark for transactional emails, so critical messages like password resets reach users reliably."*

**What You'll Find**:

#### Connection Status

- **Status Indicator**: Connected (Green) or Disconnected (Red).
- **Last Tested**: "5 minutes ago".
- **Test Connection Button**: Sends test email and validates API token.

#### API Configuration

**API Token**:

- **Input Field**: Password-masked input.
- **"Show" Toggle**: Reveal token temporarily.
- **Validation**: Real-time check on blur.
- **Help Text**: "Get your Server API Token from Postmark → Servers → API Tokens"
- **Link**: "View Postmark Dashboard" (opens in new tab).

**Default Sender**:

- **Input Field**: Email address (e.g., `noreply@yourdomain.com`).
- **Validation**: Must be verified in Postmark.
- **Status**: "Verified" (Green checkmark) or "Unverified" (Warning icon).

#### Tracking Options

**Checkboxes**:

- ☑ **Track Opens**: Enable open tracking pixels.
- ☑ **Track Links**: Convert links to tracking URLs.
- ☐ **Track Delivery**: Receive delivery confirmations (webhook required).

**Note**: "Tracking requires webhook configuration. [Set up webhooks →](/dashboard/settings/integrations/esp/webhooks)"

#### Domain Verification

**Verified Domains** (Table):

- Columns: Domain, Status, DKIM, Return-Path, Actions.
- **Status**: Verified (Green), Pending (Yellow), Failed (Red).
- **Actions**: "View DNS Records", "Re-verify", "Remove".

**"+ Add Domain" Button**: Opens domain verification wizard.

#### Advanced Settings

**Expandable Section**:

- **Message Stream**: Dropdown (Default, Broadcasts, etc.).
- **Batch Size**: Number input (1-500, default: 50).
- **Retry Attempts**: Number input (0-5, default: 3).
- **Timeout**: Seconds (5-60, default: 30).

#### Test Email

**Send Test Email Section**:

- **Recipient Email**: Input field.
- **"Send Test" Button**: Sends sample email via Postmark.
- **Result Display**: Success message with delivery time or error details.

**Save Button**: Bottom-right, saves all configuration.

**User Journey Context**: One-time setup, occasional updates when rotating API keys.

**Related Documentation**:

- [Postmark Integration Guide](/docs/features/integrations/esp-integration#postmark-integration)
- [Domain Verification](/docs/features/domains/domain-management)

**Technical Integration**:

- **API**: Postmark REST API v1.
- **Validation**: Test API call to `/email` endpoint on save.
- **Storage**: API token encrypted at rest in database.

---

### `/dashboard/settings/integrations/esp/mailgun` - Mailgun Configuration

**User Story**: *"As an admin, I want to configure Mailgun for marketing campaigns, so I can send high-volume emails with advanced features."*

**What You'll Find**:

#### Connection Status

- **Status Indicator**: Connected (Green) or Disconnected (Red).
- **Last Tested**: "10 minutes ago".
- **Test Connection Button**: Validates API key and domain.

#### API Configuration

**API Key**:

- **Input Field**: Password-masked input.
- **"Show" Toggle**: Reveal key temporarily.
- **Validation**: Real-time check on blur.
- **Help Text**: "Get your Private API Key from Mailgun → Settings → API Keys"
- **Link**: "View Mailgun Dashboard" (opens in new tab).

**Domain**:

- **Input Field**: Sending domain (e.g., `mail.yourdomain.com`).
- **Validation**: Must be verified in Mailgun.
- **Status**: "Active" (Green) or "Unverified" (Warning).

**Region**:

- **Radio Buttons**:
  - ○ US (api.mailgun.net)
  - ○ EU (api.eu.mailgun.net)
- **Help Text**: "Choose based on your Mailgun account region."

#### Tracking Options

**Checkboxes**:

- ☑ **Track Opens**: Enable open tracking.
- ☑ **Track Clicks**: Enable click tracking.
- ☑ **Automatic Unsubscribe**: Add unsubscribe links automatically.
- ☐ **DKIM Signing**: Sign emails with DKIM (requires domain setup).

#### Domain Verification

**Verified Domains** (Table):

- Columns: Domain, Status, SPF, DKIM, CNAME, Actions.
- **Status**: Verified (Green), Pending (Yellow), Failed (Red).
- **Actions**: "View DNS Records", "Re-verify", "Remove".

**"+ Add Domain" Button**: Opens domain verification wizard with DNS instructions.

#### Advanced Settings

**Expandable Section**:

- **Tag Prefix**: Text input (e.g., "pm-" for PenguinMails tags).
- **Batch Size**: Number input (1-1000, default: 100).
- **Retry Attempts**: Number input (0-5, default: 3).
- **Timeout**: Seconds (5-60, default: 30).
- **Testmode**: Toggle (sends to Mailgun's test mode, no actual delivery).

#### Email Validation

**List Validation Section**:

- **"Validate Email List" Button**: Opens modal for CSV upload.
- **Validation Results**: Shows valid, invalid, risky emails.
- **Cost Estimate**: "$0.50 per 1,000 emails validated"

#### Test Email

**Send Test Email Section**:

- **Recipient Email**: Input field.
- **Tags** (optional): Comma-separated tags.
- **"Send Test" Button**: Sends sample email via Mailgun.
- **Result Display**: Success with message ID or error details.

**Save Button**: Bottom-right, saves all configuration.

**User Journey Context**: One-time setup, occasional updates for new domains or API rotation.

**Related Documentation**:

- [Mailgun Integration Guide](/docs/features/integrations/esp-integration#mailgun-integration)
- [Email Validation](/docs/features/leads/import-export#email-validation)

**Technical Integration**:

- **API**: Mailgun REST API v3.
- **Validation**: Test API call to `/messages` endpoint on save.
- **Storage**: API key encrypted at rest in database.

---

### `/dashboard/settings/integrations/esp/routing` - Email Routing Rules

**User Story**: *"As an admin, I want to route different email types through different ESPs, so I can optimize deliverability and costs."*

**What You'll Find**:

#### Routing Strategy Overview

**Visual Diagram**:

```text
Email Type → Provider

┌─────────────────────┐
│ Transactional       │ → Postmark
├─────────────────────┤
│ Marketing           │ → Mailgun
├─────────────────────┤
│ Cold Outreach       │ → Built-in SMTP
├─────────────────────┤
│ Default (Fallback)  │ → Built-in SMTP
└─────────────────────┘
```

#### Routing Rules Builder

**Rule Cards** (Drag-and-drop reorderable):

Each rule card contains:

**Rule 1: Transactional Emails**

- **Email Type**: Dropdown
  - Options: Transactional, Marketing, Cold Outreach, Newsletter, Promotional, Custom
- **Conditions** (Optional):
  - Add condition: "Subject contains", "Recipient domain is", "Tag equals"
- **Route To**: Dropdown
  - Options: Postmark, Mailgun, Built-in SMTP
- **Priority**: Number (1 = highest)
- **Enabled**: Toggle switch
- **Actions**: Edit, Delete, Duplicate

**"+ Add Routing Rule" Button**: Creates new rule card.

#### Email Type Definitions

**Expandable Section** showing what qualifies as each type:

**Transactional**:

- Password resets
- Email verification
- Order confirmations
- Account alerts
- System notifications

**Marketing**:

- Newsletters
- Product announcements
- Promotional campaigns
- Event invitations

**Cold Outreach**:

- Sales prospecting
- Lead generation
- Custom campaigns

#### Failover Configuration

**Failover Strategy Section**:

- **Enable Failover**: Toggle switch.
- **Retry Attempts**: Number input (1-5, default: 3).
- **Retry Delay**: Seconds (10-300, default: 30).

**Failover Order** (Drag-and-drop):

1. Primary: Postmark
2. Secondary: Mailgun
3. Final: Built-in SMTP

**Help Text**: "If primary ESP fails, automatically retry with secondary after delay."

#### Cost Optimization

**Smart Routing Section**:

- ☑ **Use Free Tiers First**: Route through ESPs with remaining free quota.
- ☑ **Volume-Based Routing**: Route high-volume sends through cheapest provider.
- ☐ **Time-Based Routing**: Route based on time of day (e.g., off-peak hours).

**Estimated Monthly Cost**:

```text
Current Configuration:
- Postmark: 5,000 emails × $0.00125 = $6.25
- Mailgun: 95,000 emails × $0.00058 = $55.00
- Built-in SMTP: 100,000 emails × $0 = $0.00
Total: $61.25/month
```

**Save Button**: Bottom-right, saves routing configuration.

**User Journey Context**: Set up once, adjust as email volume grows or ESP pricing changes.

**Related Documentation**:

- [ESP Routing Strategy](/docs/features/integrations/esp-integration#routing-rules)
- [Cost Optimization](/docs/features/integrations/esp-integration#cost-optimization)

**Technical Integration**:

- **Rule Engine**: Evaluates rules in priority order.
- **Caching**: Routing decisions cached for 5 minutes.
- **Monitoring**: Track routing decisions in analytics.

---

### `/dashboard/settings/integrations/esp/webhooks` - Webhook Configuration

**User Story**: *"As an admin, I want to receive real-time delivery events from ESPs, so I can track email performance accurately."*

**What You'll Find**:

#### Webhook Endpoints

**Postmark Webhook**:

- **Endpoint URL**: `https://api.penguinmails.com/webhooks/postmark`
- **Copy Button**: Copy URL to clipboard.
- **Status**: Active (Green) or Inactive (Gray).
- **Events Received Today**: "1,234"
- **Last Event**: "2 minutes ago"

**Mailgun Webhook**:

- **Endpoint URL**: `https://api.penguinmails.com/webhooks/mailgun`
- **Copy Button**: Copy URL to clipboard.
- **Status**: Active (Green) or Inactive (Gray).
- **Events Received Today**: "5,678"
- **Last Event**: "5 minutes ago"

#### Event Subscriptions

**Postmark Events** (Checkboxes):

- ☑ **Delivery**: Email successfully delivered.
- ☑ **Bounce**: Email bounced (hard or soft).
- ☑ **Open**: Recipient opened email.
- ☑ **Click**: Recipient clicked link.
- ☐ **Spam Complaint**: Recipient marked as spam.
- ☐ **Subscription Change**: Unsubscribe or resubscribe.

**Mailgun Events** (Checkboxes):

- ☑ **Delivered**: Email successfully delivered.
- ☑ **Failed**: Permanent delivery failure.
- ☑ **Opened**: Recipient opened email.
- ☑ **Clicked**: Recipient clicked link.
- ☐ **Unsubscribed**: Recipient unsubscribed.
- ☐ **Complained**: Spam complaint.

#### Webhook Security

**Signature Verification**:

- **Postmark**: Uses `X-Postmark-Signature` header.
- **Mailgun**: Uses `X-Mailgun-Signature` header with timestamp.
- **Status**: Verified (Green checkmark) or "Configure signing key".

**IP Whitelist** (Optional):

- **Postmark IPs**: `50.31.156.6, 50.31.156.77, ...`
- **Mailgun IPs**: `209.61.151.0/24, ...`
- **"Add to Firewall" Button**: Generates firewall rules.

#### Webhook Logs

**Recent Events Table**:

- Columns: Timestamp, Provider, Event Type, Email, Status, Details.
- **Filters**: Provider, Event Type, Date Range.
- **Search**: Search by email or message ID.
- **Export**: Download logs as CSV.

**Example Rows**:

| Timestamp | Provider | Event | Email | Status | Details |
|-----------|----------|-------|-------|--------|---------|
| 2:34 PM | Postmark | Delivery | <user@example.com> | Success | Delivered in 1.2s |
| 2:33 PM | Mailgun | Open | <lead@company.com> | Success | Opened on mobile |
| 2:30 PM | Postmark | Bounce | <invalid@test.com> | Hard Bounce | User unknown |

**"View Full Log" Link**: Opens detailed webhook event viewer.

#### Webhook Testing

**Test Webhook Section**:

- **Provider**: Dropdown (Postmark, Mailgun).
- **Event Type**: Dropdown (Delivery, Bounce, Open, Click).
- **"Send Test Event" Button**: Triggers test webhook from ESP.
- **Result Display**: Shows received payload and processing status.

**User Journey Context**: Set up once during ESP configuration, check logs when troubleshooting delivery issues.

**Related Documentation**:

- [Webhook Integration](/docs/features/integrations/webhook-system)
- [ESP Webhooks](/docs/features/integrations/esp-integration#webhook-integration)

**Technical Integration**:

- **Webhook Handler**: Express.js endpoint with signature verification.
- **Event Processing**: Async job queue for webhook events.
- **Retry Logic**: Exponential backoff for failed webhook processing.

---

### `/dashboard/settings/integrations/esp/analytics` - ESP Analytics

**User Story**: *"As an admin, I want to compare ESP performance, so I can optimize my email routing strategy."*

**What You'll Find**:

#### Provider Comparison Dashboard

**Time Range Selector**:

- Buttons: Last 7 Days, Last 30 Days, Last 90 Days, Custom Range.

**Metrics Cards** (Top Row):

- **Total Emails Sent**: "156,789"
- **Average Delivery Rate**: "97.8%"
- **Average Open Rate**: "38.5%"
- **Average Click Rate**: "9.2%"

#### Deliverability Comparison

**Table View**:

| Provider | Sent | Delivered | Bounced | Opened | Clicked | Delivery Rate |
|----------|------|-----------|---------|--------|---------|---------------|
| Postmark | 5,234 | 5,192 | 42 (0.8%) | 2,352 (45.3%) | 634 (12.1%) | 99.2% |
| Mailgun | 95,123 | 93,678 | 1,445 (1.5%) | 35,789 (38.2%) | 9,234 (9.7%) | 98.5% |
| Built-in | 56,432 | 53,098 | 3,334 (5.9%) | 16,726 (31.5%) | 3,876 (7.3%) | 94.1% |

**Chart View**:

- **Line Chart**: Delivery rate over time for each provider.
- **Bar Chart**: Sent volume by provider.
- **Pie Chart**: Email type distribution.

#### Performance Insights

**Recommendations Section**:

- ✅ **Postmark**: "Excellent for transactional emails. 99.2% delivery rate."
- ⚠️ **Mailgun**: "Good performance. Consider warming up new domains."
- ⚠️ **Built-in SMTP**: "Lower delivery rate. Review IP reputation and warmup strategy."

**Cost Analysis**:

```text
Cost per Delivered Email:
- Postmark: $0.00126 (5,192 delivered)
- Mailgun: $0.00059 (93,678 delivered)
- Built-in: $0.00000 (53,098 delivered)

Total Cost This Month: $61.25
Projected Annual Cost: $735.00
```

#### Bounce Analysis

**Bounce Reasons** (Pie Chart):

- Hard Bounce (User Unknown): 45%
- Soft Bounce (Mailbox Full): 30%
- Spam Block: 15%
- Invalid Domain: 10%

**Top Bouncing Domains**:

1. `example.com` - 234 bounces
2. `test.org` - 156 bounces
3. `invalid.net` - 89 bounces

**"Export Bounce List" Button**: Download CSV of bounced emails.

#### Engagement Metrics

**Open Rate by Provider** (Bar Chart):

- Postmark: 45.3%
- Mailgun: 38.2%
- Built-in: 31.5%

**Click Rate by Provider** (Bar Chart):

- Postmark: 12.1%
- Mailgun: 9.7%
- Built-in: 7.3%

**Time to Open** (Line Chart):

- Shows average time from send to first open for each provider.

**User Journey Context**: Regular monitoring (weekly/monthly) to optimize ESP usage and routing.

**Related Documentation**:

- [Analytics Overview](/docs/features/analytics/core-analytics/overview)
- [Deliverability Monitoring](/docs/features/warmup/reputation-monitoring)

**Technical Integration**:

- **Data Source**: Aggregated from webhook events and ESP APIs.
- **Caching**: Metrics cached for 15 minutes.
- **Export**: Generate CSV/PDF reports.

## 5. Related API Endpoints

| Route | Related API | Description |
|---|---|---|
| `/settings/integrations/esp` | [ESP API](/docs/implementation-technical/api/tenant-api/esp-config) | `GET /api/v1/tenant/esp/providers` (List configured ESPs). |
| `/settings/integrations/esp/postmark` | [ESP API](/docs/implementation-technical/api/tenant-api/esp-config) | `POST /api/v1/tenant/esp/postmark` (Configure Postmark). |
| `/settings/integrations/esp/mailgun` | [ESP API](/docs/implementation-technical/api/tenant-api/esp-config) | `POST /api/v1/tenant/esp/mailgun` (Configure Mailgun). |
| `/settings/integrations/esp/routing` | [ESP API](/docs/implementation-technical/api/tenant-api/esp-config) | `PUT /api/v1/tenant/esp/routing` (Update routing rules). |
| `/settings/integrations/esp/webhooks` | [Webhook API](/docs/implementation-technical/api/platform-api/webhooks) | `POST /webhooks/postmark`, `POST /webhooks/mailgun` (Receive events). |
| `/settings/integrations/esp/analytics` | [Analytics API](/docs/implementation-technical/api/tenant-api/analytics) | `GET /api/v1/tenant/analytics/esp` (ESP performance metrics). |

## 6. Data Strategy

- **Fetching Method**:
  - **ESP List**: Server Component (cached for 5 minutes).
  - **Configuration**: Server Component with real-time validation.
  - **Analytics**: Client Component with SWR for real-time updates.
- **Caching**:
  - **Provider Status**: Cached for 5 minutes.
  - **Analytics**: Cached for 15 minutes.
  - **Webhook Logs**: No caching (real-time).
- **Security**:
  - **API Keys**: Encrypted at rest, never exposed to client.
  - **Webhook Signatures**: Verified on every request.
  - **Admin Only**: All ESP routes require admin role.

## 7. Edge Cases & Error Handling

- **Invalid API Key**: Show "Invalid API key. Please check your credentials and try again."
- **Domain Not Verified**: Block sending until domain verified. Show "Domain verification required. [View DNS records →]"
- **ESP Service Down**: Show "Unable to connect to [Provider]. Using fallback provider."
- **Webhook Signature Mismatch**: Log security warning, reject webhook, alert admin.
- **Rate Limit Exceeded**: Show "ESP rate limit reached. Emails queued for retry."
- **Routing Conflict**: Warn if multiple rules match same email type. "Rule priority determines which ESP is used."

## 8. Component Architecture

### Page Components

- **`ESPOverview`** (Server)
  - Features: Provider cards, quick stats, routing summary.
- **`PostmarkConfig`** (Client)
  - Features: API token input, domain verification, test email.
- **`MailgunConfig`** (Client)
  - Features: API key input, region selection, email validation.
- **`RoutingBuilder`** (Client)
  - Features: Drag-and-drop rules, visual routing diagram.
- **`WebhookLogs`** (Client)
  - Features: Real-time event stream, filtering, export.
- **`ESPAnalytics`** (Client)
  - Features: Interactive charts, provider comparison, cost analysis.

### Shared Components

- **`ProviderCard`**: Reused across ESP overview and analytics.
- **`ConnectionTest`**: Reused in Postmark and Mailgun config.
- **`DeliverabilityChart`**: Reused in analytics and campaign views.

## 9. Related Documentation

### Feature Documentation

- **[ESP Integration](/docs/features/integrations/esp-integration)** - Complete ESP integration guide
- **[Webhook System](/docs/features/integrations/webhook-system)** - Webhook configuration and events
- **[Email Infrastructure](/docs/features/infrastructure/email-infrastructure-setup)** - SMTP and infrastructure setup

### Technical Documentation

- **[ESP API Reference](/docs/implementation-technical/api/tenant-api/esp-config)** - API endpoints for ESP configuration
- **[Webhook API Reference](/docs/implementation-technical/api/platform-api/webhooks)** - Webhook endpoint specifications
- **[Analytics API Reference](/docs/implementation-technical/api/tenant-api/analytics)** - ESP analytics endpoints

### User Journeys

- **[Operations Team Journey](/user-journeys/internal-users/operations-journeys)** - ESP setup and monitoring workflows
- **[Developer Journey](/user-journeys/internal-users/technical-teams-journeys)** - API integration and webhook setup

---

**Last Updated:** November 25, 2025  
**Supported ESPs:** Postmark, Mailgun  
**Coming Soon:** SendGrid, Amazon SES

*ESP integration routes provide comprehensive configuration and monitoring for external email service providers, enabling optimized deliverability and cost management.*
