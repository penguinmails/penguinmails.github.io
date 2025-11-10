---
title: "API Reference - Complete Integration Guide"
description: "Comprehensive API documentation with integration guides, authentication flows, and developer resources for PenguinMails platform"
last_modified_date: "2025-11-10"
---

# API Reference - Complete Integration Guide

## Strategic Alignment
**Strategic Alignment**: This API reference documentation supports our enterprise infrastructure framework by providing comprehensive API specifications, integration guides, and developer resources for the PenguinMails platform.

**Technical Authority**: Our API documentation integrates with enterprise development platforms, SDK libraries, and third-party integration systems featuring REST APIs, webhooks, authentication protocols, and comprehensive testing frameworks.

**Operational Excellence**: Backed by enterprise API infrastructure with 99.9% uptime guarantees, comprehensive monitoring, rate limiting, and scalable integration capabilities for seamless third-party connectivity.

**User Journey Integration**: This API reference is part of your complete developer experience - connects to implementation guides, security frameworks, and operational excellence for reliable API integration and development.

---

## Document Hierarchy & Navigation

This section follows the **Progressive Complexity Framework** with three distinct levels:

### 📋 **Level 1: Quick Start & Authentication**
- `api-reference` (this document) - Main API overview with authentication and quick start
- API key management, authentication flows, and basic integration examples

### 🔧 **Level 2: Comprehensive API Reference**
- REST API endpoints, request/response formats, and detailed documentation
- Webhooks, SDKs, and integration examples for multiple programming languages

### 🚀 **Level 3: Advanced Integration**
- Enterprise features, rate limiting, error handling, and best practices
- Testing tools, debugging guides, and performance optimization strategies

---

## Quick Start Guide

### Getting Started (⭐⭐⭐)

Welcome to the PenguinMails API! This comprehensive reference will help you integrate email marketing capabilities into your applications quickly and efficiently.

**What You Can Build:**
- 🐛 Email campaign management and automation
- 📊 Advanced analytics and reporting dashboards
- 🤖 AI-powered content optimization
- 🔗 Third-party integrations (CRM, e-commerce, Zapier)
- 📱 Real-time email tracking and engagement

### Authentication Setup (⭐⭐⭐)

#### 1. Obtain Your API Key
Get your API key from the [Developer Dashboard](https://app.penguinmails.com/developers).

#### 2. Authentication Methods

**API Key Authentication (Most Common):**
```http
Authorization: Bearer pk_live_abc123def456ghi789
Content-Type: application/json
```

**JWT Token Authentication (⭐⭐⭐):**
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "secure_password"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 900,
    "token_type": "Bearer",
    "user": {
      "id": "user_123",
      "email": "user@example.com",
      "role": "user"
    }
  }
}
```

**Using JWT Tokens:**
```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**OAuth 2.0 Integration (⭐⭐):**
```http
https://app.penguinmails.com/oauth/authorize?client_id=your_client_id&redirect_uri=your_callback_url&response_type=code&scope=read write
```

---

## Core API Endpoints

### Campaign Management (⭐⭐⭐)

#### Create Campaign
```http
POST /api/v1/campaigns
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "Welcome Email Series",
  "subject": "Welcome to PenguinMails!",
  "content": {
    "html": "<h1>Welcome!</h1><p>Thank you for joining us.</p>",
    "text": "Welcome! Thank you for joining us.",
    "template_id": "welcome_template"
  },
  "recipients": [
    {
      "email": "user1@example.com",
      "personalization": {
        "name": "John",
        "company": "Acme Corp"
      }
    }
  ],
  "schedule": {
    "send_at": "2025-12-01T10:00:00Z",
    "timezone": "UTC"
  },
  "settings": {
    "analytics_enabled": true,
    "ai_optimization": true,
    "track_opens": true,
    "track_clicks": true
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "campaign_abc123",
    "name": "Welcome Email Series",
    "status": "scheduled",
    "created_at": "2025-12-01T09:00:00Z",
    "scheduled_at": "2025-12-01T10:00:00Z",
    "metrics": {
      "estimated_recipients": 1,
      "estimated_cost": "$0.77"
    },
    "ai_optimization": {
      "enabled": true,
      "improvement_score": 0.15,
      "suggestions": [
        "Subject line optimization increased open rate prediction by 15%"
      ]
    }
  }
}
```

#### List Campaigns
```http
GET /api/v1/campaigns?page=1&per_page=20&status=active&sort=created_at&order=desc
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "campaign_abc123",
      "name": "Welcome Email Series",
      "status": "active",
      "created_at": "2025-12-01T09:00:00Z",
      "metrics": {
        "sent": 1000,
        "delivered": 995,
        "opened": 350,
        "clicked": 85,
        "bounced": 5,
        "complained": 2
      },
      "cost": {
        "total": "$77.00",
        "per_recipient": "$0.077"
      }
    }
  ],
  "meta": {
    "pagination": {
      "page": 1,
      "per_page": 20,
      "total": 5,
      "pages": 1
    },
    "analytics": {
      "total_revenue_impact": "$770.00",
      "avg_open_rate": 0.35,
      "avg_click_rate": 0.085
    }
  }
}
```

### Email Sending (⭐⭐⭐)

#### Send Single Email
```http
POST /api/v1/emails/send
Authorization: Bearer {token}
Content-Type: application/json

{
  "to": "recipient@example.com",
  "subject": "Test Email",
  "content": {
    "html": "<h1>Hello!</h1><p>This is a test email.</p>",
    "text": "Hello! This is a test email."
  },
  "from": {
    "name": "Your Name",
    "email": "sender@example.com"
  },
  "reply_to": "support@example.com",
  "tracking": {
    "track_opens": true,
    "track_clicks": true
  },
  "personalization": {
    "name": "Recipient Name",
    "company": "Recipient Company"
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "message_id": "msg_def456",
    "status": "queued",
    "estimated_delivery": "2025-12-01T09:05:00Z",
    "cost": "$0.077",
    "analytics_tracking": {
      "tracking_id": "track_789xyz",
      "pixel_url": "https://analytics.penguinmails.com/pixel/789xyz",
      "click_tracking_domain": "https://clicks.penguinmails.com"
    }
  }
}
```

#### Send Bulk Emails
```http
POST /api/v1/emails/send-bulk
Authorization: Bearer {token}
Content-Type: application/json

{
  "campaign_id": "campaign_abc123",
  "recipients": [
    {
      "email": "user1@example.com",
      "personalization": {
        "name": "John Doe",
        "company": "Acme Corp"
      }
    },
    {
      "email": "user2@example.com",
      "personalization": {
        "name": "Jane Smith",
        "company": "Tech Solutions"
      }
    }
  ],
  "batch_size": 100,
  "delay_between_batches": 5
}
```

### Analytics & Reporting (⭐⭐⭐)

#### Get Campaign Analytics
```http
GET /api/v1/analytics/campaigns/{campaign_id}?period=7d
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "campaign_id": "campaign_abc123",
    "period": "7d",
    "overview": {
      "sent": 1000,
      "delivered": 995,
      "opened": 348,
      "clicked": 84,
      "bounced": 5,
      "complained": 2,
      "unsubscribed": 12
    },
    "performance": {
      "delivery_rate": 0.995,
      "open_rate": 0.35,
      "click_rate": 0.084,
      "click_to_open_rate": 0.241,
      "bounce_rate": 0.005,
      "complaint_rate": 0.002
    },
    "revenue_impact": {
      "total_value": "$770.00",
      "value_per_recipient": "$0.77",
      "revenue_per_delivered": "$0.774",
      "conversion_value": "$2,450.00"
    },
    "ai_insights": {
      "optimization_score": 0.85,
      "recommendations": [
        {
          "type": "subject_line",
          "suggestion": "Add urgency words to increase open rates",
          "expected_improvement": "12% increase in open rate"
        }
      ],
      "sentiment_analysis": {
        "positive": 0.72,
        "neutral": 0.25,
        "negative": 0.03
      }
    },
    "device_breakdown": {
      "mobile": 0.68,
      "desktop": 0.28,
      "tablet": 0.04
    },
    "engagement_timeline": [
      {
        "timestamp": "2025-12-01T10:00:00Z",
        "sent": 1000,
        "opened": 0,
        "clicked": 0
      },
      {
        "timestamp": "2025-12-01T10:15:00Z",
        "sent": 0,
        "opened": 150,
        "clicked": 12
      }
    ]
  }
}
```

### AI Personalization (⭐⭐⭐)

#### Optimize Email Content
```http
POST /api/v1/ai/optimize-content
Authorization: Bearer {token}
Content-Type: application/json

{
  "content": {
    "subject": "Don't miss our sale!",
    "html": "<h1>50% OFF Everything!</h1><p>Limited time offer.</p>"
  },
  "audience": {
    "demographics": {
      "age_range": "25-45",
      "income_level": "middle",
      "interests": ["technology", "shopping"]
    },
    "behavior": {
      "purchase_history": "frequent",
      "engagement_level": "high"
    }
  },
  "optimization_goals": ["open_rate", "click_rate", "revenue"]
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "original": {
      "subject": "Don't miss our sale!",
      "html": "<h1>50% OFF Everything!</h1><p>Limited time offer.</p>"
    },
    "optimized": {
      "subject": "Exclusive 50% OFF Tech Essentials - Limited Time!",
      "html": "<h1>⚡ Tech Essentials Sale</h1><p>Save big on the gadgets you love. Your favorites are waiting!</p>",
      "personalization_tokens": ["{{name}}", "{{product_interests}}"]
    },
    "improvements": {
      "expected_open_rate_increase": 0.18,
      "expected_click_rate_increase": 0.25,
      "sentiment_score": 0.85,
      "urgency_optimization": "Added time-sensitive language",
      "personalization_level": "high"
    },
    "ai_explanation": "Added specific product mentions and urgency cues based on user's purchase history and interests."
  }
}
```

### Contact Management (⭐⭐)

#### Add Contact
```http
POST /api/v1/contacts
Authorization: Bearer {token}
Content-Type: application/json

{
  "email": "newcontact@example.com",
  "first_name": "Jane",
  "last_name": "Doe",
  "company": "Example Corp",
  "tags": ["prospect", "tech_interested"],
  "custom_fields": {
    "lead_score": 85,
    "last_purchase": "2025-11-15",
    "preferred_communication": "email"
  },
  "consent": {
    "email_marketing": true,
    "tracking": true,
    "date_given": "2025-12-01T09:00:00Z"
  }
}
```

#### List Contacts
```http
GET /api/v1/contacts?tags=prospect&page=1&per_page=50&sort=created_at&order=desc
Authorization: Bearer {token}
```

### IP Management (⭐⭐⭐)

#### Add IP Address
```http
POST /api/v1/ip-addresses
Authorization: Bearer {token}
Content-Type: application/json

{
  "ip_address": "192.168.1.100",
  "description": "Marketing team IP",
  "purpose": "marketing_campaigns",
  "warm_up_schedule": {
    "daily_volume": 100,
    "max_daily_volume": 1000,
    "increase_rate": 0.2
  }
}
```

#### Monitor IP Health
```http
GET /api/v1/ip-addresses/health?period=24h
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "ip_health_summary": {
      "total_ips": 5,
      "healthy_ips": 4,
      "warming_ips": 1,
      "blocked_ips": 0
    },
    "ip_details": [
      {
        "ip_address": "192.168.1.100",
        "status": "healthy",
        "health_score": 0.95,
        "deliverability_rate": 0.99,
        "bounce_rate": 0.005,
        "spam_score": 0.02,
        "reputation": "excellent"
      }
    ]
  }
}
```

---

## Webhooks

### Event Types (⭐⭐⭐)

The PenguinMails platform emits structured webhook events for key lifecycle changes. Events follow a consistent pattern inspired by the API response and error formats documented above.

#### Campaign Events
- `campaign.created` - Campaign created
- `campaign.scheduled` - Campaign scheduled for sending
- `campaign.sending` - Campaign started sending
- `campaign.sent` - Campaign completed sending
- `campaign.cancelled` - Campaign cancelled

#### Email Events
- `email.delivered` - Email delivered successfully
- `email.opened` - Email opened by recipient
- `email.clicked` - Link clicked in email
- `email.bounced` - Email bounced (hard/soft)
- `email.complained` - Spam complaint received
- `email.unsubscribed` - Unsubscribe request

#### IP Management Events
- `ip.provisioned` - New IP provisioned
- `ip.activated` - IP activated for sending
- `ip.reputation_changed` - IP reputation score changed

#### System Events
- `organization.created` - New organization created
- `user.invited` - User invited to organization
- `user.joined` - User accepted invitation

#### Analytics Events
- `analytics.updated` - Campaign analytics updated
- `goal.converted` - Conversion goal achieved
- `revenue.recorded` - Revenue milestone reached

### Webhook Setup (⭐⭐⭐)

#### Register Webhook Endpoint
```http
POST /api/v1/webhooks
Authorization: Bearer {token}
Content-Type: application/json

{
  "url": "https://yourapp.com/webhooks/penguinmails",
  "events": [
    "email.sent",
    "email.delivered",
    "email.opened",
    "email.clicked",
    "campaign.completed"
  ],
  "secret": "your-webhook-secret",
  "description": "Main application webhook handler"
}
```

#### Webhook Payload Format
```json
{
  "id": "wh_abc123",
  "type": "email.opened",
  "created": "2025-12-01T09:15:30Z",
  "data": {
    "email": {
      "id": "msg_def456",
      "campaign_id": "campaign_abc123",
      "to": "recipient@example.com",
      "subject": "Welcome to PenguinMails!",
      "sent_at": "2025-12-01T09:10:00Z",
      "delivered_at": "2025-12-01T09:10:05Z",
      "opened_at": "2025-12-01T09:15:30Z"
    },
    "recipient": {
      "email": "recipient@example.com",
      "first_name": "John",
      "tags": ["customer", "vip"]
    },
    "analytics": {
      "open_count": 1,
      "click_count": 0,
      "device_type": "mobile",
      "location": "United States"
    },
    "campaign": {
      "id": "campaign_abc123",
      "name": "Welcome Series",
      "type": "onboarding"
    }
  }
}
```

#### Webhook Signature Verification
```python
import hmac
import hashlib

def verify_webhook_signature(payload: str, signature: str, secret: str) -> bool:
    """Verify webhook signature for security."""
    expected_signature = hmac.new(
        secret.encode('utf-8'),
        payload.encode('utf-8'),
        hashlib.sha256
    ).hexdigest()
    
    # Timing-safe comparison
    return hmac.compare_digest(f"sha256={expected_signature}", signature)
```

```typescript
// TypeScript implementation
import crypto from 'crypto';

export function verifyWebhookSignature(
  payload: string,
  signature: string,
  secret: string
): boolean {
  const expectedSignature = crypto
    .createHmac('sha256', secret)
    .update(payload, 'utf8')
    .digest('hex');
    
  return crypto.timingSafeEqual(
    Buffer.from(`sha256=${expectedSignature}`),
    Buffer.from(signature)
  );
}
```

### Webhook Best Practices (⭐⭐)

1. **Acknowledge Quickly**: Respond within 5 seconds
2. **Process Asynchronously**: Handle webhooks in background jobs
3. **Handle Duplicates**: Use event IDs to prevent duplicate processing
4. **Retry Logic**: Implement exponential backoff for failures
5. **Security**: Always verify signatures
6. **Logging**: Log all webhook events for debugging

---

## SDK Documentation

### Python SDK (⭐⭐⭐)

#### Installation
```bash
pip install penguinmails-python
```

#### Basic Usage
```python
from penguinmails import PenguinMails
from penguinmails.models import Campaign, Email

# Initialize client
client = PenguinMails(api_key="pk_live_abc123def456")

# Create campaign
campaign_data = {
    "name": "Product Launch",
    "subject": "New Product Available!",
    "content": {
        "html": "<h1>Exciting News!</h1><p>Check out our new product.</p>",
        "text": "Exciting News! Check out our new product."
    }
}

campaign = client.campaigns.create(campaign_data)
print(f"Campaign created: {campaign.id}")

# Send email
email = Email(
    to="user@example.com",
    subject="Hello!",
    content="<p>Welcome to PenguinMails!</p>"
)

result = client.emails.send(email)
print(f"Email sent: {result.message_id}")

# Get analytics
analytics = client.analytics.get_campaign_metrics(campaign.id)
print(f"Open rate: {analytics.open_rate}")
```

#### Advanced Features
```python
from penguinmails.ai import AIOptimizer
from penguinmails.analytics import AnalyticsTracker

# AI-powered content optimization
ai_optimizer = AIOptimizer(client)
optimized_content = ai_optimizer.optimize_content(
    content=campaign_data["content"],
    audience={
        "demographics": {"age_range": "25-45"},
        "interests": ["technology", "shopping"]
    }
)

# Real-time analytics tracking
analytics = AnalyticsTracker(client)
analytics.track_campaign_performance(
    campaign_id=campaign.id,
    metrics=["open_rate", "click_rate", "revenue"]
)

# Bulk operations
client.contacts.bulk_import([
    {"email": "user1@example.com", "name": "John"},
    {"email": "user2@example.com", "name": "Jane"}
])
```

### JavaScript/Node.js SDK (⭐⭐⭐)

#### Installation
```bash
npm install @penguinmails/sdk
```

#### Basic Usage
```javascript
import { PenguinMails } from '@penguinmails/sdk';

// Initialize client
const client = new PenguinMails({
  apiKey: 'pk_live_abc123def456'
});

// Create campaign
const campaign = await client.campaigns.create({
  name: 'Welcome Series',
  subject: 'Welcome to PenguinMails!',
  content: {
    html: '<h1>Welcome!</h1><p>Thank you for joining us.</p>',
    text: 'Welcome! Thank you for joining us.'
  },
  recipients: [
    {
      email: 'user@example.com',
      personalization: { name: 'John Doe' }
    }
  ]
});

console.log(`Campaign created: ${campaign.id}`);

// Send email
const email = {
  to: 'user@example.com',
  subject: 'Test Email',
  content: '<p>Hello from PenguinMails!</p>'
};

const result = await client.emails.send(email);
console.log(`Email sent: ${result.message_id}`);

// Get analytics
const analytics = await client.analytics.getCampaignMetrics(campaign.id);
console.log(`Open rate: ${analytics.openRate}`);
```

#### React Integration
```jsx
import React, { useState, useEffect } from 'react';
import { PenguinMailsProvider, usePenguinMails } from '@penguinmails/sdk-react';

function CampaignCreator() {
  const { campaigns, createCampaign, getAnalytics } = usePenguinMails();
  const [campaignData, setCampaignData] = useState({
    name: '',
    subject: '',
    content: ''
  });

  const handleCreateCampaign = async (e) => {
    e.preventDefault();
    try {
      const campaign = await createCampaign(campaignData);
      console.log('Campaign created:', campaign);
    } catch (error) {
      console.error('Failed to create campaign:', error);
    }
  };

  return (
    <form onSubmit={handleCreateCampaign}>
      <input
        type="text"
        placeholder="Campaign Name"
        value={campaignData.name}
        onChange={(e) => setCampaignData({...campaignData, name: e.target.value})}
      />
      <input
        type="text"
        placeholder="Subject"
        value={campaignData.subject}
        onChange={(e) => setCampaignData({...campaignData, subject: e.target.value})}
      />
      <textarea
        placeholder="Content"
        value={campaignData.content}
        onChange={(e) => setCampaignData({...campaignData, content: e.target.value})}
      />
      <button type="submit">Create Campaign</button>
    </form>
  );
}

function App() {
  return (
    <PenguinMailsProvider apiKey="pk_live_abc123def456">
      <CampaignCreator />
    </PenguinMailsProvider>
  );
}
```

### PHP SDK (⭐⭐)

#### Installation
```bash
composer require penguinmails/php-sdk
```

#### Basic Usage
```php
<?php
use PenguinMails\Client;
use PenguinMails\Models\Campaign;
use PenguinMails\Models\Email;

// Initialize client
$client = new Client('pk_live_abc123def456');

// Create campaign
$campaignData = [
    'name' => 'Product Launch',
    'subject' => 'New Product Available!',
    'content' => [
        'html' => '<h1>Exciting News!</h1><p>Check out our new product.</p>',
        'text' => 'Exciting News! Check out our new product.'
    ]
];

$campaign = $client->campaigns()->create($campaignData);
echo "Campaign created: " . $campaign->getId() . "\n";

// Send email
$email = new Email();
$email->setTo('user@example.com');
$email->setSubject('Hello from PenguinMails!');
$email->setContent('<p>Welcome to our platform!</p>');

$result = $client->emails()->send($email);
echo "Email sent: " . $result->getMessageId() . "\n";

// Get analytics
$analytics = $client->analytics()->getCampaignMetrics($campaign->getId());
echo "Open rate: " . $analytics->getOpenRate() . "\n";
?>
```

---

## Rate Limiting

### Rate Limit Headers

Every API response includes rate limit information in headers:

```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1701429600
X-RateLimit-Window: 3600
```

### Rate Limit Tiers (⭐⭐⭐)

#### Free Tier
- **Limit**: 1,000 requests/hour
- **Features**: Basic email sending, limited analytics
- **Cost**: $0

#### Starter Tier
- **Limit**: 10,000 requests/hour  
- **Features**: Full email sending, basic analytics
- **Cost**: $29/month

#### Professional Tier
- **Limit**: 100,000 requests/hour
- **Features**: Advanced analytics, AI optimization, webhooks
- **Cost**: $99/month

#### Enterprise Tier
- **Limit**: 1,000,000 requests/hour
- **Features**: Unlimited features, priority support, custom integrations
- **Cost**: $299/month

### Handling Rate Limits (⭐⭐)

#### Python Example
```python
import time
import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

class RateLimitHandler:
    def __init__(self, client):
        self.client = client
        self.retry_strategy = Retry(
            total=3,
            backoff_factor=1,
            status_forcelist=[429, 500, 502, 503, 504]
        )
        self.adapter = HTTPAdapter(max_retries=self.retry_strategy)
    
    def make_request(self, method, url, **kwargs):
        try:
            response = self.client.session.request(
                method, url, **kwargs
            )
            
            if response.status_code == 429:
                reset_time = int(response.headers.get('X-RateLimit-Reset', 0))
                current_time = int(time.time())
                wait_time = max(0, reset_time - current_time)
                
                print(f"Rate limited. Waiting {wait_time} seconds...")
                time.sleep(wait_time)
                return self.make_request(method, url, **kwargs)
            
            response.raise_for_status()
            return response.json()
            
        except requests.exceptions.HTTPError as e:
            if e.response.status_code == 429:
                # Exponential backoff
                time.sleep(2 ** self.retries)
                return self.make_request(method, url, **kwargs)
            raise
```

#### JavaScript Example
```javascript
class RateLimitHandler {
  constructor(client) {
    this.client = client;
    this.retryCount = 0;
    this.maxRetries = 3;
  }

  async makeRequest(method, url, options = {}) {
    try {
      const response = await this.client.request({
        method,
        url,
        ...options
      });

      if (response.status === 429) {
        const resetTime = parseInt(response.headers.get('X-RateLimit-Reset'));
        const currentTime = Math.floor(Date.now() / 1000);
        const waitTime = Math.max(0, resetTime - currentTime);

        console.log(`Rate limited. Waiting ${waitTime} seconds...`);
        await this.delay(waitTime * 1000);

        return this.makeRequest(method, url, options);
      }

      return response.data;
    } catch (error) {
      if (error.response?.status === 429 && this.retryCount < this.maxRetries) {
        this.retryCount++;
        const delay = Math.pow(2, this.retryCount) * 1000;
        await this.delay(delay);
        return this.makeRequest(method, url, options);
      }
      throw error;
    }
  }

  delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
```

---

## Error Handling

### Error Response Format (⭐⭐⭐)

All errors follow a consistent format:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "The provided data is invalid",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      },
      {
        "field": "subject",
        "message": "Subject cannot be empty"
      }
    ],
    "request_id": "req_abc123",
    "documentation_url": "https://docs.penguinmails.com/errors/validation-error"
  },
  "timestamp": "2025-12-01T09:00:00Z"
}
```

### Common Error Codes (⭐⭐⭐)

#### Authentication Errors
- `AUTHENTICATION_REQUIRED` (401): Missing or invalid API key
- `INSUFFICIENT_PERMISSIONS` (403): User lacks required permissions
- `TOKEN_EXPIRED` (401): JWT token has expired
- `ACCOUNT_SUSPENDED` (403): Account has been suspended

#### Validation Errors
- `VALIDATION_ERROR` (400): Request data validation failed
- `MISSING_REQUIRED_FIELD` (400): Required field not provided
- `INVALID_EMAIL_FORMAT` (400): Email address format is invalid
- `CONTENT_TOO_LARGE` (413): Request content exceeds size limits

#### Rate Limit Errors
- `RATE_LIMIT_EXCEEDED` (429): Rate limit has been exceeded
- `QUOTA_EXCEEDED` (429): Monthly quota has been exceeded

#### Resource Errors
- `RESOURCE_NOT_FOUND` (404): Requested resource not found
- `RESOURCE_ALREADY_EXISTS` (409): Resource already exists
- `RESOURCE_CONFLICT` (409): Conflict with existing resource

#### Server Errors
- `INTERNAL_SERVER_ERROR` (500): Internal server error
- `SERVICE_UNAVAILABLE` (503): Service temporarily unavailable
- `DATABASE_ERROR` (500): Database operation failed
- `EXTERNAL_SERVICE_ERROR` (502): External service error

### Error Handling Best Practices (⭐⭐)

#### Python Error Handling
```python
from penguinmails.exceptions import (
    PenguinMailsError,
    ValidationError,
    AuthenticationError,
    RateLimitError
)

def send_campaign_with_retry(client, campaign_data, max_retries=3):
    for attempt in range(max_retries):
        try:
            return client.campaigns.create(campaign_data)
        
        except ValidationError as e:
            print(f"Validation failed: {e.details}")
            return None  # Don't retry validation errors
        
        except RateLimitError as e:
            if attempt == max_retries - 1:
                raise
            wait_time = e.retry_after or (2 ** attempt)
            print(f"Rate limited. Retrying in {wait_time} seconds...")
            time.sleep(wait_time)
        
        except AuthenticationError as e:
            print(f"Authentication failed: {e}")
            return None
        
        except PenguinMailsError as e:
            if attempt == max_retries - 1:
                raise
            print(f"Server error. Retrying in {2 ** attempt} seconds...")
            time.sleep(2 ** attempt)
```

#### JavaScript Error Handling
```javascript
class PenguinMailsClient {
  async sendCampaign(campaignData, maxRetries = 3) {
    for (let attempt = 0; attempt < maxRetries; attempt++) {
      try {
        return await this.campaigns.create(campaignData);
      } catch (error) {
        if (error.code === 'VALIDATION_ERROR') {
          console.error('Validation failed:', error.details);
          throw error; // Don't retry validation errors
        }

        if (error.code === 'RATE_LIMIT_ERROR') {
          if (attempt === maxRetries - 1) throw error;
          
          const waitTime = error.retryAfter || Math.pow(2, attempt) * 1000;
          console.log(`Rate limited. Retrying in ${waitTime}ms...`);
          await this.delay(waitTime);
          continue;
        }

        if (error.code === 'AUTHENTICATION_ERROR') {
          console.error('Authentication failed:', error.message);
          throw error; // Don't retry auth errors
        }

        if (attempt === maxRetries - 1) throw error;
        
        console.log(`Server error. Retrying in ${Math.pow(2, attempt)}s...`);
        await this.delay(Math.pow(2, attempt) * 1000);
      }
    }
  }

  delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
```

---

## API Versioning

### Version Strategy (⭐⭐)

#### URL-Based Versioning
```
Current Version: /api/v1/
Previous Version: /api/v0/ (deprecated)
Next Version: /api/v2/ (planned)
```

#### Version Lifecycle
- **Current**: Fully supported with new features
- **Previous**: Supported for 6 months after new version release
- **Deprecated**: Maintained for 3 months, then discontinued
- **Discontinued**: No longer available

### Migration Guide (⭐⭐⭐)

#### v0 to v1 Migration

**Authentication Changes:**
```python
# v0 (deprecated)
headers = {
    'X-API-Key': 'pk_live_abc123'
}

# v1 (current)
headers = {
    'Authorization': 'Bearer pk_live_abc123'
}
```

**Response Format Changes:**
```python
# v0 (deprecated)
{
    "status": "success",
    "data": {...}
}

# v1 (current)
{
    "success": true,
    "data": {...}
}
```

**Error Format Changes:**
```python
# v0 (deprecated)
{
    "error": "ValidationError",
    "message": "Invalid data provided"
}

# v1 (current)
{
    "success": false,
    "error": {
        "code": "VALIDATION_ERROR",
        "message": "Invalid data provided"
    }
}
```

#### v1 to v2 Migration (Planned)

**Enhanced Analytics:**
```python
# v1 (current)
analytics = {
    "sent": 1000,
    "delivered": 990,
    "opened": 350,
    "clicked": 85
}

# v2 (planned)
analytics = {
    "sent": 1000,
    "delivered": 990,
    "opened": 350,
    "clicked": 85,
    "ai_insights": {
        "optimization_score": 0.85,
        "sentiment_score": 0.72,
        "personalization_effectiveness": 0.91
    },
    "revenue_impact": {
        "total_value": 2450.00,
        "cost_per_acquisition": 12.50,
        "lifetime_value_projection": 12500.00
    }
}
```

### Deprecation Timeline (⭐⭐)

| Version | Release Date | Deprecated Date | End of Life |
|---------|--------------|-----------------|-------------|
| v0 | 2025-01-15 | 2025-06-01 | 2025-09-01 |
| v1 | 2025-06-01 | - | - |
| v2 | 2025-12-01 | 2026-06-01 | 2026-09-01 |

---

## Data Schemas

### Campaign Schema (⭐⭐⭐)

```typescript
interface Campaign {
  id: string;
  name: string;
  subject: string;
  content: EmailContent;
  recipients: EmailRecipient[];
  status: CampaignStatus;
  created_at: string;
  updated_at: string;
  scheduled_at?: string;
  sent_at?: string;
  settings: CampaignSettings;
  metrics?: CampaignMetrics;
  cost?: CampaignCost;
  ai_optimization?: AIOptimization;
}

type CampaignStatus = 
  | 'draft'
  | 'scheduled'
  | 'sending'
  | 'sent'
  | 'cancelled'
  | 'failed';

interface EmailContent {
  html: string;
  text: string;
  template_id?: string;
  variables?: TemplateVariable[];
}

interface EmailRecipient {
  email: string;
  personalization?: Record<string, any>;
  tags?: string[];
}

interface CampaignSettings {
  analytics_enabled: boolean;
  ai_optimization: boolean;
  track_opens: boolean;
  track_clicks: boolean;
  unsubscribe_enabled: boolean;
  batch_size?: number;
  delay_between_batches?: number;
}

interface CampaignMetrics {
  sent: number;
  delivered: number;
  opened: number;
  clicked: number;
  bounced: number;
  complained: number;
  unsubscribed: number;
}

interface CampaignCost {
  total: string;
  per_recipient: string;
  currency: string;
}

interface AIOptimization {
  enabled: boolean;
  optimization_score: number;
  improvement_predictions: {
    open_rate_increase: number;
    click_rate_increase: number;
  };
  recommendations: AIRecommendation[];
}

interface AIRecommendation {
  type: 'subject_line' | 'content' | 'timing' | 'audience';
  suggestion: string;
  expected_improvement: string;
  confidence_score: number;
}
```

### Analytics Schema (⭐⭐⭐)

```typescript
interface CampaignAnalytics {
  campaign_id: string;
  period: string;
  overview: AnalyticsOverview;
  performance: PerformanceMetrics;
  revenue_impact: RevenueMetrics;
  ai_insights?: AIInsights;
  device_breakdown: DeviceBreakdown;
  engagement_timeline: TimelineEvent[];
  geographical_data?: GeographicalData;
}

interface AnalyticsOverview {
  sent: number;
  delivered: number;
  opened: number;
  clicked: number;
  bounced: number;
  complained: number;
  unsubscribed: number;
  total_recipients: number;
}

interface PerformanceMetrics {
  delivery_rate: number;
  open_rate: number;
  click_rate: number;
  click_to_open_rate: number;
  bounce_rate: number;
  complaint_rate: number;
  unsubscribe_rate: number;
}

interface RevenueMetrics {
  total_value: number;
  value_per_recipient: number;
  revenue_per_delivered: number;
  conversion_value: number;
  cost_per_acquisition: number;
  roi_percentage: number;
}

interface AIInsights {
  optimization_score: number;
  recommendations: AIRecommendation[];
  sentiment_analysis: SentimentScores;
  engagement_prediction: EngagementPrediction;
  audience_insights: AudienceInsights;
}

interface SentimentScores {
  positive: number;
  neutral: number;
  negative: number;
  dominant_emotion: string;
}

interface EngagementPrediction {
  predicted_open_rate: number;
  predicted_click_rate: number;
  confidence_interval: [number, number];
}

interface DeviceBreakdown {
  mobile: number;
  desktop: number;
  tablet: number;
  other: number;
}

interface TimelineEvent {
  timestamp: string;
  sent?: number;
  delivered?: number;
  opened?: number;
  clicked?: number;
  bounced?: number;
}
```

### Contact Schema (⭐⭐)

```typescript
interface Contact {
  id: string;
  email: string;
  first_name?: string;
  last_name?: string;
  company?: string;
  tags: string[];
  custom_fields: Record<string, any>;
  consent: ConsentSettings;
  created_at: string;
  updated_at: string;
  last_activity?: string;
  engagement_score?: number;
  lifecycle_stage?: LifecycleStage;
}

type LifecycleStage = 
  | 'subscriber'
  | 'lead'
  | 'marketing_qualified_lead'
  | 'sales_qualified_lead'
  | 'opportunity'
  | 'customer'
  | 'evangelist';

interface ConsentSettings {
  email_marketing: boolean;
  sms_marketing: boolean;
  tracking: boolean;
  third_party_sharing: boolean;
  date_given: string;
  ip_address?: string;
  user_agent?: string;
}
```

---

## Integration Examples

### E-commerce Platform Integration (⭐⭐⭐)

#### Shopify Integration
```python
import shopify
from penguinmails import PenguinMails

class ShopifyPenguinMailsIntegration:
    def __init__(self, shopify_api_key, penguinmails_api_key):
        self.shopify = shopify.ShopifyAPI(api_key=shopify_api_key)
        self.email_client = PenguinMails(api_key=penguinmails_api_key)
    
    def sync_customer_and_send_welcome(self, customer_data):
        """Sync Shopify customer to PenguinMails and send welcome email."""
        try:
            # Create contact in PenguinMails
            contact_data = {
                'email': customer_data['email'],
                'first_name': customer_data['first_name'],
                'last_name': customer_data['last_name'],
                'custom_fields': {
                    'shopify_customer_id': customer_data['id'],
                    'total_spent': customer_data['total_spent'],
                    'order_count': customer_data['orders_count']
                },
                'tags': ['shopify_customer', 'new_customer'],
                'consent': {
                    'email_marketing': True,
                    'tracking': True,
                    'date_given': customer_data['created_at']
                }
            }
            
            contact = self.email_client.contacts.create(contact_data)
            
            # Send personalized welcome email
            email_data = {
                'to': customer_data['email'],
                'subject': f"Welcome to our store, {customer_data['first_name']}!",
                'content': {
                    'html': self.generate_welcome_html(customer_data),
                    'text': self.generate_welcome_text(customer_data)
                },
                'personalization': {
                    'name': customer_data['first_name'],
                    'total_spent': customer_data['total_spent'],
                    'order_count': customer_data['orders_count']
                },
                'tracking': {
                    'track_opens': True,
                    'track_clicks': True
                }
            }
            
            result = self.email_client.emails.send(email_data)
            
            # Track integration event
            self.email_client.analytics.track_event('shopify_integration', {
                'event': 'welcome_email_sent',
                'customer_id': customer_data['id'],
                'email_id': result.message_id
            })
            
            return result
            
        except Exception as e:
            print(f"Integration error: {e}")
            self.email_client.analytics.track_error('shopify_integration_error', e)
            raise
    
    def handle_order_completed(self, order_data):
        """Send order confirmation and tracking emails."""
        try:
            # Send order confirmation
            confirmation_email = {
                'to': order_data['customer']['email'],
                'subject': f"Order #{order_data['order_number']} Confirmation",
                'content': {
                    'html': self.generate_order_confirmation_html(order_data),
                    'text': self.generate_order_confirmation_text(order_data)
                },
                'personalization': {
                    'order_number': order_data['order_number'],
                    'total_price': order_data['total_price'],
                    'line_items': order_data['line_items']
                }
            }
            
            self.email_client.emails.send(confirmation_email)
            
            # Schedule shipping notification
            self.schedule_shipping_notification(order_data)
            
            return True
            
        except Exception as e:
            print(f"Order processing error: {e}")
            raise
    
    def generate_welcome_html(self, customer_data):
        return f"""
        <html>
        <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h1 style="color: #333;">Welcome {customer_data['first_name']}!</h1>
            <p>Thank you for joining our community. As a token of our appreciation, 
            enjoy 10% off your first order with code <strong>WELCOME10</strong>.</p>
            <p>You can view your account details and order history at any time.</p>
            <a href="https://yourstore.com/account" style="background: #007bff; color: white; 
            padding: 12px 24px; text-decoration: none; border-radius: 4px;">View Your Account</a>
        </body>
        </html>
        """
```

### CRM Integration (⭐⭐)

#### Salesforce Integration
```typescript
import jsforce from 'jsforce';
import { PenguinMails } from '@penguinmails/sdk';

class SalesforcePenguinMailsIntegration {
  private emailClient: PenguinMails;
  private salesforce: jsforce.Connection;

  constructor(emailApiKey: string, salesforceConfig: any) {
    this.emailClient = new PenguinMails({ apiKey: emailApiKey });
    this.salesforce = new jsforce.Connection(salesforceConfig);
  }

  async syncLeadToEmail(leadData: any): Promise<void> {
    try {
      // Enrich lead data with AI insights
      const enrichedData = await this.enrichLeadWithAI(leadData);
      
      // Create contact in PenguinMails
      const contact = await this.emailClient.contacts.create({
        email: leadData.Email,
        first_name: leadData.FirstName,
        last_name: leadData.LastName,
        company: leadData.Company,
        custom_fields: {
          salesforce_lead_id: leadData.Id,
          lead_source: leadData.LeadSource,
          industry: leadData.Industry,
          company_size: leadData.NumberOfEmployees,
          lead_score: leadData.Rating,
          estimated_deal_value: leadData.AnnualRevenue
        },
        tags: ['salesforce_lead', leadData.LeadSource.toLowerCase()],
        consent: {
          email_marketing: true,
          tracking: true,
          date_given: new Date().toISOString()
        }
      });

      // Trigger appropriate email sequence based on lead characteristics
      await this.triggerLeadSequence(contact.id, enrichedData);
      
      // Update Salesforce with email campaign info
      await this.salesforce.sobject('Lead').update({
        Id: leadData.Id,
        PenguinMails_Contact_ID__c: contact.id,
        Last_Email_Campaign__c: enrichedData.recommended_sequence
      });

    } catch (error) {
      console.error('Salesforce sync error:', error);
      throw error;
    }
  }

  private async enrichLeadWithAI(leadData: any): Promise<any> {
    const aiInsights = await this.emailClient.ai.analyzeLead({
      company: leadData.Company,
      industry: leadData.Industry,
      job_title: leadData.Title,
      lead_source: leadData.LeadSource,
      notes: leadData.Description
    });

    return {
      ...leadData,
      ai_insights: aiInsights,
      recommended_sequence: aiInsights.recommended_email_sequence,
      personalization_score: aiInsights.personalization_score
    };
  }
}
```

### Zapier Integration (⭐⭐)

#### Zapier Webhook Handler
```javascript
const express = require('express');
const bodyParser = require('body-parser');
const { PenguinMails } = require('@penguinmails/sdk');

const app = express();
app.use(bodyParser.json());

const emailClient = new PenguinMails({
  apiKey: process.env.PENGUINMAILS_API_KEY
});

// Handle Zapier webhook triggers
app.post('/webhooks/zapier/trigger', async (req, res) => {
  try {
    const { trigger_type, data, user_id } = req.body;
    
    switch (trigger_type) {
      case 'new_subscriber':
        await handleNewSubscriber(data);
        break;
      
      case 'purchase_made':
        await handlePurchaseMade(data);
        break;
      
      case 'user_inactive':
        await handleUserInactive(data);
        break;
      
      default:
        console.log('Unknown trigger type:', trigger_type);
    }
    
    res.status(200).json({ success: true });
    
  } catch (error) {
    console.error('Zapier webhook error:', error);
    res.status(500).json({ error: error.message });
  }
});

async function handleNewSubscriber(subscriberData) {
  // Create contact
  const contact = await emailClient.contacts.create({
    email: subscriberData.email,
    first_name: subscriberData.first_name || '',
    last_name: subscriberData.last_name || '',
    custom_fields: {
      zapier_trigger: 'new_subscriber',
      source: subscriberData.source || 'zapier',
      subscription_date: subscriberData.date
    },
    tags: ['zapier_subscriber', subscriberData.source || 'unknown'],
    consent: {
      email_marketing: true,
      tracking: true,
      date_given: subscriberData.date
    }
  });

  // Send welcome email sequence
  await emailClient.campaigns.trigger_sequence(contact.id, 'welcome_series');
  
  // Track analytics
  await emailClient.analytics.trackEvent('zapier_integration', {
    trigger: 'new_subscriber',
    contact_id: contact.id,
    source: subscriberData.source
  });
}

// Zapier app configuration
module.exports = {
  app,
  port: process.env.PORT || 3000
};
```

---

## Testing Tools

### API Testing Environment (⭐⭐⭐)

#### Sandbox Environment
**Base URL**: `https://sandbox-api.penguinmails.com`
**API Key Format**: `sk_test_...`
**Rate Limits**: Relaxed for testing
**Features**: Full API functionality with test data

#### Test Data Generator
```python
import random
from datetime import datetime, timedelta

class PenguinMailsTestDataGenerator:
    def __init__(self, client):
        self.client = client
    
    def generate_test_campaigns(self, count=5):
        """Generate test campaigns for testing."""
        campaigns = []
        
        templates = [
            {
                "name": "Welcome Email",
                "subject": "Welcome to {{company_name}}!",
                "content": {
                    "html": "<h1>Welcome {{first_name}}!</h1><p>We're excited to have you.</p>",
                    "text": "Welcome {{first_name}}! We're excited to have you."
                }
            },
            {
                "name": "Product Launch",
                "subject": "New Product: {{product_name}}",
                "content": {
                    "html": "<h1>Introducing {{product_name}}</h1><p>{{product_description}}</p>",
                    "text": "Introducing {{product_name}}. {{product_description}}"
                }
            }
        ]
        
        for i in range(count):
            template = random.choice(templates)
            
            campaign_data = {
                "name": f"Test Campaign {i+1}",
                "subject": template["subject"],
                "content": template["content"],
                "recipients": self.generate_test_recipients(50),
                "settings": {
                    "analytics_enabled": True,
                    "ai_optimization": True,
                    "track_opens": True,
                    "track_clicks": True
                }
            }
            
            campaign = self.client.campaigns.create(campaign_data)
            campaigns.append(campaign)
        
        return campaigns
    
    def generate_test_recipients(self, count=100):
        """Generate test recipient data."""
        recipients = []
        first_names = ["John", "Jane", "Mike", "Sarah", "David", "Emily", "Chris", "Lisa"]
        last_names = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis"]
        companies = ["Acme Corp", "Tech Solutions", "Global Inc", "Innovation LLC", "Future Systems"]
        
        for i in range(count):
            recipients.append({
                "email": f"test{i}@example.com",
                "personalization": {
                    "first_name": random.choice(first_names),
                    "last_name": random.choice(last_names),
                    "company": random.choice(companies),
                    "role": random.choice(["Manager", "Developer", "Analyst", "Director"]),
                    "industry": random.choice(["Technology", "Healthcare", "Finance", "Education"])
                },
                "tags": [random.choice(["lead", "customer", "prospect"])]
            })
        
        return recipients
```

### API Testing Framework (⭐⭐⭐)

#### Pytest Integration
```python
import pytest
import asyncio
from penguinmails import PenguinMails
from penguinmails.models import Campaign, Email
from penguinmails.exceptions import ValidationError, AuthenticationError

class TestPenguinMailsAPI:
    @pytest.fixture
    def client(self):
        """Create test client with sandbox API key."""
        return PenguinMails(api_key="sk_test_abc123")
    
    @pytest.fixture
    def test_campaign_data(self):
        """Standard test campaign data."""
        return {
            "name": "Test Campaign",
            "subject": "Test Subject",
            "content": {
                "html": "<h1>Test Email</h1><p>This is a test email.</p>",
                "text": "Test Email - This is a test email."
            },
            "recipients": [
                {
                    "email": "test@example.com",
                    "personalization": {"name": "Test User"}
                }
            ],
            "settings": {
                "analytics_enabled": True,
                "track_opens": True,
                "track_clicks": True
            }
        }
    
    def test_campaign_creation(self, client, test_campaign_data):
        """Test campaign creation."""
        campaign = client.campaigns.create(test_campaign_data)
        
        assert campaign.id is not None
        assert campaign.name == test_campaign_data["name"]
        assert campaign.status == "draft"
        assert campaign.settings.analytics_enabled is True
    
    def test_campaign_validation(self, client):
        """Test campaign validation errors."""
        invalid_data = {
            "name": "",  # Empty name should fail
            "subject": "Test Subject",
            "content": {"html": "<h1>Test</h1>", "text": "Test"},
            "recipients": []
        }
        
        with pytest.raises(ValidationError) as exc_info:
            client.campaigns.create(invalid_data)
        
        assert "name" in str(exc_info.value).lower()
    
    def test_email_sending(self, client):
        """Test single email sending."""
        email = Email(
            to="test@example.com",
            subject="Test Email",
            content="<p>Test content</p>",
            tracking={"track_opens": True, "track_clicks": True}
        )
        
        result = client.emails.send(email)
        
        assert result.message_id is not None
        assert result.status == "queued"
        assert result.analytics_tracking.tracking_id is not None
```

#### Jest Testing Framework
```javascript
const { PenguinMails } = require('@penguinmails/sdk');

describe('PenguinMails API', () => {
  let client;

  beforeEach(() => {
    client = new PenguinMails({
      apiKey: 'sk_test_abc123',
      baseUrl: 'https://sandbox-api.penguinmails.com'
    });
  });

  describe('Campaign Management', () => {
    test('should create campaign successfully', async () => {
      const campaignData = {
        name: 'Test Campaign',
        subject: 'Test Subject',
        content: {
          html: '<h1>Test Email</h1><p>This is a test email.</p>',
          text: 'Test Email - This is a test email.'
        },
        recipients: [
          {
            email: 'test@example.com',
            personalization: { name: 'Test User' }
          }
        ],
        settings: {
          analytics_enabled: true,
          track_opens: true,
          track_clicks: true
        }
      };

      const campaign = await client.campaigns.create(campaignData);

      expect(campaign.id).toBeDefined();
      expect(campaign.name).toBe(campaignData.name);
      expect(campaign.status).toBe('draft');
    });

    test('should validate required fields', async () => {
      const invalidData = {
        name: '', // Empty name should fail
        subject: 'Test Subject',
        content: { html: '<h1>Test</h1>', text: 'Test' },
        recipients: []
      };

      await expect(client.campaigns.create(invalidData)).rejects.toThrow('ValidationError');
    });
  });

  describe('Email Sending', () => {
    test('should send single email', async () => {
      const email = {
        to: 'test@example.com',
        subject: 'Test Email',
        content: '<p>Test content</p>',
        tracking: { track_opens: true, track_clicks: true }
      };

      const result = await client.emails.send(email);

      expect(result.message_id).toBeDefined();
      expect(result.status).toBe('queued');
      expect(result.analytics_tracking).toBeDefined();
    });
  });
});
```

---

## Best Practices

### Performance Optimization (⭐⭐⭐)
1. **Use Batch Operations**: For multiple recipients, use bulk endpoints
2. **Implement Caching**: Cache frequently accessed data
3. **Optimize Webhook Processing**: Handle webhooks asynchronously
4. **Monitor Rate Limits**: Implement proper rate limiting in your application

### Security Best Practices (⭐⭐⭐)
1. **Validate All Inputs**: Always validate and sanitize user inputs
2. **Use HTTPS**: Never send API requests over HTTP
3. **Store API Keys Securely**: Use environment variables or secure key management
4. **Implement Webhook Verification**: Always verify webhook signatures
5. **Regular Security Audits**: Keep dependencies and integrations updated

### Error Handling (⭐⭐)
1. **Implement Retry Logic**: For transient errors like rate limits
2. **Log All Errors**: Maintain comprehensive error logging
3. **User-Friendly Error Messages**: Provide clear error messages to users
4. **Monitor Error Rates**: Set up alerts for high error rates

### Testing Strategy (⭐⭐)
1. **Use Sandbox Environment**: Always test in sandbox first
2. **Comprehensive Test Coverage**: Test all integration points
3. **Mock External Dependencies**: Use mocks for testing
4. **Automated Testing**: Implement CI/CD with comprehensive tests

---

## Support & Resources

### Documentation
- [API Reference](((../api-reference)) - Complete API documentation
- [Integration Examples](((./integration-examples)) - Real-world integration guides
- [SDK Documentation](((./sdk-documentation)) - Language-specific SDK guides
- [Webhook Guide](((./webhook-guide)) - Webhook implementation guide

### Community
- [Developer Forum](https://community.penguinmails.com) - Get help from the community
- [GitHub Repository](https://github.com/penguinmails/sdk) - Report issues and contribute
- [Stack Overflow](https://stackoverflow.com/questions/tagged/penguinmails) - Ask technical questions

### Support Channels
- **Documentation**: This comprehensive API reference
- **Email Support**: api-support@penguinmails.com
- **Priority Support**: Available for Enterprise customers
- **Response Time**: < 24 hours for standard support, < 4 hours for priority

---

*This API reference provides comprehensive documentation for integrating with PenguinMails' email marketing platform. For additional support or questions, please contact our developer support team.*

**Keywords**: API reference, REST API, webhooks, SDK documentation, integration guide, authentication, rate limiting, error handling, testing, best practices