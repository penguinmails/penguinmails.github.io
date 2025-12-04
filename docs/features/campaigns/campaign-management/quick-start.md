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

Dashboard â†’ Campaigns â†’ Create New Campaign

Campaign Setup:
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ Campaign Name: "Welcome Series"                     â”‚
â”‚ Campaign Type: â˜‘ Drip Campaign                      â”‚
â”‚ Target Audience: Select segment (500 contacts)      â”‚
â”‚ From Address: sales@yourcompany.com                 â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜

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

â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ Sequence Builder                                 â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚                                                  â”‚
â”‚  [START]                                         â”‚
â”‚     â”‚                                            â”‚
â”‚     â–¼                                            â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”                        â”‚
â”‚  â”‚ Email 1: Welcome    â”‚                        â”‚
â”‚  â”‚ Subject: Welcome!   â”‚                        â”‚
â”‚  â”‚ Template: Welcome   â”‚                        â”‚
â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜                        â”‚
â”‚     â”‚                                            â”‚
â”‚     â”‚ â± Wait 2 days                             â”‚
â”‚     â–¼                                            â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”                        â”‚
â”‚  â”‚ Email 2: Overview   â”‚                        â”‚
â”‚  â”‚ Subject: Features   â”‚                        â”‚
â”‚  â”‚ Template: Product   â”‚                        â”‚
â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜                        â”‚
â”‚     â”‚                                            â”‚
â”‚     â”‚ â± Wait 3 days                             â”‚
â”‚     â–¼                                            â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”                        â”‚
â”‚  â”‚ Email 3: Offer      â”‚                        â”‚
â”‚  â”‚ Subject: 20% Off    â”‚                        â”‚
â”‚  â”‚ Template: Promo     â”‚                        â”‚
â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜                        â”‚
â”‚     â”‚                                            â”‚
â”‚     â–¼                                            â”‚
â”‚  [END]                                           â”‚
â”‚                                                  â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜

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
  â˜‘ Use contact first name
  â˜‘ Include company name
  â˜‘ Add custom fields

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

[Preview Campaign] [Send Test Email] [Launch Campaign]

```

#### Step 5: Monitor Performance

**Campaign Dashboard:**

```text

Campaign: Welcome Series
Status: Active | Started: Nov 25, 2025

Overall Performance:
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ Sent: 500 | Delivered: 485 (97%)                    â”‚
â”‚ Opens: 242 (50%) | Clicks: 97 (20%)                 â”‚
â”‚ Replies: 23 (4.7%) | Unsubscribes: 2 (0.4%)         â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜

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

