---
title: "Testing Requirements & Quality Standards"
description: "Testing requirements, quality assurance, validation standards, and test coverage guidelines"
last_modified_date: "2025-11-24"
level: "2"
persona: "Quality Assurance"
---


# Testing Requirements & Quality Standards

## Testing Standards

### Test Coverage Requirements

- **Overall Coverage**: Minimum 80%

- **Critical Paths**: Minimum 90%

- **New Code**: Must maintain existing coverage percentage

- **Business Logic**: 95% coverage required

- **API Endpoints**: 100% coverage for request/response handling

### Test Organization

```text

tests/
├── unit/                          # Unit tests
│   ├── test_email_service.py      # Service layer tests
│   ├── test_ai_optimizer.py       # AI component tests
│   ├── test_analytics_service.py  # Analytics tests
│   └── test_models.py             # Model tests
├── integration/                   # Integration tests
│   ├── test_api_campaigns.py      # API endpoint tests
│   ├── test_database_operations.py# Database integration
│   └── test_external_services.py  # External API integration
├── e2e/                          # End-to-end tests
│   ├── test_campaign_workflow.py  # User workflow tests
│   ├── test_analytics_dashboard.py# Dashboard tests
│   └── test_mobile_experience.py  # Mobile experience tests
├── fixtures/                     # Test data
│   ├── sample_campaigns.json      # Sample campaign data
│   ├── user_profiles.json         # User profile data
│   └── analytics_data.json        # Analytics test data
└── conftest.py                   # Pytest configuration


```

## Unit Testing Standards

```typescript
// tests/unit/test-email-service.ts
import { describe, it, expect, beforeEach, afterEach, vi } from 'vitest';
import { EmailService } from '../../app/services/email-service';
import { EmailStatus, EmailMessage } from '../../app/models/email';
import { EmailDeliveryError, ValidationError } from '../../app/exceptions';

// Mock dependencies
vi.mock('../../app/services/smtp-client');
vi.mock('../../app/services/template-service');
vi.mock('../../app/services/analytics-service');
vi.mock('../../app/database/connection');

describe('EmailService', () => {
  let emailService: EmailService;
  let mockSmtpClient: ReturnType<typeof vi.fn>;
  let mockTemplateService: ReturnType<typeof vi.fn>;
  let mockAnalyticsService: ReturnType<typeof vi.fn>;
  let mockDatabase: ReturnType<typeof vi.fn>;

  beforeEach(() => {
    // Setup mocks
    mockSmtpClient = vi.fn();
    mockTemplateService = vi.fn();
    mockAnalyticsService = vi.fn();
    mockDatabase = vi.fn();

    // Initialize service with mocked dependencies
    emailService = new EmailService(
      mockSmtpClient as any,
      mockTemplateService as any,
      mockAnalyticsService as any,
      mockDatabase as any
    );
  });

  afterEach(() => {
    vi.clearAllMocks();
  });

  it('should send email successfully', async () => {
    // Arrange
    const emailData: EmailData = {
      to: 'test@example.com',
      subject: 'Test Subject',
      content: { html: '<p>Test content</p>', text: 'Test content' },
      from: { name: 'Test Sender', email: 'sender@example.com' }
    };

    const expectedMessageId = 'msg_123456';
    mockSmtpClient.sendEmail = vi.fn().mockResolvedValue({
      messageId: expectedMessageId,
      status: 'sent'
    });

    // Act
    const result = await emailService.sendEmail(emailData);

    // Assert
    expect(result.messageId).toBe(expectedMessageId);
    expect(result.status).toBe(EmailStatus.SENT);
    expect(result.sentAt).toBeDefined();

    // Verify method calls
    expect(mockSmtpClient.sendEmail).toHaveBeenCalledTimes(1);
    expect(mockAnalyticsService.trackDelivery).toHaveBeenCalledTimes(1);

    // Verify analytics tracking data
    const deliveryCall = mockAnalyticsService.trackDelivery.mock.calls[0];
    expect(deliveryCall[0].email).toBe(emailData.to);
    expect(deliveryCall[0].messageId).toBe(expectedMessageId);
  });

  it('should throw ValidationError for invalid recipient email', async () => {
    // Arrange
    const emailData: EmailData = {
      to: 'invalid-email', // Invalid email format
      subject: 'Test Subject',
      content: { html: '<p>Test</p>', text: 'Test' }
    };

    // Act & Assert
    await expect(emailService.sendEmail(emailData)).rejects.toThrow(ValidationError);

    const error = await emailService.sendEmail(emailData).catch(err => err);
    expect(error.message.toLowerCase()).toContain('invalid email');

    // Verify no external services were called
    expect(mockSmtpClient.sendEmail).not.toHaveBeenCalled();
    expect(mockAnalyticsService.trackDelivery).not.toHaveBeenCalled();
  });

  it('should process bulk emails with proper batch processing', async () => {
    // Arrange
    const recipients = Array.from({ length: 250 }, (_, i) => ({
      email: `user${i}@example.com`,
      name: `User ${i}`
    }));

    const emailData: EmailData = {
      subject: 'Bulk Test Email',
      content: { html: '<p>Bulk content</p>', text: 'Bulk content' }
    };

    // Mock batch sending response
    const batchResults = Array.from({ length: 250 }, (_, i) => ({
      messageId: `msg_${i}`,
      status: 'sent'
    }));

    mockSmtpClient.sendEmailBatch = vi.fn().mockResolvedValue(batchResults);

    // Act
    const results = await emailService.sendBulkEmails(recipients, emailData);

    // Assert
    expect(results).toHaveLength(250);
    expect(results.every(result => result.status === EmailStatus.SENT)).toBe(true);

    // Verify batch processing (assuming batch size of 100)
    const expectedBatches = Math.ceil(250 / 100);
    expect(mockSmtpClient.sendEmailBatch).toHaveBeenCalledTimes(expectedBatches);
  });

  it('should handle email delivery failures gracefully', async () => {
    // Arrange
    const emailData: EmailData = {
      to: 'test@example.com',
      subject: 'Test Subject',
      content: { html: '<p>Test content</p>', text: 'Test content' }
    };

    mockSmtpClient.sendEmail = vi.fn().mockRejectedValue(
      new Error('SMTP connection failed')
    );

    // Act & Assert
    await expect(emailService.sendEmail(emailData)).rejects.toThrow(EmailDeliveryError);

    // Verify analytics service was called with failure tracking
    expect(mockAnalyticsService.trackFailure).toHaveBeenCalledTimes(1);
  });

  it('should validate email content before sending', async () => {
    // Arrange - Test with missing required content
    const emailData = {
      to: 'test@example.com',
      subject: '', // Empty subject
      content: { html: '', text: '' } // Empty content
    };

    // Act & Assert
    await expect(emailService.sendEmail(emailData)).rejects.toThrow(ValidationError);

    expect(mockSmtpClient.sendEmail).not.toHaveBeenCalled();
  });
});

// Supporting interfaces
interface EmailData {
  to: string;
  subject: string;
  content: {
    html: string;
    text: string;
  };
  from?: {
    name: string;
    email: string;
  };
}

interface EmailResult {
  messageId: string;
  status: EmailStatus;
  sentAt: Date;
}


```

## Integration Testing Standards

```typescript
// tests/integration/test-campaign-api.ts
import { describe, it, expect, beforeAll, afterAll, beforeEach } from 'vitest';
import { setupServer } from 'msw/node';
import { http, HttpResponse } from 'msw';
import { createCampaign, getCampaigns } from '../../app/services/campaign-service';
import { Database } from '../../app/database/connection';

// Mock database setup
const mockDatabase = {
  campaigns: {
    create: vi.fn(),
    findMany: vi.fn(),
    findById: vi.fn(),
    update: vi.fn()
  },
  users: {
    findByEmail: vi.fn(),
    create: vi.fn()
  }
};

vi.mock('../../app/database/connection', () => ({
  Database: {
    getInstance: () => mockDatabase
  }
}));

describe('Campaign API Integration Tests', () => {
  let testUser: TestUser;
  let mockServer: ReturnType<typeof setupServer>;

  beforeAll(async () => {
    // Setup test database and create test user
    await setupTestDatabase();
    testUser = await createTestUser();
  });

  afterAll(async () => {
    await cleanupTestDatabase();
  });

  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe('Campaign Creation', () => {
    it('should create campaign successfully', async () => {
      // Arrange
      const campaignData: CreateCampaignRequest = {
        name: 'Test Campaign',
        subject: 'Test Subject Line',
        content: {
          html: '<h1>Test Campaign</h1><p>This is a test campaign.</p>',
          text: 'Test Campaign - This is a test campaign.'
        },
        recipients: [
          {
            email: 'recipient@example.com',
            personalization: { name: 'Test Recipient' }
          }
        ],
        settings: {
          analyticsEnabled: true,
          trackOpens: true,
          trackClicks: true,
          aiOptimization: false
        }
      };

      // Mock successful database creation
      mockDatabase.campaigns.create.mockResolvedValue({
        id: 'camp_123',
        ...campaignData,
        status: 'draft',
        createdAt: new Date(),
        updatedAt: new Date(),
        metrics: { sent: 0, delivered: 0, opened: 0, clicked: 0 }
      });

      // Act
      const result = await createCampaign(campaignData, testUser.id);

      // Assert
      expect(result.success).toBe(true);
      expect(result.data).toBeDefined();
      expect(result.data.name).toBe(campaignData.name);
      expect(result.data.subject).toBe(campaignData.subject);
      expect(result.data.status).toBe('draft');
      expect(result.data.id).toBeDefined();
      expect(result.data.createdAt).toBeDefined();

      // Verify campaign metrics are initialized
      expect(result.data.metrics).toBeDefined();
      expect(result.data.metrics.sent).toBe(0);

      // Verify database calls
      expect(mockDatabase.campaigns.create).toHaveBeenCalledTimes(1);
    });

    it('should reject campaign creation with duplicate name', async () => {
      // Arrange
      const campaignData: CreateCampaignRequest = {
        name: 'Duplicate Name Test',
        subject: 'Test Subject',
        content: { html: '<p>Test</p>', text: 'Test' },
        recipients: [{ email: 'test@example.com' }]
      };

      // Mock database conflict (duplicate name)
      mockDatabase.campaigns.create.mockRejectedValue(
        new Error('Campaign name already exists')
      );

      // Act & Assert
      await expect(createCampaign(campaignData, testUser.id))
        .rejects.toThrow('Campaign name already exists');
    });

    it('should validate required fields', async () => {
      // Arrange - Test with missing required fields
      const invalidData: CreateCampaignRequest = {
        name: '', // Empty name
        subject: 'Test Subject',
        content: { html: '<p>Test</p>', text: 'Test' },
        recipients: []
      };

      // Act & Assert
      await expect(createCampaign(invalidData, testUser.id))
        .rejects.toThrow('Campaign name is required');
    });
  });

  describe('Campaign Listing', () => {
    beforeEach(async () => {
      // Create multiple campaigns for testing
      const campaigns = Array.from({ length: 5 }, (_, i) => ({
        id: `camp_${i}`,
        name: `Test Campaign ${i + 1}`,
        subject: `Test Subject ${i + 1}`,
        content: { html: `<p>Campaign ${i + 1}</p>`, text: `Campaign ${i + 1}` },
        recipients: [{ email: `test${i + 1}@example.com` }],
        status: 'draft' as const,
        createdAt: new Date(),
        updatedAt: new Date(),
        userId: testUser.id
      }));

      mockDatabase.campaigns.findMany.mockResolvedValue(campaigns);
    });

    it('should list campaigns with pagination', async () => {
      // Arrange
      const paginationParams: PaginationParams = {
        page: 1,
        perPage: 3
      };

      // Mock pagination response
      const mockCampaigns = Array.from({ length: 3 }, (_, i) => ({
        id: `camp_${i}`,
        name: `Test Campaign ${i + 1}`,
        subject: `Test Subject ${i + 1}`
      }));

      mockDatabase.campaigns.findMany.mockResolvedValue(mockCampaigns);

      // Act
      const result = await getCampaigns(testUser.id, paginationParams);

      // Assert
      expect(result.success).toBe(true);
      expect(result.data).toHaveLength(3);
      expect(result.meta.pagination.page).toBe(1);
      expect(result.meta.pagination.perPage).toBe(3);
      expect(result.meta.pagination.total).toBe(5);

      // Test second page
      const page2Params = { ...paginationParams, page: 2 };
      const page2Campaigns = Array.from({ length: 2 }, (_, i) => ({
        id: `camp_${i + 3}`,
        name: `Test Campaign ${i + 4}`,
        subject: `Test Subject ${i + 4}`
      }));

      mockDatabase.campaigns.findMany.mockResolvedValue(page2Campaigns);

      const result2 = await getCampaigns(testUser.id, page2Params);
      expect(result2.data).toHaveLength(2);
      expect(result2.meta.pagination.page).toBe(2);
    });
  });

  describe('Campaign Management', () => {
    it('should update campaign successfully', async () => {
      // Arrange
      const campaignId = 'camp_123';
      const updateData: UpdateCampaignRequest = {
        name: 'Updated Campaign Name',
        subject: 'Updated Subject'
      };

      const existingCampaign = {
        id: campaignId,
        name: 'Original Campaign',
        subject: 'Original Subject',
        status: 'draft',
        userId: testUser.id
      };

      mockDatabase.campaigns.findById.mockResolvedValue(existingCampaign);
      mockDatabase.campaigns.update.mockResolvedValue({
        ...existingCampaign,
        ...updateData,
        updatedAt: new Date()
      });

      // Act
      const result = await updateCampaign(campaignId, updateData, testUser.id);

      // Assert
      expect(result.success).toBe(true);
      expect(result.data.name).toBe(updateData.name);
      expect(result.data.subject).toBe(updateData.subject);
    });

    it('should prevent unauthorized campaign updates', async () => {
      // Arrange
      const campaignId = 'camp_456';
      const updateData = { name: 'Updated Name' };
      const campaign = {
        id: campaignId,
        userId: 'different_user_id' // Different user
      };

      mockDatabase.campaigns.findById.mockResolvedValue(campaign);

      // Act & Assert
      await expect(updateCampaign(campaignId, updateData, testUser.id))
        .rejects.toThrow('Unauthorized');
    });
  });
});

// Supporting functions and types
async function setupTestDatabase(): Promise<void> {
  // Mock database setup
  console.log('Setting up test database...');
}

async function cleanupTestDatabase(): Promise<void> {
  // Mock database cleanup
  console.log('Cleaning up test database...');
}

async function createTestUser(): Promise<TestUser> {
  return {
    id: 'user_123',
    email: 'test@example.com',
    token: 'mock_jwt_token'
  };
}

// Supporting interfaces
interface TestUser {
  id: string;
  email: string;
  token: string;
}

interface CreateCampaignRequest {
  name: string;
  subject: string;
  content: {
    html: string;
    text: string;
  };
  recipients: Array<{
    email: string;
    personalization?: Record<string, unknown>;
  }>;
  settings?: {
    analyticsEnabled?: boolean;
    trackOpens?: boolean;
    trackClicks?: boolean;
    aiOptimization?: boolean;
  };
}

interface UpdateCampaignRequest {
  name?: string;
  subject?: string;
  content?: {
    html?: string;
    text?: string;
  };
}

interface PaginationParams {
  page: number;
  perPage: number;
}

interface Campaign {
  id: string;
  name: string;
  subject: string;
  status: string;
  userId: string;
  createdAt: Date;
  updatedAt: Date;
}

interface APIResponse<T> {
  success: boolean;
  data?: T;
  meta?: {
    pagination?: PaginationMeta;
  };
  error?: {
    message: string;
  };
}

interface PaginationMeta {
  page: number;
  perPage: number;
  total: number;
  totalPages: number;
}

// Mock service functions
async function createCampaign(
  data: CreateCampaignRequest,
  userId: string
): Promise<APIResponse<Campaign>> {
  // Mock implementation
  return mockDatabase.campaigns.create({ ...data, userId });
}

async function getCampaigns(
  userId: string,
  params: PaginationParams
): Promise<APIResponse<Campaign[]>> {
  // Mock implementation
  const campaigns = await mockDatabase.campaigns.findMany({ userId });
  return {
    success: true,
    data: campaigns,
    meta: {
      pagination: {
        page: params.page,
        perPage: params.perPage,
        total: campaigns.length,
        totalPages: Math.ceil(campaigns.length / params.perPage)
      }
    }
  };
}

async function updateCampaign(
  id: string,
  data: UpdateCampaignRequest,
  userId: string
): Promise<APIResponse<Campaign>> {
  const campaign = await mockDatabase.campaigns.findById(id);
  if (!campaign || campaign.userId !== userId) {
    throw new Error('Unauthorized');
  }

  const updated = await mockDatabase.campaigns.update(id, data);
  return { success: true, data: updated };
}


```

## End-to-End Testing Standards

```typescript
// tests/e2e/campaign-workflow.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Campaign Workflow E2E Tests', () => {
  test.beforeEach(async ({ page }) => {
    // Login before each test
    await page.goto('/login');
    await page.fill('[data-testid="email"]', 'test@example.com');
    await page.fill('[data-testid="password"]', 'testpass123');
    await page.click('[data-testid="login-button"]');

    // Wait for dashboard to load
    await expect(page.locator('[data-testid="dashboard-header"]')).toBeVisible();
  });

  test('complete campaign creation and sending workflow', async ({ page }) => {
    // Navigate to campaign creation
    await page.click('[data-testid="create-campaign"]');
    await expect(page.locator('[data-testid="campaign-editor"]')).toBeVisible();

    // Fill campaign details
    await page.fill('[data-testid="campaign-name"]', 'E2E Test Campaign');
    await page.fill('[data-testid="campaign-subject"]', 'E2E Test Subject Line');
    await page.fill('[data-testid="content-html"]', '<h1>E2E Test Campaign</h1><p>This is an end-to-end test.</p>');

    // Add recipients
    await page.click('[data-testid="add-recipient"]');
    await page.fill('[data-testid="recipient-email"]', 'e2e-test@example.com');
    await page.fill('[data-testid="recipient-name"]', 'E2E Test User');
    await page.click('[data-testid="save-recipient"]');

    // Configure settings
    await page.check('[data-testid="analytics-enabled"]');
    await page.check('[data-testid="track-opens"]');
    await page.check('[data-testid="track-clicks"]');

    // Save campaign
    await page.click('[data-testid="save-campaign"]');

    // Verify campaign was created
    await expect(page.locator('[data-testid="success-message"]')).toContainText('Campaign created successfully');

    // Navigate to campaign list
    await page.click('[data-testid="campaigns-nav"]');
    await expect(page.locator('[data-testid="campaign-list"]')).toBeVisible();

    // Verify campaign appears in list
    await expect(page.locator('text=E2E Test Campaign')).toBeVisible();

    // Send campaign
    await page.click('[data-testid="send-campaign"]');
    await page.click('[data-testid="confirm-send"]');

    // Verify send confirmation
    await expect(page.locator('[data-testid="send-confirmation"]')).toContainText('Campaign sent successfully');
  });

  test('AI optimization workflow', async ({ page }) => {
    // Navigate to campaign creation
    await page.click('[data-testid="create-campaign"]');

    // Fill basic campaign details
    await page.fill('[data-testid="campaign-name"]', 'AI Optimization Test');
    await page.fill('[data-testid="campaign-subject"]', 'Basic Subject Line');
    await page.fill('[data-testid="content-html"]', '<h1>AI Test Content</h1><p>Basic content for optimization.</p>');

    // Add recipient
    await page.click('[data-testid="add-recipient"]');
    await page.fill('[data-testid="recipient-email"]', 'ai-test@example.com');
    await page.fill('[data-testid="recipient-name"]', 'AI Test User');
    await page.click('[data-testid="save-recipient"]');

    // Enable AI optimization
    await page.check('[data-testid="ai-optimization"]');

    // Trigger AI optimization
    await page.click('[data-testid="optimize-with-ai"]');

    // Verify optimization progress
    await expect(page.locator('[data-testid="optimization-loading"]')).toBeVisible();

    // Wait for optimization to complete
    await expect(page.locator('[data-testid="optimization-complete"]')).toBeVisible();

    // Verify optimized content
    const optimizedSubject = await page.inputValue('[data-testid="campaign-subject"]');
    const optimizedContent = await page.inputValue('[data-testid="content-html"]');

    expect(optimizedSubject).not.toBe('Basic Subject Line');
    expect(optimizedContent).not.toBe('<h1>AI Test Content</h1><p>Basic content for optimization.</p>');

    // Verify optimization score display
    await expect(page.locator('[data-testid="optimization-score"]')).toBeVisible();
    const scoreText = await page.textContent('[data-testid="optimization-score"]');
    expect(scoreText).toMatch(/\d+% improvement/);
  });

  test('mobile responsive campaign creation', async ({ page }) => {
    // Set mobile viewport
    await page.setViewportSize({ width: 375, height: 667 });

    // Navigate to campaign creation
    await page.click('[data-testid="mobile-menu"]');
    await page.click('[data-testid="create-campaign-mobile"]');

    // Verify mobile editor layout
    await expect(page.locator('[data-testid="mobile-editor"]')).toBeVisible();

    // Test mobile form interaction
    await page.fill('[data-testid="campaign-name-mobile"]', 'Mobile Test Campaign');
    await page.fill('[data-testid="campaign-subject-mobile"]', 'Mobile Test Subject');
    await page.fill('[data-testid="content-text-mobile"]', 'Mobile test content');

    // Add recipient on mobile
    await page.click('[data-testid="add-recipient-mobile"]');
    await page.fill('[data-testid="recipient-email-mobile"]', 'mobile-test@example.com');
    await page.click('[data-testid="save-recipient-mobile"]');

    // Save campaign on mobile
    await page.click('[data-testid="save-campaign-mobile"]');

    // Verify success on mobile
    await expect(page.locator('[data-testid="mobile-success"]')).toContainText('Campaign created');
  });
});


```

## Testing Best Practices

### Unit Testing Guidelines

1. **Test Isolation**: Each test should be independent

2. **Arrange-Act-Assert**: Clear test structure

3. **Mock External Dependencies**: Use mocks for external services

4. **Test Edge Cases**: Cover boundary conditions

5. **Descriptive Test Names**: Test names should describe what is being tested

### Integration Testing Guidelines

1. **Test Real Dependencies**: Use actual databases and services

2. **Clean State**: Reset database state between tests

3. **Error Handling**: Test failure scenarios

4. **Performance**: Test response times and scalability

### E2E Testing Guidelines

1. **User Journey Focus**: Test complete user workflows

2. **Realistic Data**: Use realistic test data

3. **Cross-Browser**: Test in multiple browsers

4. **Mobile Testing**: Test mobile responsiveness

5. **Performance**: Monitor page load times

### Test Data Management

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
    {
      email: 'test@example.com',
      personalization: { name: 'Test User' }
    }
  ],
  settings: {
    analyticsEnabled: true,
    trackOpens: true,
    trackClicks: true,
    aiOptimization: false
  }
};

// Generate bulk recipient data for testing
export function createBulkRecipients(count: number = 250): BulkRecipients {
  return Array.from({ length: count }, (_, i) => ({
    email: `user${i + 1}@example.com`,
    personalization: {
      name: `User ${i + 1}`,
      company: `Company ${i + 1}`
    }
  }));
}

// Invalid recipient data for negative testing
export const invalidRecipientData: CampaignData = {
  name: 'Invalid Campaign',
  subject: 'Test Subject',
  content: { html: '<p>Test</p>', text: 'Test' },
  recipients: [
    { email: 'invalid-email' }, // Invalid email format
    { name: 'No Email User' }, // Missing email
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
      html: `<h1>Welcome {{name}}!</h1><p>We're excited to have you on board.</p>`,
      text: 'Welcome {{name}}! We\'re excited to have you on board.'
    },
    recipients: [
      {
        email: 'newuser@example.com',
        personalization: { name: 'New User' }
      }
    ]
  },

  // Promotional email campaign
  promotionalCampaign: {
    name: 'Black Friday Sale',
    subject: 'Limited Time: 50% Off Everything!',
    content: {
      html: `<h1>Black Friday Sale!</h1><p>Get 50% off all products. Use code: BLACKFRIDAY</p>`,
      text: 'Black Friday Sale! Get 50% off all products. Use code: BLACKFRIDAY'
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

// Test data generators
export class TestDataGenerator {
  static generateRecipients(count: number): RecipientData[] {
    return Array.from({ length: count }, (_, i) => ({
      email: `test${i + 1}@example.com`,
      personalization: {
        name: `Test User ${i + 1}`,
        company: `Test Company ${i + 1}`,
        role: `Role ${i + 1}`
      }
    }));
  }

  static generateCampaignName(index: number): string {
    const prefixes = ['Test', 'Demo', 'Sample', 'Example', 'Mock'];
    const suffixes = ['Campaign', 'Email', 'Newsletter', 'Update', 'Alert'];

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
          html: '<h1>Special Offer!</h1><p>Get 25% off your next purchase.</p>',
          text: 'Special Offer! Get 25% off your next purchase.'
        };
      case 'newsletter':
        return {
          html: '<h1>Weekly Update</h1><p>Here are this week\'s updates.</p>',
          text: 'Weekly Update - Here are this week\'s updates.'
        };
    }
  }
}

// Test fixtures for Vitest
export const testFixtures = {
  // Basic campaign fixture
  sampleCampaign: () => sampleCampaignData,

  // Bulk recipients fixture
  bulkRecipients: (count = 250) => createBulkRecipients(count),

  // Invalid data fixture
  invalidData: () => invalidRecipientData,

  // Template fixtures
  welcomeTemplate: () => campaignTemplates.welcomeCampaign,
  promotionalTemplate: () => campaignTemplates.promotionalCampaign,
  newsletterTemplate: () => campaignTemplates.newsletterCampaign,

  // Generator fixtures
  generateRecipients: (count: number) => TestDataGenerator.generateRecipients(count),
  generateCampaignName: (index: number) => TestDataGenerator.generateCampaignName(index)
};

// Export commonly used test constants
export const TEST_CONSTANTS = {
  VALID_EMAIL: 'test@example.com',
  INVALID_EMAIL: 'invalid-email',
  EMPTY_EMAIL: '',
  MAX_RECIPIENTS: 10000,
  BATCH_SIZE: 100,
  CAMPAIGN_NAME_MAX_LENGTH: 255,
  SUBJECT_LINE_MAX_LENGTH: 100,
  EMAIL_CONTENT_MAX_LENGTH: 50000
};

// Validation test cases
export const validationTestCases = {
  validEmails: [
    'user@example.com',
    'test.user@company.co.uk',
    'name+tag@domain.com',
    'user123@test-domain.org'
  ],

  invalidEmails: [
    'invalid-email',
    '@domain.com',
    'user@',
    'user..double.dot@example.com',
    'user@domain',
    'user@.domain.com',
    'user@domain..com'
  ],

  edgeCaseNames: [
    '', // Empty name
    'A', // Single character
    'a'.repeat(256), // Too long
    'Campaign with "quotes"',
    'Campaign with \'single quotes\'',
    'Campaign with <script>tags</script>',
    'Campaign with newline\nbreak',
    'Campaign with special chars: !@#$%^&*()'
  ]
};

// Usage example in tests:
// import { testFixtures, TEST_CONSTANTS, validationTestCases } from './sample-campaigns';
//
// describe('Campaign Validation', () => {
//   it('should validate email addresses correctly', () => {
//     validationTestCases.validEmails.forEach(email => {
//       expect(isValidEmail(email)).toBe(true);
//     });
//
//     validationTestCases.invalidEmails.forEach(email => {
//       expect(isValidEmail(email)).toBe(false);
//     });
//   });
// });


```

## Running Tests

```bash


# Run all tests

npm test


# Run unit tests only

npm run test:unit


# Run integration tests only

npm run test:integration


# Run E2E tests only

npm run test:e2e


# Run tests with coverage

npm run test:coverage


# Run specific test file

npm test -- --grep "test_send_email_success"


# Run tests in watch mode

npm run test:watch


# Run E2E tests with UI

npm run test:e2e:ui


# Run tests on CI

npm run test:ci


```

For code style and quality standards, see [`code-standards.md`](code-standards).
For documentation testing requirements, see [`documentation-contributions.md`](documentation-contributions).
