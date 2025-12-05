---
title: "Level 1: Quick Start Guide"
description: "Basic campaign creation and management workflows"
level: "1"
persona: "Marketing Users"
keywords: "quick start, campaign creation, email editor, send campaigns"
---

# Level 1: Quick Start Guide

## Level 1: Quick Start Guide

### Your First Campaign

#### Step 1: Create a New Campaign

```text

Dashboard → Campaigns → Create New Campaign

Campaign Setup:
┌─────────────────────────────────────────────────────┐
│ Campaign Name: "Welcome Series"                     │
│ Campaign Type: ☑ Drip Campaign                      │
│ Target Audience: Select segment (500 contacts)      │
│ From Address: sales@yourcompany.com                 │
└─────────────────────────────────────────────────────┘

```

#### Step 2: Build Your Sequence

**Simple 3-Email Welcome Sequence:**

```text

Email 1: Welcome Email (Send immediately)
  â†“ Wait 2 days
Email 2: Product Overview (Send 2 days after signup)
  â†“ Wait 3 days
Email 3: Special Offer (Send 5 days after signup)

```

**Visual Builder:**

```text

┌──────────────────────────────────────────────────┐
│ Sequence Builder                                 │
├──────────────────────────────────────────────────┤
│                                                  │
│  [START]                                         │
│     │                                            │
│     â–¼                                            │
│  ┌─────────────────────┐                        │
│  │ Email 1: Welcome    │                        │
│  │ Subject: Welcome!   │                        │
│  │ Template: Welcome   │                        │
│  └─────────────────────┘                        │
│     │                                            │
│     │ â± Wait 2 days                             │
│     â–¼                                            │
│  ┌─────────────────────┐                        │
│  │ Email 2: Overview   │                        │
│  │ Subject: Features   │                        │
│  │ Template: Product   │                        │
│  └─────────────────────┘                        │
│     │                                            │
│     │ â± Wait 3 days                             │
│     â–¼                                            │
│  ┌─────────────────────┐                        │
│  │ Email 3: Offer      │                        │
│  │ Subject: 20% Off    │                        │
│  │ Template: Promo     │                        │
│  └─────────────────────┘                        │
│     │                                            │
│     â–¼                                            │
│  [END]                                           │
│                                                  │
└──────────────────────────────────────────────────┘

```

#### Step 3: Configure Email Content

**Email 1 Setup:**

```text

Subject Line: Welcome to {{company}}!
Preview Text: Thanks for signing up, {{firstName}}

Template: Select from library or create new

  - Welcome Email Template

  - Getting Started Template

  - Custom Template

Personalization:
  ☑ Use contact first name
  ☑ Include company name
  ☑ Add custom fields

```

#### Step 4: Review and Launch

**Pre-Launch Checklist:**

```text

Campaign Review:
âœ“ Audience: 500 contacts selected
âœ“ Sequence: 3 emails configured
âœ“ Templates: All emails have content
âœ“ Personalization: Variables validated
âœ“ Schedule: Ready to launch
âœ“ From Address: Verified and warmed
âœ“ Deliverability: [Myths Checked](/guides/deliverability-myths-debunked)

[Preview Campaign] [Send Test Email] [Launch Campaign]

```

#### Step 5: Monitor Performance

**Campaign Dashboard:**

```text

Campaign: Welcome Series
Status: Active | Started: Nov 25, 2025

Overall Performance:
┌─────────────────────────────────────────────────────┐
│ Sent: 500 | Delivered: 485 (97%)                    │
│ Opens: 242 (50%) | Clicks: 97 (20%)                 │
│ Replies: 23 (4.7%) | Unsubscribes: 2 (0.4%)         │
└─────────────────────────────────────────────────────┘

Step Performance:
Email 1: 500 sent | 50% open | 20% click
Email 2: 350 sent | 45% open | 18% click
Email 3: 200 sent | 40% open | 15% click

```

### Campaign Types

#### One-Time Broadcast

Send a single email to your entire list or segment:

```text

Use Cases:

- Product announcements

- Newsletter broadcasts

- Event invitations

- Special promotions

Setup Time: 5 minutes
Best For: Time-sensitive announcements

```

#### Drip Campaign

Automated sequence delivered over time:

```text

Use Cases:

- Welcome series (3-5 emails)

- Onboarding sequences (5-10 emails)

- Educational content series

- Lead nurturing campaigns

Setup Time: 15-30 minutes
Best For: Relationship building

```

#### Triggered Campaign

Event-based campaigns that start automatically:

```text

Triggers:

- Contact signup

- Form submission

- Purchase completion

- Abandoned cart

- Custom events

Setup Time: 20-40 minutes
Best For: Behavioral automation

```

#### A/B Test Campaign

Compare variations to optimize performance:

```text

Test Elements:

- Subject lines

- Email content

- Send times

- Sender names

Setup Time: 10-20 minutes
Best For: Performance optimization

```

---
