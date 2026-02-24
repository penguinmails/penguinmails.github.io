---
title: "Webhook Routes - Testing & Implementation"
description: "Interactive testing tools for webhooks and code implementation examples for signature verification."
last_modified_date: "2026-02-24"
level: "2"
persona: "Developers"
---

# Webhook Routes - Testing & Implementation

### `/dashboard/settings/webhooks/[webhook_id]/test` - Manual Testing

#### Test Event Configuration

- **Event Type Selection**: Dropdown (email.sent, email.opened, etc.).
- **Data Source**:
  - ○ **Use Sample Data** (System default)
  - ○ **Use Real Data** (Select Campaign/Contact)

#### Test Payload Preview

Live preview of the JSON payload that will be sent to the endpoint.

```json
{
  "id": "evt_test_123",
  "type": "email.opened",
  "created_at": "2025-11-15T10:30:00Z",
  "data": {
    "email_id": "eml_abc456",
    "contact": { "email": "test@example.com" }
  }
}
```

**"Send Test Webhook" Button**: Triggers a real POST request to the configured URL.

#### Test Results View

- **Success**:
  - Status: ✓ 200 OK
  - Time: 124ms
  - Body: "OK"
- **Failure**:
  - Status: ✘ Connection Timeout
  - Error: "Endpoint did not respond within 5000ms"

---

### Code Examples (Implementation)

#### Signature Verification (Node.js)

```javascript
const crypto = require('crypto');

function verifySignature(payload, signature, secret) {
  const hmac = crypto.createHmac('sha256', secret);
  hmac.update(payload);
  const computed = hmac.digest('hex');
  const expected = `sha256=${computed}`;
  
  return crypto.timingSafeEqual(
    Buffer.from(expected),
    Buffer.from(signature)
  );
}

// Usage with Express
app.post('/webhooks', (req, res) => {
  const signature = req.headers['x-penguinmails-signature'];
  const isValid = verifySignature(JSON.stringify(req.body), signature, process.env.WH_SECRET);
  // ...
});
```

#### Event Schema (email.opened)

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
      "email": "string"
    },
    "metadata": {
      "user_agent": "string",
      "ip_address": "string",
      "location": {
        "city": "string",
        "country": "string"
      }
    }
  }
}
```
