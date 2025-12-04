---
title: "TypeScript Advanced - Standards"
description: "Advanced TypeScript patterns, practices, and conventions"
last_modified_date: "2025-12-04"
level: "3"
persona: "Senior Developers"
keywords: "TypeScript, advanced patterns, type system, generics"
---

# TypeScript Advanced - Standards

## TypeScript Standards

### Interface and Type Definitions

```typescript
// types/campaign.types.ts
export interface EmailRecipient {
  readonly email: string;
  readonly name?: string;
  readonly personalization?: PersonalizationData;
  readonly tags?: string[];
  readonly consent: ConsentSettings;
}

export interface PersonalizationData {
  readonly [key: string]: string | number | boolean;
}

export interface CampaignSettings {
  readonly analytics_enabled: boolean;
  readonly ai_optimization: boolean;
  readonly track_opens: boolean;
  readonly track_clicks: boolean;
  readonly batch_size?: number;
  readonly delay_between_batches?: number;
}

export interface CreateCampaignRequest {
  readonly name: string;
  readonly subject: string;
  readonly content: EmailContent;
  readonly recipients: EmailRecipient[];
  readonly settings: CampaignSettings;
  readonly schedule?: ScheduleSettings;
}

export interface EmailContent {
  readonly html: string;
  readonly text: string;
  readonly template_id?: string;
  readonly variables?: TemplateVariable[];
}

export interface ScheduleSettings {
  readonly send_at: Date;
  readonly timezone: string;
  readonly recurring?: RecurringSettings;
}

// Service implementation
export class CampaignService {
  constructor(
    private readonly apiClient: ApiClient,
    private readonly analyticsService: AnalyticsService,
    private readonly aiService: AIService
  ) {}

  async createCampaign(
    request: CreateCampaignRequest
  ): Promise<EmailCampaign> {
    try {
      // Validate request data
      this.validateCampaignRequest(request);

      // Track campaign creation event
      await this.analyticsService.trackEvent('campaign_creation_started', {
        userId: request.recipients[0]?.email, // Simplified for example
        campaignType: request.settings.ai_optimization ? 'ai_optimized' : 'standard',
        timestamp: new Date().toISOString()
      });

      // Apply AI optimization if enabled
      let optimizedContent = request.content;
      if (request.settings.ai_optimization) {
        optimizedContent = await this.aiService.optimizeContent(
          request.content,
          request.recipients
        );
      }

      // Create campaign with API
      const campaign = await this.apiClient.post<EmailCampaign>('/api/v1/campaigns', {
        ...request,
        content: optimizedContent
      });

      // Track successful creation
      await this.analyticsService.trackEvent('campaign_created', {
        campaignId: campaign.id,
        hasAIOptimization: request.settings.ai_optimization,
        recipientCount: request.recipients.length
      });

      return campaign;
    } catch (error) {
      await this.analyticsService.trackError('campaign_creation_failed', {
        error: error.message,
        requestType: 'create_campaign'
      });

      throw new CampaignCreationError(
        'Failed to create campaign',
        { originalError: error }
      );
    }
  }

  private validateCampaignRequest(request: CreateCampaignRequest): void {
    if (!request.name?.trim()) {
      throw new ValidationError('Campaign name is required');
    }

    if (!request.subject?.trim()) {
      throw new ValidationError('Campaign subject is required');
    }

    if (!request.content?.html?.trim()) {
      throw new ValidationError('Campaign content HTML is required');
    }

    if (!request.recipients || request.recipients.length === 0) {
      throw new ValidationError('At least one recipient is required');
    }

    // Validate recipients
    for (const recipient of request.recipients) {
      if (!this.isValidEmail(recipient.email)) {
        throw new ValidationError(`Invalid email address: ${recipient.email}`);
      }
    }
  }

  private isValidEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }
}

// Custom error classes
export class CampaignCreationError extends Error {
  constructor(
    message: string,
    public readonly context?: Record<string, any>
  ) {
    super(message);
    this.name = 'CampaignCreationError';
  }
}

export class ValidationError extends Error {
  constructor(
    message: string,
    public readonly field?: string
  ) {
    super(message);
    this.name = 'ValidationError';
  }
}

```

### Component Development Standards

```tsx
// components/CampaignEditor.tsx
import React, { useState, useCallback, useMemo } from 'react';
import { useCampaign } from '../hooks/useCampaign';
import { useAnalytics } from '../hooks/useAnalytics';
import { Button } from './ui/Button';
import { Input } from './ui/Input';
import { TextArea } from './ui/TextArea';
import { LoadingSpinner } from './ui/LoadingSpinner';

interface CampaignEditorProps {
  readonly campaignId?: string;
  readonly onSave: (campaign: EmailCampaign) => void;
  readonly onCancel: () => void;
}

export const CampaignEditor: React.FC<CampaignEditorProps> = ({
  campaignId,
  onSave,
  onCancel
}) => {
  // State management
  const [formData, setFormData] = useState<CreateCampaignRequest>({
    name: '',
    subject: '',
    content: { html: '', text: '' },
    recipients: [],
    settings: {
      analytics_enabled: true,
      ai_optimization: false,
      track_opens: true,
      track_clicks: true
    }
  });

  const [errors, setErrors] = useState<Record<string, string>>({});
  const [isOptimizing, setIsOptimizing] = useState(false);

  // Hooks
  const { createCampaign, updateCampaign, isLoading } = useCampaign();
  const { trackEvent, trackError } = useAnalytics();

  // Derived values
  const canSave = useMemo(() => {
    return formData.name.trim() &&
           formData.subject.trim() &&
           formData.content.html.trim() &&
           formData.recipients.length > 0 &&
           Object.keys(errors).length === 0;
  }, [formData, errors]);

  // Event handlers
  const handleInputChange = useCallback((
    field: keyof CreateCampaignRequest,
    value: any
  ) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    setErrors(prev => ({ ...prev, [field]: '' }));
  }, []);

  const handleContentChange = useCallback((
    field: 'html' | 'text',
    value: string
  ) => {
    setFormData(prev => ({
      ...prev,
      content: { ...prev.content, [field]: value }
    }));
    setErrors(prev => ({ ...prev, content: '' }));
  }, []);

  const handleRecipientsChange = useCallback((recipients: EmailRecipient[]) => {
    setFormData(prev => ({ ...prev, recipients }));
    setErrors(prev => ({ ...prev, recipients: '' }));
  }, []);

  const handleAIOptimization = useCallback(async () => {
    if (!formData.content.html.trim()) {
      setErrors(prev => ({
        ...prev,
        content: 'Content is required for AI optimization'
      }));
      return;
    }

    setIsOptimizing(true);
    try {
      // Trigger AI optimization
      const optimizedContent = await aiService.optimizeContent(
        formData.content,
        formData.recipients
      );

      setFormData(prev => ({
        ...prev,
        content: optimizedContent,
        settings: {
          ...prev.settings,
          ai_optimization: true
        }
      }));

      trackEvent('ai_optimization_applied', {
        campaignId,
        optimizationType: 'content'
      });
    } catch (error) {
      trackError('ai_optimization_failed', error);
      setErrors(prev => ({
        ...prev,
        ai_optimization: 'AI optimization failed. Please try again.'
      }));
    } finally {
      setIsOptimizing(false);
    }
  }, [formData, aiService, trackEvent, trackError, campaignId]);

  const handleSave = useCallback(async () => {
    if (!canSave) {
      trackError('campaign_save_validation_failed', {
        errors,
        formData
      });
      return;
    }

    try {
      const campaign = campaignId
        ? await updateCampaign(campaignId, formData)
        : await createCampaign(formData);

      trackEvent('campaign_saved', {
        campaignId: campaign.id,
        hasAIOptimization: formData.settings.ai_optimization
      });

      onSave(campaign);
    } catch (error) {
      trackError('campaign_save_failed', error);
    }
  }, [canSave, campaignId, formData, createCampaign, updateCampaign, onSave, trackEvent, trackError]);

  // Render
  if (isLoading) {
    return <LoadingSpinner />;
  }

  return (
    <div className="campaign-editor">
      <form onSubmit={(e) => { e.preventDefault(); handleSave(); }}>
        <div className="editor-header">
          <h2>{campaignId ? 'Edit Campaign' : 'Create Campaign'}</h2>
          <div className="editor-actions">
            <Button
              type="button"
              variant="secondary"
              onClick={onCancel}
            >
              Cancel
            </Button>
            <Button
              type="submit"
              variant="primary"
              disabled={!canSave}
              onClick={handleSave}
            >
              {campaignId ? 'Update Campaign' : 'Create Campaign'}
            </Button>
          </div>
        </div>

        <div className="editor-content">
          <section className="campaign-basic-info">
            <h3>Basic Information</h3>
            <div className="form-group">
              <label htmlFor="campaign-name">Campaign Name</label>
              <Input
                id="campaign-name"
                type="text"
                value={formData.name}
                onChange={(e) => handleInputChange('name', e.target.value)}
                error={errors.name}
                placeholder="Enter campaign name"
              />
            </div>

            <div className="form-group">
              <label htmlFor="campaign-subject">Email Subject</label>
              <Input
                id="campaign-subject"
                type="text"
                value={formData.subject}
                onChange={(e) => handleInputChange('subject', e.target.value)}
                error={errors.subject}
                placeholder="Enter email subject"
                maxLength={100}
              />
            </div>
          </section>

          <section className="campaign-content">
            <h3>Email Content</h3>
            <div className="form-group">
              <label htmlFor="content-html">HTML Content</label>
              <TextArea
                id="content-html"
                value={formData.content.html}
                onChange={(e) => handleContentChange('html', e.target.value)}
                error={errors.content}
                placeholder="Enter HTML content..."
                rows={10}
              />
            </div>

            <div className="form-group">
              <label htmlFor="content-text">Plain Text Content</label>
              <TextArea
                id="content-text"
                value={formData.content.text}
                onChange={(e) => handleContentChange('text', e.target.value)}
                placeholder="Enter plain text content..."
                rows={5}
              />
            </div>

            <div className="ai-optimization-section">
              <Button
                type="button"
                variant="secondary"
                onClick={handleAIOptimization}
                disabled={isOptimizing || !formData.content.html.trim()}
                loading={isOptimizing}
              >
                {isOptimizing ? 'Optimizing with AI...' : 'Optimize with AI'}
              </Button>
              {errors.ai_optimization && (
                <p className="error-message">{errors.ai_optimization}</p>
              )}
            </div>
          </section>
        </div>
      </form>
    </div>
  );
};

```

