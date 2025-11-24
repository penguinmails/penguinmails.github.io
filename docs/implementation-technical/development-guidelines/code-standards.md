---
title: "Code Style & Quality Standards"
description: "Enterprise development workflows, security protocols, performance standards, and comprehensive coding conventions"
last_modified_date: "2025-11-24"
level: "3"
persona: "Senior Developers"
---

# Code Style & Quality Standards

## Python Code Standards

### Style Guide Compliance

```python
# ✅ Good: Clear, documented, well-structured code
def calculate_email_delivery_score(
    recipient_engagement: float,
    content_quality: float,
    technical_score: float,
    historical_performance: Optional[dict] = None
) -> EmailDeliveryScore:
    """Calculate comprehensive email delivery score using multiple metrics.

    This function analyzes recipient engagement patterns, content quality,
    technical deliverability factors, and historical performance to provide
    a weighted delivery score.

    Args:
        recipient_engagement: Historical engagement rate (0.0-1.0)
        content_quality: AI-evaluated content score (0.0-1.0)
        technical_score: Technical deliverability score (0.0-1.0)
        historical_performance: Optional historical metrics for trend analysis

    Returns:
        EmailDeliveryScore: Comprehensive delivery score with confidence interval

    Raises:
        ValueError: If any score is outside valid range (0.0-1.0)

    Example:
        >>> score = calculate_email_delivery_score(0.85, 0.92, 0.88)
        >>> print(score.overall_score)
        0.88
    """
    # Validate input parameters
    for name, value in [
        ('recipient_engagement', recipient_engagement),
        ('content_quality', content_quality),
        ('technical_score', technical_score)
    ]:
        if not isinstance(value, (int, float)) or not (0.0 <= value <= 1.0):
            raise ValueError(f"{name} must be a float between 0.0 and 1.0")

    # Calculate weighted score with confidence based on data quality
    weights = {
        'engagement': 0.4,
        'quality': 0.35,
        'technical': 0.25
    }

    base_score = (
        recipient_engagement * weights['engagement'] +
        content_quality * weights['quality'] +
        technical_score * weights['technical']
    )

    # Adjust confidence based on historical data availability
    confidence = 0.7  # Base confidence
    if historical_performance:
        confidence += 0.2  # Increase confidence with historical data
        if len(historical_performance.get('campaigns', [])) > 10:
            confidence += 0.1  # More confidence with more data

    return EmailDeliveryScore(
        overall_score=round(base_score, 3),
        confidence=min(confidence, 1.0),
        component_scores={
            'engagement': recipient_engagement,
            'quality': content_quality,
            'technical': technical_score
        }
    )

# ❌ Bad: Poor documentation, unclear variable names, magic numbers
def calc(x, y, z):
    s = x * 0.4 + y * 0.35 + z * 0.25
    return EmailDeliveryScore(overall_score=s, confidence=0.7)
```

### Documentation Standards

```python
from typing import List, Dict, Optional, Union
from datetime import datetime
from pydantic import BaseModel

class EmailCampaignAnalytics(BaseModel):
    """Analytics data for email campaign performance."""

    campaign_id: str
    sent_count: int
    delivered_count: int
    opened_count: int
    clicked_count: int
    bounced_count: int
    complained_count: int
    created_at: datetime

    @property
    def delivery_rate(self) -> float:
        """Calculate delivery rate as percentage."""
        if self.sent_count == 0:
            return 0.0
        return (self.delivered_count / self.sent_count) * 100

    @property
    def open_rate(self) -> float:
        """Calculate open rate as percentage of delivered emails."""
        if self.delivered_count == 0:
            return 0.0
        return (self.opened_count / self.delivered_count) * 100

    @property
    def click_rate(self) -> float:
        """Calculate click rate as percentage of delivered emails."""
        if self.delivered_count == 0:
            return 0.0
        return (self.clicked_count / self.delivered_count) * 100

    def to_dict(self, include_calculated: bool = True) -> Dict[str, Union[int, float, str]]:
        """Convert analytics to dictionary format.

        Args:
            include_calculated: Whether to include calculated rates

        Returns:
            Dictionary representation of analytics data
        """
        data = {
            'campaign_id': self.campaign_id,
            'sent_count': self.sent_count,
            'delivered_count': self.delivered_count,
            'opened_count': self.opened_count,
            'clicked_count': self.clicked_count,
            'bounced_count': self.bounced_count,
            'complained_count': self.complained_count,
            'created_at': self.created_at.isoformat()
        }

        if include_calculated:
            data.update({
                'delivery_rate': self.delivery_rate,
                'open_rate': self.open_rate,
                'click_rate': self.click_rate
            })

        return data
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

```python
# Security-focused validation example
from pydantic import BaseModel, validator, Field
from typing import Optional
import re

class SecureCampaignRequest(BaseModel):
    name: str = Field(..., min_length=1, max_length=100, description="Campaign name")
    subject: str = Field(..., min_length=1, max_length=200, description="Email subject")
    content: dict = Field(..., description="Email content")
    recipients: list = Field(..., min_items=1, max_items=10000, description="Recipients list")
    
    # Security validations
    @validator('name')
    def validate_name(cls, v):
        # Prevent XSS and injection
        if re.search(r'[<>"\']', v):
            raise ValueError("Invalid characters in name")
        return v.strip()
    
    @validator('subject')
    def validate_subject(cls, v):
        # Prevent header injection
        if re.search(r'[\r\n]', v):
            raise ValueError("Invalid characters in subject")
        return v.strip()
    
    @validator('recipients')
    def validate_recipients(cls, v):
        email_pattern = re.compile(
            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        )
        
        for recipient in v:
            if not isinstance(recipient, dict):
                raise ValueError("Invalid recipient format")
            
            email = recipient.get('email', '')
            if not email_pattern.match(email):
                raise ValueError(f"Invalid email address: {email}")
                
            # Sanitize personalization data
            if 'personalization' in recipient:
                recipient['personalization'] = cls._sanitize_personalization(
                    recipient['personalization']
                )
        
        return v
    
    @classmethod
    def _sanitize_personalization(cls, data: dict) -> dict:
        """Sanitize personalization data to prevent injection."""
        if not isinstance(data, dict):
            return {}
        
        sanitized = {}
        for key, value in data.items():
            # Only allow safe string/number values
            if isinstance(value, (str, int, float, bool)):
                if isinstance(value, str):
                    # Basic XSS prevention
                    sanitized[key] = value.replace('<', '<').replace('>', '>')
                else:
                    sanitized[key] = value
        return sanitized
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

```python
# Optimized database queries
from sqlalchemy.orm import joinedload, selectinload
from typing import List, Optional

class OptimizedCampaignService:
    """Service with performance-optimized database operations."""
    
    async def get_campaign_with_metrics(self, campaign_id: str) -> Optional[Campaign]:
        """Eager load related data to minimize N+1 queries."""
        return await self.db.query(Campaign)
        .options(
            selectinload(Campaign.recipients),  # Batch load recipients
            joinedload(Campaign.user),          # Join with user table
            selectinload(Campaign.analytics)    # Load analytics in one query
        )
        .filter(Campaign.id == campaign_id)
        .first()
    
    async def get_campaigns_batch(self, user_id: str, limit: int = 50) -> List[Campaign]:
        """Efficiently load campaigns with pagination."""
        return await self.db.query(Campaign)
        .options(
            selectinload(Campaign.recipients),
            selectinload(Campaign.analytics)
        )
        .filter(Campaign.user_id == user_id)
        .order_by(Campaign.created_at.desc())
        .limit(limit)
        .all()
    
    async def search_campaigns(self, query: str, user_id: str) -> List[Campaign]:
        """Use database-level search for better performance."""
        return await self.db.query(Campaign)
        .options(selectinload(Campaign.recipients))
        .filter(
            and_(
                Campaign.user_id == user_id,
                or_(
                    Campaign.name.ilike(f"%{query}%"),
                    Campaign.subject.ilike(f"%{query}%")
                )
            )
        )
        .all()
```

### Caching Strategy

```python
# Efficient caching implementation
import redis.asyncio as redis
from typing import Any, Optional
import json
import time

class CacheService:
    def __init__(self, redis_url: str):
        self.redis = redis.from_url(redis_url)
    
    async def get(self, key: str) -> Optional[Any]:
        """Get value from cache with error handling."""
        try:
            value = await self.redis.get(key)
            return json.loads(value) if value else None
        except Exception as e:
            # Log error but don't fail the main operation
            logger.warning(f"Cache get failed for key {key}: {e}")
            return None
    
    async def set(self, key: str, value: Any, expire: int = 3600) -> bool:
        """Set value in cache with expiration."""
        try:
            await self.redis.setex(
                key,
                expire,
                json.dumps(value, default=str)
            )
            return True
        except Exception as e:
            logger.warning(f"Cache set failed for key {key}: {e}")
            return False
    
    async def invalidate_pattern(self, pattern: str) -> int:
        """Invalidate multiple keys matching a pattern."""
        try:
            keys = await self.redis.keys(pattern)
            if keys:
                return await self.redis.delete(*keys)
            return 0
        except Exception as e:
            logger.warning(f"Cache invalidate failed for pattern {pattern}: {e}")
            return 0

class CampaignCacheDecorator:
    def __init__(self, cache_service: CacheService):
        self.cache = cache_service
        self.default_ttl = 300  # 5 minutes
    
    def cached_campaign(self, ttl: Optional[int] = None):
        """Decorator for caching campaign data."""
        def decorator(func):
            @wraps(func)
            async def wrapper(campaign_id: str, *args, **kwargs):
                cache_key = f"campaign:{campaign_id}"
                
                # Try cache first
                cached = await self.cache.get(cache_key)
                if cached is not None:
                    return cached
                
                # Get from database
                result = await func(campaign_id, *args, **kwargs)
                
                # Cache result
                if result:
                    await self.cache.set(cache_key, result, ttl or self.default_ttl)
                
                return result
            return wrapper
        return decorator
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