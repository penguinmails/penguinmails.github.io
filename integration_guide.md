---
last_modified_date: "2025-10-28"
---

# **PenguinMails Third-Party Integration Guide**

---

## 1. **Purpose**

This guide provides comprehensive documentation for integrating PenguinMails with third-party services and platforms. It covers API integrations, webhook configurations, authentication methods, and best practices for maintaining reliable and secure connections with external systems.

## 2. **Integration Architecture**

### **Integration Types**
- **API Integrations**: RESTful API connections for data exchange
- **Webhook Integrations**: Real-time event notifications
- **OAuth Integrations**: Secure authentication flows
- **Embedded Integrations**: Third-party widgets and components
- **Database Integrations**: Direct data synchronization

### **Integration Framework**
```typescript
interface Integration {
  id: string;
  name: string;
  category: IntegrationCategory;
  provider: string;
  status: IntegrationStatus;
  configuration: IntegrationConfig;
  authentication: AuthenticationMethod;
  endpoints: IntegrationEndpoint[];
  webhooks?: WebhookConfig[];
  rateLimits: RateLimitConfig;
  errorHandling: ErrorHandlingConfig;
  monitoring: MonitoringConfig;
}

enum IntegrationCategory {
  EMAIL_SERVICE = 'email_service',
  PAYMENT_PROCESSOR = 'payment_processor',
  ANALYTICS = 'analytics',
  CRM = 'crm',
  MARKETING_AUTOMATION = 'marketing_automation',
  SOCIAL_MEDIA = 'social_media',
  STORAGE = 'storage',
  COMMUNICATION = 'communication'
}

enum IntegrationStatus {
  ACTIVE = 'active',
  INACTIVE = 'inactive',
  ERROR = 'error',
  MAINTENANCE = 'maintenance',
  DEPRECATED = 'deprecated'
}
```

## 3. **Core Service Integrations**

### **Email Service Providers (ESP)**

#### **Mailgun Integration**
```typescript
interface MailgunConfig {
  apiKey: string;
  domain: string;
  webhookSigningKey: string;
  baseUrl: string;
  rateLimit: {
    requestsPerMinute: number;
    requestsPerHour: number;
  };
}

interface MailgunWebhookEvent {
  event: 'delivered' | 'bounced' | 'complained' | 'unsubscribed' | 'clicked';
  recipient: string;
  campaignId?: string;
  timestamp: Date;
  metadata: Record<string, any>;
}

// Integration setup
const mailgunIntegration = {
  sending: {
    endpoint: 'https://api.mailgun.net/v3/{domain}/messages',
    method: 'POST',
    headers: {
      'Authorization': 'Basic ' + btoa('api:' + apiKey),
      'Content-Type': 'multipart/form-data'
    },
    body: {
      from: 'sender@domain.com',
      to: ['recipient@example.com'],
      subject: 'Campaign Subject',
      html: '<html>Campaign content</html>',
      'v:campaign-id': campaignId,
      'v:recipient-id': recipientId
    }
  },
  webhooks: {
    endpoint: '/api/webhooks/mailgun',
    events: ['delivered', 'bounced', 'complained', 'unsubscribed', 'clicked'],
    signature: 'X-Mailgun-Signature'
  }
};
```

#### **SendGrid Integration**
```typescript
interface SendGridConfig {
  apiKey: string;
  webhookVerificationKey: string;
  ipPool?: string;
  subuser?: string;
}

const sendGridIntegration = {
  sending: {
    endpoint: 'https://api.sendgrid.com/v3/mail/send',
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${apiKey}`,
      'Content-Type': 'application/json'
    },
    body: {
      personalizations: [{
        to: [{ email: 'recipient@example.com' }],
        dynamic_template_data: { campaignId, recipientId }
      }],
      from: { email: 'sender@domain.com' },
      template_id: templateId,
      custom_args: { campaignId, recipientId }
    }
  },
  webhooks: {
    endpoint: '/api/webhooks/sendgrid',
    events: ['delivered', 'bounce', 'spamreport', 'unsubscribe', 'click'],
    signature: 'X-Twilio-Email-Event-Webhook-Signature'
  }
};
```

### **Payment Processing**

#### **Stripe Connect Integration**
```typescript
interface StripeConnectConfig {
  publishableKey: string;
  secretKey: string;
  webhookSecret: string;
  connectAccountId?: string;
  applicationFee: number; // percentage
}

const stripeIntegration = {
  accountCreation: {
    endpoint: 'https://api.stripe.com/v2/accounts',
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${secretKey}`,
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: {
      type: 'express',
      country: 'US',
      email: accountEmail,
      capabilities: {
        card_payments: { requested: true },
        transfers: { requested: true }
      }
    }
  },
  onboarding: {
    endpoint: 'https://api.stripe.com/v2/account_links',
    method: 'POST',
    body: {
      account: accountId,
      refresh_url: `${baseUrl}/settings/billing`,
      return_url: `${baseUrl}/settings/billing`,
      type: 'account_onboarding'
    }
  },
  webhooks: {
    endpoint: '/api/webhooks/stripe',
    events: [
      'account.updated',
      'capability.updated',
      'payment_intent.succeeded',
      'payment_intent.payment_failed',
      'invoice.payment_succeeded',
      'invoice.payment_failed'
    ],
    signature: 'Stripe-Signature'
  }
};
```

### **Analytics and Tracking**

#### **PostHog Integration**
```typescript
interface PostHogConfig {
  apiKey: string;
  host: string;
  personalApiKey?: string;
  projectId: string;
}

const postHogIntegration = {
  tracking: {
    initialization: `
      import { PostHog } from 'posthog-js';

      postHog.init('${apiKey}', {
        api_host: '${host}',
        capture_pageview: true,
        capture_pageleave: true,
        persistence: 'localStorage'
      });
    `,
    eventTracking: {
      campaignSent: (campaignId: string, recipientCount: number) => {
        posthog.capture('campaign_sent', {
          campaign_id: campaignId,
          recipient_count: recipientCount,
          timestamp: new Date().toISOString()
        });
      },
      campaignOpened: (campaignId: string, recipientId: string) => {
        posthog.capture('campaign_opened', {
          campaign_id: campaignId,
          recipient_id: recipientId,
          timestamp: new Date().toISOString()
        });
      }
    },
    userIdentification: {
      identify: (userId: string, traits: Record<string, any>) => {
        posthog.identify(userId, traits);
      },
      group: (organizationId: string, properties: Record<string, any>) => {
        posthog.group('organization', organizationId, properties);
      }
    }
  },
  api: {
    eventsEndpoint: `${host}/capture`,
    personsEndpoint: `${host}/api/persons`,
    featureFlagsEndpoint: `${host}/api/feature_flag`
  }
};
```

### **Database Integration**

#### **NileDB Integration**
```typescript
interface NileDBConfig {
  projectId: string;
  apiKey: string;
  databaseUrl: string;
  tenantId?: string;
}

const nileDBIntegration = {
  connection: {
    host: 'db.thenile.dev',
    port: 5432,
    database: 'penguinmails',
    user: 'api_key',
    password: apiKey,
    ssl: true,
    application_name: 'penguinmails'
  },
  authentication: {
    // Core authentication managed by NileDB
    signup: async (email: string, password: string, userData: any) => {
      // NileDB handles user creation and authentication
      const user = await nile.auth.signup({
        email,
        password,
        data: {
          ...userData,
          email_verified: false,
          onboarding_step: 'verify'
        }
      });
      return user;
    },
    signin: async (email: string, password: string) => {
      // Session management via NileDB
      const { user, session } = await nile.auth.signin({
        email,
        password
      });
      return { user, session };
    },
    validateSession: async (token: string) => {
      const user = await nile.auth.verifyToken(token);
      return user;
    }
  },
  tenantIsolation: {
    // Row Level Security for multi-tenant data isolation
    tenantContext: (tenantId: string) => `
      SELECT nile.current_tenant('${tenantId}');
    `,
    userTenantCheck: (userId: string, tenantId: string) => `
      SELECT EXISTS(
        SELECT 1 FROM tenant_users
        WHERE user_id = '${userId}' AND tenant_id = '${tenantId}'
      );
    `
  },
  profileManagement: {
    // Application layer profile extensions
    getUserWithProfile: (userId: string) => `
      SELECT
        u.*,
        tu.roles,
        up.theme, up.language, up.timezone,
        up.email_notifications, up.push_notifications,
        s.is_staff as isPenguinMailsStaff
      FROM users u
      LEFT JOIN tenant_users tu ON u.id = tu.user_id
      LEFT JOIN user_preferences up ON u.id = up.user_id
      LEFT JOIN staff_members s ON u.id = s.user_id
      WHERE u.id = '${userId}';
    `,
    updatePreferences: (userId: string, preferences: any) => `
      INSERT INTO user_preferences (user_id, tenant_id, theme, language, timezone,
                                   email_notifications, push_notifications,
                                   weekly_reports, marketing_emails, created_at, updated_at)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      ON CONFLICT (user_id, tenant_id) DO UPDATE SET
        theme = EXCLUDED.theme,
        language = EXCLUDED.language,
        timezone = EXCLUDED.timezone,
        email_notifications = EXCLUDED.email_notifications,
        push_notifications = EXCLUDED.push_notifications,
        weekly_reports = EXCLUDED.weekly_reports,
        marketing_emails = EXCLUDED.marketing_emails,
        updated = CURRENT_TIMESTAMP;
    `
  },
  multiTenancy: {
    createTenant: (tenantName: string, adminEmail: string) => `
      INSERT INTO tenants (name, domain, settings, status, created_at, updated_at)
      VALUES ('${tenantName}', '${adminEmail.split('@')[1]}', '{}', 'active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      RETURNING id;
    `,
    linkUserToTenant: (tenantId: string, userId: string, role: string) => `
      INSERT INTO tenant_users (tenant_id, user_id, roles, email, created, updated)
      VALUES ('${tenantId}', '${userId}', '["${role}"]', (SELECT email FROM users WHERE id = '${userId}'), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      ON CONFLICT (tenant_id, user_id) DO UPDATE SET
        roles = EXCLUDED.roles,
        updated = CURRENT_TIMESTAMP;
    `
  }
};
```

## 4. **Webhook Management**

### **Webhook Architecture**
```typescript
interface WebhookConfig {
  id: string;
  url: string;
  events: string[];
  secret?: string;
  headers?: Record<string, string>;
  retryPolicy: RetryPolicy;
  rateLimit?: RateLimitConfig;
  filters?: WebhookFilter[];
}

interface RetryPolicy {
  maxAttempts: number;
  backoffStrategy: 'linear' | 'exponential';
  baseDelay: number; // milliseconds
  maxDelay: number;  // milliseconds
}

interface WebhookFilter {
  eventType: string;
  conditions: Record<string, any>;
}

// Webhook processing pipeline
class WebhookProcessor {
  async processWebhook(provider: string, payload: any, signature?: string) {
    // 1. Verify signature
    if (signature) {
      await this.verifySignature(provider, payload, signature);
    }

    // 2. Parse event
    const event = await this.parseEvent(provider, payload);

    // 3. Apply filters
    if (!this.matchesFilters(event, webhookConfig.filters)) {
      return;
    }

    // 4. Process event
    await this.processEvent(event);

    // 5. Send acknowledgment
    return { status: 'processed', eventId: event.id };
  }

  private async verifySignature(provider: string, payload: any, signature: string) {
    const secret = this.getWebhookSecret(provider);
    const expectedSignature = crypto
      .createHmac('sha256', secret)
      .update(JSON.stringify(payload))
      .digest('hex');

    if (signature !== expectedSignature) {
      throw new Error('Invalid webhook signature');
    }
  }
}
```

### **Webhook Event Processing**
```typescript
interface WebhookEvent {
  id: string;
  provider: string;
  eventType: string;
  payload: any;
  metadata: {
    timestamp: Date;
    userAgent: string;
    ipAddress: string;
    retryCount: number;
  };
}

// Event processing by provider
const eventProcessors = {
  mailgun: {
    delivered: async (event: WebhookEvent) => {
      const { recipient, 'v:campaign-id': campaignId } = event.payload;
      await updateEmailStatus(campaignId, recipient, 'delivered');
      await trackDeliveryMetrics(campaignId, recipient);
    },
    bounced: async (event: WebhookEvent) => {
      const { recipient, 'v:campaign-id': campaignId } = event.payload;
      await updateEmailStatus(campaignId, recipient, 'bounced');
      await handleBounce(campaignId, recipient);
    }
  },
  stripe: {
    'payment_intent.succeeded': async (event: WebhookEvent) => {
      const { id, amount, currency } = event.payload.data.object;
      await recordPayment(id, amount, currency, 'succeeded');
      await updateSubscriptionStatus(id, 'active');
    },
    'invoice.payment_failed': async (event: WebhookEvent) => {
      const { subscription } = event.payload.data.object;
      await handleFailedPayment(subscription);
      await notifyCustomer(subscription);
    }
  }
};
```

## 5. **OAuth Integration**

### **OAuth 2.0 Flow Implementation**
```typescript
interface OAuthConfig {
  clientId: string;
  clientSecret: string;
  authorizationUrl: string;
  tokenUrl: string;
  scopes: string[];
  redirectUri: string;
}

class OAuthIntegration {
  async initiateAuthorization(provider: string) {
    const config = this.getOAuthConfig(provider);
    const state = this.generateState();

    const authUrl = new URL(config.authorizationUrl);
    authUrl.searchParams.set('client_id', config.clientId);
    authUrl.searchParams.set('redirect_uri', config.redirectUri);
    authUrl.searchParams.set('scope', config.scopes.join(' '));
    authUrl.searchParams.set('state', state);
    authUrl.searchParams.set('response_type', 'code');

    // Store state for verification
    await this.storeState(state, provider);

    return authUrl.toString();
  }

  async handleCallback(provider: string, code: string, state: string) {
    // Verify state
    const storedState = await this.getStoredState(provider);
    if (state !== storedState) {
      throw new Error('Invalid OAuth state');
    }

    // Exchange code for tokens
    const config = this.getOAuthConfig(provider);
    const tokenResponse = await fetch(config.tokenUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': `Basic ${btoa(`${config.clientId}:${config.clientSecret}`)}`
      },
      body: new URLSearchParams({
        grant_type: 'authorization_code',
        code,
        redirect_uri: config.redirectUri
      })
    });

    const tokens = await tokenResponse.json();
    await this.storeTokens(provider, tokens);

    return tokens;
  }

  async refreshToken(provider: string) {
    const config = this.getOAuthConfig(provider);
    const refreshToken = await this.getRefreshToken(provider);

    const tokenResponse = await fetch(config.tokenUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': `Basic ${btoa(`${config.clientId}:${config.clientSecret}`)}`
      },
      body: new URLSearchParams({
        grant_type: 'refresh_token',
        refresh_token: refreshToken
      })
    });

    const tokens = await tokenResponse.json();
    await this.updateTokens(provider, tokens);

    return tokens;
  }
}
```

### **Supported OAuth Providers**
```typescript
const oauthProviders = {
  google: {
    authorizationUrl: 'https://accounts.google.com/o/oauth2/auth',
    tokenUrl: 'https://oauth2.googleapis.com/token',
    scopes: ['https://www.googleapis.com/auth/gmail.send', 'https://www.googleapis.com/auth/contacts'],
    userInfoUrl: 'https://www.googleapis.com/oauth2/v2/userinfo'
  },
  microsoft: {
    authorizationUrl: 'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
    tokenUrl: 'https://login.microsoftonline.com/common/oauth2/v2.0/token',
    scopes: ['https://graph.microsoft.com/Mail.Send', 'https://graph.microsoft.com/Contacts.Read'],
    userInfoUrl: 'https://graph.microsoft.com/v1.0/me'
  },
  hubspot: {
    authorizationUrl: 'https://app.hubspot.com/oauth/authorize',
    tokenUrl: 'https://api.hubapi.com/oauth/v1/token',
    scopes: ['contacts', 'content'],
    userInfoUrl: 'https://api.hubapi.com/oauth/v1/access-tokens/{token}'
  }
};
```

## 6. **Integration Monitoring**

### **Health Monitoring**
```typescript
interface IntegrationHealth {
  integrationId: string;
  status: 'healthy' | 'degraded' | 'unhealthy';
  lastCheck: Date;
  responseTime: number;
  errorRate: number;
  metrics: {
    requestsTotal: number;
    requestsSuccessful: number;
    requestsFailed: number;
    averageResponseTime: number;
    uptimePercentage: number;
  };
  alerts: IntegrationAlert[];
}

interface IntegrationAlert {
  id: string;
  type: 'error_rate' | 'response_time' | 'connectivity' | 'quota_exceeded';
  severity: 'low' | 'medium' | 'high' | 'critical';
  message: string;
  timestamp: Date;
  resolved: boolean;
}

// Health check implementation
class IntegrationHealthChecker {
  async checkHealth(integration: Integration): Promise<IntegrationHealth> {
    const startTime = Date.now();

    try {
      // Perform health check based on integration type
      const result = await this.performHealthCheck(integration);

      const responseTime = Date.now() - startTime;
      const status = this.determineStatus(result, responseTime);

      return {
        integrationId: integration.id,
        status,
        lastCheck: new Date(),
        responseTime,
        errorRate: this.calculateErrorRate(integration),
        metrics: await this.gatherMetrics(integration),
        alerts: await this.checkAlerts(integration)
      };
    } catch (error) {
      return {
        integrationId: integration.id,
        status: 'unhealthy',
        lastCheck: new Date(),
        responseTime: Date.now() - startTime,
        errorRate: 1,
        metrics: this.getDefaultMetrics(),
        alerts: [{
          id: generateId(),
          type: 'connectivity',
          severity: 'high',
          message: `Health check failed: ${error.message}`,
          timestamp: new Date(),
          resolved: false
        }]
      };
    }
  }
}
```

### **Integration Dashboard**
```typescript
interface IntegrationDashboard {
  summary: {
    totalIntegrations: number;
    activeIntegrations: number;
    failingIntegrations: number;
    averageHealthScore: number;
  };
  integrations: IntegrationHealth[];
  recentAlerts: IntegrationAlert[];
  performanceTrends: {
    responseTime: TimeSeriesData;
    errorRate: TimeSeriesData;
    throughput: TimeSeriesData;
  };
}

// Dashboard data aggregation
const generateDashboard = async (): Promise<IntegrationDashboard> => {
  const integrations = await getAllIntegrations();
  const healthChecks = await Promise.all(
    integrations.map(integration => healthChecker.checkHealth(integration))
  );

  const summary = {
    totalIntegrations: integrations.length,
    activeIntegrations: healthChecks.filter(h => h.status === 'healthy').length,
    failingIntegrations: healthChecks.filter(h => h.status === 'unhealthy').length,
    averageHealthScore: healthChecks.reduce((sum, h) => sum + getHealthScore(h), 0) / healthChecks.length
  };

  return {
    summary,
    integrations: healthChecks,
    recentAlerts: await getRecentAlerts(),
    performanceTrends: await getPerformanceTrends()
  };
};
```

## 7. **Error Handling and Recovery**

### **Integration Error Types**
```typescript
enum IntegrationErrorType {
  AUTHENTICATION_ERROR = 'authentication_error',
  AUTHORIZATION_ERROR = 'authorization_error',
  RATE_LIMIT_ERROR = 'rate_limit_error',
  NETWORK_ERROR = 'network_error',
  API_ERROR = 'api_error',
  DATA_ERROR = 'data_error',
  CONFIGURATION_ERROR = 'configuration_error',
  QUOTA_ERROR = 'quota_error'
}

interface IntegrationError {
  type: IntegrationErrorType;
  message: string;
  details: any;
  retryable: boolean;
  retryAfter?: number; // seconds
  incidentId?: string;
}

// Error handling strategy
const handleIntegrationError = async (
  integration: Integration,
  error: IntegrationError
): Promise<void> => {
  // Log error
  await logIntegrationError(integration.id, error);

  // Update integration status
  if (error.type === IntegrationErrorType.AUTHENTICATION_ERROR) {
    await updateIntegrationStatus(integration.id, 'error');
  }

  // Handle retry logic
  if (error.retryable) {
    await scheduleRetry(integration.id, error.retryAfter || 60);
  }

  // Send notifications
  if (error.type === IntegrationErrorType.API_ERROR) {
    await notifyIntegrationTeam(integration, error);
  }

  // Update monitoring
  await updateHealthMetrics(integration.id, error);
};
```

### **Circuit Breaker Pattern**
```typescript
interface CircuitBreakerConfig {
  failureThreshold: number;     // Number of failures to trip
  recoveryTimeout: number;      // Time to wait before attempting recovery
  monitoringPeriod: number;     // Time window for failure counting
}

class CircuitBreaker {
  private state: 'closed' | 'open' | 'half-open' = 'closed';
  private failures = 0;
  private lastFailureTime = 0;

  async execute<T>(operation: () => Promise<T>): Promise<T> {
    if (this.state === 'open') {
      if (Date.now() - this.lastFailureTime > this.config.recoveryTimeout) {
        this.state = 'half-open';
      } else {
        throw new Error('Circuit breaker is open');
      }
    }

    try {
      const result = await operation();
      this.onSuccess();
      return result;
    } catch (error) {
      this.onFailure();
      throw error;
    }
  }

  private onSuccess() {
    this.failures = 0;
    this.state = 'closed';
  }

  private onFailure() {
    this.failures++;
    this.lastFailureTime = Date.now();

    if (this.failures >= this.config.failureThreshold) {
      this.state = 'open';
    }
  }
}
```

## 8. **Security Considerations**

### **API Key Management**
```typescript
interface APIKeyConfig {
  key: string;
  provider: string;
  environment: string;
  permissions: string[];
  rateLimits: RateLimitConfig;
  expiration?: Date;
  rotationSchedule?: 'monthly' | 'quarterly' | 'never';
}

// Secure key storage and rotation
class APIKeyManager {
  async storeKey(config: APIKeyConfig): Promise<void> {
    const encryptedKey = await this.encryptKey(config.key);
    await this.vault.store(`integrations/${config.provider}/keys/${config.environment}`, {
      key: encryptedKey,
      permissions: config.permissions,
      created: new Date(),
      expires: config.expiration
    });
  }

  async rotateKey(provider: string, environment: string): Promise<void> {
    const oldKey = await this.getKey(provider, environment);
    const newKey = await this.generateNewKey(provider);

    // Test new key
    await this.testKey(provider, newKey);

    // Update configuration
    await this.updateConfiguration(provider, environment, newKey);

    // Revoke old key
    await this.revokeKey(provider, oldKey);

    // Update storage
    await this.storeKey({
      ...oldKey,
      key: newKey,
      created: new Date()
    });
  }
}
```

### **Data Protection**
- **Encryption**: All integration data encrypted in transit and at rest
- **Access Control**: Least privilege access to integration credentials
- **Audit Logging**: Complete audit trail of all integration activities
- **Data Minimization**: Only collect necessary data for integration functionality

## 9. **Performance Optimization**

### **Caching Strategies**
```typescript
interface CacheConfig {
  strategy: 'write-through' | 'write-behind' | 'read-through';
  ttl: number;              // Time to live in seconds
  maxSize: number;          // Maximum cache size
  evictionPolicy: 'lru' | 'lfu' | 'fifo';
}

// Integration response caching
class IntegrationCache {
  async get<T>(key: string, fetcher: () => Promise<T>): Promise<T> {
    const cached = await this.cache.get(key);
    if (cached && !this.isExpired(cached)) {
      return cached.data;
    }

    const data = await fetcher();
    await this.cache.set(key, { data, timestamp: Date.now() });
    return data;
  }

  private isExpired(entry: CacheEntry): boolean {
    return Date.now() - entry.timestamp > this.config.ttl * 1000;
  }
}
```

### **Rate Limiting**
```typescript
interface RateLimitConfig {
  requestsPerSecond?: number;
  requestsPerMinute?: number;
  requestsPerHour?: number;
  burstLimit?: number;
  strategy: 'fixed-window' | 'sliding-window' | 'token-bucket';
}

// Rate limiter implementation
class RateLimiter {
  private requests = new Map<string, number[]>();

  async checkLimit(identifier: string, config: RateLimitConfig): Promise<boolean> {
    const now = Date.now();
    const windowSize = this.getWindowSize(config);
    const maxRequests = this.getMaxRequests(config);

    const userRequests = this.requests.get(identifier) || [];
    const windowStart = now - windowSize;

    // Remove old requests outside the window
    const recentRequests = userRequests.filter(time => time > windowStart);

    if (recentRequests.length >= maxRequests) {
      return false; // Rate limit exceeded
    }

    // Add current request
    recentRequests.push(now);
    this.requests.set(identifier, recentRequests);

    return true; // Within limits
  }
}
```

## 10. **Support System Integration**

### **Current Integration Points (Production)**

#### **Dashboard Header Integration**
**File**: `components/layout/components/DashboardHeader.tsx`
**Status**: ✅ Production Ready

```tsx
// Current help center integration
const HelpCenterIntegration = () => {
  const helpLinks = [
    {
      name: 'Knowledge Base',
      url: 'https://help.penguinmails.com/knowledge-base',
      category: 'self-service',
      icon: 'BookOpenIcon'
    },
    {
      name: 'Support',
      url: 'https://help.penguinmails.com/support',
      category: 'contact',
      icon: 'SupportIcon'
    },
    {
      name: 'Video Tutorials',
      url: 'https://help.penguinmails.com/video-tutorials',
      category: 'learning',
      icon: 'PlayIcon'
    },
    {
      name: 'Glossary',
      url: 'https://help.penguinmails.com/glossary',
      category: 'reference',
      icon: 'GlossaryIcon'
    },
    {
      name: 'Our Services',
      url: 'https://help.penguinmails.com/our-services',
      category: 'information',
      icon: 'ServiceIcon'
    }
  ];

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="ghost" size="sm" className="gap-2">
          <HelpCircleIcon className="h-4 w-4" />
          <span>Help</span>
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end" className="w-56">
        <DropdownMenuLabel>Help & Support</DropdownMenuLabel>
        <DropdownMenuSeparator />
        {helpLinks.map((link) => (
          <DropdownMenuItem key={link.name} asChild>
            <a
              href={link.url}
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center gap-3"
            >
              <link.icon className="h-4 w-4 text-muted-foreground" />
              <div className="flex flex-col">
                <span className="font-medium">{link.name}</span>
                <span className="text-xs text-muted-foreground capitalize">
                  {link.category.replace('-', ' ')}
                </span>
              </div>
            </a>
          </DropdownMenuItem>
        ))}
      </DropdownMenuContent>
    </DropdownMenu>
  );
};
```

#### **Support Email Integration**
**File**: `components/support/SupportButton.tsx`
**Status**: ✅ Production Ready

```tsx
// Current email-based support system
const EmailSupportButton = () => {
  const handleSupportClick = () => {
    const userInfo = getCurrentUserInfo();
    const tenantInfo = getCurrentTenantInfo();

    const subject = encodeURIComponent(
      `[Support] ${tenantInfo.name} - ${getSupportIssueType()}`
    );

    const body = encodeURIComponent(`
Hi PenguinMails Support Team,

I need assistance with:

[Please describe your issue here]

---
Customer Information:
- Company: ${tenantInfo.name}
- User: ${userInfo.name} (${userInfo.email})
- Plan: ${tenantInfo.plan || 'Unknown'}
- Account Created: ${tenantInfo.created}
- Last Login: ${userInfo.lastLogin}

Technical Information:
- Browser: ${navigator.userAgent}
- URL: ${window.location.href}
- Timestamp: ${new Date().toISOString()}
- Version: ${process.env.NEXT_PUBLIC_APP_VERSION}

Please include this information when responding.

Best regards,
${userInfo.name}
    `);

    // Create mailto link
    const mailtoLink = `mailto:support@penguinmails.com?subject=${subject}&body=${body}`;
    window.location.href = mailtoLink;

    // Track support button click
    posthog.capture('support_button_click', {
      source: 'floating_button',
      user_id: userInfo.id,
      tenant_id: tenantInfo.id
    });
  };

  return (
    <div className="fixed bottom-6 right-6 z-50">
      <Button
        onClick={handleSupportClick}
        className="h-14 w-14 rounded-full shadow-lg hover:shadow-xl transition-all duration-200 bg-primary hover:bg-primary/90"
        size="lg"
        aria-label="Contact Support"
      >
        <MessageCircleIcon className="h-6 w-6" />
      </Button>

      {/* Tooltip */}
      <div className="absolute bottom-16 right-0 opacity-0 group-hover:opacity-100 transition-opacity">
        <div className="bg-gray-900 text-white text-sm px-3 py-2 rounded-lg whitespace-nowrap">
          Contact Support
          <div className="absolute top-full left-1/2 transform -translate-x-1/2 border-4 border-transparent border-t-gray-900"></div>
        </div>
      </div>
    </div>
  );
};
```

### **Planned Support System Enhancements (2027)**

#### **Ticket System Integration**
**Phase**: 2027 Q1
**Strategy**: Gradual migration with dual-running period

```typescript
// Ticket system integration
class TicketSystemIntegration {
  async createSupportTicket(supportRequest: SupportRequest) {
    // Create ticket in new system
    const ticket = await this.ticketService.create({
      subject: supportRequest.subject,
      description: supportRequest.description,
      customerEmail: supportRequest.email,
      customerName: supportRequest.name,
      priority: supportRequest.priority,
      category: supportRequest.category,
      metadata: {
        source: 'website_form',
        user_id: supportRequest.userId,
        tenant_id: supportRequest.tenantId,
        original_mailto_attempt: supportRequest.mailtoAttempted
      }
    });

    // Send confirmation to customer
    await this.sendTicketConfirmation(ticket);

    // Notify support team
    await this.notifySupportTeam(ticket);

    // Update analytics
    await this.trackTicketCreation(ticket);

    return ticket;
  }

  async migrateEmailToTicket(emailData: any) {
    const existingTicket = await this.findExistingTicket(emailData);

    if (existingTicket) {
      // Add email as message to existing ticket
      return await this.addMessageToTicket(existingTicket.id, {
        sender_type: 'customer',
        content: emailData.body,
        message_type: 'comment',
        metadata: {
          original_email_id: emailData.id,
          subject: emailData.subject
        }
      });
    } else {
      // Create new ticket from email
      return await this.createSupportTicket({
        subject: emailData.subject,
        description: emailData.body,
        email: emailData.from,
        name: emailData.fromName,
        priority: this.determinePriority(emailData),
        category: this.categorizeEmail(emailData),
        userId: null, // Email-based tickets may not have user accounts
        tenantId: null,
        mailtoAttempted: true
      });
    }
  }
}
```

#### **Knowledge Base Integration**
```typescript
// Knowledge base auto-suggestion
class KnowledgeBaseIntegration {
  async suggestArticles(ticketContent: string, category?: string) {
    const suggestions = await this.searchKnowledgeBase(ticketContent, {
      limit: 3,
      category: category,
      relevance_threshold: 0.7
    });

    return suggestions.map(article => ({
      title: article.title,
      url: article.url,
      snippet: article.snippet,
      relevance_score: article.score,
      auto_suggested: true
    }));
  }

  async addSuggestionsToTicket(ticketId: string, suggestions: any[]) {
    if (suggestions.length === 0) return;

    await this.ticketService.addInternalNote(ticketId, {
      content: `Auto-suggested knowledge base articles:\n\n${
        suggestions.map(s => `- [${s.title}](${s.url}) - ${s.snippet}`).join('\n')
      }`,
      message_type: 'auto_suggestion',
      metadata: {
        suggestions: suggestions,
        generated_at: new Date().toISOString()
      }
    });
  }
}
```

### **Support Analytics & Monitoring**

#### **Support System Metrics**
```typescript
// Support analytics tracking
class SupportAnalytics {
  async trackSupportRequest(request: SupportRequest, response: any) {
    const metrics = {
      request_category: request.category,
      request_priority: request.priority,
      customer_tier: request.customerTier,
      routing_channel: response.method || 'ticket',
      resolution_time: response.resolutionTime,
      customer_satisfaction: response.satisfaction,
      deflected_to_kb: response.deflectedToKnowledgeBase,
      escalated: response.escalated,
      timestamp: new Date().toISOString()
    };

    // Store in analytics database
    await this.storeSupportMetrics(metrics);

    // Real-time dashboard updates
    await this.updateRealTimeDashboard(metrics);

    // Alert on SLA breaches
    if (response.slaBreached) {
      await this.triggerSLAAlert(metrics);
    }
  }

  async generateSupportReport(dateRange: DateRange) {
    return {
      total_requests: await this.getTotalRequests(dateRange),
      average_resolution_time: await this.getAverageResolutionTime(dateRange),
      customer_satisfaction: await this.getCustomerSatisfaction(dateRange),
      sla_compliance_rate: await this.getSLAComplianceRate(dateRange),
      channel_breakdown: await this.getChannelBreakdown(dateRange),
      category_breakdown: await this.getCategoryBreakdown(dateRange),
      kb_deflection_rate: await this.getKBDeflectionRate(dateRange),
      support_cost_per_ticket: await this.getSupportCost(dateRange)
    };
  }
}
```

### **Migration Strategy**

#### **Phase 1: Parallel Running (2027 Q1)**
**Duration**: 4 weeks
**Strategy**: Both email and ticket systems active

```typescript
// Dual system support
class DualSupportSystem {
  async routeSupportRequest(request: SupportRequest) {
    // Determine routing based on request type and customer tier
    const routingDecision = this.determineRouting(request);

    switch (routingDecision.channel) {
      case 'ticket':
        return await this.createTicket(request);
      case 'email':
        return await this.sendEmailRequest(request);
      case 'chat':
        return await this.initiateChat(request);
      default:
        return await this.createTicket(request); // Default to tickets
    }
  }

  private determineRouting(request: SupportRequest): RoutingDecision {
    // Enterprise customers → tickets
    if (request.customerTier === 'enterprise') {
      return { channel: 'ticket', reason: 'enterprise_customer' };
    }

    // Complex technical issues → tickets
    if (request.category === 'technical' && request.complexity === 'high') {
      return { channel: 'ticket', reason: 'complex_technical_issue' };
    }

    // Simple questions → help center first
    if (request.category === 'general' && request.complexity === 'low') {
      return { channel: 'help_center_first', reason: 'simple_inquiry' };
    }

    // Default to tickets for tracking and analytics
    return { channel: 'ticket', reason: 'default_routing' };
  }
}
```

#### **Phase 2: Ticket System Primary (2027 Q2)**
**Duration**: 8 weeks
**Strategy**: Tickets as primary, email as fallback

#### **Phase 3: Full Migration (2027 Q3)**
**Duration**: 12 weeks
**Strategy**: Tickets only, email support deprecated

### **Success Metrics**
- **Current System (Email-Based)**: <24 hours response, 1,000+ emails/month manageable
- **Future System (Ticket-Based)**: <4 hours first response, 10,000+ tickets/month capacity

---

## Related Documents
- [API Reference](api_reference.md) - Complete API documentation
- [Security & Privacy](security_privacy.md) - Security policies and procedures
- [Infrastructure Documentation](infrastructure_documentation.md) - System architecture
- [Development Guidelines](development_guidelines.md) - Code standards and practices
- [Environment & Release Management](environment_release.md) - Deployment processes

**Keywords**: third-party integrations, API integrations, webhooks, OAuth, Mailgun, SendGrid, Stripe, PostHog, NileDB, rate limiting, error handling, monitoring, support system, ticket management, knowledge base, customer success