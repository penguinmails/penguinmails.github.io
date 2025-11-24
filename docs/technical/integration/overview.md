---
title: "Integration & API Overview"
description: "Complete API documentation and third-party integration guides for developers and integrators"
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---

# Integration & API Overview

## Complete Developer Ecosystem

**Strategic Alignment**: Our comprehensive integration ecosystem supports our market leadership goals by providing **unlimited connectivity** to existing business systems. This technical flexibility enables customers to scale their operations without changing their core workflows, supporting our value proposition of being the most adaptable cold email solution.

**Technical Authority**: Our API infrastructure integrates **enterprise-grade security and scalability** featuring OAuth 2.0 authentication, comprehensive rate limiting, and comprehensive JavaScript/TypeScript SDK support that establish technical credibility in the developer community.

**Operational Excellence**: Backed by **99.9% API uptime** with comprehensive error handling, detailed logging, and intelligent rate limiting that ensures your integrations always work reliably when you need them.

**User Journey Integration**: This integration capability is part of your complete [developer experience journey] - connecting to [campaign management](/docs/core-features) and [analytics tracking](/docs/core-features/analytics/overview) to provide seamless workflow automation that scales with your business.

PenguinMails provides a comprehensive integration ecosystem designed for developers, with **RESTful APIs, SDKs for major programming languages, webhook systems, and extensive third-party integrations**. Build custom solutions with confidence using our enterprise-grade API infrastructure.

### **Integration Mission**

Enable **seamless integration** with existing business systems while providing the flexibility to build custom solutions, ensuring that cold email becomes an integrated part of your business workflow rather than a separate tool.

---

## Core API Architecture

### **RESTful API Design**

## API Foundation

- **Base URL**: `https://api.penguinmails.com/v1/` (production) / `https://sandbox-api.penguinmails.com/v1/` (testing)
- **Authentication**: JWT tokens, API keys, and OAuth 2.0 support
- **Rate Limiting**: Tiered rate limits (1K to 1M requests) with intelligent throttling
- **Versioning**: URL-based versioning (v1, v2) with 6-month backward compatibility

## Response Format Standardization

```json
{
  "success": true,
  "data": {
    "id": "campaign_abc123",
    "name": "Welcome Series",
    "status": "active"
  },
  "meta": {
    "request_id": "req_xyz789",
    "timestamp": "2025-12-01T09:00:00Z"
  }
}
```

### **Authentication & Authorization**

**API Key Authentication (Level 3)**
```http
Authorization: Bearer pk_live_abc123def456ghi789
Content-Type: application/json
```

**JWT Token Authentication**
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "secure_password"
}
```

**OAuth 2.0 Integration**
```http
https://app.penguinmails.com/oauth/authorize?client_id=your_client_id&redirect_uri=your_callback_url&response_type=code&scope=read write
```

---

## Core API Endpoints

### **Campaign Management API (Level 3)**

**Create Campaign**
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
  "settings": {
    "analytics_enabled": true,
    "ai_optimization": true,
    "track_opens": true,
    "track_clicks": true
  }
}
```

**AI-Powered Optimization Response**
```json
{
  "success": true,
  "data": {
    "id": "campaign_abc123",
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

### **Email Sending API (Level 3)**

**Single Email Send**
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
  "tracking": {
    "track_opens": true,
    "track_clicks": true
  }
}
```

**Bulk Email Send**
```http
POST /api/v1/emails/send-bulk
Authorization: Bearer {token}
Content-Type: application/json

{
  "campaign_id": "campaign_abc123",
  "recipients": [
    {
      "email": "user1@example.com",
      "personalization": {"name": "John Doe"}
    }
  ],
  "batch_size": 100,
  "delay_between_batches": 5
}
```

### **Analytics & Reporting API (Level 3)**

**Campaign Analytics**
```http
GET /api/v1/analytics/campaigns/{campaign_id}?period=7d
Authorization: Bearer {token}
```

**Advanced Analytics Response**
```json
{
  "success": true,
  "data": {
    "overview": {
      "sent": 1000,
      "delivered": 995,
      "opened": 348,
      "clicked": 84
    },
    "revenue_impact": {
      "total_value": "$770.00",
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
      ]
    }
  }
}
```

---

## AI & Machine Learning APIs

### **AI Personalization Engine (Level 3)**

**Content Optimization**
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
      "interests": ["technology", "shopping"]
    }
  },
  "optimization_goals": ["open_rate", "click_rate", "revenue"]
}
```

**AI Response with Optimization**
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
      "html": "<h1>⚡ Tech Essentials Sale</h1><p>Save big on the gadgets you love.</p>"
    },
    "improvements": {
      "expected_open_rate_increase": 0.18,
      "expected_click_rate_increase": 0.25,
      "sentiment_score": 0.85
    }
  }
}
```

---

## Webhook System

### **Real-time Event Notifications**

**Event Types**
- **Campaign Events**: `campaign.created`, `campaign.sent`, `campaign.completed`
- **Email Events**: `email.sent`, `email.delivered`, `email.opened`, `email.clicked`
- **Analytics Events**: `analytics.updated`, `goal.converted`, `revenue.recorded`

**Webhook Registration**
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
    "campaign.completed"
  ],
  "secret": "your-webhook-secret"
}
```

**Webhook Payload Format**
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
      "opened_at": "2025-12-01T09:15:30Z"
    },
    "analytics": {
      "open_count": 1,
      "device_type": "mobile",
      "location": "United States"
    }
  }
}
```

**Signature Verification**
```javascript
const crypto = require('crypto');

function verifyWebhookSignature(payload, signature, secret) {
  const expectedSignature = crypto
    .createHmac('sha256', secret)
    .update(payload, 'utf8')
    .digest('hex');
    
  const expectedHeader = `sha256=${expectedSignature}`;
  return crypto.timingSafeEqual(
    Buffer.from(expectedHeader),
    Buffer.from(signature)
  );
}
```

---

## SDK Libraries

### **JavaScript/TypeScript SDK**

Our primary SDK support focuses on JavaScript and TypeScript for modern web development workflows.

### **JavaScript SDK**

**Installation & Basic Usage**
```bash
npm install @penguinmails/sdk
```

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
  }
});

console.log(`Campaign created: ${campaign.id}`);

// Send email with tracking
const email = {
  to: 'user@example.com',
  subject: 'Test Email',
  content: '<p>Hello from PenguinMails!</p>',
  tracking: {
    track_opens: true,
    track_clicks: true
  }
};

const result = await client.emails.send(email);
console.log(`Email sent: ${result.message_id}`);
```

**React Integration**
```jsx
import { PenguinMailsProvider, usePenguinMails } from '@penguinmails/sdk-react';

function CampaignCreator() {
  const { campaigns, createCampaign } = usePenguinMails();

  const handleCreateCampaign = async (campaignData) => {
    try {
      const campaign = await createCampaign(campaignData);
      console.log('Campaign created:', campaign);
    } catch (error) {
      console.error('Failed to create campaign:', error);
    }
  };

  return ()
    <form onSubmit={handleCreateCampaign}>
      {/* Campaign form fields */}
    </form>
  );
}

function App() {
  return ()
    <PenguinMailsProvider apiKey="pk_live_abc123def456">
      <CampaignCreator />
    </PenguinMailsProvider>
  );
}
```

### **CSS Integration**

Our platform supports CSS-based email template customization with responsive design capabilities:

```css
/* PenguinMails Email Template Styles */
.penguin-email-container {
  max-width: 600px;
  margin: 0 auto;
  font-family: 'Helvetica Neue', Arial, sans-serif;
  line-height: 1.6;
  color: #333;
}

.penguin-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 30px 20px;
  text-align: center;
}

.penguin-content {
  padding: 30px 20px;
  background: #ffffff;
}

.penguin-button {
  display: inline-block;
  background: #4CAF50;
  color: white;
  padding: 12px 24px;
  text-decoration: none;
  border-radius: 5px;
  font-weight: bold;
  margin: 20px 0;
}

/* Responsive Design */
@media only screen and (max-width: 600px) {
  .penguin-email-container {
    width: 100% !important;
  }
  
  .penguin-content {
    padding: 20px 15px !important;
  }
}
```

---

## Third-Party Integrations

### **CRM Integrations (Level 2)**

**Salesforce Integration**
```typescript
import { PenguinMails } from '@penguinmails/sdk';
import jsforce from 'jsforce';

class SalesforcePenguinMailsIntegration {
  private emailClient: PenguinMails;
  private salesforce: jsforce.Connection;

  constructor(emailApiKey: string, salesforceConfig: any) {
    this.emailClient = new PenguinMails({ apiKey: emailApiKey });
    this.salesforce = new jsforce.Connection(salesforceConfig);
  }

  async syncLeadToEmail(leadData: any): Promise<void> {
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
        industry: leadData.Industry
      },
      tags: ['salesforce_lead', leadData.LeadSource.toLowerCase()]
    });

    // Trigger appropriate email sequence
    await this.triggerLeadSequence(contact.id, enrichedData);
  }
}
```

**HubSpot Integration**
```javascript
import { PenguinMails } from '@penguinmails/sdk';
import { Client } from '@hubspot/api-client';

class HubSpotPenguinMailsIntegration {
  constructor(penguinmailsApiKey, hubspotApiKey) {
    this.emailClient = new PenguinMails({ apiKey: penguinmailsApiKey });
    this.hubspot = new Client({ accessToken: hubspotApiKey });
  }

  async syncContactToEmail(hubspotContact) {
    try {
      // Get additional contact data from HubSpot
      const contactData = await this.hubspot.crm.contacts.basicApi.getById(
        hubspotContact.id,
        ['email', 'firstname', 'lastname', 'company', 'lifecyclestage']
      );

      // AI-enrichment for better targeting
      const enrichedData = await this.emailClient.ai.analyzeContact({
        company: contactData.properties.company || '',
        lifecycleStage: contactData.properties.lifecyclestage || 'lead'
      });

      // Create contact in PenguinMails
      const contact = await this.emailClient.contacts.create({
        email: contactData.properties.email,
        firstName: contactData.properties.firstname || '',
        lastName: contactData.properties.lastname || '',
        company: contactData.properties.company || '',
        customFields: {
          hubspotContactId: hubspotContact.id,
          lifecycleStage: contactData.properties.lifecyclestage || 'lead',
          aiEnrichment: enrichedData
        },
        tags: ['hubspot_sync', 'crm_integration']
      });

      return contact;
    } catch (error) {
      console.error('Integration error:', error);
      throw error;
    }
  }
}
```

### **E-commerce Platform Integrations (Level 3)**

**Shopify Integration**
```javascript
import { PenguinMails } from '@penguinmails/sdk';
import { shopifyApi } from '@shopify/shopify-api';

class ShopifyPenguinMailsIntegration {
  constructor(shopifyApiKey, penguinmailsApiKey) {
    this.shopify = shopifyApi({ apiKey: shopifyApiKey });
    this.emailClient = new PenguinMails({ apiKey: penguinmailsApiKey });
  }

  async syncCustomerAndSendWelcome(customerData) {
    try {
      // Create contact with purchase history
      const contactData = {
        email: customerData.email,
        firstName: customerData.first_name,
        customFields: {
          shopifyCustomerId: customerData.id,
          totalSpent: customerData.total_spent,
          orderCount: customerData.orders_count
        },
        tags: ['shopify_customer', 'new_customer']
      };

      const contact = await this.emailClient.contacts.create(contactData);

      // Send personalized welcome email
      const emailData = {
        to: customerData.email,
        subject: `Welcome ${customerData.first_name}!`,
        content: {
          html: this.generateWelcomeHtml(customerData),
          text: this.generateWelcomeText(customerData)
        }
      };

      const result = await this.emailClient.emails.send(emailData);
      return result;
    } catch (error) {
      console.error('Integration error:', error);
      throw error;
    }
  }

  generateWelcomeHtml(customerData) {
    return `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <h1>Welcome ${customerData.first_name}!</h1>
        <p>Thank you for joining our community!</p>
        <p>Order History: ${customerData.orders_count} orders</p>
        <p>Total Spent: $${customerData.total_spent}</p>
      </div>
    `;
  }
}
```

### **Zapier Integration (Level 2)**

**Zapier Webhook Handler**
```javascript
const express = require('express');
const { PenguinMails } = require('@penguinmails);

const app = express();
const emailClient = new PenguinMails({
  apiKey: process.env.PENGUINMAILS_API_KEY
});

// Handle Zapier webhook triggers
app.post('/webhooks/zapier) => {
  try {
    const { trigger_type, data } = req.body;

    switch (trigger_type) {
      case 'new_subscriber':
        await handleNewSubscriber(data);
        break;
      case 'purchase_made':
        await handlePurchaseMade(data);
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
  const contact = await emailClient.contacts.create({
    email: subscriberData.email,
    first_name: subscriberData.first_name || '',
    custom_fields: {
      zapier_trigger: 'new_subscriber',
      source: subscriberData.source || 'zapier'
    },
    tags: ['zapier_subscriber', subscriberData.source || 'unknown']
  });

  // Trigger welcome sequence
  await emailClient.campaigns.trigger_sequence(contact.id, 'welcome_series');
}
```

---

## Payment Processing Integrations

### **Stripe Integration (Level 3)**

PenguinMails uses **Stripe** for subscription management and payment processing, providing secure checkout flows and self-service billing management for tenants.

**Key Features**:
- **Stripe Checkout Sessions**: Hosted payment pages for plan upgrades and subscription creation
- **Webhook Integration**: Real-time synchronization of subscription events
- **Customer Portal**: Self-service billing management (planned)
- **Payment Security**: PCI-compliant payment processing without storing card details

**Architecture**:
- **Light Database Reference**: Stripe is the source of truth for billing data
- **Metadata Tracking**: Company and user context attached to Stripe sessions
- **Event-Driven Sync**: Webhooks update local subscription state automatically

**Implementation Details**:

For complete technical implementation details, including:
- Checkout flow and API routes
- Webhook event handlers
- Database schema requirements
- Security best practices
- Testing with Stripe test mode

See: **[Stripe Integration Documentation](/docs/technical/integration/stripe)**

**Quick Integration Example**:

```typescript
// Create checkout session for plan upgrade
const session = await stripeApi.checkout.sessions.create({
  mode: 'subscription',
  line_items: [{
    price_data: {
      currency: 'usd',
      recurring: { interval: 'month' },
      product_data: { name: 'Pro Plan' },
      unit_amount: 8900, // $89 in cents
    },
    quantity: 1,
  }],
  success_url: `${appUrl}/dashboard/settings/billing?checkout=success`,
  cancel_url: `${appUrl}/dashboard/settings/billing?checkout=canceled`,
  metadata: {
    tenant_id: tenantId,  // NileDB tenant ID for multi-tenant isolation
    plan_id: 'pro',
  },
});

// Redirect user to Stripe Checkout
window.location.href = session.url;
```

**Webhook Events Handled**:

- `checkout.session.completed`: Links subscription to tenant's subscription record (updates `subscriptions` + `tenant_config` tables)
- `invoice.paid`: Records payment in `payments` table and confirms service continuation
- `customer.subscription.updated`: Syncs subscription status and period end date in `subscriptions` table

**Related Resources**:

- [Settings Billing Route](/docs/design/routes/settings#dashboard-settings/billing)
- [Pricing Plans](/docs/pricing/overview) (if exists)

---

## Rate Limiting & Error Handling

### **Rate Limiting Tiers (Level 3)**

| Tier | Requests/Hour | Features | Cost |
|------|---------------|----------|------|
| **Free** | 1,000 | Basic email sending, limited analytics | $0 |
| **Starter** | 10,000 | Full email sending, basic analytics | $29/month |
| **Professional** | 100,000 | Advanced analytics, AI optimization, webhooks | $99/month |
| **Enterprise** | 1,000,000 | Unlimited features, priority support, custom integrations | $299/month |

### Rate Limit Headers

```markdown
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1701429600
```

### **Error Handling Best Practices (Level 2)**

**Standard Error Response**
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
      }
    ],
    "request_id": "req_abc123"
  }
}
```

**JavaScript/TypeScript Error Handling**
```javascript
import {
  PenguinMailsError,
  ValidationError,
  RateLimitError,
  AuthenticationError
} from '@penguinmails/sdk';

async function sendCampaignWithRetry(client, campaignData, maxRetries = 3) {
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      return await client.campaigns.create(campaignData);
    } catch (error) {
      if (error instanceof ValidationError) {
        console.error('Validation failed:', error.details);
        return null; // Don't retry validation errors
      }

      if (error instanceof RateLimitError) {
        if (attempt === maxRetries - 1) {
          throw error;
        }
        const waitTime = error.retryAfter || Math.pow(2, attempt) * 1000;
        console.log(`Rate limited. Retrying in ${waitTime}ms...`);
        await new Promise(resolve => setTimeout(resolve, waitTime));
        continue;
      }

      if (error instanceof AuthenticationError) {
        console.error('Authentication failed:', error.message);
        return null;
      }

      throw error; // Re-throw unexpected errors
    }
  }
}
```

---

## Testing & Development Tools

### **Sandbox Environment**

**Testing Setup**
- **Base URL**: `https://sandbox-api.penguinmails.com`
- **API Key Format**: `sk_test_...`
- **Features**: Full API functionality with test data
- **Rate Limits**: Relaxed for testing

### **Test Data Generator**
```javascript
import { PenguinMails } from '@penguinmails/sdk';

class PenguinMailsTestDataGenerator {
  constructor(client) {
    this.client = client;
  }

  async generateTestCampaigns(count = 5) {
    const campaigns = [];

    for (let i = 0; i < count; i++) {
      const campaignData = {
        name: `Test Campaign ${i + 1}`,
        subject: `Test Subject ${i + 1}`,
        content: {
          html: `<h1>Test Email ${i + 1}</h1><p>This is test content.</p>`,
          text: `Test Email ${i + 1} - This is test content.`
        },
        recipients: this.generateTestRecipients(50),
        settings: {
          analyticsEnabled: true,
          aiOptimization: true,
          trackOpens: true,
          trackClicks: true
        }
      };

      const campaign = await this.client.campaigns.create(campaignData);
      campaigns.push(campaign);
    }

    return campaigns;
  }

  generateTestRecipients(count) {
    const recipients = [];
    for (let i = 0; i < count; i++) {
      recipients.push({
        email: `test${i}@example.com`,
        personalization: {
          name: `Test User ${i}`,
          company: `Test Company ${i}`
        }
      });
    }
    return recipients;
  }
}
```

### **API Testing Framework**
```javascript
import { test, expect } from '@jest/globals';
import { PenguinMails } from '@penguinmails/sdk';
import { ValidationError } from '@penguinmails/sdk';

describe('PenguinMails API', () => {
  let client;

  beforeEach(() => {
    client = new PenguinMails({ apiKey: 'sk_test_abc123' });
  });

  test('should create campaign successfully', async () => {
    const campaignData = {
      name: 'Test Campaign',
      subject: 'Test Subject',
      content: { html: '<h1>Test</h1>', text: 'Test' },
      recipients: [{ email: 'test@example.com' }]
    };

    const campaign = await client.campaigns.create(campaignData);

    expect(campaign.id).toBeDefined();
    expect(campaign.name).toBe(campaignData.name);
    expect(campaign.status).toBe('draft');
  });

  test('should handle validation errors', async () => {
    const invalidCampaignData = {
      name: '', // Invalid: empty name
      subject: 'Test Subject',
      content: { html: '<h1>Test</h1>', text: 'Test' },
      recipients: []
    };

    await expect(client.campaigns.create(invalidCampaignData))
      .rejects
      .toThrow(ValidationError);
  });
});
```

---

## Additional Resources

### **Developer Documentation**
- **[API Reference](/docs/technical/integration/advanced-integrations)** - Complete API documentation
- **[SDK Documentation](/docs/technical/integration/development-resources)** - Detailed SDK guides
- **[Webhook Guide](/docs/technical/integration/advanced-integrations/webhook-guide)** - Webhook implementation guide
- **[Testing Framework](/docs/technical/integration/development-resources/testing-framework)** - Testing tools and best practices

### **Support & Community**
- **Developer Support**: developer-support@penguinmails.com
- **API Status**: https://status.penguinmails.com
- **Developer Community**: https://community.penguinmails.com
- **GitHub Examples**: https://github.com/penguinmails/examples

### **Integration Partners**
- **Certified Partners**: Pre-built integrations with major platforms
- **Integration Marketplace**: Browse available integrations
- **Custom Development**: Enterprise custom integration services
- **Partnership Program**: Revenue sharing for integration partners

---

*Our comprehensive integration ecosystem ensures that PenguinMails seamlessly fits into your existing technology stack while providing the flexibility to build custom solutions that drive your business forward.*

---
*Previous: [Technical Operations Overview](/docs/technical/operations/overview) | Next: [Core Features Overview](/docs/core-features) →*
---
