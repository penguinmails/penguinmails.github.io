---
title: "Marketing Platform API - Usage Examples"
description: "Implementation examples in Node.js, Python, and CSS for common integration scenarios."
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---

# Marketing Platform API - Usage Examples

## SDK and Implementation Examples

### Node.js Integration

```javascript
const MarketingPlatform = require('marketing-platform-sdk');

const client = new MarketingPlatform.Client({
  apiKey: process.env.MARKETING_API_KEY
});

// Create a campaign
const campaign = await client.campaigns.create({
  name: 'Mobile App Launch',
  type: 'email',
  target: {
    segments: ['enterprise_customers']
  }
});

// Track conversion
await client.analytics.trackConversion({
  campaignId: campaign.id,
  recipientId: 'recipient_123',
  revenue: 299.99
});
```

### Python Integration

```python
import marketing_platform

client = marketing_platform.Client(api_key='your_api_key')

# Fetch campaign performance
performance = client.campaigns.get_performance('camp_789xyz')
print(f"Delivery Rate: {performance.rates.delivery_rate}%")
```

### CSS for Email Templates

```css
/* Marketing Platform Email Template Styles */
.email-template {
  max-width: 600px;
  margin: 0 auto;
  font-family: 'Helvetica Neue', Arial, sans-serif;
}

.header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 30px 20px;
  text-align: center;
}

.content {
  padding: 30px 20px;
  background: #ffffff;
}

.cta-button {
  display: inline-block;
  background: #4CAF50;
  color: white;
  padding: 12px 24px;
  text-decoration: none;
  border-radius: 5px;
  font-weight: bold;
  margin: 20px 0;
}
```
