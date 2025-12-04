---
title: "API Bug Patterns"
description: "Common API-related bugs and debugging strategies"
last_modified_date: "2025-12-04"
level: "3"
persona: "Quality Assurance"
keywords: "API debugging, REST API, error handling, API testing"
---

# API Bug Patterns

### API Issues

**Problem**: Inconsistent error responses

```typescript
// api/campaigns-controller.ts
import { Request, Response } from 'express';
import { ValidationError } from '../errors/validation-error';
import { CampaignService } from '../services/campaign-service';
import { logger } from '../utils/logger';

interface CreateCampaignRequest {
  subject: string;
  content: string;
  recipients: EmailRecipient[];
}

interface ApiResponse<T> {
  success: boolean;
  data?: T;
  errors?: ValidationErrorMessage[];
  error?: string;
  message?: string;
}

interface ValidationErrorMessage {
  field: string;
  message: string;
  code: string;
}

interface EmailRecipient {
  email: string;
  name?: string;
}

class CampaignsController {
  private campaignService: CampaignService;

  constructor(campaignService: CampaignService) {
    this.campaignService = campaignService;
  }

  async createCampaign(req: Request, res: Response): Promise<void> {
    try {
      // Validate input
      const requestData = this.validateCreateCampaignRequest(req.body);

      // Process campaign
      const result = await this.campaignService.createCampaign(requestData);

      // Consistent success response
      const response: ApiResponse<CampaignResult> = {
        success: true,
        data: {
          campaignId: result.campaignId,
          status: result.status,
          recipientCount: result.recipientCount
        }
      };

      res.status(201).json(response);
    } catch (error) {
      this.handleError(error, res);
    }
  }

  async getCampaign(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;

      if (!id) {
        const response: ApiResponse<never> = {
          success: false,
          errors: [{
            field: 'id',
            message: 'Campaign ID is required',
            code: 'REQUIRED_FIELD'
          }]
        };
        res.status(400).json(response);
        return;
      }

      const campaign = await this.campaignService.getCampaign(id);

      if (!campaign) {
        const response: ApiResponse<never> = {
          success: false,
          error: 'Campaign not found'
        };
        res.status(404).json(response);
        return;
      }

      const response: ApiResponse<Campaign> = {
        success: true,
        data: campaign
      };

      res.json(response);
    } catch (error) {
      this.handleError(error, res);
    }
  }

  private validateCreateCampaignRequest(body: unknown): CreateCampaignRequest {
    if (!body || typeof body !== 'object') {
      throw new ValidationError('Request body is required');
    }

    const data = body as CreateCampaignRequest;
    const errors: ValidationErrorMessage[] = [];

    if (!data.subject || typeof data.subject !== 'string') {
      errors.push({
        field: 'subject',
        message: 'Subject is required and must be a string',
        code: 'INVALID_SUBJECT'
      });
    }

    if (!data.content || typeof data.content !== 'string') {
      errors.push({
        field: 'content',
        message: 'Content is required and must be a string',
        code: 'INVALID_CONTENT'
      });
    }

    if (!Array.isArray(data.recipients) || data.recipients.length === 0) {
      errors.push({
        field: 'recipients',
        message: 'At least one recipient is required',
        code: 'INVALID_RECIPIENTS'
      });
    } else {
      data.recipients.forEach((recipient, index) => {
        if (!recipient.email || typeof recipient.email !== 'string') {
          errors.push({
            field: `recipients[${index}].email`,
            message: 'Valid email address is required',
            code: 'INVALID_EMAIL'
          });
        }
      });
    }

    if (errors.length > 0) {
      throw new ValidationError('Validation failed', errors);
    }

    return data;
  }

  private handleError(error: unknown, res: Response): void {
    if (error instanceof ValidationError) {
      // Validation errors with detailed field information
      const response: ApiResponse<never> = {
        success: false,
        errors: error.errors
      };

      res.status(400).json(response);
    } else if (error instanceof Error) {
      // Log unexpected errors
      logger.error('Unexpected error in campaigns controller', {
        error: error.message,
        stack: error.stack
      });

      // Consistent error response format
      const response: ApiResponse<never> = {
        success: false,
        error: 'Internal server error'
      };

      res.status(500).json(response);
    } else {
      // Fallback for unknown error types
      const response: ApiResponse<never> = {
        success: false,
        error: 'An unexpected error occurred'
      };

      res.status(500).json(response);
    }
  }
}

// Supporting interfaces and types
interface CampaignResult {
  campaignId: string;
  status: 'pending' | 'processing' | 'completed' | 'failed';
  recipientCount: number;
}

interface Campaign {
  id: string;
  subject: string;
  content: string;
  status: string;
  recipientCount: number;
  createdAt: string;
  updatedAt: string;
}

interface CampaignService {
  createCampaign(data: CreateCampaignRequest): Promise<CampaignResult>;
  getCampaign(id: string): Promise<Campaign | null>;
}

// Usage example
const campaignService = new CampaignService(); // Mock implementation
const controller = new CampaignsController(campaignService);

// Example Express route setup
// app.post('/api/v1/campaigns', (req, res) => controller.createCampaign(req, res));
// app.get('/api/v1/campaigns/:id', (req, res) => controller.getCampaign(req, res));

```

