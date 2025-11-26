---
title: "Developer Quick Start Templates"
description: "Documentation for Developer Quick Start Templates - Quick Start Templates"
last_modified_date: "2025-11-24"
level: "2"
persona: "Documentation Users"
---

# Developer Quick Start Templates

## Technology-Specific Templates

### JavaScript/TypeScript Templates

#### Basic Email Campaign Script

```javascript

// Basic PenguinMails email campaign template

import { PenguinMails } from '@penguinmails/sdk';

async function createBasicCampaign() {

  const client = new PenguinMails({

    apiKey: "YOUR_API_KEY",

    environment: process.env.NODE_ENV === 'production' ? 'production' : 'sandbox'

  });

  const campaign = {

    name: "Welcome Campaign",

    subject: "Welcome to PenguinMails!",

    templateId: "welcome-template",

    audience: {

      segmentId: "new_subscribers"

    },

    schedule: {

      type: "immediate"

    }

  };

  const result = await client.campaigns.create(campaign);

  return result;

}

// Usage

const campaign = await createBasicCampaign();

console.log(`Campaign created: ${campaign.id}`);

```

#### Node.js Express Integration Template

```javascript
const express = require('express');

const { PenguinMails } = require('@penguinmails/sdk');

const app = express();

app.use(express.json());

const client = new PenguinMails({

  apiKey: process.env.PENGUINMAILS_API_KEY

});

// Send notification email

app.post('/api/send-notification', async (req, res) => {

  const { email, message, type } = req.body;

  try {

    const result = await client.campaigns.sendImmediate({

      templateId: 'notification-template',

      recipient: email,

      variables: {

        message,

        type,

        timestamp: new Date().toISOString()

      }

    });

    res.json({ success: true, campaignId: result.id });

  } catch (error) {
    res.status(400).json({ success: false, error: error.message });
  }
});

// Campaign creation endpoint
app.post('/api/create-campaign', async (req, res) => {
  const { name, subject, templateId, segmentId } = req.body;

  try {
    const campaign = await client.campaigns.create({
      name,
      subject,
      templateId,
      audience: {
        segmentId
      },
      schedule: {
        type: 'scheduled',
        time: new Date(Date.now() + 24 * 60 * 60 * 1000) // 24 hours from now
      }
    });

    res.json({ success: true, campaign });
  } catch (error) {
    res.status(400).json({ success: false, error: error.message });
  }
});

app.listen(3000, () => {
  console.log('PenguinMails integration server running on port 3000');
});
```

#### Next.js Component Example

```jsx
'use client';

import { useState } from 'react';

export default function EmailCampaignManager() {
  const [campaign, setCampaign] = useState({
    name: '',
    subject: '',
    templateId: '',
    scheduledDate: ''
  });
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsLoading(true);

    try {
      const response = await fetch('/api/create-campaign', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(campaign)
      });

      const result = await response.json();
      if (result.success) {
        alert('Campaign created successfully!');
      } else {
        alert('Error creating campaign: ' + result.error);
      }
    } catch (error) {
      alert('Error: ' + error.message);
    }

    setIsLoading(false);
  };

  return (
    <div className="max-w-md mx-auto p-6">
      <h1 className="text-2xl font-bold mb-4">Create Email Campaign</h1>

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium mb-1">Campaign Name</label>
          <input
            type="text"
            value={campaign.name}
            onChange={(e) => setCampaign({...campaign, name: e.target.value})}
            className="w-full border rounded px-3 py-2"
            required
          />
        </div>

        <div>
          <label className="block text-sm font-medium mb-1">Subject</label>
          <input
            type="text"
            value={campaign.subject}
            onChange={(e) => setCampaign({...campaign, subject: e.target.value})}
            className="w-full border rounded px-3 py-2"
            required
          />
        </div>

        <button
          type="submit"
          disabled={isLoading}
          className="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600 disabled:opacity-50"
        >
          {isLoading ? 'Creating...' : 'Create Campaign'}
        </button>
      </form>
    </div>
  );
}
```

### CSS Email Templates

#### Responsive Email Template

```css
/* PenguinMails Email Template Styles */
.email-container {
  max-width: 600px;
  margin: 0 auto;
  font-family: 'Helvetica Neue', Arial, sans-serif;
  background-color: #f8f9fa;
}

.email-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 40px 30px;
  text-align: center;
}

.email-header h1 {
  margin: 0;
  font-size: 28px;
  font-weight: bold;
}

.email-content {
  background: #ffffff;
  padding: 40px 30px;
  line-height: 1.6;
  color: #333333;
}

.email-content p {
  margin-bottom: 20px;
  font-size: 16px;
}

.cta-button {
  display: inline-block;
  background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
  color: white !important;
  padding: 15px 30px;
  text-decoration: none;
  border-radius: 8px;
  font-weight: bold;
  font-size: 16px;
  margin: 25px 0;
  transition: all 0.3s ease;
}

.cta-button:hover {
  background: linear-gradient(135deg, #45a049 0%, #4CAF50 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

.email-footer {
  background: #f8f9fa;
  padding: 30px;
  text-align: center;
  font-size: 14px;
  color: #666666;
  border-top: 1px solid #dee2e6;
}

/* Mobile Responsive Design */
@media only screen and (max-width: 600px) {
  .email-container {
    width: 100% !important;
    margin: 0 !important;
  }
  
  .email-header {
    padding: 30px 20px !important;
  }
  
  .email-content {
    padding: 30px 20px !important;
  }
  
  .email-footer {
    padding: 20px !important;
  }
  
  .cta-button {
    width: 100% !important;
    text-align: center !important;
    padding: 18px 30px !important;
  }
}

/* Dark mode support */
@media (prefers-color-scheme: dark) {
  .email-container {
    background-color: #1a1a1a;
  }
  
  .email-content {
    background: #2d2d2d;
    color: #e0e0e0;
  }
  
  .email-footer {
    background: #1a1a1a;
    color: #999999;
  }
}

/* Outlook specific styles */
<!--[if mso]>
  .email-container {
    font-family: Arial, sans-serif !important;
  }
  .cta-button {
    background: #4CAF50 !important;
    border: none !important;
  }
<![endif]-->
```

### SQL Database Integration

#### User Campaign Analytics Query

```sql
-- Campaign Performance Analytics Query

SELECT 
    c.id as campaign_id,
    c.name as campaign_name,
    c.subject,
    c.created_at,
    COUNT(CASE WHEN e.status = 'sent' THEN 1 END) as emails_sent,
    COUNT(CASE WHEN e.status = 'delivered' THEN 1 END) as emails_delivered,
    COUNT(CASE WHEN e.status = 'opened' THEN 1 END) as emails_opened,
    COUNT(CASE WHEN e.status = 'clicked' THEN 1 END) as emails_clicked,
    ROUND(
        COUNT(CASE WHEN e.status = 'delivered' THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN e.status = 'sent' THEN 1 END), 0), 
        2
    ) as delivery_rate_percent,
    ROUND(
        COUNT(CASE WHEN e.status = 'opened' THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN e.status = 'delivered' THEN 1 END), 0), 
        2
    ) as open_rate_percent,
    ROUND(
        COUNT(CASE WHEN e.status = 'clicked' THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN e.status = 'delivered' THEN 1 END), 0), 
        2
    ) as click_rate_percent
FROM campaigns c
LEFT JOIN email_events e ON c.id = e.campaign_id
WHERE c.created_at >= NOW() - INTERVAL '30 days'
GROUP BY c.id, c.name, c.subject, c.created_at
ORDER BY c.created_at DESC;

-- Email Event Tracking Table Schema
CREATE TABLE email_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID REFERENCES campaigns(id),
    recipient_email VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('sent', 'delivered', 'opened', 'clicked', 'bounced', 'complained')),
    event_timestamp TIMESTAMPTZ DEFAULT NOW(),
    user_agent TEXT,
    ip_address INET,
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_email_events_campaign_id ON email_events(campaign_id);
CREATE INDEX idx_email_events_status ON email_events(status);
CREATE INDEX idx_email_events_timestamp ON email_events(event_timestamp);
CREATE INDEX idx_email_events_recipient ON email_events(recipient_email);

-- View for Campaign Analytics Dashboard
CREATE VIEW campaign_analytics AS
SELECT 
    c.id,
    c.name,
    c.subject,
    c.created_at,
    c.status,
    COUNT(DISTINCT e.recipient_email) as total_recipients,
    COUNT(DISTINCT CASE WHEN e.status = 'delivered' THEN e.recipient_email END) as delivered_count,
    COUNT(DISTINCT CASE WHEN e.status = 'opened' THEN e.recipient_email END) as opened_count,
    COUNT(DISTINCT CASE WHEN e.status = 'clicked' THEN e.recipient_email END) as clicked_count,
    ROUND(
        COALESCE(
            COUNT(DISTINCT CASE WHEN e.status = 'delivered' THEN e.recipient_email END) * 100.0 / 
            NULLIF(COUNT(DISTINCT e.recipient_email), 0), 0
        ), 2
    ) as delivery_rate,
    ROUND(
        COALESCE(
            COUNT(DISTINCT CASE WHEN e.status = 'opened' THEN e.recipient_email END) * 100.0 / 
            NULLIF(COUNT(DISTINCT CASE WHEN e.status = 'delivered' THEN e.recipient_email END), 0), 0
        ), 2
    ) as open_rate,
    ROUND(
        COALESCE(
            COUNT(DISTINCT CASE WHEN e.status = 'clicked' THEN e.recipient_email END) * 100.0 / 
            NULLIF(COUNT(DISTINCT CASE WHEN e.status = 'delivered' THEN e.recipient_email END), 0), 0
        ), 2
    ) as click_rate
FROM campaigns c
LEFT JOIN email_events e ON c.id = e.campaign_id
GROUP BY c.id, c.name, c.subject, c.created_at, c.status
ORDER BY c.created_at DESC;
```

## Development Workflow Templates

### Environment Setup Template

```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - PENGUINMAILS_API_KEY=${PENGUINMAILS_API_KEY}
      - PENGUINMAILS_ENV=${PENGUINMAILS_ENV:-sandbox}
    volumes:
      - .:/app
      - /app/node_modules

  # Optional: Redis for queue management
  redis:
    image: redis:alpine
    ports:
      - "6379:6379"
```

### Package.json Template

```json
{
  "name": "penguinmails-integration",
  "version": "1.0.0",
  "description": "PenguinMails Email Campaign Integration",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js",
    "test": "jest",
    "test:watch": "jest --watch",
    "lint": "eslint .",
    "type-check": "tsc --noEmit",
    "build": "webpack --mode production"
  },
  "dependencies": {
    "@penguinmails/sdk": "^1.0.0",
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^7.0.0",
    "dotenv": "^16.3.1",
    "winston": "^3.10.0"
  },
  "devDependencies": {
    "nodemon": "^3.0.1",
    "jest": "^29.6.4",
    "typescript": "^5.0.0",
    "@types/node": "^20.0.0",
    "@types/express": "^4.17.17",
    "eslint": "^8.47.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0"
  },
  "engines": {
    "node": ">=16.0.0",
    "npm": ">=8.0.0"
  }
}
```

### TypeScript Configuration Template

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020", "DOM"],
    "module": "commonjs",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "removeComments": false,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true
  },
  "include": [
    "src/**/*"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "**/*.test.ts",
    "**/*.spec.ts"
  ]
}
```

### Configuration Template

```typescript
// config/penguinmails.ts
interface PenguinMailsConfig {
  apiKey: string;
  baseURL: string;
  timeout: number;
  retries: number;
  rateLimit: {
    requests: number;
    period: number;
  };
}

const configs: Record<string, PenguinMailsConfig> = {
  development: {
    apiKey: process.env.PENGUINMAILS_API_KEY || '',
    baseURL: 'https://api-sandbox.penguinmails.com',
    timeout: 30000,
    retries: 3,
    rateLimit: {
      requests: 100,
      period: 60000 // 1 minute
    }
  },
  production: {
    apiKey: process.env.PENGUINMAILS_API_KEY || '',
    baseURL: 'https://api.penguinmails.com',
    timeout: 30000,
    retries: 3,
    rateLimit: {
      requests: 1000,
      period: 60000
    }
  }
};

export const getConfig = (): PenguinMailsConfig => {

  const env = process.env.NODE_ENV || 'development';

  return configs[env] || configs.development;

};
```

## Cross-Domain Integration Requirements

### Sales Integration

- **CRM System Coordination**: Synchronize campaign data with CRM systems
- **Lead Attribution**: Track email campaign engagement for sales pipeline attribution
- **Sales Alert Integration**: Send alerts for high-value prospect engagement

### Marketing Integration

- **Campaign Performance Analytics**: Coordinate with marketing analytics platforms
- **Customer Segment Sync**: Real-time synchronization of customer segments
- **Cross-Channel Coordination**: Coordinate email with other marketing channels

### Customer Success Integration

- **Health Score Correlation**: Link email engagement to customer health scores
- **Success Campaign Coordination**: Coordinate email campaigns with success initiatives
- **Retention Campaign Automation**: Automate retention campaigns based on customer signals

### Finance Integration

- **Revenue Attribution**: Track revenue attribution from email campaigns

- **Cost Allocation**: Allocate marketing costs to appropriate budget categories

- **ROI Tracking**: Coordinate email campaign ROI with financial reporting

## Quick Start Checklist

- [ ] Set up development environment with Docker

- [ ] Configure API keys and environment variables

- [ ] Install and configure PenguinMails SDK

- [ ] Test basic email sending functionality

- [ ] Set up error handling and logging

- [ ] Configure rate limiting and retry logic

- [ ] Implement cross-domain integrations

- [ ] Set up monitoring and alerting

- [ ] Configure production deployment

- [ ] Implement comprehensive testing

- [ ] Set up TypeScript configuration

- [ ] Configure CSS framework for email templates

- [ ] Set up SQL database schema for analytics

This template library provides developers with proven starting points for PenguinMails integration using JavaScript/TypeScript, CSS, and SQL.
