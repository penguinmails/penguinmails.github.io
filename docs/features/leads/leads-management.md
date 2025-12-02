---
title: "Leads Management"
description: "Contact management, list segmentation, and lead scoring"
last_modified_date: "2025-11-24"
level: "2"
persona: "Marketers, Sales Teams"
status: "ACTIVE"
category: "Leads"
---

# Leads Management

## Centralized contact management with powerful segmentation and enrichment capabilities

---

## Overview

Leads Management is the core of your audience strategy. It allows you to import, organize, clean, and segment your contacts to ensure the right message reaches the right person.

### Key Features

- **Contact Database** - Unified view of all leads

- **Smart Lists** - Dynamic segmentation based on behavior

- **Custom Fields** - Store any data point

- **Lead Scoring** - Identify high-value prospects

- **Import/Export** - CSV and API support

---

## Level 1: Managing Contacts

### Adding Contacts

## Methods

1. **CSV Import**: Bulk upload via dashboard.

2. **Manual Entry**: Add one-by-one.

3. **API**: Programmatic sync from CRM.

4. **Forms**: Web forms on your landing pages.

### Contact Profile

## Standard Fields

- Email Address (Unique Identifier)

- First Name / Last Name

- Company Name

- Job Title

- Phone Number

- Status (Active, Unsubscribed, Bounced)

## Custom Fields

Create fields specific to your business:

- `Industry` (Text)

- `Budget` (Number)

- `Subscription Date` (Date)

- `VIP Status` (Boolean)

---

## Level 2: Segmentation

### Static Lists

## Manual collections of contacts

- Example: "Conference Attendees 2025"

- Contacts are manually added or removed.

### Smart Segments

## Dynamic lists based on rules

Automatically update as contact data changes.

## Example Rules

- `Industry` IS "Technology" AND `Location` IS "USA"

- `Last Opened Email` < 30 days ago

- `Lead Score` > 50

## Use Cases

- Re-engagement campaigns for inactive users

- VIP offers for high-value leads

- Industry-specific newsletters

---

## Level 3: Lead Scoring & Enrichment

### Lead Scoring

## Assign points based on engagement

| Action | Points |
|--------|--------|
| Opened Email | +1 |
| Clicked Link | +5 |
| Replied | +10 |
| Visited Pricing Page | +20 |
| Bounced | -50 |
| Unsubscribed | Reset to 0 |

## Score Tiers

- **Hot (50+)**: Ready for sales outreach

- **Warm (20-49)**: Nurture with content

- **Cold (<20)**: Awareness campaigns

### Data Enrichment (Future)

*Coming Q2 2026*
Automatically populate missing fields (Company Size, Location, Social Profiles) based on email domain.

---

## Technical Implementation

### Database Schema

```sql

CREATE TABLE contacts (
  id UUID PRIMARY KEY,
  tenant_id UUID REFERENCES tenants(id),
  email VARCHAR(255) NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  attributes JSONB DEFAULT '{}', -- Custom fields
  score INT DEFAULT 0,
  status VARCHAR(20) DEFAULT 'active',
  created_at TIMESTAMP,
  updated_at TIMESTAMP,

  UNIQUE(tenant_id, email)
);

CREATE TABLE lists (
  id UUID PRIMARY KEY,
  tenant_id UUID,
  name VARCHAR(255),
  type VARCHAR(20) -- 'static' or 'dynamic'
);

```

### API Usage

```text

// Add a contact
POST /api/v1/contacts
{
  "email": "<lead@example.com>",
  "first_name": "Jane",
  "attributes": {
    "industry": "SaaS"
  }
}

// Search contacts
GET /api/v1/contacts/search?query=industry:SaaS

```

---

## Related Documentation

### Campaigns

- **[Campaign Management](/docs/features/campaigns/campaign-management/overview)** - Sending to lists

### Compliance

- **[GDPR Compliance](/docs/features/compliance/gdpr-compliance)** - Data rights

- **[Unsubscribe Management](/docs/features/compliance/unsubscribe-management)** - Opt-out handling

---

**Last Updated:** November 24, 2025
**Capacity:** Unlimited contacts (billed by usage)

*Clean data is the foundation of effective marketing. Use segmentation to send relevant content every time.*


