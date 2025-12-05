---
title: "Database Bug Patterns"
description: "Database performance and consistency issues"
last_modified_date: "2025-12-04"
level: "3"
persona: "Quality Assurance"
keywords: "database debugging, SQL, query optimization, data consistency"
---

# Database Bug Patterns

### Database Issues

**Problem**: N+1 query problem

```typescript
// services/campaign-query-service.ts
import { Database, Table } from '../database/connection';

interface Campaign {
  id: string;
  userId: string;
  subject: string;
  content: string;
  recipients?: Recipient[];
  createdAt: Date;
  updatedAt: Date;
}

interface Recipient {
  id: string;
  campaignId: string;
  email: string;
  name?: string;
  status: 'pending' | 'sent' | 'failed';
}

interface CampaignQueryService {
  getCampaignsWithRecipients(userId: string): Promise<Campaign[]>;
  getCampaignWithRecipients(campaignId: string): Promise<Campaign | null>;
  getCampaignsWithRecipientStats(userId: string): Promise<CampaignStats[]>;
}

interface CampaignStats {
  id: string;
  subject: string;
  totalRecipients: number;
  sentCount: number;
  failedCount: number;
  pendingCount: number;
}

class CampaignQueryServiceImpl implements CampaignQueryService {
  constructor(private db: Database) {}

  async getCampaignsWithRecipients(userId: string): Promise<Campaign[]> {
    // âŒ Bad: N+1 query problem - DO NOT USE
    // const campaigns = await this.db.campaigns.where('userId', '=', userId).findMany();
    // for (const campaign of campaigns) {
    //   campaign.recipients = await this.db.recipients.where('campaignId', '=', campaign.id).findMany();
    // }
    // return campaigns;

    // âœ… Good: Eager loading with single query
    const query = this.db.campaigns
      .where('userId', '=', userId)
      .join('recipients', 'campaignId', 'id')
      .select(`
        campaigns.*,
        recipients.id as recipient_id,
        recipients.email as recipient_email,
        recipients.name as recipient_name,
        recipients.status as recipient_status
      `);

    const results = await query.findMany();

    // Group results by campaign
    const campaignMap = new Map<string, Campaign>();

    for (const row of results) {
      const campaignId = row.id;

      if (!campaignMap.has(campaignId)) {
        campaignMap.set(campaignId, {
          id: row.id,
          userId: row.userId,
          subject: row.subject,
          content: row.content,
          recipients: [],
          createdAt: row.createdAt,
          updatedAt: row.updatedAt
        });
      }

      const campaign = campaignMap.get(campaignId)!;

      // Add recipient if exists
      if (row.recipient_id) {
        campaign.recipients!.push({
          id: row.recipient_id,
          campaignId,
          email: row.recipient_email,
          name: row.recipient_name,
          status: row.recipient_status
        });
      }
    }

    return Array.from(campaignMap.values());
  }

  async getCampaignWithRecipients(campaignId: string): Promise<Campaign | null> {
    const query = this.db.campaigns
      .where('id', '=', campaignId)
      .join('recipients', 'campaignId', 'id')
      .select(`
        campaigns.*,
        recipients.id as recipient_id,
        recipients.email as recipient_email,
        recipients.name as recipient_name,
        recipients.status as recipient_status
      `);

    const results = await query.findMany();

    if (results.length === 0) {
      return null;
    }

    const campaignData = results[0];
    const recipients: Recipient[] = [];

    for (const row of results) {
      if (row.recipient_id) {
        recipients.push({
          id: row.recipient_id,
          campaignId,
          email: row.recipient_email,
          name: row.recipient_name,
          status: row.recipient_status
        });
      }
    }

    return {
      id: campaignData.id,
      userId: campaignData.userId,
      subject: campaignData.subject,
      content: campaignData.content,
      recipients,
      createdAt: campaignData.createdAt,
      updatedAt: campaignData.updatedAt
    };
  }

  async getCampaignsWithRecipientStats(userId: string): Promise<CampaignStats[]> {
    // âœ… Good: Aggregate with single query using GROUP BY
    const query = this.db.campaigns
      .where('userId', '=', userId)
      .leftJoin('recipients', 'campaignId', 'id')
      .select(`
        campaigns.id,
        campaigns.subject,
        COUNT(recipients.id) as total_recipients,
        COUNT(CASE WHEN recipients.status = 'sent' THEN 1 END) as sent_count,
        COUNT(CASE WHEN recipients.status = 'failed' THEN 1 END) as failed_count,
        COUNT(CASE WHEN recipients.status = 'pending' THEN 1 END) as pending_count
      `)
      .groupBy('campaigns.id', 'campaigns.subject');

    const results = await query.findMany();

    return results.map(row => ({
      id: row.id,
      subject: row.subject,
      totalRecipients: Number(row.total_recipients) || 0,
      sentCount: Number(row.sent_count) || 0,
      failedCount: Number(row.failed_count) || 0,
      pendingCount: Number(row.pending_count) || 0
    }));
  }

  // âŒ Bad: Example of N+1 query (for educational purposes)
  async badGetCampaignsWithRecipients(userId: string): Promise<Campaign[]> {
    // This would cause N+1 problem - don't use this!
    const campaigns = await this.db.campaigns.where('userId', '=', userId).findMany();

    for (const campaign of campaigns) {
      // Each iteration triggers a separate database query
      campaign.recipients = await this.db.recipients
        .where('campaignId', '=', campaign.id)
        .findMany();
    }

    return campaigns;
  }
}

// Usage example
const queryService = new CampaignQueryServiceImpl(database); // Assume database is initialized

async function demonstrateQueryOptimization() {
  const userId = 'user_123';

  // Good: Single query with eager loading
  const campaigns = await queryService.getCampaignsWithRecipients(userId);
  console.log(`Loaded ${campaigns.length} campaigns`);

  // Good: Campaign with statistics
  const stats = await queryService.getCampaignsWithRecipientStats(userId);
  console.log('Campaign statistics:', stats);

  // Good: Individual campaign with recipients
  const firstCampaign = campaigns[0];
  if (firstCampaign) {
    const campaignWithRecipients = await queryService.getCampaignWithRecipients(firstCampaign.id);
    console.log(`Campaign ${campaignWithRecipients?.id} has ${campaignWithRecipients?.recipients?.length} recipients`);
  }
}

```
