---
title: "Regulatory Framework Overview"
description: "Primary email marketing regulations and requirements"
last_modified_date: "2025-12-04"
level: "3"
persona: "Compliance Officers"
keywords: "CAN-SPAM, GDPR, CCPA, CASL, regulations"
---

# Regulatory Framework Overview

## Regulatory Framework Overview

### Primary Email Marketing Regulations

#### CAN-SPAM Act (United States)

**Legal Foundation**: 15 U.S.C. § 7701-7713
**Enforcement**: Federal Trade Commission (FTC)
**Scope**: All commercial email sent to or from the US

**Core Requirements**:

1. **Accurate Header Information**: No false or misleading headers

2. **No Deceptive Subject Lines**: Subject line must reflect content

3. **Clear Identification**: Must identify email as advertisement

4. **Physical Address**: Include valid physical postal address

5. **Honor Opt-Out**: Honor unsubscribe requests within 10 business days

6. **Responsibility Assignment**: Sender must accept responsibility for compliance

**Technical Implementation**:

```html
<!-- Required CAN-SPAM elements in email template -->
<header>
  <from>company@example.com</from>
  <reply-to>unsubscribe@example.com</reply-to>
  <subject>Your Subject Line (must reflect content)</subject>
</header>

<body>
  <!-- Clear sender identification -->
  <p>Sent by: [Company Name]</p>
  <p>Address: [Physical Address]</p>
  <p>Phone: [Contact Number]</p>

  <!-- Clear unsubscribe mechanism -->
  <a href="mailto:unsubscribe@example.com?subject=UNSUBSCRIBE">Unsubscribe</a>
</body>


```

#### General Data Protection Regulation (EU)

**Legal Foundation**: Regulation (EU) 2016/679
**Enforcement**: National supervisory authorities
**Scope**: Processing personal data of EU residents

**Core Requirements for Email Marketing**:

1. **Lawful Basis**: Must have valid legal basis for processing

2. **Data Minimization**: Collect only necessary data

3. **Purpose Limitation**: Use data only for specified purposes

4. **Accuracy**: Maintain accurate and up-to-date data

5. **Storage Limitation**: Retain data only as long as necessary

6. **Integrity and Confidentiality**: Implement appropriate security

7. **Accountability**: Demonstrate compliance with all principles

**Email-Specific Requirements**:

- **Consent**: Explicit opt-in consent for email processing

- **Right to be Forgotten**: Ability to delete personal data

- **Data Portability**: Ability to export personal data

- **Notification of Breaches**: 72-hour notification requirement

- **Data Processing Records**: Maintain detailed processing logs

#### California Consumer Privacy Act (CCPA)

**Legal Foundation**: California Civil Code §§ 1798.100-1798.199
**Enforcement**: California Attorney General's Office
**Scope**: California residents' personal information

**Core Requirements**:

1. **Right to Know**: Consumers can request data collection disclosure

2. **Right to Delete**: Consumers can request data deletion

3. **Right to Opt-Out**: Consumers can opt-out of data sale

4. **Right to Non-Discrimination**: Cannot discriminate against exercising rights

**Email Marketing Implications**:

- **Data Collection Notice**: Must disclose email collection practices

- **Opt-Out Mechanisms**: Must provide clear opt-out options

- **Data Processing Purpose**: Must disclose processing purposes

- **Third-Party Sharing**: Must disclose data sharing practices

#### PCI DSS v4.0 (Payment Card Industry)

**Legal Foundation**: PCI Security Standards Council
**Enforcement**: Financial institutions and card brands
**Scope**: Any organization processing payment cards

**Email Marketing Implications**:

- **DMARC Compliance**: Mandatory by March 2025 for payment processing

- **Data Encryption**: All payment-related email communications

- **Access Control**: Restrict access to payment data

- **Regular Security Testing**: Ongoing security assessments

### International Email Regulations

#### Personal Data Protection Act (PDPA) - Singapore

**Key Requirements**:

- Consent-based email marketing for Singapore residents

- Data protection officer requirements for large organizations

- Mandatory data breach notification

- Cross-border data transfer restrictions

#### Lei Geral de Proteção de Dados (LGPD) - Brazil

**Key Requirements**:

- Similar to GDPR with Brazilian-specific requirements

- Data protection officer requirement for large processors

- Local data storage requirements for sensitive data

- Right to data portability and deletion

---

