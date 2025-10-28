# **PenguinMails Third-Party Integration Guide**

> **Status**: Current | **Last Updated**: October 28, 2025

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
  apiKey: string;
  databaseId: string;
  workspace: string;
  tenantId?: string;
}

const nileDBIntegration = {
  connection: {
    host: 'db.thenile.dev',
    port: 5432,
    database: databaseId,
    user: 'api_key',
    password: apiKey,
    ssl: true,
    application_name: 'penguinmails'
  },
  tenantIsolation: {
    // Automatic tenant isolation using RLS
    defaultTenant: () => `
      SELECT set_config('app.current_tenant', '${tenantId}', false);
    `,
    tenantContext: (tenantId: string) => `
      SELECT nile.current_tenant('${tenantId}');
    `
  },
  multiTenancy: {
    createTenant: (tenantName: string, adminEmail: string) => `
      INSERT INTO tenants (name, admin_email, created_at)
      VALUES ('${tenantName}', '${adminEmail}', CURRENT_TIMESTAMP)
      RETURNING id;
    `,
    switchTenant: (tenantId: string) => `
      SELECT nile.current_tenant('${tenantId}');
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

---

## Related Documents
- [API Reference](api_reference.md) - Complete API documentation
- [Security & Privacy](security_privacy.md) - Security policies and procedures
- [Infrastructure Documentation](infrastructure_documentation.md) - System architecture
- [Development Guidelines](development_guidelines.md) - Code standards and practices
- [Environment & Release Management](environment_release.md) - Deployment processes

**Keywords**: third-party integrations, API integrations, webhooks, OAuth, Mailgun, SendGrid, Stripe, PostHog, NileDB, rate limiting, error handling, monitoring