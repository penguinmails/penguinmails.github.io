---
title: "Level 3: Technical Implementation"
description: "API integration and batch processing implementation"
level: "3"
persona: "Developers"
keywords: "API, batch processing, integration, technical implementation"
---

# Level 3: Technical Implementation

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

- **[Leads Management](/docs/features/leads/leads-management)** - Contact database and management

- **[Contact Segmentation](/docs/features/leads/contact-segmentation)** - Create segments from imported contacts

- **[Lead Scoring](/docs/features/leads/lead-scoring)** - Score imported contacts automatically

- **[Campaign Management](/docs/features/campaigns/campaign-management/overview)** - Use imported contacts in campaigns

---

**Last Updated:** November 25, 2025
**Status:** Planned - High Priority (Level 2)
**Target Release:** Q1 2026
**Owner:** Leads Team
