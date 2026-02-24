---
title: "Testing Guide - Fixtures & Data Management"
description: "Guidelines for managing test data, fixtures, and data generators."
last_modified_date: "2026-02-24"
level: "2"
persona: "Quality Assurance"
---

# Testing Guide - Fixtures & Data Management

### Test Data Management

Robust tests require high-quality, reproducible test data. PenguinMails uses a combination of static fixtures and dynamic data generators to ensure comprehensive coverage.

#### **Test Fixtures Implementation**

```typescript
// tests/fixtures/sample-campaigns.ts
import { CampaignData, RecipientData, BulkRecipients } from '../types/test-types';

// Sample campaign data for testing
export const sampleCampaignData: CampaignData = {
  name: 'Test Campaign',
  subject: 'Test Subject Line',
  content: {
    html: '<h1>Test Campaign</h1><p>This is a test campaign.</p>',
    text: 'Test Campaign - This is a test campaign.'
  },
  recipients: [
    { email: 'user1@example.com', personalization: { name: 'User 1' } },
    { email: 'user2@example.com', personalization: { name: 'User 2' } }
  ],
  settings: {
    trackOpens: true,
    trackClicks: true
  }
};

// Edge cases for recipient validation
export const recipientValidationTestCases = {
  valid: [
    { email: 'valid@example.com', personalization: { name: 'Valid User' } },
    { email: 'user.name+tag@company.com' }
  ],
  invalid: [
    { email: 'invalid-email' }, // Missing @
    { email: 'user@' }, // Missing domain
    { email: '@domain.com' }, // Missing user
    { email: '' }, // Empty email
    { email: 'missing@company', personalization: { name: '' } }, // Empty personalization
    {
      email: 'valid@example.com',
      personalization: null as any // Invalid personalization type
    }
  ]
};

// Campaign templates for different scenarios
export const campaignTemplates = {
  // Welcome email campaign
  welcomeCampaign: {
    name: 'Welcome New Users',
    subject: 'Welcome to Our Platform, {{name}}!',
    content: {
      html: '<h1>Welcome!</h1><p>We are glad to have you here, {{name}}.</p>',
      text: 'Welcome! We are glad to have you here, {{name}}.'
    },
    recipients: [
      {
        email: 'customer@example.com',
        personalization: { name: 'Customer' }
      }
    ],
    settings: {
      trackOpens: true,
      trackClicks: true
    }
  },

  // Newsletter campaign
  newsletterCampaign: {
    name: 'Weekly Newsletter',
    subject: 'Your Weekly Tech Update',
    content: {
      html: `<h1>Tech News This Week</h1><p>Latest updates in technology and industry trends.</p>`,
      text: 'Tech News This Week - Latest updates in technology and industry trends.'
    },
    recipients: [
      {
        email: 'subscriber@example.com',
        personalization: {
          name: 'Subscriber',
          interests: ['technology', 'innovation']
        }
      }
    ]
  }
};
```

#### **Test Data Generators**

```typescript
export class TestDataGenerator {
  static generateRecipients(count: number): RecipientData[] {
    return Array.from({ length: count }, (_, i) => ({
      email: `test${i + 1}@example.com`,
      personalization: {
        name: `Test User ${i + 1}`,
        id: `UID-${1000 + i}`
      }
    }));
  }

  static generateCampaignName(index: number): string {
    const prefixes = ['Summer', 'Winter', 'Spring', 'Fall', 'Holiday', 'Flash'];
    const suffixes = ['Sale', 'Promo', 'Update', 'News', 'Alert', 'Offer'];

    const prefix = prefixes[index % prefixes.length];
    const suffix = suffixes[Math.floor(index / prefixes.length) % suffixes.length];

    return `${prefix} ${suffix} ${index + 1}`;
  }

  static generateEmailContent(type: 'welcome' | 'promotional' | 'newsletter'): EmailContent {
    switch (type) {
      case 'welcome':
        return {
          html: '<h1>Welcome {{name}}!</h1><p>Thank you for joining us.</p>',
          text: 'Welcome {{name}}! Thank you for joining us.'
        };
      case 'promotional':
        return {
          html: '<h1>Limited Offer!</h1><p>Get 50% off today only.</p>',
          text: 'Limited Offer! Get 50% off today only.'
        };
      case 'newsletter':
        return {
          html: '<h1>Weekly Update</h1><p>Here are this week\'s updates.</p>',
          text: 'Weekly Update - Here are this week\'s updates.'
        };
    }
  }
}
```

### Data Management Best Practices

1. **Isolation**: Tests should never share data unless explicitly designed as a stateful E2E journey.
2. **Reproducibility**: Use fixed seeds for random data generators where possible.
3. **Realism**: Ensure test data reflects the constraints and complexity of production data.
4. **Validation Test Cases**: Maintain a comprehensive set of valid and invalid data cases for regression testing.
5. **Cleanliness**: Automate the cleanup of generated test data from test environments.
