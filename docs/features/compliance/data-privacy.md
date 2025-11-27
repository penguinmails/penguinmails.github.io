---
title: "Data Privacy"
description: "Privacy policy enforcement and data handling practices for PenguinMails"
last_modified_date: "2025-11-24"
level: "2"
persona: "Legal Teams, Privacy Officers"
status: "ACTIVE"
category: "Compliance"
---


# Data Privacy

**Privacy-first architecture and data handling practices to protect user data.**

---


## Overview

PenguinMails is built on a foundation of privacy-by-design principles, ensuring that user data is protected through technical, organizational, and procedural safeguards. We provide transparency and control over data collection, processing, and storage.


### Privacy Principles


- **Data Minimization** - Collect only what's necessary


- **Purpose Limitation** - Use data only for stated purposes


- **Transparency** - Clear communication about data practices


- **User Control** - Empower users to manage their data


- **Security First** - Protect data with encryption and access controls


- **Accountability** - Maintain compliance and audit trails

---


## Level 1: Core Privacy Features


### Privacy-First Data Collection

**Collect minimum necessary data** for email marketing functionality.


#### Required Data

**For Registration:**


- Email address (authentication)


- Name (personalization)


- Password (hashed, never stored in plain text)

**For Campaigns:**


- Contact email addresses


- Optional: First name, last name, company


- Custom fields (user-defined, optional)


#### Not Collected


- ❌ Social Security Numbers


- ❌ Financial information (Stripe handles payments)


- ❌ Sensitive health data


- ❌ Biometric data


- ❌ Unnecessary tracking data

---


### Transparent Privacy Policies

**Clear, accessible privacy policies** that explain data practices.


#### Privacy Policy Available At


- **Marketing website** - <https://penguinmails.com/privacy>


- **In-app link** - Footer of every page


- **Onboarding** - Shown during signup


- **API documentation** - Privacy considerations for developers


#### Privacy Policy Includes


1. **What data we collect** - Comprehensive list


2. **Why we collect it** - Purpose for each data type


3. **How we use it** - Processing activities


4. **Who we share it with** - Third-party processors


5. **How long we keep it** - Retention policies


6. **User rights** - Access, deletion, portability


7. **Contact information** - Privacy officer contact


#### Policy Updates


- **Notification required** - Email notice of material changes


- **Version history** - Track policy changes over time


- **Effective date** - Clear indication of when changes take effect


- **Continued use** - Implied acceptance or explicit re-consent

---


### User Data Control

**Empower users to manage their own data** through self-service tools.


#### Data Access

**User Profile Data Export**


- Download all personal data in JSON or CSV format


- Includes: profile, preferences, campaign history, analytics


- Generated within 24 hours


- Available via: Settings → Privacy → Export My Data

**Contact Data Export**


- Export all contacts and lists


- CSV format compatible with other tools


- Includes all custom fields


- Available via: Leads → Export


#### Data Correction


- **Self-service profile editing** - Update name, email, preferences


- **Contact data updates** - Correct contact information


- **Bulk corrections** - CSV import for bulk updates


- **API updates** - Programmatic data correction


#### Data Deletion


- **Account deletion** - Complete removal of user account


- **30-day grace period** - Soft delete allows recovery


- **Permanent deletion** - After 30 days, irreversible


- **Cascade delete** - Removes all associated data

**What Gets Deleted:**


- ✅ User profile and credentials


- ✅ Contact lists and segmentation


- ✅ Campaign data and templates


- ✅ All personally identifiable information (PII)

**What's Retained (Legal/Compliance):**


- ⚠️ Audit logs (7 years, anonymized)


- ⚠️ Transaction records (7 years for tax compliance)


- ⚠️ Abuse/spam reports (perpetual, for platform security)

---


### Data Security

**Multi-layered security** protects data at rest and in transit.


#### Encryption

**Encryption at Rest**


- **Database encryption** - PostgreSQL transparent data encryption


- **Field-level encryption** - Additional encryption for sensitive fields


- **Encrypted backups** - All backups encrypted


- **Key management** - Secure key storage and rotation

**Encryption in Transit**


- **TLS 1.3** - All connections encrypted (web, API)


- **SMTP TLS** - Email transmission encrypted


- **No plain HTTP** - HTTPS enforced


- **HSTS enabled** - Prevent downgrade attacks


#### Access Controls


- **Role-based access** - Users have minimum necessary permissions


- **Multi-factor authentication** - Optional MFA for enhanced security


- **Session management** - Automatic logout, secure session tokens


- **IP restrictions** - Optional IP allowlisting for enterprise

---


## Level 2: Advanced Privacy Features


### Privacy by Design & Default

**Privacy considerations built into every feature** from the ground up.


#### Design Principles

**Proactive Not Reactive**


- Privacy protections in place before data collected


- Security reviews for new features


- Privacy impact assessments for high-risk processing

**Privacy as Default**


- Most privacy-protective settings enabled by default


- Users must opt-in to data sharing


- No pre-checked consent boxes


- Minimal data collection by default

**Privacy Embedded**


- Not a bolt-on feature


- Integrated into architecture


- Part of development lifecycle


- Continuous monitoring and improvement


#### Default Settings


```yaml
New User Defaults:
  data_sharing: false
  analytics_tracking: minimal
  marketing_emails: false
  third_party_integrations: disabled
  session_timeout: 30 minutes
  mfa: recommended (not required)


```

---


### Data Retention & Deletion

**Automated data lifecycle management** ensures compliance with retention policies.


#### Retention Policies

**User Data**


```yaml
Active Users:
  Profile Data: Indefinite (while account active)
  Activity Logs: 12 months (rolling)
  
Deleted Accounts:
  Soft Delete: 30 days (recovery period)
  Hard Delete: Permanent after 30 days
  Audit Logs: 7 years (anonymized, compliance)


```

**Contact Data**


```yaml
Active Contacts:
  Engaged (opened/clicked): Indefinite
  Inactive (no engagement): 24 months
  
Unsubscribed:
  Email address: Perpetual (suppression list)
  Other data: Deleted after 30 days
  
Bounced:
  Hard bounce: Immediate suppression
  Soft bounce (3x): Suppression after 3 attempts


```

**Campaign Data**


```yaml
Campaigns:
  Metadata: 36 months
  Email Content: 24 months
  Send Logs: 36 months
  Analytics: 12 months (aggregated indefinitely)


```


#### Automated Deletion

**Scheduled Jobs:**


- **Daily** - Remove expired soft-deleted accounts


- **Weekly** - Clean up inactive bounce logs


- **Monthly** - Archive old campaign data


- **Quarterly** - Review and clean up test data

---


### Third-Party Data Sharing

**Transparency about sub-processors** and when data is shared.


#### Sub-Processors (Services We Use)

**Infrastructure**


- **NileDB** - Multi-tenant PostgreSQL database


  - Purpose: Data storage


  - Location: US (EU option Q2 2026)


  - Data: All platform data
  

- **Redis** - Caching and queue management


  - Purpose: Performance, background jobs


  - Location: Same as application server


  - Data: Temporary cache, job queues


- **Hostwind** - VPS hosting


  - Purpose: Infrastructure hosting


  - Location: US data centers


  - Data: All application and database data

**Payment Processing**


- **Stripe** - Payment processor


  - Purpose: Subscription billing


  - Location: Global (US-based)


  - Data: Payment method, billing address (tokenized)

**Email Delivery (Optional)**


- **Postmark** - Transactional email delivery


  - Purpose: High-deliverability email sending


  - Location: US


  - Data: Email content, recipient addresses


- **Mailgun** - Bulk email delivery


  - Purpose: Marketing campaign delivery


  - Location: US (EU option available)


  - Data: Email content, recipient addresses


#### Data Sharing Controls

**When We Share Data:**


- ✅ With user consent (integrations)


- ✅ To provide requested services


- ✅ With sub-processors (listed above)


- ✅ For legal compliance (subpoena, court order)

**When We DON'T Share Data:**


- ❌ Selling to third parties


- ❌ Marketing to non-users


- ❌ Sharing with affiliates


- ❌ Unrelated business purposes

---


### Privacy for Contacts

**Respect privacy of your email contacts** (not just platform users).


#### Contact Privacy Rights

**GDPR Rights for Contacts (EU residents):**


- Right to access data


- Right to rectification


- Right to erasure


- Right to data portability


- Right to object to processing

**How Contacts Exercise Rights:**


1. **Contact the tenant** - Email sender (your customer)


2. **Tenant requests from PenguinMails** - Via admin panel


3. **PenguinMails fulfills request** - Export, correct, delete data


4. **Confirmation provided** - Tenant notifies contact


#### Contact Data Security


- **Tenant isolation** - Contacts visible only to owning tenant


- **Workspace isolation** - Optional workspace-level separation


- **Encrypted storage** - Same encryption as user data


- **Access logging** - Audit trail of contact data access

---


## Level 3: Technical Implementation


### Privacy-Enhancing Technologies


#### Pseudonymization

**Separate PII from operational data** where possible.


```sql
-- Separate tables for PII vs operational data
CREATE TABLE contacts (
  id UUID PRIMARY KEY,
  email VARCHAR(255) ENCRYPTED, -- PII
  created_at TIMESTAMP
);

CREATE TABLE contact_engagement (
  contact_id UUID REFERENCES contacts(id),
  campaign_id UUID,
  event_type VARCHAR(50),
  occurred_at TIMESTAMP
  -- No PII stored here
);


```


#### Data Anonymization

**Anonymize audit logs** after relevant retention period.


```javascript
// Anonymization Job (runs quarterly)
UPDATE audit_logs 
SET 
  user_email = 'anonymized@example.com',
  ip_address = '0.0.0.0',
  user_agent = 'anonymized'
WHERE 
  created_at < NOW() - INTERVAL '90 days'
  AND anonymized = false;


```

---


### Privacy API Endpoints


#### Export User Data


```javascript
POST /api/v1/privacy/export
Authorization: Bearer {user_token}

Response:
{
  "export_id": "exp_abc123",
  "status": "processing",
  "estimated_completion": "2025-11-24T12:00:00Z",
  "download_url": null // available when complete
}


```


#### Delete User Account


```javascript
DELETE /api/v1/users/me
Authorization: Bearer {user_token}

{
  "confirmation": "DELETE",
  "reason": "no_longer_needed" // optional
}

Response:
{
  "status": "scheduled_for_deletion",
  "soft_delete_until": "2025-12-24T10:30:00Z",
  "permanent_deletion_date": "2025-12-24T10:30:00Z"
}


```

---


### Privacy Audit Logging

**Comprehensive logging** of privacy-sensitive actions.


```javascript
Privacy Audit Events:


- user.data_exported


- user.data_deleted


- user.consent_updated


- contact.data_accessed


- contact.data_exported


- contact.data_deleted


- privacy_policy.accepted


- privacy_policy.updated


- dpa.signed


```

---


## Privacy Impact Assessments (PIA)

**Evaluate privacy risks** for new features and processing activities.


### When PIA Required


- New feature involving personal data


- Changes to data processing


- New third-party integration


- Expansion to new jurisdiction


### PIA Process


1. **Identify data flows** - Map data collection and sharing


2. **Assess necessity** - Justify data collection


3. **Evaluate risks** - Privacy and security risks


4. **Mitigation measures** - Technical and organizational safeguards


5. **Documentation** - Record PIA findings


6. **Review** - Regular reassessment

---


## Privacy Training & Awareness


### For PenguinMails Team


- **Privacy onboarding** - New employee training


- **Annual refresher** - Yearly privacy training


- **Incident response** - How to handle privacy incidents


- **Data handling** - Proper data access and storage practices


### For Customers (Tenants)


- **Privacy best practices** - Documentation and guides


- **Compliance resources** - Help center articles


- **Template DPAs** - Standard data processing agreements


- **Privacy webinars** - Regular training sessions

---


## Related Documentation


### Compliance


- **[GDPR Compliance](./gdpr-compliance.md)** - EU data protection details


- **[CAN-SPAM Compliance](./can-spam-compliance.md)** - US email law


- **[Unsubscribe Management](./unsubscribe-management.md)** - Opt-out handling


- **[Compliance Overview](./README.md)** - All compliance features


### Security


- **[Security Framework](../../compliance-security/enterprise/security-framework.md)** - Security architecture


- **[Data Encryption](../../implementation-technical/security/data-encryption.md)** - Encryption technical details


- **[Access Controls](../../implementation-technical/security/access-controls.md)** - RBAC implementation


### Legal


- **[Privacy Policy](../../business/legal/privacy-policy.md)** - Official privacy policy


- **[Terms of Service](../../business/legal/terms-of-service.md)** - User agreement


- **[DPA Template](../../business/legal/dpa-template.md)** - Data processing agreement

---


## Privacy Support


### Contact Privacy Team


- **Email** - <privacy@penguinmails.com>


- **Data Protection Officer** - <dpo@penguinmails.com>


- **Security Issues** - <security@penguinmails.com>


### Privacy Resources


- **Help Center** - Privacy FAQs and guides


- **Privacy Policy** - Official privacy documentation


- **Trust Center** - Security and compliance information

---

**Last Updated:** November 24, 2025  
**Privacy Officer:** Chief Privacy Officer  
**Compliance:** GDPR, CCPA, PIPEDA, LGPD

*Privacy is a fundamental right. PenguinMails is committed to protecting user privacy through technical excellence, transparency, and accountability.*
