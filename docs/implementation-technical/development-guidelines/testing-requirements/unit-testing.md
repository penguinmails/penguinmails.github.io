---
title: "Testing Guide - Unit Testing"
description: "Unit testing standards and detailed examples for core services."
last_modified_date: "2026-02-24"
level: "2"
persona: "Quality Assurance"
---

# Testing Guide - Unit Testing

### Unit Testing Standards

Unit tests focus on individual functions and services in isolation. Mocking is used for all external dependencies to ensure tests are fast and deterministic.

#### **EmailService** - Core Service Unit Test

```typescript
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

  beforeEach(() => {
    mockSmtpClient = { sendEmail: vi.fn(), sendEmailBatch: vi.fn() } as any;
    mockTemplateService = { render: vi.fn() } as any;
    mockAnalyticsService = { trackDelivery: vi.fn() } as any;

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
    };
    const expectedMessageId = 'msg_12345';
    mockSmtpClient.sendEmail.mockResolvedValue({ messageId: expectedMessageId });

    // Act
    const result = await emailService.sendEmail(emailData);

    // Assert
    expect(result.messageId).toBe(expectedMessageId);
    expect(mockSmtpClient.sendEmail).toHaveBeenCalledTimes(1);

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
      content: { html: '<p>Test content</p>', text: 'Test content' }
    };

    // Act & Assert
    const error = await emailService.sendEmail(emailData).catch(e => e);
    expect(error).toBeInstanceOf(ValidationError);
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

    mockSmtpClient.sendEmailBatch.mockResolvedValue({ success: true });

    // Act
    await emailService.sendBulkEmail(recipients, 'Test Template');

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
    mockSmtpClient.sendEmail.mockRejectedValue(new Error('SMTP connection error'));

    // Act & Assert
    await expect(emailService.sendEmail(emailData)).rejects.toThrow('SMTP connection error');
  });
});
```

### Unit Testing Guidelines

1. **Test Isolation**: Each test should be independent and not rely on the state of other tests.
2. **Arrange-Act-Assert**: Use the triple-A pattern for clear test structure.
3. **Mock External Dependencies**: Use mocks for all database, file system, and network operations.
4. **Boundary Testing**: Explicitly test edge cases and error conditions.
5. **Code Coverage**: Aim for >80% code coverage on core business logic.
