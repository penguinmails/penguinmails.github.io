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

```
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

```python
# tests/unit/test_email_service.py
import pytest
from unittest.mock import Mock, patch, MagicMock
from datetime import datetime, timezone
from app.services.email_service import EmailService
from app.models.email import EmailMessage, EmailStatus
from app.exceptions import EmailDeliveryError, ValidationError

class TestEmailService:
    """Comprehensive unit tests for EmailService."""

    def setup_method(self):
        """Set up test fixtures before each test method."""
        self.mock_smtp_client = Mock()
        self.mock_template_service = Mock()
        self.mock_analytics_service = Mock()
        self.mock_database = Mock()

        self.email_service = EmailService(
            smtp_client=self.mock_smtp_client,
            template_service=self.mock_template_service,
            analytics_service=self.mock_analytics_service,
            database=self.mock_database
        )

    def test_send_email_success(self):
        """Test successful email sending."""
        # Arrange
        email_data = {
            'to': 'test@example.com',
            'subject': 'Test Subject',
            'content': {'html': '<p>Test content</p>', 'text': 'Test content'},
            'from': {'name': 'Test Sender', 'email': 'sender@example.com'}
        }

        expected_message_id = 'msg_123456'
        self.mock_smtp_client.send_email.return_value = {
            'message_id': expected_message_id,
            'status': 'sent'
        }

        # Act
        result = self.email_service.send_email(email_data)

        # Assert
        assert result.message_id == expected_message_id
        assert result.status == EmailStatus.SENT
        assert result.sent_at is not None

        # Verify method calls
        self.mock_smtp_client.send_email.assert_called_once()
        self.mock_analytics_service.track_delivery.assert_called_once()

        # Verify analytics tracking data
        delivery_call = self.mock_analytics_service.track_delivery.call_args
        assert delivery_call[1]['email'] == email_data['to']
        assert delivery_call[1]['message_id'] == expected_message_id

    def test_send_email_invalid_recipient(self):
        """Test email sending with invalid recipient email."""
        # Arrange
        email_data = {
            'to': 'invalid-email',  # Invalid email format
            'subject': 'Test Subject',
            'content': {'html': '<p>Test</p>', 'text': 'Test'}
        }

        # Act & Assert
        with pytest.raises(ValidationError) as exc_info:
            self.email_service.send_email(email_data)

        assert 'invalid email' in str(exc_info.value).lower()

        # Verify no external services were called
        self.mock_smtp_client.send_email.assert_not_called()
        self.mock_analytics_service.track_delivery.assert_not_called()

    def test_send_bulk_emails_batch_processing(self):
        """Test bulk email sending with proper batch processing."""
        # Arrange
        recipients = [
            {'email': f'user{i}@example.com', 'name': f'User {i}'}
            for i in range(250)  # Test with more than default batch size
        ]

        email_data = {
            'subject': 'Bulk Test Email',
            'content': {'html': '<p>Bulk content</p>', 'text': 'Bulk content'}
        }

        self.mock_smtp_client.send_email_batch.return_value = [
            {'message_id': f'msg_{i}', 'status': 'sent'} for i in range(250)
        ]

        # Act
        results = self.email_service.send_bulk_emails(recipients, email_data)

        # Assert
        assert len(results) == 250
        assert all(result.status == EmailStatus.SENT for result in results)

        # Verify batch processing
        expected_batches = (250 + 99) // 100  # Assuming batch size of 100
        assert self.mock_smtp_client.send_email_batch.call_count == expected_batches
```

## Integration Testing Standards

```python
# tests/integration/test_campaign_api.py
import pytest
import asyncio
from httpx import AsyncClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.main import app
from app.database.connection import get_database
from app.models.campaign import Campaign
from app.models.user import User

@pytest.fixture
async def test_client():
    """Create test client with test database."""
    # Setup test database
    engine = create_engine("postgresql://test:test@localhost/testdb")
    TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

    # Create tables
    from app.database.models import Base
    Base.metadata.create_all(bind=engine)

    # Override database dependency
    def get_test_database():
        try:
            db = TestingSessionLocal()
            yield db
        finally:
            db.close()

    app.dependency_overrides[get_database] = get_test_database

    async with AsyncClient(app=app, base_url="http://testserver") as client:
        yield client

    # Cleanup
    Base.metadata.drop_all(bind=engine)

@pytest.fixture
async def test_user(test_client):
    """Create test user for authentication."""
    user_data = {
        "email": "test@example.com",
        "password": "testpass123",
        "first_name": "Test",
        "last_name": "User"
    }

    response = await test_client.post("/api/v1/auth/register", json=user_data)
    assert response.status_code == 201

    # Login to get token
    login_response = await test_client.post("/api/v1/auth/login", json={
        "email": user_data["email"],
        "password": user_data["password"]
    })

    token = login_response.json()["data"]["access_token"]
    return {"token": token, "user_id": login_response.json()["data"]["user"]["id"]}

@pytest.mark.asyncio
class TestCampaignAPI:
    """Integration tests for Campaign API endpoints."""

    async def test_create_campaign_success(self, test_client, test_user):
        """Test successful campaign creation."""
        campaign_data = {
            "name": "Test Campaign",
            "subject": "Test Subject Line",
            "content": {
                "html": "<h1>Test Campaign</h1><p>This is a test campaign.</p>",
                "text": "Test Campaign - This is a test campaign."
            },
            "recipients": [
                {
                    "email": "recipient@example.com",
                    "personalization": {"name": "Test Recipient"}
                }
            ],
            "settings": {
                "analytics_enabled": True,
                "track_opens": True,
                "track_clicks": True,
                "ai_optimization": False
            }
        }

        headers = {"Authorization": f"Bearer {test_user['token']}"}

        response = await test_client.post(
            "/api/v1/campaigns",
            json=campaign_data,
            headers=headers
        )

        assert response.status_code == 201
        data = response.json()

        assert data["success"] is True
        assert "data" in data
        assert data["data"]["name"] == campaign_data["name"]
        assert data["data"]["subject"] == campaign_data["subject"]
        assert data["data"]["status"] == "draft"
        assert "id" in data["data"]
        assert "created_at" in data["data"]

        # Verify campaign metrics are initialized
        assert "metrics" in data["data"]
        assert data["data"]["metrics"]["sent"] == 0

    async def test_create_campaign_duplicate_name(self, test_client, test_user):
        """Test campaign creation with duplicate name."""
        campaign_data = {
            "name": "Duplicate Name Test",
            "subject": "Test Subject",
            "content": {"html": "<p>Test</p>", "text": "Test"},
            "recipients": [{"email": "test@example.com"}]
        }

        headers = {"Authorization": f"Bearer {test_user['token']}"}

        # Create first campaign
        response1 = await test_client.post(
            "/api/v1/campaigns",
            json=campaign_data,
            headers=headers
        )
        assert response1.status_code == 201

        # Try to create second campaign with same name
        response2 = await test_client.post(
            "/api/v1/campaigns",
            json=campaign_data,
            headers=headers
        )
        assert response2.status_code == 409
        assert "duplicate" in response2.json()["error"]["message"].lower()

    async def test_list_campaigns_pagination(self, test_client, test_user):
        """Test campaign listing with pagination."""
        # Create multiple campaigns
        headers = {"Authorization": f"Bearer {test_user['token']}"}

        campaigns_to_create = 5
        for i in range(campaigns_to_create):
            campaign_data = {
                "name": f"Test Campaign {i+1}",
                "subject": f"Test Subject {i+1}",
                "content": {"html": f"<p>Campaign {i+1}</p>", "text": f"Campaign {i+1}"},
                "recipients": [{"email": f"test{i+1}@example.com"}]
            }

            await test_client.post(
                "/api/v1/campaigns",
                json=campaign_data,
                headers=headers
            )

        # Test pagination
        response = await test_client.get(
            "/api/v1/campaigns?page=1&per_page=3",
            headers=headers
        )

        assert response.status_code == 200
        data = response.json()

        assert len(data["data"]) == 3
        assert data["meta"]["pagination"]["page"] == 1
        assert data["meta"]["pagination"]["per_page"] == 3
        assert data["meta"]["pagination"]["total"] == 5

        # Test second page
        response2 = await test_client.get(
            "/api/v1/campaigns?page=2&per_page=3",
            headers=headers
        )

        data2 = response2.json()
        assert len(data2["data"]) == 2  # Remaining campaigns
        assert data2["meta"]["pagination"]["page"] == 2
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

```python
# tests/fixtures/sample_campaigns.py
import pytest
from datetime import datetime
from typing import List, Dict

@pytest.fixture
def sample_campaign_data() -> Dict:
    """Basic campaign data for testing."""
    return {
        "name": "Test Campaign",
        "subject": "Test Subject Line",
        "content": {
            "html": "<h1>Test Campaign</h1><p>This is a test campaign.</p>",
            "text": "Test Campaign - This is a test campaign."
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
            "track_clicks": True,
            "ai_optimization": False
        }
    }

@pytest.fixture
def bulk_recipients() -> List[Dict]:
    """Generate bulk recipient data for testing."""
    return [
        {
            "email": f"user{i}@example.com",
            "personalization": {"name": f"User {i}"}
        }
        for i in range(1, 251)  # 250 recipients
    ]

@pytest.fixture
def invalid_recipient_data() -> Dict:
    """Invalid recipient data for negative testing."""
    return {
        "name": "Invalid Campaign",
        "subject": "Test Subject",
        "content": {"html": "<p>Test</p>", "text": "Test"},
        "recipients": [
            {"email": "invalid-email"},  # Invalid email
            {"name": "No Email User"},  # Missing email
            {"email": ""}  # Empty email
        ]
    }
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