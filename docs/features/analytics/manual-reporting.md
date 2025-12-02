---
title: "Manual Reporting & Data Export"
description: "Scheduled reports, data export capabilities, and integration with external analytics tools"
level: "1"
status: "ACTIVE"
roadmap_timeline: "Q4 2025"
priority: "High"
related_features:


  - analytics/core-analytics/overview


  - analytics/enhanced-analytics/overview
related_tasks:


  - epic-1-project-foundation
---


# Manual Reporting & Data Export

**Quick Access**: Export email performance data and generate scheduled reports for external analysis.

## Overview

Manual Reporting provides essential data export and report generation capabilities for users who need to analyze email performance in external tools or share results with stakeholders. This Level 1 feature complements the directional analytics dashboard with flexible export options.

### Key Capabilities

- **Scheduled Reports**: Weekly/monthly automated reports via email

- **Data Export**: CSV, Excel, PDF formats for all metrics

- **External Tool Integration**: Export to Google Sheets, Excel, BI tools

- **Custom Date Ranges**: Flexible reporting periods

- **Multi-Tenant Support**: Workspace-level and tenant-level reports

---

## Level 1: Quick Start Guide

### Generate Your First Report

#### Step 1: Navigate to Reports

```text

Dashboard → Analytics → Reports → Create New Report


```

#### Step 2: Configure Report

**Choose Report Type:**

- **Campaign Performance**: Metrics for specific campaigns

- **Overall Performance**: Aggregated metrics across all campaigns

- **Deliverability Report**: Bounce rates, spam complaints, unsubscribes

- **Workspace Summary**: Per-workspace performance breakdown

- **Domain Health**: Per-domain reputation and metrics

**Select Date Range:**

- Last 7 days

- Last 30 days

- Last 90 days

- Custom range

**Choose Metrics:**

- ✅ Emails sent

- ✅ Delivery rate

- ✅ Open rate (directional)

- ✅ Click rate (directional)

- ✅ Bounce rate

- ✅ Spam complaints

- ✅ Unsubscribes

#### Step 3: Export or Schedule

**Immediate Export:**

- Click "Export Now"

- Choose format: CSV, Excel, or PDF

- Download file

**Schedule Report:**

- Set frequency: Daily, Weekly, Monthly

- Choose delivery time

- Add email recipients

- Click "Create Schedule"

### Export Data from Dashboard

**Quick Export from Any View:**

1. View any analytics dashboard

2. Click "Export" button (top right)

3. Choose format and click "Download"

**Available Exports:**

- Campaign list → CSV/Excel

- Campaign metrics → CSV/Excel

- Email engagement data → CSV

- Lead lists → CSV/Excel

- Domain health → CSV

---

## Level 2: Advanced Reporting

### Scheduled Report Configuration

#### Weekly Performance Report

**Configuration:**

```yaml
name: "Weekly Campaign Performance"
frequency: weekly
day_of_week: monday
time: "09:00"
timezone: "America/New_York"

recipients:


  - team@company.com


  - manager@company.com

format: pdf
include:


  - summary_metrics


  - top_campaigns


  - deliverability_trends


  - weekly_comparison


```

**Delivered Report Includes:**

- Executive summary with key metrics

- Week-over-week comparison

- Top/bottom performing campaigns

- Deliverability trends chart

- Action items and recommendations

#### Monthly Executive Report

**Configuration:**

```yaml
name: "Monthly Executive Summary"
frequency: monthly
day_of_month: 1
time: "08:00"

recipients:


  - executives@company.com

format: pdf_executive
include:


  - executive_summary


  - growth_metrics


  - workspace_breakdown


  - roi_analysis


  - month_over_month_trends


```

**Delivered Report Includes:**

- Month-over-month growth

- Per-workspace performance

- ROI metrics (emails sent vs opportunities created)

- Strategic recommendations

- Next month priorities

### Custom Data Exports

#### Campaign-Level Export

**Available Fields:**

```typescript
interface CampaignExport {
  // Campaign info
  campaignId: string;
  campaignName: string;
  createdAt: Date;
  launchedAt: Date;
  status: string;

  // Sending metrics
  totalEmails: number;
  deliveredEmails: number;
  bouncedEmails: number;
  deliveryRate: number;

  // Engagement (directional)
  opens: number;
  openRate: number;
  clicks: number;
  clickRate: number;
  clickToOpenRate: number;

  // Negative metrics
  spamComplaints: number;
  spamRate: number;
  unsubscribes: number;
  unsubscribeRate: number;

  // Timing
  avgTimeToOpen: number;  // minutes
  avgTimeToClick: number; // minutes

  // Metadata
  workspaceName: string;
  domainUsed: string;
  emailsSentPerDay: number;
}


```

**Export Process:**

1. Select campaigns (individual or bulk)

2. Choose fields to include

3. Select format (CSV, Excel)

4. Click "Export"

#### Lead-Level Export

**Available Fields:**

```typescript
interface LeadExport {
  // Lead info
  leadId: string;
  email: string;
  firstName: string;
  lastName: string;
  company: string;

  // Custom fields
  customFields: Record<string, any>;

  // Engagement
  emailsSent: number;
  emailsDelivered: number;
  emailsOpened: number;
  emailsClicked: number;
  lastOpenedAt: Date;
  lastClickedAt: Date;

  // Status
  status: string;
  leadScore: number;
  tags: string[];

  // Metadata
  createdAt: Date;
  updatedAt: Date;
  source: string;
}


```

### Integration with External Tools

#### Google Sheets Integration

**Setup:**

1. Go to Settings → Integrations → Google Sheets

2. Click "Connect Google Account"

3. Authorize PenguinMails

4. Create auto-export rule

**Auto-Export Configuration:**

```yaml
destination:
  type: google_sheets
  spreadsheet_id: "abc123..."
  sheet_name: "Campaign Performance"

schedule:
  frequency: daily
  time: "06:00"

data:
  export_type: campaign_metrics
  date_range: yesterday
  append_mode: true  # Add new rows vs overwrite


```

**Result:** Daily campaign metrics automatically appended to Google Sheet.

#### Excel / BI Tool Integration

**Export Formats:**

- **CSV**: Universal format, compatible with all tools

- **Excel (.xlsx)**: Formatted spreadsheets with charts

- **JSON**: For custom integrations and APIs

- **Parquet**: For big data tools (future)

**API-Based Export:**

```typescript
// Programmatic data export via API
const response = await fetch('/api/exports/create', {
  method: 'POST',
  headers: {
    'Authorization': 'Bearer YOUR_API_KEY',
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    exportType: 'campaign_metrics',
    dateRange: {
      from: '2025-10-01',
      to: '2025-10-31',
    },
    format: 'csv',
    fields: ['campaignName', 'totalEmails', 'openRate', 'clickRate'],
  }),
});

const { exportId, downloadUrl } = await response.json();


```

### Report Customization

#### Custom Report Templates

Create reusable report templates:

**Template Configuration:**

```yaml
name: "Client Monthly Report"
description: "Monthly performance report for client review"

sections:


  - type: summary_metrics
    metrics: [sent, delivered, opened, clicked]



  - type: chart
    chart_type: line
    metric: delivery_rate
    title: "Delivery Rate Trend"



  - type: table
    title: "Top 10 Campaigns"
    columns: [name, sent, delivered, opens, clicks]
    sort_by: clicks
    limit: 10



  - type: text
    content: |
      ## Executive Summary
      This month showed strong performance...



  - type: recommendations
    auto_generated: true

styling:
  logo: "https://your-logo-url.com/logo.png"
  primary_color: "#007bff"
  font: "Arial"


```

**Using Templates:**

1. Create template once

2. Generate report from template → Select date range

3. Report generated with latest data

---

## Level 3: Technical Implementation

### Database Schema

```sql
-- Scheduled reports
CREATE TABLE scheduled_reports (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  workspace_id UUID REFERENCES workspaces(id),

  name VARCHAR(255) NOT NULL,
  description TEXT,

  -- Schedule
  frequency VARCHAR(50), -- daily, weekly, monthly
  day_of_week INTEGER,   -- 0-6 for weekly
  day_of_month INTEGER,  -- 1-31 for monthly
  time TIME,
  timezone VARCHAR(50) DEFAULT 'UTC',

  -- Configuration
  report_type VARCHAR(50), -- campaign, deliverability, workspace_summary
  date_range VARCHAR(50),  -- last_7d, last_30d, etc.
  format VARCHAR(20),      -- csv, excel, pdf
  config JSONB,            -- Additional configuration

  -- Delivery
  recipients TEXT[],       -- Array of email addresses
  is_active BOOLEAN DEFAULT TRUE,

  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  last_run_at TIMESTAMP,
  next_run_at TIMESTAMP
);

-- Report generation history
CREATE TABLE report_generations (
  id UUID PRIMARY KEY,
  scheduled_report_id UUID REFERENCES scheduled_reports(id),
  tenant_id UUID NOT NULL REFERENCES tenants(id),

  -- Generation details
  generated_at TIMESTAMP DEFAULT NOW(),
  generation_time_ms INTEGER,
  status VARCHAR(50),      -- success, failed, partial
  error_message TEXT,

  -- Output
  file_path TEXT,         -- S3 path or local path
  file_size_bytes INTEGER,
  row_count INTEGER,

  -- Delivery
  sent_to TEXT[],
  delivery_status JSONB,  -- Per-recipient delivery status

  metadata JSONB
);

-- Data export jobs
CREATE TABLE export_jobs (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  user_id UUID REFERENCES users(id),

  -- Export config
  export_type VARCHAR(50),  -- campaigns, leads, metrics
  format VARCHAR(20),       -- csv, excel, json
  date_range JSONB,
  filters JSONB,
  fields TEXT[],

  -- Processing
  status VARCHAR(50),       -- pending, processing, completed, failed
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  processing_time_ms INTEGER,

  -- Output
  file_path TEXT,
  file_size_bytes INTEGER,
  row_count INTEGER,
  download_url TEXT,
  expires_at TIMESTAMP,     -- Temporary download link expiration

  -- Error handling
  error_message TEXT,

  created_at TIMESTAMP DEFAULT NOW()
);


```

### Report Generation Service

```typescript
import { Parser } from 'json2csv';
import ExcelJS from 'exceljs';
import PDFDocument from 'pdfkit';

class ReportGenerator {
  async generateReport(config: ScheduledReport): Promise<string> {
    // 1. Fetch data
    const data = await this.fetchReportData(config);

    // 2. Generate file based on format
    let filePath: string;
    switch (config.format) {
      case 'csv':
        filePath = await this.generateCSV(data, config);
        break;
      case 'excel':
        filePath = await this.generateExcel(data, config);
        break;
      case 'pdf':
        filePath = await this.generatePDF(data, config);
        break;
      default:
        throw new Error(`Unsupported format: ${config.format}`);
    }

    // 3. Upload to storage
    const uploadedPath = await this.uploadToS3(filePath);

    // 4. Send to recipients
    await this.emailReport(config.recipients, uploadedPath, config);

    // 5. Log generation
    await db.reportGenerations.create({
      scheduledReportId: config.id,
      tenantId: config.tenantId,
      generatedAt: new Date(),
      filePath: uploadedPath,
      sentTo: config.recipients,
      status: 'success',
    });

    return uploadedPath;
  }

  private async generateCSV(data: any[], config: ScheduledReport): Promise<string> {
    const fields = this.getFieldsForReportType(config.reportType);
    const parser = new Parser({ fields });
    const csv = parser.parse(data);

    const filePath = `/tmp/report-${config.id}-${Date.now()}.csv`;
    await fs.promises.writeFile(filePath, csv);

    return filePath;
  }

  private async generateExcel(data: any[], config: ScheduledReport): Promise<string> {
    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet('Report');

    // Add header
    const fields = this.getFieldsForReportType(config.reportType);
    worksheet.addRow(fields.map(f => f.label));

    // Style header
    worksheet.getRow(1).font = { bold: true };
    worksheet.getRow(1).fill = {
      type: 'pattern',
      pattern: 'solid',
      fgColor: { argb: 'FF4472C4' },
    };

    // Add data rows
    data.forEach(row => {
      worksheet.addRow(fields.map(f => row[f.value]));
    });

    // Auto-fit columns
    worksheet.columns.forEach(column => {
      column.width = 15;
    });

    const filePath = `/tmp/report-${config.id}-${Date.now()}.xlsx`;
    await workbook.xlsx.writeFile(filePath);

    return filePath;
  }

  private async generatePDF(data: any[], config: ScheduledReport): Promise<string> {
    const doc = new PDFDocument();
    const filePath = `/tmp/report-${config.id}-${Date.now()}.pdf`;
    const stream = fs.createWriteStream(filePath);

    doc.pipe(stream);

    // Title
    doc.fontSize(20).text(config.name, { align: 'center' });
    doc.moveDown();

    // Date range
    doc.fontSize(12).text(`Period: ${this.formatDateRange(config.dateRange)}`);
    doc.moveDown();

    // Summary metrics
    const summary = this.calculateSummary(data);
    doc.fontSize(14).text('Summary', { underline: true });
    doc.fontSize(10);
    Object.entries(summary).forEach(([key, value]) => {
      doc.text(`${key}: ${value}`);
    });

    doc.moveDown();

    // Detailed table
    doc.fontSize(14).text('Detailed Metrics', { underline: true });
    // ... table rendering logic ...

    doc.end();

    return new Promise((resolve) => {
      stream.on('finish', () => resolve(filePath));
    });
  }
}


```

### Scheduled Report Runner

```typescript
// Background job to run scheduled reports
cron.schedule('*/15 * * * *', async () => {  // Every 15 minutes
  const dueReports = await db.scheduledReports.findDue();

  for (const report of dueReports) {
    await reportQueue.add('generate-report', {
      reportId: report.id,
    });

    // Update next run time
    await db.scheduledReports.update(report.id, {
      nextRunAt: calculateNextRun(report),
    });
  }
});

// Queue worker
reportQueue.process('generate-report', async (job) => {
  const { reportId } = job.data;
  const report = await db.scheduledReports.findById(reportId);

  try {
    const generator = new ReportGenerator();
    await generator.generateReport(report);

    await db.scheduledReports.update(reportId, {
      lastRunAt: new Date(),
    });
  } catch (error) {
    logger.error('Report generation failed:', error);

    await db.reportGenerations.create({
      scheduledReportId: reportId,
      tenantId: report.tenantId,
      status: 'failed',
      errorMessage: error.message,
    });
  }
});


```

### API Endpoints

**Create Export Job:**

```typescript
// POST /api/exports
app.post('/api/exports', authenticate, async (req, res) => {
  const { exportType, format, dateRange, filters, fields } = req.body;

  // Create export job
  const exportJob = await db.exportJobs.create({
    tenantId: req.user.tenantId,
    userId: req.user.id,
    exportType,
    format,
    dateRange,
    filters,
    fields,
    status: 'pending',
  });

  // Queue for processing
  await exportQueue.add('process-export', {
    exportJobId: exportJob.id,
  });

  return res.json({
    exportId: exportJob.id,
    status: 'pending',
    estimatedTime: estimateExportTime(exportType, dateRange),
  });
});

// GET /api/exports/:id
app.get('/api/exports/:id', authenticate, async (req, res) => {
  const exportJob = await db.exportJobs.findById(req.params.id);

  if (exportJob.tenantId !== req.user.tenantId) {
    return res.status(403).json({ error: 'Forbidden' });
  }

  if (exportJob.status === 'completed') {
    // Generate temporary download URL
    const downloadUrl = await s3.getSignedUrl('getObject', {
      Bucket: process.env.S3_BUCKET,
      Key: exportJob.filePath,
      Expires: 3600, // 1 hour
    });

    return res.json({
      exportId: exportJob.id,
      status: 'completed',
      downloadUrl,
      expiresAt: addHours(new Date(), 1),
      fileSize: exportJob.fileSizeBytes,
      rowCount: exportJob.rowCount,
    });
  }

  return res.json({
    exportId: exportJob.id,
    status: exportJob.status,
  });
});


```

---

## Related Documentation

### Feature Completeness Review

- **[Analytics & Reporting Gap Analysis](/.kiro/specs/feature-completeness-review/findings/analytics-reporting)** - Comprehensive review of analytics features and roadmap

- **[Third-Party Dependencies](/docs\features\analytics/)** - External services and integrations

### Analytics

- **[Core Analytics](/docs/analytics/core-analytics/overview)** - Dashboard and metrics

- **[Enhanced Analytics](/docs/analytics/enhanced-analytics/overview)** - Advanced analytics (Q1 2026)

### Integration

- **[API Access](/docs/integrations/api-access)** - Programmatic data export

- **[CRM Integration](/docs/integrations/crm-integration/overview)** - External tool sync

### Technical

- **[API Architecture](/docs/implementation-technical/api/README)** - Export API endpoints

---

**Last Updated:** November 25, 2025
**Status:** Active - Core Feature (Level 1)
**Owner:** Analytics Team




