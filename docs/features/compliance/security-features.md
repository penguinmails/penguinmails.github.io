---
title: "Security Features"
description: "Comprehensive security infrastructure including SSL/TLS, authentication, encryption, and compliance controls"
level: "1"
status: "ACTIVE"
roadmap_timeline: "Q4 2025"
priority: "Critical"
related_features:


  - compliance/gdpr-compliance


  - compliance/data-privacy


  - infrastructure/email-infrastructure-setup


  - domains/domain-management


  - enterprise/user-management
related_tasks:


  - epic-1-project-foundation


  - epic-2-user-authentication-profile
---


# Security Features

**Quick Access**: Core security infrastructure protecting email sending, user data, and platform operations.

## Overview

PenguinMails implements comprehensive security controls across all platform layers, including email authentication (SPF, DKIM, DMARC), data encryption, secure access controls, and compliance-ready audit logging.

### Key Security Pillars

1. **Email Authentication**: SPF, DKIM, DMARC for sender verification

2. **Transport Security**: SSL/TLS encryption for all communications

3. **Data Encryption**: At-rest and in-transit encryption

4. **Access Control**: Role-based permissions and secure authentication

5. **Audit Logging**: Comprehensive activity tracking

6. **Compliance**: GDPR, CCPA, SOC2-ready controls

---

## Level 1: Core Security Quick Reference

### Email Authentication (SPF, DKIM, DMARC)

#### SPF (Sender Policy Framework)

**What It Does**: Specifies which mail servers can send email on behalf of your domain.

**Setup** (Automated during infrastructure setup):

```text

TXT Record: @ or yourdomain.com
Value: v=spf1 ip4:YOUR_VPS_IP ~all


```

**Best Practices:**

- Use `~all` (soft fail) initially, upgrade to `-all` (hard fail) after testing

- Include all authorized sending IPs

- Keep SPF record under 255 characters

- Avoid more than 10 DNS lookups

#### DKIM (DomainKeys Identified Mail)

**What It Does**: Cryptographic signature proving email authenticity.

**Setup** (Automated):

```text

TXT Record: default._domainkey.yourdomain.com
Value: v=DKIM1; k=rsa; p=YOUR_PUBLIC_KEY


```

**Best Practices:**

- Rotate DKIM keys quarterly

- Use 2048-bit keys minimum

- Monitor for validation failures

- Keep private keys secure and encrypted

#### DMARC (Domain-based Message Authentication)

**What It Does**: Policy instructing receivers how to handle failed SPF/DKIM checks.

**Setup** (Staged rollout recommended):

```text

Phase 1 (Monitoring):
TXT Record: _dmarc.yourdomain.com
Value: v=DMARC1; p=none; rua=mailto:dmarc@yourdomain.com

Phase 2 (Quarantine - after 30 days):
Value: v=DMARC1; p=quarantine; pct=10; rua=mailto:dmarc@yourdomain.com

Phase 3 (Reject - after 90 days):
Value: v=DMARC1; p=reject; rua=mailto:dmarc@yourdomain.com


```

**Best Practices:**

- Start with `p=none` to monitor

- Gradually increase `pct` (percentage)

- Review aggregate reports weekly

- Achieve 100% SPF+DKIM alignment before `p=reject`

### SSL/TLS Certificates

**Automatic Configuration:**

- Let's Encrypt SSL certificates auto-installed

- Auto-renewal 30 days before expiration

- TLS 1.2+ enforcement

- Strong cipher suite configuration

**Coverage:**

- SMTP connections (ports 465, 587)

- HTTPS for web dashboard

- API endpoints

**Monitoring:**

- 30-day expiration warning

- 7-day expiration alert

- 1-day expiration critical alert

### Data Encryption

#### At-Rest Encryption

**Database:**

- NileDB built-in encryption

- Sensitive fields individually encrypted (passwords, API keys, OAuth tokens)

- AES-256 encryption standard

**File Storage:**

- Email templates encrypted

- Uploaded files encrypted

- Backup encryption enabled

#### In-Transit Encryption

**All Communications Secured:**

- HTTPS for all web traffic (TLS 1.2+)

- SMTP TLS for email transmission

- API requests over HTTPS only

- WebSocket connections over WSS

### Secure Credential Storage

**Password Handling:**

- Bcrypt hashing (cost factor 12)

- Never stored in plaintext

- Password complexity requirements enforced

- Password reset with time-limited tokens

**API Keys & Secrets:**

- Encrypted at rest (AES-256)

- Never logged or exposed in errors

- Rotation supported

- Scoped permissions per key

**OAuth Tokens:**

- Encrypted storage

- Automatic expiration

- Refresh token rotation

- Revocation support

### Access Control

**Authentication:**

- NileDB SDK email/password authentication

- Secure session management

- CSRF protection enabled

- Rate limiting on auth endpoints

**Authorization:**

- Role-based access control (RBAC)

- Tenant-level isolation

- Workspace-level permissions

- Resource-level permissions

**Roles:**

- **Platform Admin**: Full system access

- **Tenant Admin**: Tenant-wide management

- **Workspace Owner**: Workspace management

- **Workspace Member**: Limited workspace access

- **API User**: Programmatic access only

---

## Level 2: Advanced Security Configuration

### Firewall & Network Security

#### VPS Firewall Rules

**Allowed Inbound:**

```text

Port 25   (SMTP)       - Email reception
Port 465  (SMTPS)      - Secure SMTP
Port 587  (Submission) - Email submission
Port 993  (IMAPS)      - Secure IMAP
Port 443  (HTTPS)      - Web traffic
Port 22   (SSH)        - Admin access (restricted IPs only)


```

**Blocked by Default:**

- All other ports

- Outbound connections restricted to necessary services

**IP Whitelisting:**

- SSH access limited to admin IPs

- API access can be IP-restricted per tenant

- SMTP relay can be IP-restricted

#### DDoS Protection

**Rate Limiting:**

```typescript
// API endpoints


- 100 requests/minute per IP (anonymous)


- 1000 requests/minute per authenticated user


- 10,000 requests/minute per API key

// SMTP


- 50 connections/minute per IP


- 500 emails/hour per account (configurable)


```

**Fail2ban Configuration:**

- Auto-ban after 5 failed auth attempts

- Ban duration: 1 hour (first), 24 hours (repeat)

- Email notification on bans

### Advanced Authentication Security

#### Session Security

**Configuration:**

```typescript
session: {
  secret: process.env.SESSION_SECRET, // Cryptographically random
  maxAge: 24 * 60 * 60 * 1000,       // 24 hours
  rolling: true,                      // Extend on activity
  httpOnly: true,                     // Prevent XSS
  secure: true,                       // HTTPS only
  sameSite: 'strict',                 // CSRF protection
}


```

**Session Management:**

- Automatic logout after 24 hours inactivity

- Concurrent session limit (5 per user)

- Session revocation on password change

- "Logout all devices" functionality

#### Password Policies

**Requirements:**

- Minimum 12 characters

- Must contain: uppercase, lowercase, number, special character

- Cannot contain email address or common words

- Password history: prevent reuse of last 5 passwords

- Maximum age: 90 days (configurable)

**Breach Detection:**

- Check against Have I Been Pwned database

- Warn users of compromised passwords

- Force reset if breach detected

#### Two-Factor Authentication (2FA)

**Status:** PLANNED (Level 4 - Enterprise Features)

**Future Implementation:**

- TOTP (Time-based One-Time Password)

- SMS verification

- Email verification codes

- Hardware security keys (U2F/WebAuthn)

### Audit Logging

#### What Gets Logged

**User Actions:**

- Login/logout events

- Password changes

- Profile updates

- Permission changes

- Resource creation/deletion

**Email Events:**

- Email sent/received

- Campaign launches

- Template modifications

- Domain changes

**Security Events:**

- Failed login attempts

- API authentication failures

- Permission denied events

- Suspicious activity detection

**Infrastructure Events:**

- VPS provisioning/deletion

- DNS record changes

- SSL certificate renewals

- Service restarts

#### Log Structure

```typescript
interface AuditLog {
  id: string;
  tenantId: string;
  userId?: string;
  timestamp: Date;

  // Event details
  eventType: string;        // 'user.login', 'email.sent', etc.
  eventCategory: string;    // 'auth', 'email', 'infrastructure'
  action: string;           // 'create', 'update', 'delete', 'view'
  resource: string;         // 'campaign', 'user', 'domain'
  resourceId?: string;

  // Context
  ipAddress: string;
  userAgent: string;
  requestId: string;

  // Changes (for update actions)
  changeset?: {
    before: object;
    after: object;
  };

  // Security
  severity: 'info' | 'warning' | 'critical';
  tags: string[];
}


```

#### Log Retention

- **Default**: 90 days

- **Enterprise**: 1 year

- **Compliance Mode**: 7 years (GDPR/CCPA)

#### Log Access

- Tenant admins can view own tenant logs

- Platform admins can view all logs

- Export to CSV/JSON available

- Integration with SIEM tools (Enterprise)

### Security Headers

All HTTP responses include security headers:

```text

Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: geolocation=(), microphone=(), camera=()


```

### Vulnerability Scanning

**Automated Scans:**

- Weekly dependency vulnerability scans (npm audit, Snyk)

- Monthly infrastructure scans

- Quarterly penetration testing (planned)

**Security Updates:**

- Critical patches applied within 24 hours

- High-priority patches within 7 days

- Regular updates within 30 days

---

## Level 3: Technical Implementation

### Database Encryption

#### Field-Level Encryption

```typescript
// Encryption utilities
import { encrypt, decrypt } from '@/lib/encryption';

// Encrypted field example
class User {
  @Column()
  email: string;

  @Column({ type: 'text' })
  private _passwordHash: string;

  @Column({ type: 'text', nullable: true })
  private _apiKey: string;

  // Encrypted API key storage
  get apiKey(): string | null {
    return this._apiKey ? decrypt(this._apiKey) : null;
  }

  set apiKey(value: string | null) {
    this._apiKey = value ? encrypt(value) : null;
  }

  // Password hashing
  async setPassword(password: string): Promise<void> {
    // Check against breached passwords
    const isBreached = await checkPasswordBreach(password);
    if (isBreached) {
      throw new Error('Password found in breach database');
    }

    this._passwordHash = await bcrypt.hash(password, 12);
  }

  async verifyPassword(password: string): Promise<boolean> {
    return bcrypt.compare(password, this._passwordHash);
  }
}


```

#### Encryption Key Management

```typescript
// Key derivation
import { pbkdf2Sync, randomBytes } from 'crypto';

// Master key from environment
const MASTER_KEY = process.env.ENCRYPTION_MASTER_KEY;

// Derive encryption key for specific purpose
function deriveKey(purpose: string, salt?: Buffer): Buffer {
  const keySalt = salt || randomBytes(32);
  return pbkdf2Sync(MASTER_KEY, keySalt, 100000, 32, 'sha256');
}

// Encrypt data
function encrypt(data: string): string {
  const iv = randomBytes(16);
  const key = deriveKey('field-encryption');
  const cipher = crypto.createCipheriv('aes-256-gcm', key, iv);

  let encrypted = cipher.update(data, 'utf8', 'hex');
  encrypted += cipher.final('hex');

  const authTag = cipher.getAuthTag();

  // Return: iv + authTag + encrypted
  return iv.toString('hex') + ':' + authTag.toString('hex') + ':' + encrypted;
}

// Decrypt data
function decrypt(encryptedData: string): string {
  const [ivHex, authTagHex, encrypted] = encryptedData.split(':');

  const iv = Buffer.from(ivHex, 'hex');
  const authTag = Buffer.from(authTagHex, 'hex');
  const key = deriveKey('field-encryption');

  const decipher = crypto.createDecipheriv('aes-256-gcm', key, iv);
  decipher.setAuthTag(authTag);

  let decrypted = decipher.update(encrypted, 'hex', 'utf8');
  decrypted += decipher.final('utf8');

  return decrypted;
}


```

### SMTP Security Implementation

#### TLS Configuration

```nginx


# Postfix configuration for secure SMTP

smtpd_tls_security_level = may
smtpd_tls_cert_file = /etc/letsencrypt/live/mail.domain.com/fullchain.pem
smtpd_tls_key_file = /etc/letsencrypt/live/mail.domain.com/privkey.pem
smtpd_tls_protocols = !SSLv2, !SSLv3, !TLSv1, !TLSv1.1
smtpd_tls_ciphers = high
smtpd_tls_mandatory_ciphers = high
smtpd_tls_mandatory_protocols = !SSLv2, !SSLv3, !TLSv1, !TLSv1.1
smtpd_tls_auth_only = yes


# Client TLS (outbound)

smtp_tls_security_level = may
smtp_tls_protocols = !SSLv2, !SSLv3, !TLSv1, !TLSv1.1
smtp_tls_ciphers = high


```

#### DKIM Signing

```typescript
import { DKIMSigner } from 'dkim-signer';

async function signEmail(email: Email, domain: Domain): Promise<string> {
  const dkimKey = await getDKIMPrivateKey(domain.id);

  const signer = new DKIMSigner({
    domainName: domain.name,
    selector: 'default',
    privateKey: dkimKey.privateKey,
    headerCanonicalization: 'relaxed',
    bodyCanonicalization: 'relaxed',
  });

  const signature = await signer.sign(email.raw);
  return signature;
}

// DKIM key generation
async function generateDKIMKeys(domainId: string): Promise<DKIMKeyPair> {
  const { publicKey, privateKey } = await generateKeyPair('rsa', {
    modulusLength: 2048,
    publicKeyEncoding: {
      type: 'spki',
      format: 'pem',
    },
    privateKeyEncoding: {
      type: 'pkcs8',
      format: 'pem',
    },
  });

  // Store encrypted private key
  await db.dkimKeys.create({
    domainId,
    selector: 'default',
    publicKey,
    privateKeyEncrypted: encrypt(privateKey),
    createdAt: new Date(),
    expiresAt: addMonths(new Date(), 3), // 3-month rotation
  });

  return { publicKey, privateKey };
}


```

### API Security Middleware

#### Authentication Middleware

```typescript
import { Request, Response, NextFunction } from 'express';
import { verifyJWT, verifyAPIKey } from '@/lib/auth';

export async function authenticate(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    // Check for JWT token (user sessions)
    const authHeader = req.headers.authorization;
    if (authHeader?.startsWith('Bearer ')) {
      const token = authHeader.substring(7);
      const user = await verifyJWT(token);
      req.user = user;
      return next();
    }

    // Check for API key
    const apiKey = req.headers['x-api-key'];
    if (apiKey) {
      const apiUser = await verifyAPIKey(apiKey as string);
      req.user = apiUser;
      return next();
    }

    return res.status(401).json({ error: 'Authentication required' });
  } catch (error) {
    logger.error('Authentication error:', error);
    return res.status(401).json({ error: 'Invalid credentials' });
  }
}


```

#### Rate Limiting Middleware

```typescript
import rateLimit from 'express-rate-limit';
import RedisStore from 'rate-limit-redis';

// API rate limiting
export const apiLimiter = rateLimit({
  store: new RedisStore({
    client: redisClient,
    prefix: 'rl:api:',
  }),
  windowMs: 60 * 1000, // 1 minute
  max: async (req) => {
    // Authenticated users get higher limits
    if (req.user?.apiKey) return 10000;
    if (req.user) return 1000;
    return 100; // Anonymous
  },
  message: 'Too many requests, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
});

// Auth rate limiting (stricter)
export const authLimiter = rateLimit({
  store: new RedisStore({
    client: redisClient,
    prefix: 'rl:auth:',
  }),
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 attempts per window
  skipSuccessfulRequests: true,
  message: 'Too many login attempts, please try again later',
});


```

#### Security Headers Middleware

```typescript
import helmet from 'helmet';

export const securityHeaders = helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'"], // Remove unsafe-inline in production
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", 'data:', 'https:'],
      connectSrc: ["'self'"],
      fontSrc: ["'self'"],
      objectSrc: ["'none'"],
      mediaSrc: ["'self'"],
      frameSrc: ["'none'"],
    },
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true,
  },
  referrerPolicy: {
    policy: 'strict-origin-when-cross-origin',
  },
});


```

### Security Monitoring

#### Suspicious Activity Detection

```typescript
// Monitor for suspicious patterns
async function detectSuspiciousActivity(event: AuditLog): Promise<void> {
  const checks = [
    checkBruteForce(event),
    checkRapidActions(event),
    checkUnusualLocation(event),
    checkUnusualTime(event),
    checkMassDelete(event),
  ];

  const alerts = (await Promise.all(checks)).filter(Boolean);

  if (alerts.length > 0) {
    await createSecurityAlert(event.tenantId, event.userId, alerts);
  }
}

// Example: Brute force detection
async function checkBruteForce(event: AuditLog): Promise<SecurityAlert | null> {
  if (event.eventType !== 'user.login.failed') return null;

  const recentFailures = await db.auditLogs.count({
    where: {
      eventType: 'user.login.failed',
      ipAddress: event.ipAddress,
      timestamp: { gte: subMinutes(new Date(), 15) },
    },
  });

  if (recentFailures >= 5) {
    return {
      type: 'brute_force',
      severity: 'critical',
      message: `${recentFailures} failed login attempts from ${event.ipAddress}`,
    };
  }

  return null;
}


```

---

## Compliance & Certifications

### Current Compliance

- ✅ **GDPR Ready**: Data encryption, audit logs, right to deletion

- ✅ **CCPA Ready**: Data privacy controls, opt-out mechanisms

- ✅ **CAN-SPAM**: Unsubscribe management, sender authentication

### In Progress

- 🔄 **SOC 2 Type I** (Q2 2026)

- 🔄 **ISO 27001** (Q3 2026)

- 🔄 **PCI DSS** (Q4 2026 - if handling card data directly)

### Security Best Practices

- Regular security audits

- Penetration testing (quarterly)

- Employee security training

- Incident response plan

- Data backup and disaster recovery

- Vendor security assessments

---

## Related Documentation

### Compliance

- **[GDPR Compliance](/docs/features/compliance/gdpr-compliance.md)** - Data protection and privacy

- **[Data Privacy](/docs/features/compliance/data-privacy.md)** - Privacy controls and policies

- **[CAN-SPAM Compliance](/docs/features/compliance/can-spam-compliance.md)** - Email compliance

### Infrastructure

- **[Email Infrastructure Setup](../infrastructure/email-infrastructure-setup.md)** - SPF, DKIM, DMARC setup

- **[Multi-Tenant Architecture](../infrastructure/multi-tenant-architecture.md)** - Tenant isolation

### Enterprise

- **[User Management](../enterprise/user-management.md)** - Authentication and authorization

- **[Enterprise Features](../enterprise/enterprise-features/overview.md)** - Advanced security (SSO, MFA)

### Technical

- **[Architecture Overview](../../technical/architecture/overview.md)** - Security architecture

- **[Development Standards](../../implementation-technical/development-guidelines/development-standards.md)** - Secure coding practices

---

**Last Updated:** November 25, 2025
**Status:** Active - Core Feature (Level 1)
**Owner:** Security Team
