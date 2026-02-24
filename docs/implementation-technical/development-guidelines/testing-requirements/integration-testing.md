---
title: "Testing Guide - Integration Testing"
description: "Integration testing standards for APIs and database interactions."
last_modified_date: "2026-02-24"
level: "2"
persona: "Quality Assurance"
---

# Testing Guide - Integration Testing

### Integration Testing Standards

Integration tests verify that different components of the system work together correctly, particularly the interaction between APIs and the database.

#### **Campaign API Integration Tests**

```typescript
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
        name: 'Integration Test Campaign',
        subject: 'Test Subject Line',
        content: {
          html: '<h1>Test Campaign</h1><p>This is an integration test campaign.</p>',
          text: 'Integration Test Campaign - This is an integration test campaign.'
        },
        recipients: [{ email: 'recipient@example.com' }]
      };

      // Mock database success
      mockDatabase.campaigns.create.mockResolvedValue({
        id: 'camp_123',
        ...campaignData,
        status: 'draft',
        createdAt: new Date()
      });

      // Act
      const result = await createCampaign(campaignData, testUser.id);

      // Assert
      expect(result.success).toBe(true);
      expect(result.data.name).toBe(campaignData.name);
      expect(result.data.subject).toBe(campaignData.subject);
      expect(result.data.status).toBe('draft');
      expect(result.data.id).toBeDefined();
    });

    it('should reject campaign creation with invalid data', async () => {
      // Arrange
      const invalidData = {
        name: '', // Empty name
        subject: 'Test Subject',
        content: { html: '<p>Test</p>', text: 'Test' },
        recipients: []
      };

      // Act & Assert
      await expect(createCampaign(invalidData as any, testUser.id))
        .rejects.toThrow('Campaign name is required');
    });
  });

  describe('Campaign Listing', () => {
    beforeEach(async () => {
      // Create multiple campaigns for testing
      const campaigns = Array.from({ length: 5 }, (_, i) => ({
        id: `camp_${i}`,
        name: `Test Campaign ${i + 1}`,
        subject: `Subject ${i + 1}`,
        status: 'draft' as const,
        createdAt: new Date(),
        updatedAt: new Date(),
        userId: testUser.id
      }));

      mockDatabase.campaigns.findMany.mockResolvedValue(campaigns);
    });

    it('should list campaigns with pagination', async () => {
      // Arrange
      const paginationParams = { page: 1, perPage: 3 };

      // Act
      const result = await getCampaigns(testUser.id, paginationParams);

      // Assert
      expect(result.success).toBe(true);
      expect(result.data).toHaveLength(5); // In integration, it might return all or filtered depending on mock
      expect(mockDatabase.campaigns.findMany).toHaveBeenCalledWith(expect.objectContaining({
        take: 3,
        skip: 0
      }));
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
      
      const existingCampaign = { id: campaignId, userId: testUser.id };
      mockDatabase.campaigns.findById.mockResolvedValue(existingCampaign);
      mockDatabase.campaigns.update.mockResolvedValue({ ...existingCampaign, ...updateData });

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
```

### Integration Testing Guidelines

1. **Database Cleanliness**: Ensure each test starts with a clean database state or uses transactions that are rolled back.
2. **API Parity**: Integration tests should use the same request/response contracts used in production.
3. **External Service Virtualization**: Use WireMock or similar tools to virtualize external API dependencies.
4. **Environment Isolation**: Run integration tests in an environment that matches production as closely as possible.
5. **Contract Verification**: Verify that the database schema matches the expectations of the integration tests.
