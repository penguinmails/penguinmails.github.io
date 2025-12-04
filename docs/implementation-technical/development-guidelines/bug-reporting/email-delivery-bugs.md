---
title: "Email Delivery Bug Patterns"
description: "Common email delivery issues and their solutions"
last_modified_date: "2025-12-04"
level: "3"
persona: "Quality Assurance"
keywords: "email delivery, SMTP, bounce handling, email debugging"
---

# Email Delivery Bug Patterns

## Common Bug Patterns

### Email Delivery Issues

**Problem**: Emails not being sent to certain recipients

```typescript
// services/bounce-handler.ts
interface BounceData {
  email: string;
  status: 'bounced' | 'delivered' | 'failed';
  type?: 'hard' | 'soft' | 'unknown';
  reason?: string;
  timestamp: string;
}

interface BounceHandler {
  handleEmailBounce(bounceData: BounceData): Promise<void>;
}

class BounceHandlerImpl implements BounceHandler {
  async handleEmailBounce(bounceData: BounceData): Promise<void> {
    if (bounceData.status === 'bounced') {
      await this.processBounce(bounceData);
    }
  }

  private async processBounce(bounceData: BounceData): Promise<void> {
    const bounceType = bounceData.type || 'hard';

    switch (bounceType) {
      case 'hard':
        // Hard bounce - permanent failure
        await this.permanentlyBounceEmail(bounceData.email, bounceData.reason);
        break;
      case 'soft':
        // Soft bounce - temporary failure, retry later
        await this.scheduleRetry(bounceData.email, bounceData.reason);
        break;
      default:
        // Unknown bounce type - manual review
        await this.flagForReview(bounceData.email, bounceData.reason);
        break;
    }
  }

  private async permanentlyBounceEmail(email: string, reason?: string): Promise<void> {
    console.log(`Permanently bouncing email ${email} - Reason: ${reason || 'No reason provided'}`);

    // Update database to mark as permanently failed
    await this.updateEmailStatus(email, 'permanently_bounced', reason);

    // Add to suppression list
    await this.addToSuppressionList(email, reason || 'Permanent bounce');
  }

  private async scheduleRetry(email: string, reason?: string): Promise<void> {
    console.log(`Scheduling retry for email ${email} - Reason: ${reason || 'Temporary failure'}`);

    // Schedule retry in 1 hour
    const retryTime = new Date(Date.now() + 60 * 60 * 1000);
    await this.scheduleEmailRetry(email, retryTime, reason);
  }

  private async flagForReview(email: string, reason?: string): Promise<void> {
    console.log(`Flagging email ${email} for manual review - Reason: ${reason || 'Unknown bounce type'}`);

    // Create review task
    await this.createReviewTask({
      email,
      reason: reason || 'Unknown bounce type',
      priority: 'medium',
      type: 'bounce_review'
    });
  }

  private async updateEmailStatus(email: string, status: string, reason?: string): Promise<void> {
    // Mock implementation - would update database
    console.log(`Updating email status: ${email} -> ${status} (${reason})`);
  }

  private async addToSuppressionList(email: string, reason: string): Promise<void> {
    // Mock implementation - would add to suppression list
    console.log(`Adding ${email} to suppression list: ${reason}`);
  }

  private async scheduleEmailRetry(email: string, retryTime: Date, reason?: string): Promise<void> {
    // Mock implementation - would schedule retry task
    console.log(`Scheduling retry for ${email} at ${retryTime.toISOString()}`);
  }

  private async createReviewTask(taskData: {
    email: string;
    reason: string;
    priority: 'low' | 'medium' | 'high';
    type: string;
  }): Promise<void> {
    // Mock implementation - would create review task
    console.log(`Creating review task for ${taskData.email}: ${taskData.reason}`);
  }
}

// Usage example
const bounceHandler = new BounceHandlerImpl();

// Example bounce scenarios
const bounceScenarios = [
  {
    email: 'user1@example.com',
    status: 'bounced' as const,
    type: 'hard' as const,
    reason: 'User does not exist',
    timestamp: new Date().toISOString()
  },
  {
    email: 'user2@example.com',
    status: 'bounced' as const,
    type: 'soft' as const,
    reason: 'Mailbox full',
    timestamp: new Date().toISOString()
  },
  {
    email: 'user3@example.com',
    status: 'bounced' as const,
    type: undefined,
    reason: 'Unknown error',
    timestamp: new Date().toISOString()
  }
];

async function demonstrateBounceHandling() {
  for (const bounceData of bounceScenarios) {
    await bounceHandler.handleEmailBounce(bounceData);
  }
}

```

**Problem**: Campaign tracking not working

```typescript
// services/email-tracking-service.ts
import { DatabaseError } from '../errors/database-error';

interface EmailTrackingData {
  campaignId: string;
  recipientEmail: string;
  openedAt: Date;
  userAgent?: string;
  ipAddress?: string;
}

interface TrackingResult {
  success: boolean;
  message: string;
  isDuplicate?: boolean;
}

interface EmailTrackingService {
  trackEmailOpen(data: EmailTrackingData): Promise<TrackingResult>;
  trackEmailClick(data: EmailClickData): Promise<TrackingResult>;
  getOpenStats(campaignId: string): Promise<OpenStats>;
}

interface EmailClickData {
  campaignId: string;
  recipientEmail: string;
  clickedAt: Date;
  url: string;
}

interface OpenStats {
  totalOpens: number;
  uniqueOpens: number;
  duplicateOpens: number;
  openRate: number;
}

class EmailTrackingServiceImpl implements EmailTrackingService {
  async trackEmailOpen(data: EmailTrackingData): Promise<TrackingResult> {
    try {
      // Validate input data
      this.validateTrackingData(data);

      // Attempt to insert tracking record
      await this.insertOpenRecord(data);

      return {
        success: true,
        message: 'Email open tracked successfully'
      };
    } catch (error) {
      return this.handleTrackingError(error, data);
    }
  }

  async trackEmailClick(data: EmailClickData): Promise<TrackingResult> {
    try {
      // Validate input data
      this.validateClickData(data);

      // Attempt to insert click record
      await this.insertClickRecord(data);

      return {
        success: true,
        message: 'Email click tracked successfully'
      };
    } catch (error) {
      return this.handleTrackingError(error, data);
    }
  }

  async getOpenStats(campaignId: string): Promise<OpenStats> {
    try {
      const stats = await this.calculateOpenStats(campaignId);
      return stats;
    } catch (error) {
      throw new DatabaseError(`Failed to get open stats for campaign ${campaignId}`);
    }
  }

  private validateTrackingData(data: EmailTrackingData): void {
    if (!data.campaignId) {
      throw new Error('Campaign ID is required');
    }
    if (!data.recipientEmail) {
      throw new Error('Recipient email is required');
    }
    if (!data.openedAt) {
      throw new Error('Opened timestamp is required');
    }
  }

  private validateClickData(data: EmailClickData): void {
    this.validateTrackingData({
      campaignId: data.campaignId,
      recipientEmail: data.recipientEmail,
      openedAt: data.clickedAt
    });
    if (!data.url) {
      throw new Error('URL is required for click tracking');
    }
  }

  private async insertOpenRecord(data: EmailTrackingData): Promise<void> {
    // Mock implementation - would insert into database
    console.log('Inserting open record:', data);

    // Simulate potential duplicate
    if (data.recipientEmail.includes('duplicate')) {
      throw new Error('Duplicate tracking attempt');
    }
  }

  private async insertClickRecord(data: EmailClickData): Promise<void> {
    // Mock implementation - would insert click record
    console.log('Inserting click record:', data);
  }

  private async calculateOpenStats(campaignId: string): Promise<OpenStats> {
    // Mock implementation - would calculate from database
    return {
      totalOpens: 150,
      uniqueOpens: 120,
      duplicateOpens: 30,
      openRate: 0.12
    };
  }

  private async handleTrackingError(error: unknown, data: EmailTrackingData): Promise<TrackingResult> {
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';

    if (errorMessage.includes('Duplicate tracking attempt')) {
      // Handle duplicate tracking gracefully
      console.info(`Duplicate tracking attempt for ${data.campaignId}:${data.recipientEmail}`);

      return {
        success: true,
        message: 'Email open already tracked',
        isDuplicate: true
      };
    } else if (errorMessage.includes('constraint') || errorMessage.includes('unique')) {
      // Database constraint violation
      console.info(`Constraint violation for ${data.campaignId}:${data.recipientEmail}`);

      return {
        success: true,
        message: 'Email interaction already tracked',
        isDuplicate: true
      };
    } else {
      // General error
      console.error(`Failed to track email interaction: ${errorMessage}`);

      // Could send to monitoring system here
      await this.sendToMonitoringSystem({
        campaignId: data.campaignId,
        recipientEmail: data.recipientEmail,
        error: errorMessage,
        timestamp: new Date().toISOString()
      });

      return {
        success: false,
        message: 'Failed to track email interaction'
      };
    }
  }

  private async sendToMonitoringSystem(monitoringData: {
    campaignId: string;
    recipientEmail: string;
    error: string;
    timestamp: string;
  }): Promise<void> {
    // Mock implementation - would send to monitoring system
    console.log('Sending to monitoring system:', monitoringData);
  }
}

// Usage example
const trackingService = new EmailTrackingServiceImpl();

async function demonstrateEmailTracking() {
  // Test successful tracking
  const openData: EmailTrackingData = {
    campaignId: 'campaign_123',
    recipientEmail: 'user@example.com',
    openedAt: new Date(),
    userAgent: 'Mozilla/5.0...',
    ipAddress: '192.168.1.1'
  };

  const result1 = await trackingService.trackEmailOpen(openData);
  console.log('Tracking result 1:', result1);

  // Test duplicate handling
  const duplicateData: EmailTrackingData = {
    ...openData,
    recipientEmail: 'duplicate@example.com'
  };

  const result2 = await trackingService.trackEmailOpen(duplicateData);
  console.log('Tracking result 2:', result2);
}

```

