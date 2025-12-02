---
title: "CAN-SPAM Compliance"
description: "US email law compliance for PenguinMails - CAN-SPAM Act requirements"
last_modified_date: "2025-11-24"
level: "2"
persona: "Marketing Teams, Compliance Officers"
status: "ACTIVE"
category: "Compliance"
---


# CAN-SPAM Compliance

**Ensure compliance with US email marketing laws through automated CAN-SPAM features.**

---

## Overview

The CAN-SPAM Act (Controlling the Assault of Non-Solicited Pornography And Marketing Act) is the primary US law regulating commercial email. PenguinMails provides built-in features to ensure your email campaigns comply with all CAN-SPAM requirements.

### CAN-SPAM Penalties

**Non-compliance can result in:**

- Up to $51,744 per violation

- Additional fines for aggravated violations

- Criminal penalties for serious infractions

PenguinMails automates compliance to help you avoid these penalties.

---

## Level 1: Core CAN-SPAM Requirements

### 1. Don't Use False or Misleading Header Information

**Requirement:** "From," "To," "Reply-To," and routing information must be accurate and identify the business sending the message.

#### PenguinMails Implementation

- ✅ **Verified sender addresses** - Only send from authenticated domains

- ✅ **Accurate From name** - Clearly identifies your business

- ✅ **Valid Reply-To** - Monitored mailbox for replies

- ✅ **No spoofing** - SPF, DKIM, DMARC prevent header manipulation

#### Setup Checklist

- [ ] Use your business domain as sender

- [ ] Set "From" name to your business or brand name

- [ ] Provide working Reply-To address

- [ ] Configure SPF/DKIM/DMARC records

---

### 2. Don't Use Deceptive Subject Lines

**Requirement:** Subject lines must accurately reflect the content of the message.

#### Best Practices

- ✅ **Honest subject lines** - Accurately describe email content

- ✅ **No clickbait** - Avoid misleading or sensational subjects

- ✅ **Match content** - Subject and email body should align

- ✅ **No fake urgency** - Don't create false sense of urgency

#### PenguinMails Features

- **Subject line review** - AI-powered subject line analysis (future)

- **Spam score checker** - Identify potentially deceptive subjects

- **Best practice templates** - Pre-approved subject line examples

- **Team review workflow** - Require approval for campaigns

---

### 3. Identify the Message as an Advertisement

**Requirement:** You must clearly and conspicuously disclose that the message is an advertisement.

#### When Required

- **Commercial messages** - Selling products or services

- **First contact** - No prior business relationship

- **Promotional content** - Marketing or advertising material

#### Exemptions

- **Transactional emails** - Order confirmations, shipping, account updates

- **Relationship messages** - Existing customer communications

- **Requested information** - User-initiated contact

#### PenguinMails Implementation

- **Email templates** - Built-in ad disclosure

- **Customizable disclaimer** - Add your disclosure text

- **Automatic insertion** - Disclosure added to commercial emails

- **Compliance templates** - Pre-configured compliant templates

**Example Disclosure:**

```text

This is an advertisement from [Your Company Name]


```

---

### 4. Tell Recipients Where You're Located

**Requirement:** Include your valid physical postal address in every email.

#### Address Requirements

- ✅ **Street address** - Valid postal delivery location

- ✅ **P.O. Box** - Registered with USPS

- ✅ **Private mailbox** - At commercial mail receiving agency

#### PenguinMails Implementation

- **Company profile** - Set address once, used everywhere

- **Automatic insertion** - Address in email footers

- **Workspace-specific** - Different address per workspace/company

- **Template variables** - `{{company.address}}` for templates

#### Configuration

```yaml
Company Address Setup:
  Location: Settings → Company Profile → Physical Address
  Required Fields:


    - Street address


    - City, State, ZIP


    - Country
  Display: Automatically added to all commercial emails


```

---

### 5. Provide an Opt-Out Method

**Requirement:** Give recipients a clear, easy way to opt out of future emails.

#### Unsubscribe Requirements

- ✅ **Conspicuous** - Easy to find and recognize

- ✅ **Easy to use** - Simple one-click or reply-to method

- ✅ **No login required** - Work without authentication

- ✅ **No fees** - Free to unsubscribe

- ✅ **Include in every email** - All commercial messages

#### PenguinMails Unsubscribe Features

**One-Click Unsubscribe**

- **List-Unsubscribe header** - RFC 8058 compliant

- **Web-based unsubscribe** - Hosted unsubscribe page

- **Instant processing** - Immediate removal from future sends

- **Confirmation page** - User feedback on successful unsubscribe

**Unsubscribe Link Placement**

- **Footer placement** - Clear and prominent

- **Before physical address** - High visibility location

- **Multiple formats** - Text link + button option

- **Mobile-optimized** - Easy to tap on mobile devices

**Example Unsubscribe Text:**

```text

If you no longer wish to receive these emails, you may
[unsubscribe here]({{unsubscribe_url}})


```

---

### 6. Honor Opt-Out Requests Promptly

**Requirement:** Process opt-out requests within 10 business days.

#### PenguinMails Compliance

- ✅ **Instant opt-out** - Removed immediately (not 10 days)

- ✅ **Automated processing** - No manual intervention needed

- ✅ **Suppression list** - Prevent re-adds

- ✅ **Global opt-out** - Applies across all campaigns

- ✅ **Permanent** - Cannot resubscribe without explicit consent

#### Unsubscribe Processing

```text

User clicks unsubscribe
  ↓
Immediate removal from active campaigns
  ↓
Added to global suppression list
  ↓
Future sends automatically blocked
  ↓
Confirmation email sent (optional)


```

#### Suppression List Features

- **Perpetual storage** - Never delete unsubscribed emails

- **Import/export** - Maintain external suppression lists

- **Cross-workspace** - Share suppression across workspaces

- **Compliance reports** - Audit opt-out processing times

---

### 7. Monitor What Others Are Doing on Your Behalf

**Requirement:** Even if you hire a company to handle your email marketing, you cannot contract away your legal responsibility to comply.

#### Responsibilities as PenguinMails User

- ✅ **Monitor campaigns** - Review content before sending

- ✅ **Verify compliance** - Ensure all requirements met

- ✅ **Audit third parties** - If using agencies or freelancers

- ✅ **Maintain records** - Document compliance procedures

#### PenguinMails Accountability Features

- **Audit logs** - Track all email sends and modifications

- **User activity** - Monitor team member actions

- **Approval workflows** - Require manager approval for sends

- **Compliance reports** - Regular compliance status reports

---

## Level 2: Advanced Compliance

### Transactional vs. Commercial Emails

#### Transactional Emails (CAN-SPAM Exempt)

Emails that facilitate an agreed-upon transaction or update about an ongoing relationship:

- ✅ **Order confirmations** - Purchase receipts

- ✅ **Shipping notifications** - Delivery updates

- ✅ **Account alerts** - Password resets, security alerts

- ✅ **Service updates** - Changes to terms, features

- ✅ **Legal notices** - Privacy policy updates

**Rules for Transactional:**

- Primary purpose must be transactional

- Can include minimal commercial content

- No unsubscribe required (but best practice)

- Subject line must relate to transaction

#### Commercial Emails (CAN-SPAM Applies)

Emails whose primary purpose is commercial advertisement:

- ⚠️ **Promotional campaigns** - Sales, discounts, offers

- ⚠️ **Newsletter with ads** - Content + promotional material

- ⚠️ **Product announcements** - New product launches

- ⚠️ **Event invitations** - Webinars, conferences

**Full CAN-SPAM compliance required:**

- Must include physical address

- Must include unsubscribe option

- Must honor opt-outs within 10 days

- Cannot use deceptive headers or subjects

### Email Classification in PenguinMails

**Campaign Type Selection:**

```yaml
Campaign Setup:
  Email Type:


    - Commercial (default) → Full CAN-SPAM requirements


    - Transactional → Minimal requirements (best practice compliance)


    - Administrative → Internal team communications


```

---

### Consent & Permission

#### Express Consent (Best Practice)

While CAN-SPAM doesn't require prior consent, best practice is:

- **Opt-in forms** - Clear consent to receive emails

- **Confirmed interest** - Double opt-in for verification

- **Specific consent** - What types of emails they'll receive

- **Documented consent** - Timestamp and source

#### PenguinMails Consent Features

- **Double opt-in** - Email confirmation required

- **Consent records** - Timestamp, IP, source

- **Preference center** - Users control email types

- **Consent proof** - Audit trail for compliance

---

### Record Keeping

#### Required Documentation

- **Email content** - Archive all sent emails

- **Send dates** - When emails were sent

- **Opt-out requests** - Log all unsubscribe actions

- **Processing time** - Verify 10-day compliance

- **Recipient lists** - Who received each campaign

#### PenguinMails Retention

```yaml
Retention Policy:
  Email Content: 24 months
  Send Logs: 36 months
  Opt-out Records: Indefinite (perpetual suppression)
  Audit Logs: 7 years
  Campaign Analytics: 12 months


```

---

## Level 3: Technical Implementation

### Automated Compliance Features

#### Email Footer Auto-Insertion

```html
<!-- Automatically added to all commercial emails -->
<footer class="can-spam-footer">
  <p><small>This is a commercial message from {{company.name}}</small></p>

  <p>{{company.address}}</p>

  <p>
    <a href="{{unsubscribe_url}}">Unsubscribe</a> |
    <a href="{{preferences_url}}">Email Preferences</a>
  </p>
</footer>


```

#### List-Unsubscribe Header

```text

List-Unsubscribe: <mailto:unsubscribe@penguinmails.com?subject=unsubscribe>,
                  <https://penguinmails.com/unsubscribe/{{campaign_id}}/{{contact_id}}>
List-Unsubscribe-Post: List-Unsubscribe=One-Click


```

### Compliance Validation

#### Pre-Send Validation

Before any campaign sends, PenguinMails automatically checks:

- [ ] Valid sender domain (authenticated)

- [ ] Physical address present

- [ ] Unsubscribe link included

- [ ] Subject line not deceptive (spam score)

- [ ] From/Reply-To addresses valid

- [ ] Commercial content identified

**Validation fails?** → Campaign blocked until resolved

---

## Compliance Reports

### Monthly Compliance Report

**Automated reports include:**

- Total emails sent

- Opt-out rate and processing time

- Compliance score (100% = fully compliant)

- Failed validation incidents

- Remediation actions taken

### Audit Trail

**Track all compliance activities:**

- Campaign approvals

- Template modifications

- Unsubscribe processing

- Suppression list updates

- Compliance setting changes

---

## Best Practices

### Beyond Minimum Compliance

1. **Be Transparent** - Clear about who you are and what you're sending

2. **Make Unsubscribe Easy** - Prominent, one-click unsubscribe

3. **Segment Your Audience** - Send relevant content only

4. **Monitor Engagement** - Remove inactive subscribers

5. **Keep Clean Lists** - Regular list hygiene and validation

6. **Train Your Team** - Educate on compliance requirements

7. **Document Everything** - Maintain records of compliance

8. **Use Double Opt-In** - Verify email addresses and consent

---

## Related Documentation

### Compliance

- **[GDPR Compliance](/docs/features/compliance/gdpr-compliance)** - EU data protection

- **[Unsubscribe Management](/docs/features/compliance/unsubscribe-management)** - Opt-out automation

- **[Data Privacy](/docs/features/compliance/data-privacy)** - Privacy policies

- **[Compliance Overview](https://github.com/penguinmails/penguinmails.github.io/blob/main/README.md)** - All compliance features

### Implementation

- **[Email Authentication](/docs/features/domains/sender-authentication)** - SPF, DKIM, DMARC

- **[Campaign Management](/docs/features/campaigns/campaign-management/overview)** - Campaign creation

- **[Template Editor](/docs/features/templates/template-editor)** - Email templates

---

## Support & Resources

### FTC CAN-SPAM Act Resources

- **FTC CAN-SPAM Guide** - <https://www.ftc.gov/tips-advice/business-center/guidance/can-spam-act-compliance-guide-business>

- **Email Law Compliance** - <https://www.ftc.gov/business-guidance/resources/can-spam-act-compliance-guide-business>

### PenguinMails Compliance Support

- **Compliance Team** - <compliance@penguinmails.com>

- **Legal Documentation** - Terms of Service, Privacy Policy

- **Support Portal** - Compliance questions and guidance

---

**Last Updated:** November 24, 2025
**Regulatory Authority:** Federal Trade Commission (FTC)
**Applies To:** All commercial emails sent to US recipients

*PenguinMails automates CAN-SPAM compliance but users are ultimately responsible for ensuring their email practices comply with all applicable laws.*

