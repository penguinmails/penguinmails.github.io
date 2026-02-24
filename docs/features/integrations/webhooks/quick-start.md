---
title: "Webhooks Quick Start"
description: "Setting up your first webhook and receiving real-time event notifications."
last_modified_date: "2026-02-24"
level: "2"
persona: "Developers"
---

# Webhooks Quick Start

Webhooks allow PenguinMails to push real-time notifications to your application whenever specific events occur (e.g., an email is opened or a campaign is finished).

## 1. Create a Webhook

Navigate to **Settings → Integrations → Webhooks → Create Webhook**.

**Configuration:**

- **Name**: e.g., "CRM Sync"
- **Endpoint URL**: The URL on your server that will receive the `POST` requests.
- **Events**: Select the events you want to subscribe to (e.g., `email.opened`, `email.clicked`, `campaign.completed`).

## 2. Receiving Events

Your endpoint must be able to receive `POST` requests with a JSON payload and respond with a `200 OK` within 5 seconds.

**Example Payload (`email.opened`):**

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
      "email": "user@example.com"
    }
  }
}
```

## 3. Simple Node.js Receiver

```javascript
const express = require('express');
const app = express();
app.use(express.json());

app.post('/webhooks/penguinmails', (req, res) => {
  const event = req.body;
  
  // Handle the event
  console.log(`Received event: ${event.type}`);
  
  // Return a 200 OK response quickly
  res.status(200).send('OK');
});

app.listen(3000, () => console.log('Listening for webhooks on port 3000'));
```

## Supported Events

- `email.sent`
- `email.opened`
- `email.clicked`
- `email.bounced`
- `email.unsubscribed`
- `campaign.started`
- `campaign.completed`
