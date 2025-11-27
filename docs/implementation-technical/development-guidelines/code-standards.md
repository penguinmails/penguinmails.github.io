---
title: "Code Style & Quality Standards"
description: "Enterprise development workflows, security protocols, performance standards, and comprehensive coding conventions"
last_modified_date: "2025-11-24"
level: "3"
persona: "Senior Developers"
---

# Code Style & Quality Standards

## TypeScript Code Standards

### Style Guide Compliance

```typescript
// ✅ Good: Clear, documented, well-structured code
interface EmailDeliveryScore {
  overallScore: number;
  confidence: number;
  componentScores: {
    engagement: number;
    quality: number;
    technical: number;
  };
}

interface HistoricalPerformance {
  campaigns?: CampaignMetrics[];
  averagePerformance?: number;
  trendDirection?: 'improving' | 'declining' | 'stable';
}

interface CampaignMetrics {
  id: string;
  performance: number;
  date: string;
}

/**
 * Calculate comprehensive email delivery score using multiple metrics.
 *
 * This function analyzes recipient engagement patterns, content quality,
 * technical deliverability factors, and historical performance to provide
 * a weighted delivery score.
 *
 * @param recipientEngagement - Historical engagement rate (0.0-1.0)
 * @param contentQuality - AI-evaluated content score (0.0-1.0)
 * @param technicalScore - Technical deliverability score (0.0-1.0)
 * @param historicalPerformance - Optional historical metrics for trend analysis
 * @returns Comprehensive delivery score with confidence interval
 * @throws {Error} If any score is outside valid range (0.0-1.0)
 *
 * @example
 * ```typescript
 * const score = calculateEmailDeliveryScore(0.85, 0.92, 0.88);
 * console.log(score.overallScore); // 0.88
 * ```
 */
function calculateEmailDeliveryScore(
  recipientEngagement: number,
  contentQuality: number,
  technicalScore: number,
  historicalPerformance?: HistoricalPerformance
): EmailDeliveryScore {
  // Validate input parameters
  const scoreParams = [
    { name: 'recipientEngagement', value: recipientEngagement },
    { name: 'contentQuality', value: contentQuality },
    { name: 'technicalScore', value: technicalScore }
  ];

  for (const param of scoreParams) {
    if (typeof param.value !== 'number' || param.value < 0.0 || param.value > 1.0) {
      throw new Error(`${param.name} must be a number between 0.0 and 1.0`);
    }
  }

  // Calculate weighted score with confidence based on data quality
  const weights = {
    engagement: 0.4,
    quality: 0.35,
    technical: 0.25
  };

  const baseScore =
    recipientEngagement * weights.engagement +
    contentQuality * weights.quality +
    technicalScore * weights.technical;

  // Adjust confidence based on historical data availability
  let confidence = 0.7; // Base confidence
  
  if (historicalPerformance) {
    confidence += 0.2; // Increase confidence with historical data
    
    const campaignCount = historicalPerformance.campaigns?.length || 0;
    if (campaignCount > 10) {
      confidence += 0.1; // More confidence with more data
    }
  }

  return {
    overallScore: Math.round(baseScore * 1000) / 1000,
    confidence: Math.min(confidence, 1.0),
    componentScores: {
      engagement: recipientEngagement,
      quality: contentQuality,
      technical: technicalScore
    }
  };
}

// ❌ Bad: Poor documentation, unclear variable names, magic numbers
function calc(x: number, y: number, z: number): EmailDeliveryScore {
  const s = x * 0.4 + y * 0.35 + z * 0.25;
  return {
    overallScore: s,
    confidence: 0.7,
    componentScores: { engagement: x, quality: y, technical: z }
  };
}
```

### Documentation Standards

```typescript
interface EmailCampaignAnalytics {
  campaignId: string;
  sentCount: number;
  deliveredCount: number;
  openedCount: number;
  clickedCount: number;
  bouncedCount: number;
  complainedCount: number;
  createdAt: Date;
  deliveryRate?: number;
  openRate?: number;
  clickRate?: number;
}

/**
 * Analytics data for email campaign performance.
 */
class EmailCampaignAnalyticsService {
  constructor(private readonly analytics: EmailCampaignAnalytics) {}

  /**
   * Calculate delivery rate as percentage.
   */
  getDeliveryRate(): number {
    if (this.analytics.sentCount === 0) {
      return 0.0;
    }
    return (this.analytics.deliveredCount / this.analytics.sentCount) * 100;
  }

  /**
   * Calculate open rate as percentage of delivered emails.
   */
  getOpenRate(): number {
    if (this.analytics.deliveredCount === 0) {
      return 0.0;
    }
    return (this.analytics.openedCount / this.analytics.deliveredCount) * 100;
  }

  /**
   * Calculate click rate as percentage of delivered emails.
   */
  getClickRate(): number {
    if (this.analytics.deliveredCount === 0) {
      return 0.0;
    }
    return (this.analytics.clickedCount / this.analytics.deliveredCount) * 100;
  }

  /**
   * Convert analytics to dictionary format.
   *
   * @param includeCalculated - Whether to include calculated rates
   * @returns Dictionary representation of analytics data
   */
  toDictionary(includeCalculated: boolean = true): Record<string, number | string> {
    const data: Record<string, number | string> = {
      campaignId: this.analytics.campaignId,
      sentCount: this.analytics.sentCount,
      deliveredCount: this.analytics.deliveredCount,
      openedCount: this.analytics.openedCount,
      clickedCount: this.analytics.clickedCount,
      bouncedCount: this.analytics.bouncedCount,
      complainedCount: this.analytics.complainedCount,
      createdAt: this.analytics.createdAt.toISOString()
    };

    if (includeCalculated) {
      data.deliveryRate = this.getDeliveryRate();
      data.openRate = this.getOpenRate();
      data.clickRate = this.getClickRate();
    }

    return data;
  }
}
```

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

## CSS Standards

### Design System Integration

```scss
// styles/components/campaign-editor.scss
@import '../design-system/tokens/colors';
@import '../design-system/tokens/typography';
@import '../design-system/tokens/spacing';
@import '../design-system/tokens/elevation';

.campaign-editor {
  max-width: 1200px;
  margin: 0 auto;
  padding: spacing(xl);

  .editor-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: spacing(xl);
    padding-bottom: spacing(md);
    border-bottom: 1px solid $color-border-subtle;

    h2 {
      @include text-heading-lg;
      color: $color-text-primary;
      margin: 0;
    }

    .editor-actions {
      display: flex;
      gap: spacing(sm);
    }
  }

  .editor-content {
    display: grid;
    gap: spacing(xl);

    section {
      background: $color-surface;
      border-radius: $border-radius-lg;
      padding: spacing(lg);
      box-shadow: $elevation-1;
      border: 1px solid $color-border-light;

      h3 {
        @include text-heading-md;
        color: $color-text-primary;
        margin: 0 0 spacing(md) 0;
        padding-bottom: spacing(sm);
        border-bottom: 2px solid $color-primary-100;
      }
    }
  }

  .form-group {
    margin-bottom: spacing(md);

    label {
      @include text-body-sm;
      font-weight: $font-weight-medium;
      color: $color-text-secondary;
      display: block;
      margin-bottom: spacing(xs);
    }

    input, textarea {
      @include input-base;
      width: 100%;

      &:focus {
        @include input-focus;
      }

      &.error {
        @include input-error;
      }
    }

    .error-message {
      @include text-caption;
      color: $color-error;
      margin-top: spacing(xs);
    }
  }

  .ai-optimization-section {
    display: flex;
    align-items: center;
    gap: spacing(sm);
    margin-top: spacing(md);

    button {
      @include button-secondary;

      &:disabled {
        @include button-disabled;
      }
    }
  }
}

// Responsive design
@include mobile {
  .campaign-editor {
    padding: spacing(md);

    .editor-header {
      flex-direction: column;
      gap: spacing(md);
      align-items: stretch;

      .editor-actions {
        justify-content: stretch;

        button {
          flex: 1;
        }
      }
    }
  }
}
```

## Security Standards

### Input Validation

```typescript
// Security-focused validation example

interface SecureCampaignRequest {
  name: string;
  subject: string;
  content: EmailContent;
  recipients: EmailRecipient[];
}

interface EmailContent {
  html: string;
  text: string;
  templateId?: string;
}

interface EmailRecipient {
  email: string;
  name?: string;
  personalization?: Record<string, string | number | boolean>;
}

interface ValidationResult {
  isValid: boolean;
  errors: string[];
}

interface PersonalizationSanitizer {
  [key: string]: string | number | boolean;
}

/**
 * Security-focused validation service
 */
class SecureCampaignValidationService {
  private readonly emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  private readonly invalidNamePattern = /[<>\"']/;
  private readonly invalidSubjectPattern = /[\r\n]/;

  /**
   * Validate campaign request with security considerations
   */
  validateCampaignRequest(request: SecureCampaignRequest): ValidationResult {
    const errors: string[] = [];

    // Validate name
    const nameValidation = this.validateName(request.name);
    if (!nameValidation.isValid) {
      errors.push(...nameValidation.errors);
    }

    // Validate subject
    const subjectValidation = this.validateSubject(request.subject);
    if (!subjectValidation.isValid) {
      errors.push(...subjectValidation.errors);
    }

    // Validate content
    const contentValidation = this.validateContent(request.content);
    if (!contentValidation.isValid) {
      errors.push(...contentValidation.errors);
    }

    // Validate recipients
    const recipientsValidation = this.validateRecipients(request.recipients);
    if (!recipientsValidation.isValid) {
      errors.push(...recipientsValidation.errors);
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }

  private validateName(name: string): ValidationResult {
    const errors: string[] = [];

    if (!name || name.trim().length === 0) {
      errors.push("Name is required");
      return { isValid: false, errors };
    }

    if (name.length > 100) {
      errors.push("Name must be less than 100 characters");
    }

    if (this.invalidNamePattern.test(name)) {
      errors.push("Name contains invalid characters");
    }

    return { isValid: errors.length === 0, errors };
  }

  private validateSubject(subject: string): ValidationResult {
    const errors: string[] = [];

    if (!subject || subject.trim().length === 0) {
      errors.push("Subject is required");
      return { isValid: false, errors };
    }

    if (subject.length > 200) {
      errors.push("Subject must be less than 200 characters");
    }

    if (this.invalidSubjectPattern.test(subject)) {
      errors.push("Subject contains invalid characters");
    }

    return { isValid: errors.length === 0, errors };
  }

  private validateContent(content: EmailContent): ValidationResult {
    const errors: string[] = [];

    if (!content.html || content.html.trim().length === 0) {
      errors.push("HTML content is required");
    }

    if (!content.text || content.text.trim().length === 0) {
      errors.push("Text content is required");
    }

    return { isValid: errors.length === 0, errors };
  }

  private validateRecipients(recipients: EmailRecipient[]): ValidationResult {
    const errors: string[] = [];

    if (!recipients || recipients.length === 0) {
      errors.push("At least one recipient is required");
      return { isValid: false, errors };
    }

    if (recipients.length > 10000) {
      errors.push("Maximum 10,000 recipients allowed");
      return { isValid: false, errors };
    }

    for (let i = 0; i < recipients.length; i++) {
      const recipient = recipients[i];
      const recipientErrors = this.validateRecipient(recipient, i);
      errors.push(...recipientErrors);
    }

    return { isValid: errors.length === 0, errors };
  }

  private validateRecipient(recipient: EmailRecipient, index: number): string[] {
    const errors: string[] = [];
    const prefix = `Recipient ${index + 1}`;

    if (!recipient.email) {
      errors.push(`${prefix}: Email is required`);
      return errors;
    }

    if (!this.emailPattern.test(recipient.email)) {
      errors.push(`${prefix}: Invalid email address: ${recipient.email}`);
    }

    if (recipient.personalization) {
      const sanitized = this.sanitizePersonalization(recipient.personalization);
      if (Object.keys(sanitized).length !== Object.keys(recipient.personalization).length) {
        errors.push(`${prefix}: Personalization contains invalid data`);
      }
    }

    return errors;
  }

  /**
   * Sanitize personalization data to prevent injection
   */
  private sanitizePersonalization(data: PersonalizationSanitizer): PersonalizationSanitizer {
    if (!data || typeof data !== 'object') {
      return {};
    }

    const sanitized: PersonalizationSanitizer = {};

    for (const [key, value] of Object.entries(data)) {
      // Only allow safe string/number/boolean values
      if (typeof value === 'string' || typeof value === 'number' || typeof value === 'boolean') {
        if (typeof value === 'string') {
          // Basic XSS prevention - escape HTML
          sanitized[key] = value
            .replace(/</g, '<')
            .replace(/>/g, '>')
            .replace(/"/g, '"')
            .replace(/'/g, '&#x27;');
        } else {
          sanitized[key] = value;
        }
      }
    }

    return sanitized;
  }
}
```

### Authentication & Authorization

```typescript
// Secure authentication patterns
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';

export class AuthenticationService {
  private readonly jwtSecret: string;
  private readonly jwtExpiresIn = '24h';
  
  constructor(jwtSecret: string) {
    this.jwtSecret = jwtSecret;
  }

  async hashPassword(password: string): Promise<string> {
    // Use appropriate salt rounds (12+ for production)
    return bcrypt.hash(password, 12);
  }

  async verifyPassword(password: string, hashedPassword: string): Promise<boolean> {
    return bcrypt.compare(password, hashedPassword);
  }

  generateToken(user: User): string {
    return jwt.sign(
      {
        userId: user.id,
        email: user.email,
        role: user.role,
        permissions: user.permissions
      },
      this.jwtSecret,
      {
        expiresIn: this.jwtExpiresIn,
        issuer: 'penguinmails.com',
        audience: 'penguinmails-users'
      }
    );
  }

  verifyToken(token: string): DecodedToken {
    try {
      return jwt.verify(token, this.jwtSecret, {
        issuer: 'penguinmails.com',
        audience: 'penguinmails-users'
      }) as DecodedToken;
    } catch (error) {
      throw new AuthenticationError('Invalid or expired token');
    }
  }

  hasPermission(decodedToken: DecodedToken, requiredPermission: string): boolean {
    return decodedToken.permissions.includes(requiredPermission) ||
           decodedToken.permissions.includes('admin:*');
  }
}

// Authorization middleware
export function requirePermission(permission: string) {
  return (req: Request, res: Response, next: NextFunction) => {
    const token = extractTokenFromRequest(req);
    
    if (!token) {
      return res.status(401).json({ error: 'Authentication required' });
    }

    try {
      const decoded = authService.verifyToken(token);
      
      if (!authService.hasPermission(decoded, permission)) {
        return res.status(403).json({ error: 'Insufficient permissions' });
      }

      // Attach user info to request
      req.user = decoded;
      next();
    } catch (error) {
      return res.status(401).json({ error: 'Invalid authentication' });
    }
  };
}
```

## Performance Standards

### Database Optimization

```typescript
// Optimized database queries with TypeScript

interface Campaign {
  id: string;
  name: string;
  subject: string;
  userId: string;
  createdAt: Date;
  recipients?: EmailRecipient[];
  analytics?: CampaignAnalytics[];
  user?: User;
}

interface EmailRecipient {
  id: string;
  email: string;
  name?: string;
  campaignId: string;
}

interface CampaignAnalytics {
  id: string;
  campaignId: string;
  sentCount: number;
  deliveredCount: number;
  openedCount: number;
  clickedCount: number;
}

interface User {
  id: string;
  email: string;
  name: string;
}

interface CampaignQueryOptions {
  includeRecipients?: boolean;
  includeAnalytics?: boolean;
  includeUser?: boolean;
  limit?: number;
  offset?: number;
}

/**
 * Service with performance-optimized database operations
 */
class OptimizedCampaignService {
  constructor(private readonly db: DatabaseService) {}

  /**
   * Eager load related data to minimize N+1 queries
   */
  async getCampaignWithMetrics(
    campaignId: string,
    options: CampaignQueryOptions = {}
  ): Promise<Campaign | null> {
    const queryBuilder = this.db.createQueryBuilder()
      .select('campaign')
      .from(Campaign, 'campaign')
      .where('campaign.id = :campaignId', { campaignId });

    // Eager load recipients to avoid N+1 queries
    if (options.includeRecipients !== false) {
      queryBuilder.leftJoinAndSelect('campaign.recipients', 'recipients');
    }

    // Join with user table
    if (options.includeUser) {
      queryBuilder.leftJoinAndSelect('campaign.user', 'user');
    }

    // Load analytics in one query
    if (options.includeAnalytics) {
      queryBuilder.leftJoinAndSelect('campaign.analytics', 'analytics');
    }

    return queryBuilder.getOne();
  }

  /**
   * Efficiently load campaigns with pagination
   */
  async getCampaignsBatch(
    userId: string,
    options: CampaignQueryOptions = {}
  ): Promise<Campaign[]> {
    const { limit = 50, offset = 0, includeRecipients = true, includeAnalytics = true } = options;

    const queryBuilder = this.db.createQueryBuilder()
      .select('campaign')
      .from(Campaign, 'campaign')
      .where('campaign.userId = :userId', { userId })
      .orderBy('campaign.createdAt', 'DESC')
      .take(limit)
      .skip(offset);

    // Eager load related data
    if (includeRecipients) {
      queryBuilder.leftJoinAndSelect('campaign.recipients', 'recipients');
    }

    if (includeAnalytics) {
      queryBuilder.leftJoinAndSelect('campaign.analytics', 'analytics');
    }

    return queryBuilder.getMany();
  }

  /**
   * Use database-level search for better performance
   */
  async searchCampaigns(
    query: string,
    userId: string,
    options: CampaignQueryOptions = {}
  ): Promise<Campaign[]> {
    const queryBuilder = this.db.createQueryBuilder()
      .select('campaign')
      .from(Campaign, 'campaign')
      .where('campaign.userId = :userId', { userId })
      .andWhere(
        '(campaign.name ILIKE :query OR campaign.subject ILIKE :query)',
        { query: `%${query}%` }
      )
      .orderBy('campaign.createdAt', 'DESC');

    // Include recipients for search results
    if (options.includeRecipients !== false) {
      queryBuilder.leftJoinAndSelect('campaign.recipients', 'recipients');
    }

    return queryBuilder.getMany();
  }
}

/**
 * Enhanced query builder interface
 */
interface QueryBuilder<T> {
  select(alias: string): QueryBuilder<T>;
  from(entity: Function, alias: string): QueryBuilder<T>;
  where(condition: string, parameters?: Record<string, unknown>): QueryBuilder<T>;
  andWhere(condition: string, parameters?: Record<string, unknown>): QueryBuilder<T>;
  leftJoinAndSelect(propertyPath: string, alias: string): QueryBuilder<T>;
  orderBy(sort: string, order?: 'ASC' | 'DESC'): QueryBuilder<T>;
  take(limit: number): QueryBuilder<T>;
  skip(offset: number): QueryBuilder<T>;
  getOne(): Promise<T | null>;
  getMany(): Promise<T[]>;
}

interface DatabaseService {
  createQueryBuilder<T>(): QueryBuilder<T>;
}
```

### Caching Strategy

```typescript
// Efficient caching implementation with TypeScript

interface CacheValue {
  data: unknown;
  timestamp: number;
  ttl: number;
}

interface CacheOptions {
  ttl?: number; // Time to live in seconds
  tags?: string[];
}

interface CacheResult<T> {
  success: boolean;
  data?: T;
  error?: string;
}

/**
 * High-performance caching service
 */
class CacheService {
  private readonly defaultTTL = 3600; // 1 hour
  private readonly redisClient: RedisClient;

  constructor(redisClient: RedisClient) {
    this.redisClient = redisClient;
  }

  /**
   * Get value from cache with error handling
   */
  async get<T>(key: string): Promise<T | null> {
    try {
      const value = await this.redisClient.get(key);
      if (!value) return null;

      const parsed = JSON.parse(value) as CacheValue;
      
      // Check if cache entry has expired
      if (Date.now() - parsed.timestamp > parsed.ttl * 1000) {
        await this.redisClient.del(key);
        return null;
      }

      return parsed.data as T;
    } catch (error) {
      console.warn(`Cache get failed for key ${key}:`, error);
      return null;
    }
  }

  /**
   * Set value in cache with expiration
   */
  async set<T>(key: string, value: T, options: CacheOptions = {}): Promise<boolean> {
    const ttl = options.ttl || this.defaultTTL;
    
    try {
      const cacheValue: CacheValue = {
        data: value,
        timestamp: Date.now(),
        ttl
      };

      await this.redisClient.setex(key, ttl, JSON.stringify(cacheValue));
      return true;
    } catch (error) {
      console.warn(`Cache set failed for key ${key}:`, error);
      return false;
    }
  }

  /**
   * Invalidate multiple keys matching a pattern
   */
  async invalidatePattern(pattern: string): Promise<number> {
    try {
      const keys = await this.redisClient.keys(pattern);
      if (keys.length === 0) return 0;

      return await this.redisClient.del(...keys);
    } catch (error) {
      console.warn(`Cache invalidate failed for pattern ${pattern}:`, error);
      return 0;
    }
  }

  /**
   * Get multiple cache values in batch
   */
  async mget<T>(keys: string[]): Promise<(T | null)[]> {
    try {
      const values = await this.redisClient.mget(keys);
      return values.map(value => {
        if (!value) return null;
        
        try {
          const parsed = JSON.parse(value) as CacheValue;
          if (Date.now() - parsed.timestamp > parsed.ttl * 1000) {
            return null;
          }
          return parsed.data as T;
        } catch {
          return null;
        }
      });
    } catch (error) {
      console.warn(`Cache mget failed for keys ${keys.join(', ')}:`, error);
      return keys.map(() => null);
    }
  }
}

/**
 * Decorator for caching function results
 */
class CampaignCacheDecorator {
  constructor(
    private readonly cacheService: CacheService,
    private readonly defaultTTL: number = 300 // 5 minutes
  ) {}

  /**
   * Decorator for caching campaign data
   */
  cachedCampaign<T extends (...args: unknown[]) => Promise<unknown>>(
    ttl?: number
  ) {
    return (target: unknown, propertyKey: string, descriptor: PropertyDescriptor) => {
      const originalMethod = descriptor.value;

      descriptor.value = async function (...args: unknown[]) {
        const cacheKey = `campaign:${JSON.stringify(args)}`;
        
        // Try cache first
        const cached = await this.cacheService.get<T>(cacheKey);
        if (cached !== null) {
          return cached;
        }
        
        // Get from original method
        const result = await originalMethod.apply(this, args);
        
        // Cache result if not null/undefined
        if (result !== null && result !== undefined) {
          await this.cacheService.set(cacheKey, result, { ttl: ttl || this.defaultTTL });
        }
        
        return result;
      };

      return descriptor;
    };
  }
}

/**
 * Redis client interface
 */
interface RedisClient {
  get(key: string): Promise<string | null>;
  setex(key: string, ttl: number, value: string): Promise<void>;
  del(...keys: string[]): Promise<number>;
  mget(...keys: string[]): Promise<(string | null)[]>;
  keys(pattern: string): Promise<string[]>;
}
```

## Code Review Checklist

### Before Submitting PR

- [ ] Code follows style guidelines and passes linting
- [ ] All functions/classes have proper docstrings
- [ ] Complex logic includes inline comments
- [ ] No hardcoded values or magic numbers
- [ ] Error handling is comprehensive
- [ ] Input validation is implemented
- [ ] Security best practices followed
- [ ] Performance considerations addressed
- [ ] Tests are written and passing
- [ ] Documentation is updated
- [ ] No console.logs or debug statements
- [ ] Dead code removed
- [ ] Consistent naming conventions
- [ ] File size reasonable (<500 lines)

### Security Review Points

- [ ] User inputs are validated and sanitized
- [ ] Authentication and authorization implemented
- [ ] Sensitive data not logged or exposed
- [ ] SQL injection prevention
- [ ] XSS protection measures
- [ ] CSRF protection where applicable
- [ ] Rate limiting implemented
- [ ] Secure headers set
- [ ] Dependencies are up to date
- [ ] No hardcoded secrets or keys

### Performance Review Points

- [ ] Database queries are optimized
- [ ] N+1 query problems avoided
- [ ] Appropriate caching implemented
- [ ] Large datasets are paginated
- [ ] Image/media files are optimized
- [ ] Bundle sizes are reasonable
- [ ] Lazy loading where appropriate
- [ ] Memory usage is efficient
- [ ] API response times are acceptable

For comprehensive testing requirements, see [`testing-requirements.md`](testing-requirements).
For the contribution workflow, see [`code-contribution.md`](code-contribution).
