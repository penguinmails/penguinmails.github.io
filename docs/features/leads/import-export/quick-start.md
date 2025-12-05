---
title: "Level 1: Quick Start Guide"
description: "Basic contact import and export workflows"
level: "1"
persona: "Marketing Users"
keywords: "quick start, import contacts, export contacts, CSV upload"
---

# Level 1: Quick Start Guide

## Level 1: Quick Start Guide

### Your First Import

#### Step 1: Prepare Your File

**Supported Formats:**

- CSV (Comma-separated values)

- TSV (Tab-separated values)

- Excel (.xlsx, .xls)

**Recommended Columns:**

```csv
email,first_name,last_name,company,phone,tags,custom_field_industry
john@example.com,John,Doe,Acme Inc,555-1234,customer|vip,SaaS
jane@example.com,Jane,Smith,Tech Corp,555-5678,lead,Technology

```

**Required Field:**

- `email` (must be unique)

#### Step 2: Upload File

```text

Contacts → Import → Upload File

[Choose File] contacts.csv (2.5 MB, 5,000 rows)

Preview:
  âœ“ 5,000 rows detected
  âœ“ 8 columns found
  âœ“ Header row detected

[Next: Map Fields →]

```

#### Step 3: Map Fields

```text

Map Your Columns:

CSV Column          →  PenguinMails Field
─────────────────────────────────────────
email               →  [Email Address] âœ“
first_name          →  [First Name] âœ“
last_name           →  [Last Name] âœ“
company             →  [Company] âœ“
phone               →  [Phone Number] âœ“
tags                →  [Tags] (comma/pipe separated)
custom_field_industry → [Custom Field: Industry]

Unmapped Columns:
  (none)

[Next: Validation →]

```

#### Step 4: Validation

```text

Validation Results:

âœ“ Valid Records: 4,892 (97.8%)
âš  Warnings: 95 (1.9%)
âœ— Errors: 13 (0.3%)

Issues Found:
  13 × Invalid email format
  82 × Duplicate emails (will skip)
  13 × Phone number format issues

Actions:
  ○ Import only valid records (4,892)
  ○ Fix errors and re-upload
  ○ Download error report

[Import Valid Records]

```

#### Step 5: Configure Import

```text

Import Options:

Duplicate Handling:
  ○ Skip duplicates (keep existing)
  ● Update existing (merge new data)
  ○ Create duplicates (allow)

Tags:
  ☑ Add tag: "imported_2025_11"
  ☑ Add tag: "bulk_upload"

Segment:
  ☑ Add to segment: Create new "November Import"

[Start Import]

```

#### Step 6: Import Running

```text

Importing Contacts...

Progress: â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘â–‘ 75% (3,669 / 4,892)

Elapsed: 00:02:14
Estimated remaining: 00:00:45

[View Live Progress]

```

#### Step 7: Import Complete

```text

âœ“ Import Completed Successfully

Summary:
  Total Rows: 5,000
  Imported: 4,892
  Skipped (errors): 13
  Skipped (duplicates): 95
  Updated (existing): 432
  Created (new): 4,460

[View Contacts] [Download Report] [Import History]

```

### Quick Export

#### Export All Contacts

```text

Contacts → Export

Selection:
  ● All Contacts (12,847)
  ○ Current View/Filter (4,892)
  ○ Selected Contacts (0)
  ○ Specific Segment

Format:
  ● CSV
  ○ Excel (.xlsx)
  ○ JSON

Fields:
  ☑ Email
  ☑ First Name
  ☑ Last Name
  ☑ Company
  ☑ Tags
  ☑ Lead Score
  ☑ All Custom Fields

[Export]

âœ“ Export ready: contacts_export_2025-11-25.csv (2.8 MB)
[Download]

```

---
