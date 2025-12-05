---
title: "Frontend UI Specification"
description: "UI specifications for API key management"
level: "3"
keywords: "UI, frontend, user interface"
---

# Frontend UI Specification

## Frontend UI Specification

### Route: `/dashboard/settings/developers/api-keys`

**Page Title:** API Keys

**Layout:** Settings page with sidebar navigation

**Components:**

#### 1. API Key List Table

**Columns:**

- Name (user-provided)

- Key (masked: `pm_live_abc...xyz`)

- Permissions (badges)

- Rate Limit (requests/min)

- Status (Active, Revoked)

- Last Used (relative time: "2 hours ago")

- Actions (Copy, Regenerate, Revoke)

**Actions:**

- **Copy:** Copy masked key to clipboard (for reference)

- **Regenerate:** Open confirmation modal, generate new key

- **Revoke:** Open confirmation modal, revoke key

#### 2. Create API Key Button

**Location:** Top right of page

**Action:** Open "Create API Key" modal

**Modal Fields:**

- Name (text input, required)

- Permissions (multi-select checkboxes)

- Rate Limit (display only, based on subscription tier)

**Modal Actions:**

- Cancel (close modal)

- Generate Key (create key, display once)

#### 3. API Key Details Modal

**Trigger:** Click on API key row

**Content:**

- Key name

- Masked key value

- Permissions list

- Rate limit

- Created date

- Last used timestamp

- Usage chart (requests per day, last 30 days)

- Error rate chart

- Top endpoints table

- Geographic distribution map

#### 4. API Key Created Success Modal

**Trigger:** After successful key generation

**Content:**

- âš ï¸ Warning: "Store this key securely. It will not be shown again."

- API key value (full, copyable)

- Copy button

- Download as .env file button

- Code examples (curl, Node.js, Python)

**Actions:**

- Copy Key (copy to clipboard)

- Download .env (download as file)

- Close (close modal, cannot reopen to view key)

**Example Code Snippets:**

**cURL:**

```bash
curl -X POST https://api.penguinmails.com/api/v1/emails/send \
  -H "Authorization: Bearer pm_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6" \
  -H "Content-Type: application/json" \
  -d '{"to": "user@example.com", "subject": "Test", "body": "Hello"}'

```

**Node.js:**

```javascript
const axios = require('axios');

const apiKey = 'pm_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';

axios.post('https://api.penguinmails.com/api/v1/emails/send', {
  to: 'user@example.com',
  subject: 'Test',
  body: 'Hello'
}, {
  headers: {
    'Authorization': `Bearer ${apiKey}`
  }
});

```

**JavaScript/Node.js:**

```javascript
const axios = require('axios');

const apiKey = 'pm_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';

async function sendEmail() {
  try {
    const response = await axios.post(
      'https://api.penguinmails.com/api/v1/emails/send',
      {
        to: 'user@example.com',
        subject: 'Test',
        body: 'Hello'
      },
      {
        headers: {
          'Authorization': `Bearer ${apiKey}`
        }
      }
    );

    console.log('Email sent:', response.data);
  } catch (error) {
    console.error('Error:', error.response.data);
  }
}

sendEmail();

```

---
