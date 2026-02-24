---
title: "Testing Guide - End-to-End Testing"
description: "End-to-End testing standards using Playwright for critical user workflows."
last_modified_date: "2026-02-24"
level: "2"
persona: "Quality Assurance"
---

# Testing Guide - End-to-End Testing

### End-to-End (E2E) Testing Standards

E2E tests verify the entire application stack from the user's perspective, covering critical workflows across different browsers and devices.

#### **Campaign Workflow E2E Tests**

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
    await page.fill('[data-testid="campaign-subject"]', 'Subject for E2E Test');
    
    // Switch to recipients tab and add recipient
    await page.click('[data-testid="tab-recipients"]');
    await page.fill('[data-testid="recipient-email"]', 'e2e-recipient@example.com');
    await page.click('[data-testid="add-recipient"]');

    // Save campaign
    await page.click('[data-testid="save-campaign"]');
    await expect(page.locator('text=Campaign saved successfully')).toBeVisible();

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
    
    // Trigger AI optimization
    await page.click('[data-testid="ai-optimize"]');
    
    // Wait for AI processing
    await expect(page.locator('[data-testid="ai-loading"]')).not.toBeVisible({ timeout: 10000 });

    // Verify optimized content
    const optimizedSubject = await page.inputValue('[data-testid="campaign-subject"]');
    expect(optimizedSubject).not.toBe('Basic Subject Line');

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

    // Verify mobile layout
    await expect(page.locator('[data-testid="campaign-editor-mobile"]')).toBeVisible();

    // Fill basic details
    await page.fill('[data-testid="campaign-name"]', 'Mobile Campaign');

    // Save campaign on mobile
    await page.click('[data-testid="save-campaign-mobile"]');

    // Verify success on mobile
    await expect(page.locator('[data-testid="mobile-success"]')).toContainText('Campaign created');
  });
});
```

### E2E Testing Guidelines

1. **Test User Journeys**: Focus on high-value user paths through the application.
2. **Data-Test-IDs**: Use stable `data-testid` attributes for selecting elements instead of styles or text.
3. **Flakiness Avoidance**: Use automatic waiting and avoid hard `sleep` or `timeout` calls.
4. **Cross-Browser Verification**: Run E2E tests on Chromium, Firefox, and WebKit.
5. **Mobile Simulation**: Test responsive layouts and mobile-specific interactions.
6. **Performance**: Monitor page load times and core web vitals during E2E runs.
