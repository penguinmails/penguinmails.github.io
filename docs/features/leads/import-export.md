---
title: "Contact Import/Export"
description: "Bulk import and export contacts with CSV/Excel support, field mapping, validation, and history tracking"
level: "2"
status: "PLANNED"
roadmap_timeline: "Q1 2026"
priority: "High"
related_features:


  - leads/leads-management


  - leads/contact-segmentation


  - leads/lead-scoring
related_tasks:


  - epic-7-leads-management
---


# Contact Import/Export

**Quick Access**: Bulk import contacts from CSV/Excel files with intelligent field mapping, validation, and export capabilities for data portability.

## Overview

Contact Import/Export enables you to efficiently manage large contact databases by importing from external sources and exporting for analysis, backups, or migration to other systems.

### Key Capabilities

- **CSV/Excel Import**: Support for multiple file formats

- **Intelligent Field Mapping**: Auto-detect and map columns

- **Validation & Error Handling**: Catch issues before import

- **Bulk Operations**: Update, add, or merge thousands of contacts

- **Custom Field Support**: Import custom field data

- **Export with Filters**: Export specific segments or entire lists

- **Import History**: Track all imports with rollback capability

- **Duplicate Detection**: Smart merging and conflict resolution

---

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

```

Contacts → Import → Upload File

[Choose File] contacts.csv (2.5 MB, 5,000 rows)

Preview:
  ✓ 5,000 rows detected
  ✓ 8 columns found
  ✓ Header row detected

[Next: Map Fields →]


```

#### Step 3: Map Fields

```

Map Your Columns:

CSV Column          →  PenguinMails Field
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
email               →  [Email Address] ✓
first_name          →  [First Name] ✓
last_name           →  [Last Name] ✓
company             →  [Company] ✓
phone               →  [Phone Number] ✓
tags                →  [Tags] (comma/pipe separated)
custom_field_industry → [Custom Field: Industry]

Unmapped Columns:
  (none)

[Next: Validation →]


```

#### Step 4: Validation

```

Validation Results:

✓ Valid Records: 4,892 (97.8%)
⚠ Warnings: 95 (1.9%)
✗ Errors: 13 (0.3%)

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

```

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

```

Importing Contacts...

Progress: ████████████░░░░ 75% (3,669 / 4,892)

Elapsed: 00:02:14
Estimated remaining: 00:00:45

[View Live Progress]


```

#### Step 7: Import Complete

```

✓ Import Completed Successfully

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

```

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

✓ Export ready: contacts_export_2025-11-25.csv (2.8 MB)
[Download]


```

---

## Level 2: Advanced Import/Export

### Advanced Import Options

#### Field Mapping Strategies

**Auto-Mapping Rules:**

```yaml
auto_mapping:
  exact_match:


    - email → email


    - first_name → firstName


    - firstname → firstName


    - fname → firstName
    
  fuzzy_match:


    - company_name → company (80% similarity)


    - org → company


    - organization → company
    
  custom_field_detection:


    - pattern: custom_*, cf_*


    - create_if_missing: true


```

**Manual Mapping:**

```

Custom Field Mapping:

CSV Column: "annual_revenue"
  → Map to: [Create New Custom Field]
     Field Name: annual_revenue
     Field Type: ○ Text  ● Number  ○ Date  ○ Boolean
     Validation: Min: 0, Max: 1000000000

CSV Column: "subscription_tier"
  → Map to: [Create New Custom Field]
     Field Name: subscription_tier
     Field Type: ○ Text  ● Select  ○ Multi-Select
     Options: Free, Starter, Pro, Enterprise


```

**Transformation Rules:**

```yaml
transformations:
  phone:
    normalize: true  # (555) 123-4567 → +15551234567
    default_country: US
    
  tags:
    delimiter: "|"  # or "," or ";"
    trim_whitespace: true
    lowercase: true
    
  custom_dates:
    format: "MM/DD/YYYY"  # or "YYYY-MM-DD", "DD-MM-YYYY"
    timezone: "America/New_York"
    
  company:
    title_case: true  # "acme inc" → "Acme Inc"


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

```

When duplicate email found:

Strategy: Smart Merge
  ○ Keep existing values (skip import)
  ● Update with new values (overwrite)
  ○ Merge non-empty values (fill blanks)
  ○ Create duplicate contact

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

```

Export Contacts

Segment: Hot Leads (Score 75+)
Filters:
  ☑ Lead Score: 75-100
  ☑ Last Activity: Within 30 days
  ☑ Subscription: Active
  ☑ Exclude: Bounced emails

Result: 1,247 contacts


```

**Export by Date Range:**

```

Export Contacts Added:
  From: 2025-10-01
  To: 2025-10-31
  
  Includes: 3,450 contacts


```

**Export by Custom Criteria:**

```

Advanced Filter:
  Country = "United States"
  AND Company Size ≥ "51-200"
  AND Lead Score > 50
  AND Tags contains "enterprise"
  
  Result: 892 contacts


```

#### Custom Field Selection

```

Select Fields to Export:

Standard Fields:
  ☑ Email
  ☑ First Name
  ☑ Last Name
  ☑ Company
  ☑ Phone
  ☑ Created Date
  ☑ Last Activity
  ☑ Lead Score
  ☑ Tags
  ☐ Internal Notes

Custom Fields:
  ☑ Industry
  ☑ Company Size
  ☑ Annual Revenue
  ☐ Account Type
  ☐ Trial End Date

Engagement Metrics:
  ☑ Total Emails Sent
  ☑ Total Opens
  ☑ Total Clicks
  ☑ Last Opened Date
  ☐ Average Open Rate
  ☐ Average Click Rate

Segments:
  ☑ Active Segments (comma-separated)


```

#### Export Formats

**CSV Export:**

```csv
email,first_name,last_name,company,phone,lead_score,tags,industry,created_at
john@example.com,John,Doe,Acme Inc,+15551234567,87,"customer,vip",SaaS,2025-10-15T14:30:00Z


```

**Excel Export (.xlsx):**

```

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

```

Import History

Date                User           File               Status    Records
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
2025-11-25 14:30   Sarah Johnson  contacts_nov.csv   ✓ Success  4,892
2025-11-18 09:15   Michael Chen   leads_q4.xlsx      ✓ Success  2,341
2025-11-10 16:45   Sarah Johnson  trial_users.csv    ⚠ Partial  1,450 / 1,500
2025-11-03 11:20   Emily Davis    webinar_list.csv   ✗ Failed   0 / 850
2025-10-28 13:00   Sarah Johnson  october_leads.csv  ✓ Success  3,210

[View Details] [Download Report] [Rollback]


```

#### Import Details

```

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
  email → Email Address
  first_name → First Name
  last_name → Last Name
  company → Company
  tags → Tags

Tags Added:


  - imported_2025_11


  - bulk_upload

Segment Created:


  - "November Import" (4,892 contacts)

[Download Error Report] [Rollback Import]


```

#### Rollback Import

```

Rollback Import: contacts_nov.csv

⚠ Warning: This will:


  - Delete 4,460 contacts created by this import


  - Restore 432 contacts to their previous state


  - Remove tags: imported_2025_11, bulk_upload


  - Delete segment: "November Import"

This action CANNOT be undone.

Confirm rollback:
  ☐ I understand this will delete 4,460 contacts
  ☐ I have exported a backup

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

## Level 3: Technical Implementation

### Database Schema

```sql
-- Import jobs tracking
CREATE TABLE import_jobs (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  workspace_id UUID REFERENCES workspaces(id),
  
  -- File information
  file_name VARCHAR(255),
  file_size BIGINT,
  file_url TEXT,  -- S3 URL
  file_type VARCHAR(50),  -- csv, xlsx, json
  
  -- Import configuration
  field_mapping JSONB,
  import_options JSONB,  -- duplicate strategy, tags, etc.
  
  -- Status
  status VARCHAR(50),  -- pending, processing, completed, failed, rolled_back
  
  -- Results
  total_rows INTEGER,
  imported_count INTEGER DEFAULT 0,
  updated_count INTEGER DEFAULT 0,
  created_count INTEGER DEFAULT 0,
  skipped_count INTEGER DEFAULT 0,
  error_count INTEGER DEFAULT 0,
  
  -- Error details
  errors JSONB,  -- Array of row errors
  
  -- Progress tracking
  processed_rows INTEGER DEFAULT 0,
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  
  -- User tracking
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  
  -- Rollback support
  can_rollback BOOLEAN DEFAULT TRUE,
  rolled_back_at TIMESTAMP
);

CREATE INDEX idx_import_jobs_tenant ON import_jobs(tenant_id);
CREATE INDEX idx_import_jobs_status ON import_jobs(status);
CREATE INDEX idx_import_jobs_created ON import_jobs(created_at);

-- Import events (for rollback)
CREATE TABLE import_events (
  id UUID PRIMARY KEY,
  import_job_id UUID NOT NULL REFERENCES import_jobs(id),
  contact_id UUID NOT NULL REFERENCES contacts(id),
  
  -- Event type
  event_type VARCHAR(50),  -- created, updated, skipped
  
  -- Snapshot of old data (for rollback)
  previous_data JSONB,
  new_data JSONB,
  
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_import_events_job ON import_events(import_job_id);
CREATE INDEX idx_import_events_contact ON import_events(contact_id);

-- Export jobs
CREATE TABLE export_jobs (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  
  -- Export configuration
  export_type VARCHAR(50),  -- full, filtered, segment
  filters JSONB,
  selected_fields JSONB,
  
  -- Output
  file_format VARCHAR(50),  -- csv, xlsx, json
  file_url TEXT,  -- S3 URL
  file_size BIGINT,
  
  -- Status
  status VARCHAR(50),  -- pending, processing, completed, failed
  
  -- Results
  total_contacts INTEGER,
  
  -- Progress
  processed_contacts INTEGER DEFAULT 0,
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  expires_at TIMESTAMP,  -- Auto-delete after 7 days
  
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_export_jobs_tenant ON export_jobs(tenant_id);
CREATE INDEX idx_export_jobs_status ON export_jobs(status);


```

### Import Service

```typescript
interface ImportOptions {
  fileName: string;
  fileUrl: string;
  fileType: 'csv' | 'xlsx' | 'json';
  fieldMapping: Record<string, string>;
  duplicateStrategy: 'skip' | 'update' | 'create';
  tags?: string[];
  segmentName?: string;
  validateEmail?: boolean;
  validatePhone?: boolean;
}

interface ImportResult {
  jobId: string;
  totalRows: number;
  imported: number;
  created: number;
  updated: number;
  skipped: number;
  errors: ImportError[];
}

interface ImportError {
  row: number;
  field?: string;
  value?: any;
  error: string;
}

class ImportService {
  async startImport(
    tenantId: string,
    options: ImportOptions
  ): Promise<ImportResult> {
    // Create import job
    const job = await db.importJobs.create({
      tenantId,
      fileName: options.fileName,
      fileUrl: options.fileUrl,
      fileType: options.fileType,
      fieldMapping: options.fieldMapping,
      importOptions: {
        duplicateStrategy: options.duplicateStrategy,
        tags: options.tags,
        segmentName: options.segmentName,
      },
      status: 'pending',
    });
    
    // Queue for processing
    await importQueue.add('process-import', {
      jobId: job.id,
      options,
    });
    
    return {
      jobId: job.id,
      totalRows: 0,
      imported: 0,
      created: 0,
      updated: 0,
      skipped: 0,
      errors: [],
    };
  }
  
  async processImport(jobId: string, options: ImportOptions): Promise<void> {
    const job = await db.importJobs.findById(jobId);
    
    try {
      // Update status
      await db.importJobs.update(jobId, {
        status: 'processing',
        startedAt: new Date(),
      });
      
      // Download file from S3
      const fileContent = await s3.getObject(options.fileUrl);
      
      // Parse file
      const rows = await this.parseFile(fileContent, options.fileType);
      
      await db.importJobs.update(jobId, {
        totalRows: rows.length,
      });
      
      // Process rows
      const results = await this.processRows(
        jobId,
        rows,
        options
      );
      
      // Create segment if specified
      if (options.segmentName) {
        await this.createSegment(
          job.tenantId,
          options.segmentName,
          results.contactIds
        );
      }
      
      // Update job with results
      await db.importJobs.update(jobId, {
        status: 'completed',
        completedAt: new Date(),
        importedCount: results.imported,
        createdCount: results.created,
        updatedCount: results.updated,
        skippedCount: results.skipped,
        errorCount: results.errors.length,
        errors: results.errors,
      });
      
      // Send notification
      await this.notifyImportComplete(job, results);
      
    } catch (error) {
      await db.importJobs.update(jobId, {
        status: 'failed',
        completedAt: new Date(),
        errors: [{ row: 0, error: error.message }],
      });
      
      throw error;
    }
  }
  
  private async parseFile(
    content: Buffer,
    fileType: string
  ): Promise<any[]> {
    switch (fileType) {
      case 'csv':
        return await this.parseCSV(content);
      case 'xlsx':
        return await this.parseExcel(content);
      case 'json':
        return JSON.parse(content.toString());
      default:
        throw new Error(`Unsupported file type: ${fileType}`);
    }
  }
  
  private async parseCSV(content: Buffer): Promise<any[]> {
    return new Promise((resolve, reject) => {
      const results: any[] = [];
      
      const stream = Readable.from(content);
      
      stream
        .pipe(csv())
        .on('data', (row) => results.push(row))
        .on('end', () => resolve(results))
        .on('error', reject);
    });
  }
  
  private async parseExcel(content: Buffer): Promise<any[]> {
    const workbook = XLSX.read(content);
    const sheetName = workbook.SheetNames[0];
    const sheet = workbook.Sheets[sheetName];
    
    return XLSX.utils.sheet_to_json(sheet);
  }
  
  private async processRows(
    jobId: string,
    rows: any[],
    options: ImportOptions
  ): Promise<{
    imported: number;
    created: number;
    updated: number;
    skipped: number;
    errors: ImportError[];
    contactIds: string[];
  }> {
    let imported = 0;
    let created = 0;
    let updated = 0;
    let skipped = 0;
    const errors: ImportError[] = [];
    const contactIds: string[] = [];
    
    for (let i = 0; i < rows.length; i++) {
      const row = rows[i];
      
      try {
        // Map fields
        const mappedData = this.mapFields(row, options.fieldMapping);
        
        // Validate
        const validation = await this.validateContact(mappedData, options);
        
        if (!validation.valid) {
          errors.push({
            row: i + 1,
            error: validation.error,
          });
          skipped++;
          continue;
        }
        
        // Check for duplicates
        const existing = await db.contacts.findByEmail(
          mappedData.email
        );
        
        if (existing) {
          if (options.duplicateStrategy === 'skip') {
            skipped++;
            continue;
          } else if (options.duplicateStrategy === 'update') {
            // Store previous data for rollback
            await db.importEvents.create({
              importJobId: jobId,
              contactId: existing.id,
              eventType: 'updated',
              previousData: existing,
              newData: mappedData,
            });
            
            // Update contact
            await db.contacts.update(existing.id, mappedData);
            
            updated++;
            imported++;
            contactIds.push(existing.id);
          }
        } else {
          // Create new contact
          const contact = await db.contacts.create(mappedData);
          
          await db.importEvents.create({
            importJobId: jobId,
            contactId: contact.id,
            eventType: 'created',
            newData: mappedData,
          });
          
          created++;
          imported++;
          contactIds.push(contact.id);
        }
        
        // Add tags
        if (options.tags && options.tags.length > 0) {
          const contact = existing || await db.contacts.findByEmail(mappedData.email);
          await this.addTags(contact.id, options.tags);
        }
        
        // Update progress
        await db.importJobs.update(jobId, {
          processedRows: i + 1,
        });
        
      } catch (error) {
        errors.push({
          row: i + 1,
          error: error.message,
        });
        skipped++;
      }
    }
    
    return {
      imported,
      created,
      updated,
      skipped,
      errors,
      contactIds,
    };
  }
  
  private mapFields(
    row: any,
    mapping: Record<string, string>
  ): any {
    const mapped: any = {};
    
    for (const [csvField, dbField] of Object.entries(mapping)) {
      if (row[csvField] !== undefined) {
        mapped[dbField] = row[csvField];
      }
    }
    
    return mapped;
  }
  
  private async validateContact(
    data: any,
    options: ImportOptions
  ): Promise<{ valid: boolean; error?: string }> {
    // Email required
    if (!data.email) {
      return { valid: false, error: 'Email is required' };
    }
    
    // Email format
    if (options.validateEmail) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(data.email)) {
        return { valid: false, error: 'Invalid email format' };
      }
    }
    
    // Phone format
    if (options.validatePhone && data.phone) {
      const phoneRegex = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/;
      if (!phoneRegex.test(data.phone)) {
        return { valid: false, error: 'Invalid phone format' };
      }
    }
    
    return { valid: true };
  }
  
  async rollbackImport(jobId: string): Promise<void> {
    const job = await db.importJobs.findById(jobId);
    
    if (!job.canRollback) {
      throw new Error('Import cannot be rolled back');
    }
    
    // Get all events
    const events = await db.importEvents.findAll({
      where: { importJobId: jobId },
    });
    
    for (const event of events) {
      if (event.eventType === 'created') {
        // Delete contact
        await db.contacts.delete(event.contactId);
      } else if (event.eventType === 'updated') {
        // Restore previous data
        await db.contacts.update(
          event.contactId,
          event.previousData
        );
      }
    }
    
    // Update job
    await db.importJobs.update(jobId, {
      status: 'rolled_back',
      rolledBackAt: new Date(),
    });
  }
}


```

### Export Service

```typescript
interface ExportOptions {
  format: 'csv' | 'xlsx' | 'json';
  filters?: any;
  segmentId?: string;
  selectedFields?: string[];
  includeCustomFields?: boolean;
  includeEngagementMetrics?: boolean;
}

class ExportService {
  async startExport(
    tenantId: string,
    options: ExportOptions
  ): Promise<{ jobId: string }> {
    const job = await db.exportJobs.create({
      tenantId,
      exportType: options.segmentId ? 'segment' : options.filters ? 'filtered' : 'full',
      filters: options.filters,
      selectedFields: options.selectedFields,
      fileFormat: options.format,
      status: 'pending',
      expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),  // 7 days
    });
    
    // Queue for processing
    await exportQueue.add('process-export', {
      jobId: job.id,
      options,
    });
    
    return { jobId: job.id };
  }
  
  async processExport(jobId: string, options: ExportOptions): Promise<void> {
    try {
      await db.exportJobs.update(jobId, {
        status: 'processing',
        startedAt: new Date(),
      });
      
      // Fetch contacts
      const contacts = await this.fetchContacts(options);
      
      await db.exportJobs.update(jobId, {
        totalContacts: contacts.length,
      });
      
      // Generate file
      const fileContent = await this.generateFile(contacts, options);
      
      // Upload to S3
      const fileUrl = await s3.putObject({
        bucket: 'exports',
        key: `${jobId}.${options.format}`,
        body: fileContent,
        expiresIn: 7 * 24 * 60 * 60,  // 7 days
      });
      
      await db.exportJobs.update(jobId, {
        status: 'completed',
        completedAt: new Date(),
        fileUrl,
        fileSize: fileContent.length,
      });
      
    } catch (error) {
      await db.exportJobs.update(jobId, {
        status: 'failed',
        completedAt: new Date(),
      });
      throw error;
    }
  }
  
  private async fetchContacts(options: ExportOptions): Promise<any[]> {
    let query: any = {};
    
    if (options.segmentId) {
      query.include = [{
        model: db.segmentContacts,
        where: { segmentId: options.segmentId },
      }];
    }
    
    if (options.filters) {
      query.where = options.filters;
    }
    
    return await db.contacts.findAll(query);
  }
  
  private async generateFile(
    contacts: any[],
    options: ExportOptions
  ): Promise<Buffer> {
    switch (options.format) {
      case 'csv':
        return this.generateCSV(contacts, options);
      case 'xlsx':
        return this.generateExcel(contacts, options);
      case 'json':
        return Buffer.from(JSON.stringify(contacts, null, 2));
      default:
        throw new Error(`Unsupported format: ${options.format}`);
    }
  }
  
  private async generateCSV(
    contacts: any[],
    options: ExportOptions
  ): Promise<Buffer> {
    const fields = options.selectedFields || [
      'email',
      'firstName',
      'lastName',
      'company',
      'phone',
    ];
    
    const csvWriter = createObjectCsvStringifier({
      header: fields.map(f => ({ id: f, title: f })),
    });
    
    const csv = csvWriter.getHeaderString() + csvWriter.stringifyRecords(contacts);
    
    return Buffer.from(csv);
  }
  
  private async generateExcel(
    contacts: any[],
    options: ExportOptions
  ): Promise<Buffer> {
    const workbook = XLSX.utils.book_new();
    const worksheet = XLSX.utils.json_to_sheet(contacts);
    
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Contacts');
    
    return XLSX.write(workbook, { type: 'buffer', bookType: 'xlsx' });
  }
}


```

### Background Jobs

```typescript
// Process import jobs
importQueue.process('process-import', async (job) => {
  const { jobId, options } = job.data;
  const service = new ImportService();
  
  await service.processImport(jobId, options);
});

// Process export jobs
exportQueue.process('process-export', async (job) => {
  const { jobId, options } = job.data;
  const service = new ExportService();
  
  await service.processExport(jobId, options);
});

// Clean up old exports
cron.schedule('0 4 * * *', async () => {  // 4 AM daily
  const expiredExports = await db.exportJobs.findAll({
    where: {
      expiresAt: { [Op.lt]: new Date() },
      status: 'completed',
    },
  });
  
  for (const exportJob of expiredExports) {
    // Delete from S3
    if (exportJob.fileUrl) {
      await s3.deleteObject(exportJob.fileUrl);
    }
    
    // Delete job
    await db.exportJobs.delete(exportJob.id);
  }
});


```

### API Endpoints

```typescript
// Start import
app.post('/api/contacts/import', authenticate, async (req, res) => {
  const { fileName, fileUrl, fieldMapping, options } = req.body;
  
  const service = new ImportService();
  const result = await service.startImport(req.user.tenantId, {
    fileName,
    fileUrl,
    fileType: 'csv',
    fieldMapping,
    ...options,
  });
  
  return res.json(result);
});

// Get import status
app.get('/api/contacts/import/:jobId', authenticate, async (req, res) => {
  const job = await db.importJobs.findById(req.params.jobId);
  
  if (job.tenantId !== req.user.tenantId) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  
  return res.json(job);
});

// Rollback import
app.post('/api/contacts/import/:jobId/rollback', authenticate, async (req, res) => {
  const service = new ImportService();
  await service.rollbackImport(req.params.jobId);
  
  return res.json({ success: true });
});

// Start export
app.post('/api/contacts/export', authenticate, async (req, res) => {
  const service = new ExportService();
  const result = await service.startExport(req.user.tenantId, req.body);
  
  return res.json(result);
});

// Get export status
app.get('/api/contacts/export/:jobId', authenticate, async (req, res) => {
  const job = await db.exportJobs.findById(req.params.jobId);
  
  if (job.tenantId !== req.user.tenantId) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  
  return res.json(job);
});

// Download export
app.get('/api/contacts/export/:jobId/download', authenticate, async (req, res) => {
  const job = await db.exportJobs.findById(req.params.jobId);
  
  if (job.tenantId !== req.user.tenantId) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  
  if (job.status !== 'completed') {
    return res.status(400).json({ error: 'Export not ready' });
  }
  
  // Generate signed URL for S3 download
  const signedUrl = await s3.getSignedUrl(job.fileUrl, 300);  // 5 minutes
  
  return res.json({ downloadUrl: signedUrl });
});


```

---

## Related Documentation

- **[Leads Management](./leads-management.md)** - Contact database and management

- **[Contact Segmentation](./contact-segmentation.md)** - Create segments from imported contacts

- **[Lead Scoring](./lead-scoring.md)** - Score imported contacts automatically

- **[Campaign Management](../campaigns/campaign-management/overview.md)** - Use imported contacts in campaigns

---

**Last Updated:** November 25, 2025  
**Status:** Planned - High Priority (Level 2)  
**Target Release:** Q1 2026  
**Owner:** Leads Team
