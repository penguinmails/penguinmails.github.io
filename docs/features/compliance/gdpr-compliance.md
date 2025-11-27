---
title: "GDPR Compliance"
description: "EU data protection compliance for PenguinMails - GDPR requirements and implementation"
last_modified_date: "2025-11-24"
level: "2"
persona: "Compliance Officers, Legal Teams"
status: "ACTIVE"
category: "Compliance"
---


# GDPR Compliance

**Ensure EU data protection compliance with built-in GDPR features.**

---


## Overview

PenguinMails is built with GDPR (General Data Protection Regulation) compliance at its core, providing automated tools and processes to help you meet EU data protection requirements when processing personal data of EU citizens.


### Key GDPR Principles in PenguinMails


- **Lawfulness & Transparency** - Clear consent mechanisms and privacy policies


- **Data Minimization** - Collect only necessary data for email campaigns


- **Purpose Limitation** - Use data only for stated purposes


- **Accuracy** - Tools to maintain accurate contact data


- **Storage Limitation** - Automated data retention policies


- **Integrity & Confidentiality** - Encryption and security measures


- **Accountability** - Comprehensive audit logs and compliance records

---


## Level 1: Core GDPR Features


### Data Subject Rights

PenguinMails provides tools to fulfill all GDPR data subject rights:


#### Right to Access


- **Self-service data export** - Users can download all their personal data


- **Admin data access** - Tenant admins can retrieve user data on request


- **Data inventory** - Clear visibility into what data is stored


#### Right to Erasure (Right to be Forgotten)


- **Permanent deletion** - Complete removal of personal data from all systems


- **Cascade deletion** - Removes data across all related records


- **Retention policy override** - Immediate deletion on request


- **Deletion verification** - Confirmation and audit trail of deletion


#### Right to Rectification


- **User profile updates** - Self-service profile editing


- **Contact data correction** - Bulk update tools for contact lists


- **Data validation** - Automated data quality checks


#### Right to Data Portability


- **CSV export** - Standard format for data portability


- **API access** - Programmatic data retrieval


- **Complete data package** - All user data in machine-readable format


#### Right to Object


- **Opt-out mechanisms** - Clear unsubscribe and opt-out options


- **Processing restrictions** - Stop specific data processing activities


- **Marketing preferences** - Granular consent management


### Consent Management


#### Explicit Consent Requirements


- **Double opt-in** - Verified email address confirmation


- **Consent records** - Timestamp and source of consent


- **Granular consent** - Separate consent for different processing activities


- **Consent withdrawal** - Easy opt-out at any time


#### Consent Documentation


- **Audit trail** - Complete history of consent actions


- **Proof of consent** - Timestamp, IP address, consent method


- **Consent scope** - What user consented to and when


- **Consent expiry** - Automatic re-confirmation after set period


### Data Processing Agreements (DPA)


#### PenguinMails as Data Processor


- **Standard DPA template** - GDPR-compliant agreement with customers


- **Sub-processor list** - Transparent list of third-party services


- **Data processing terms** - Clear terms of service


- **Customer controls** - Tenant admins control their data processing


#### Sub-Processors

PenguinMails uses the following sub-processors:


- **NileDB** - Multi-tenant database (PostgreSQL)


- **Redis** - Caching and queue management


- **Hostwind** - Infrastructure hosting (VPS)


- **Stripe** - Payment processing


- **Postmark/Mailgun** - Email service providers (optional)

All sub-processors are GDPR-compliant and covered by Data Processing Agreements.

---


## Level 2: Advanced GDPR Compliance


### Data Protection Impact Assessments (DPIA)


#### When DPIA is Required


- Large-scale processing of sensitive data


- Systematic monitoring of public areas


- Automated decision-making with legal effects


#### PenguinMails DPIA Support


- **Risk assessment tools** - Evaluate processing risks


- **Compliance checklists** - Ensure all requirements met


- **Documentation templates** - DPIA documentation support


- **External audit support** - Compliance verification


### Privacy by Design & Default


#### Built-in Privacy Features


- **Encryption at rest** - All data encrypted in databases


- **Encryption in transit** - TLS 1.3 for all connections


- **Pseudonymization** - Separate PII from operational data


- **Access controls** - Role-based access to personal data


- **Minimal data collection** - Only essential fields required


#### Default Privacy Settings


- **Opt-in by default** - No pre-checked consent boxes


- **Limited data retention** - Automatic deletion after retention period


- **Restricted access** - Need-to-know principle for team access


- **Privacy-first defaults** - Most privacy-protective settings enabled


### Cross-Border Data Transfers


#### EU Data Residency


- **EU hosting options** - Data stored in EU data centers (planned Q2 2026)


- **Data localization** - Keep EU citizen data within EU


- **Standard Contractual Clauses (SCCs)** - Legal mechanism for transfers


- **Transfer impact assessments** - Evaluate risks of data transfers


#### Current Architecture


- **US-based infrastructure** - Hostwind VPS in US data centers


- **SCCs in place** - Standard contractual clauses with customers


- **GDPR-compliant** - Despite US hosting, full GDPR compliance maintained


- **Future EU region** - EU data center planned for 2026


### Breach Notification


#### Automatic Breach Detection


- **Monitoring systems** - Real-time security monitoring


- **Anomaly detection** - Unusual access patterns flagged


- **Audit logs** - Comprehensive activity logging


- **Alert systems** - Immediate notification of suspicious activity


#### 72-Hour Notification Requirement


- **Breach assessment** - Rapid evaluation of breach severity


- **Notification workflow** - Automated notification to affected parties


- **Supervisory authority notification** - Report to data protection authorities


- **Documentation** - Complete incident documentation and response

---


## Level 3: Technical Implementation


### Data Retention Policies


#### Automated Retention Management


```yaml
Retention Policies:
  Contact Data:
    Active contacts: Indefinite (while engaged)
    Inactive contacts: 24 months since last engagement
    Unsubscribed: 30 days (for suppression list)
  
  Campaign Data:
    Campaign metadata: 36 months
    Email content: 24 months
    Analytics data: 12 months (aggregated indefinitely)
  
  User Data:
    Active users: Indefinite
    Deleted accounts: 30 days (soft delete)
    Audit logs: 7 years (compliance requirement)
  
  Payment Data:
    Transaction records: 7 years (tax compliance)
    Card data: Never stored (Stripe handles)


```


#### Retention Enforcement


- **Automated deletion** - Scheduled jobs remove expired data


- **Soft delete** - 30-day recovery window before permanent deletion


- **Audit trail** - Record of all deletion actions


- **Override options** - Legal hold capabilities


### Data Encryption


#### Encryption at Rest


- **Database encryption** - PostgreSQL transparent data encryption


- **Field-level encryption** - Sensitive fields additionally encrypted


- **Encryption keys** - Managed via AWS KMS (future) or local key management


- **Key rotation** - Automatic key rotation policies


#### Encryption in Transit


- **TLS 1.3** - All API and web traffic encrypted


- **SMTP TLS** - Email transmission encrypted


- **Certificate management** - Automated SSL certificate renewal


- **HSTS enabled** - Strict transport security enforced


### Access Controls & Auditing


#### Role-Based Access Control (RBAC)


- **Principle of least privilege** - Users have minimum necessary access


- **Tenant isolation** - Complete data separation between tenants


- **Admin roles** - Super Admin, Tenant Admin, User roles


- **Granular permissions** - Fine-grained access control


#### Comprehensive Audit Logging


- **All data access logged** - Who accessed what, when


- **Immutable logs** - Append-only audit trail


- **Log retention** - 7 years for compliance


- **Export capabilities** - Audit log export for compliance reviews


### API & Integration Compliance


#### GDPR-Compliant API


- **Data portability endpoints** - `/api/users/{id}/export`


- **Deletion endpoints** - `/api/users/{id}/delete`


- **Consent management** - `/api/contacts/{id}/consent`


- **Audit log access** - `/api/audit-logs`


#### Third-Party Integration Controls


- **Data sharing agreements** - Control what data is shared


- **Integration audit** - Log all third-party data access


- **Revocable access** - Disconnect integrations instantly


- **Minimal data sharing** - Share only necessary fields

---


## Compliance Checklist


### For Tenant Administrators


- [ ] Review and accept Data Processing Agreement


- [ ] Configure data retention policies


- [ ] Set up double opt-in for new contacts


- [ ] Implement privacy policy on landing pages


- [ ] Train team on GDPR requirements


- [ ] Establish data breach response plan


- [ ] Document lawful basis for processing


- [ ] Review consent records regularly


- [ ] Conduct periodic data audits


- [ ] Test data export and deletion processes


### For End Users (Contacts)


- [ ] Provide clear privacy policy


- [ ] Offer easy opt-out mechanism


- [ ] Include physical address in emails (required)


- [ ] Honor unsubscribe requests immediately


- [ ] Maintain suppression list


- [ ] Respond to data access requests within 30 days


- [ ] Delete data upon request

---


## Related Documentation


### Compliance & Legal


- **[CAN-SPAM Compliance](./can-spam-compliance.md)** - US email law compliance


- **[Unsubscribe Management](./unsubscribe-management.md)** - Automated opt-out handling


- **[Data Privacy](./data-privacy.md)** - Privacy policy and data handling


- **[Compliance Overview](./README.md)** - All compliance features


### Technical Implementation


- **[Security Framework](../../compliance-security/enterprise/security-framework.md)** - Security architecture


- **[Audit Logging](../../implementation-technical/security/audit-logging.md)** - Audit log implementation


- **[Data Encryption](../../implementation-technical/security/data-encryption.md)** - Encryption technical details


### Business Context


- **[Product Roadmap](../../roadmap/product-roadmap.md)** - Compliance feature timeline


- **[Legal Resources](../../business/legal/README.md)** - Legal documentation and templates

---


## Support & Resources


### Getting Help with GDPR Compliance


- **Documentation** - Review compliance guides and checklists


- **Support Team** - Contact support for compliance questions


- **Legal Counsel** - Consult your legal team for specific guidance


- **DPO Contact** - Reach out to your Data Protection Officer


### External Resources


- **EU GDPR Official Website** - <https://gdpr.eu>


- **ICO GDPR Guidance** - <https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/>


- **DPA Templates** - Standard contractual clauses and DPA templates

---

**Last Updated:** November 24, 2025  
**Next Review:** Quarterly (every 3 months)  
**Regulatory Changes:** Monitor EU data protection developments

*PenguinMails is committed to maintaining GDPR compliance and protecting user privacy. This documentation is regularly updated to reflect current regulations and best practices.*
