---
title: "Marketing Platform API - External Integrations"
description: "Integration endpoints for CRM systems (Salesforce, HubSpot), CDPs, and webhooks."
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---

# Marketing Platform API - External Integrations

## CRM and Data Integrations

### Salesforce Integration

```http
POST /api/v1/integrations/crm/salesforce/sync
```

**Request Body:**

```json
{
  "sync_direction": "bi_directional",
  "objects": ["lead", "contact", "account"],
  "mapping": {
    "lead": {
      "marketing_platform.field": "salesforce.field",
      "email": "Email",
      "company": "Company"
    }
  },
  "sync_frequency": "real_time"
}
```

### HubSpot Integration

```http
POST /api/v1/integrations/crm/hubspot/contacts
```

**Request Body:**

```json
{
  "action": "create_or_update",
  "contacts": [
    {
      "properties": {
        "email": "john.doe@company.com",
        "firstname": "John",
        "lastname": "Doe"
      }
    }
  ]
}
```

### Customer Data Platform (CDP) Integration

```http
POST /api/v1/integrations/cdp/audience/update
```

**Request Body:**

```json
{
  "audience_id": "aud_enterprise_customers",
  "operation": "add_members",
  "members": [
    {
      "external_id": "contact_456",
      "attributes": {
        "engagement_score": 85
      }
    }
  ]
}
```

## Webhook Integration API

### Register Webhook Endpoint

```http
POST /api/v1/webhooks
```

**Request Body:**

```json
{
  "url": "https://your-crm.com/webhooks/marketing-platform",
  "events": [
    "campaign.sent",
    "lead.captured",
    "conversion.success"
  ],
  "secret": "your_webhook_secret_key"
}
```

### Webhook Verification (Node.js Example)

```javascript
// Signature verification
const crypto = require('crypto');

function verifyWebhook(payload, signature, secret) {
  const expectedSignature = crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('hex');

  return signature === `sha256=${expectedSignature}`;
}
```
