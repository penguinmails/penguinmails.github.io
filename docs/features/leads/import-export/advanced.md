---
title: "Level 2: Advanced Import/Export"
description: "Field mapping, validation, and error handling"
level: "2"
persona: "Marketing Operations"
keywords: "field mapping, validation, error handling, data quality"
---

# Level 2: Advanced Import/Export

## Level 2: Advanced Import/Export

### Advanced Import Options

#### Field Mapping Strategies

**Auto-Mapping Rules:**

```yaml
auto_mapping:
  exact_match:

    - email â†’ email

    - first_name â†’ firstName

    - firstname â†’ firstName

    - fname â†’ firstName

  fuzzy_match:

    - company_name â†’ company (80% similarity)

    - org â†’ company

    - organization â†’ company

  custom_field_detection:

    - pattern: custom_*, cf_*

    - create_if_missing: true

```

**Manual Mapping:**

```text

Custom Field Mapping:

CSV Column: "annual_revenue"
  â†’ Map to: [Create New Custom Field]
     Field Name: annual_revenue
     Field Type: â—‹ Text  â— Number  â—‹ Date  â—‹ Boolean
     Validation: Min: 0, Max: 1000000000

CSV Column: "subscription_tier"
  â†’ Map to: [Create New Custom Field]
     Field Name: subscription_tier
     Field Type: â—‹ Text  â— Select  â—‹ Multi-Select
     Options: Free, Starter, Pro, Enterprise

```

**Transformation Rules:**

```yaml
transformations:
  phone:
    normalize: true  # (555) 123-4567 â†’ +15551234567
    default_country: US

  tags:
    delimiter: "|"  # or "," or ";"
    trim_whitespace: true
    lowercase: true

  custom_dates:
    format: "MM/DD/YYYY"  # or "YYYY-MM-DD", "DD-MM-YYYY"
    timezone: "America/New_York"

  company:
    title_case: true  # "acme inc" â†’ "Acme Inc"

```

#### Validation Rules

**Email Validation:**

```yaml
email_validation:
  syntax_check: true
  mx_record_validation: true  # Verify domain exists
  disposable_email_detection: true
  role_based_detection: true  # info@, support@, etc.

  actions:
    invalid_syntax: reject
    no_mx_record: warn
    disposable: warn
    role_based: accept

```

**Duplicate Detection:**

```yaml
duplicate_detection:
  match_on:

    - email  # Primary key

  fuzzy_match:

    - first_name + last_name + company

    - phone

  similarity_threshold: 85%  # 85% match = duplicate

  resolution_strategy:

    - skip_new

    - update_existing

    - merge_fields

    - create_new

```

**Data Validation:**

```yaml
field_validation:
  phone:
    pattern: "^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$"
    required: false

  company:
    min_length: 2
    max_length: 200

  lead_score:
    type: integer
    min: 0
    max: 100

  custom_fields:
    validate_type: true
    enforce_required: true

```

#### Merge Strategies

**Update Existing Contacts:**

```text

When duplicate email found:

Strategy: Smart Merge
  â—‹ Keep existing values (skip import)
  â— Update with new values (overwrite)
  â—‹ Merge non-empty values (fill blanks)
  â—‹ Create duplicate contact

Per-Field Strategy:
  Email: [Keep existing]
  First Name: [Update if blank]
  Last Name: [Update if blank]
  Company: [Always update]
  Tags: [Append (merge)]
  Custom Fields: [Update if blank]
  Lead Score: [Keep existing]

```

**Conflict Resolution:**

```yaml
conflict_resolution:
  email:
    action: keep_existing  # Never overwrite

  name:
    action: update_if_blank

  tags:
    action: merge

  custom_fields:
    action: update_if_newer
    criteria: updated_at timestamp

  lead_score:
    action: keep_higher_value

```

### Advanced Export Options

#### Filtered Exports

**Export by Segment:**

```text

Export Contacts

Segment: Hot Leads (Score 75+)
Filters:
  â˜‘ Lead Score: 75-100
  â˜‘ Last Activity: Within 30 days
  â˜‘ Subscription: Active
  â˜‘ Exclude: Bounced emails

Result: 1,247 contacts

```

**Export by Date Range:**

```text

Export Contacts Added:
  From: 2025-10-01
  To: 2025-10-31

  Includes: 3,450 contacts

```

**Export by Custom Criteria:**

```text

Advanced Filter:
  Country = "United States"
  AND Company Size â‰¥ "51-200"
  AND Lead Score > 50
  AND Tags contains "enterprise"

  Result: 892 contacts

```

#### Custom Field Selection

```text

Select Fields to Export:

Standard Fields:
  â˜‘ Email
  â˜‘ First Name
  â˜‘ Last Name
  â˜‘ Company
  â˜‘ Phone
  â˜‘ Created Date
  â˜‘ Last Activity
  â˜‘ Lead Score
  â˜‘ Tags
  â˜ Internal Notes

Custom Fields:
  â˜‘ Industry
  â˜‘ Company Size
  â˜‘ Annual Revenue
  â˜ Account Type
  â˜ Trial End Date

Engagement Metrics:
  â˜‘ Total Emails Sent
  â˜‘ Total Opens
  â˜‘ Total Clicks
  â˜‘ Last Opened Date
  â˜ Average Open Rate
  â˜ Average Click Rate

Segments:
  â˜‘ Active Segments (comma-separated)

```

#### Export Formats

**CSV Export:**

```csv
email,first_name,last_name,company,phone,lead_score,tags,industry,created_at
john@example.com,John,Doe,Acme Inc,+15551234567,87,"customer,vip",SaaS,2025-10-15T14:30:00Z

```

**Excel Export (.xlsx):**

```text

Features:

  - Multiple sheets (Contacts, Custom Fields, Segments)

  - Formatted headers

  - Data validation

  - Freeze panes

  - Auto-filter enabled

```

**JSON Export:**

```json
[
  {
    "email": "john@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "company": "Acme Inc",
    "phone": "+15551234567",
    "leadScore": 87,
    "tags": ["customer", "vip"],
    "customFields": {
      "industry": "SaaS",
      "companySize": "51-200"
    },
    "segments": ["Hot Leads", "Enterprise Tier"],
    "createdAt": "2025-10-15T14:30:00Z",
    "lastActivityAt": "2025-11-24T10:15:00Z"
  }
]

```

### Import History & Rollback

#### View Import History

```text

Import History

Date                User           File               Status    Records
â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
2025-11-25 14:30   Sarah Johnson  contacts_nov.csv   âœ“ Success  4,892
2025-11-18 09:15   Michael Chen   leads_q4.xlsx      âœ“ Success  2,341
2025-11-10 16:45   Sarah Johnson  trial_users.csv    âš  Partial  1,450 / 1,500
2025-11-03 11:20   Emily Davis    webinar_list.csv   âœ— Failed   0 / 850
2025-10-28 13:00   Sarah Johnson  october_leads.csv  âœ“ Success  3,210

[View Details] [Download Report] [Rollback]

```

#### Import Details

```text

Import Details: contacts_nov.csv
Imported: 2025-11-25 14:30:42
User: Sarah Johnson

Summary:
  File: contacts_nov.csv (2.5 MB)
  Total Rows: 5,000

  Imported Successfully: 4,892 (97.8%)

    - New Contacts: 4,460

    - Updated Existing: 432

  Skipped (Errors): 13 (0.3%)

    - Invalid Email: 13

  Skipped (Duplicates): 95 (1.9%)

Mapping:
  email â†’ Email Address
  first_name â†’ First Name
  last_name â†’ Last Name
  company â†’ Company
  tags â†’ Tags

Tags Added:

  - imported_2025_11

  - bulk_upload

Segment Created:

  - "November Import" (4,892 contacts)

[Download Error Report] [Rollback Import]

```

#### Rollback Import

```text

Rollback Import: contacts_nov.csv

âš  Warning: This will:

  - Delete 4,460 contacts created by this import

  - Restore 432 contacts to their previous state

  - Remove tags: imported_2025_11, bulk_upload

  - Delete segment: "November Import"

This action CANNOT be undone.

Confirm rollback:
  â˜ I understand this will delete 4,460 contacts
  â˜ I have exported a backup

[Cancel] [Confirm Rollback]

```

### Scheduled Imports

**Automated CSV Import:**

```yaml
scheduled_import:
  name: "Daily Salesforce Export"

  source:
    type: sftp
    host: sftp.example.com
    path: /exports/contacts_daily.csv
    credentials: salesforce_sftp

  schedule:
    frequency: daily
    time: "02:00"  # 2 AM
    timezone: "America/New_York"

  mapping:
    auto_detect: true
    mappings:
      Id: external_id
      Email: email
      FirstName: firstName
      LastName: lastName
      Company: company

  options:
    duplicate_strategy: update_existing
    add_tag: "salesforce_sync"
    notification_email: admin@example.com

```

**API Import Automation:**

```typescript
// Sync from external CRM daily
cron.schedule('0 2 * * *', async () => {
  const contacts = await externalCRM.fetchNewContacts();

  await importContacts({
    contacts,
    source: 'external_crm',
    duplicateStrategy: 'update_existing',
    tags: ['crm_sync', `sync_${new Date().toISOString().split('T')[0]}`],
  });
});

```

---
