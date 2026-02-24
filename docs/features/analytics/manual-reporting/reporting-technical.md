---
title: "Reporting Technical Implementation"
description: "Database schema and report generation service logic for developers."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers"
---

# Reporting Technical Implementation

**Internal mechanics of the automated report generation and delivery pipeline.**

---

## 1. Database Schema

Schema designed for flexible scheduling and execution tracking.

```sql
-- Recurring schedule configuration
CREATE TABLE scheduled_reports (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL,
  workspace_id UUID,
  name VARCHAR(255) NOT NULL,
  frequency VARCHAR(50), -- daily, weekly, monthly
  time TIME,
  timezone VARCHAR(50),
  report_type VARCHAR(50),
  format VARCHAR(20), -- csv, excel, pdf
  recipients TEXT[],
  last_run_at TIMESTAMP,
  next_run_at TIMESTAMP
);

-- Individual generation log
CREATE TABLE report_generations (
  id UUID PRIMARY KEY,
  scheduled_report_id UUID REFERENCES scheduled_reports(id),
  generated_at TIMESTAMP DEFAULT NOW(),
  status VARCHAR(50), -- success, failed
  file_path TEXT, -- S3 Bucket location
  row_count INTEGER
);
```

---

## 2. Generation Service

The `ReportGenerator` service handles data aggregation and file conversion.

### Processing Logic

```typescript
class ReportGenerator {
  async generate(config: ScheduledReport) {
    // 1. Aggregation: Run SQL queries to get metrics for the timeframe
    const data = await this.aggregator.fetch(config);
    
    // 2. Formatting: Convert to target format
    const filePath = await this.formatter.output(data, config.format);

    // 3. Delivery: Upload to S3 and notify via Email provider
    const s3Url = await this.storage.upload(filePath);
    await this.mailer.sendReport(config.recipients, s3Url);
  }
}
```

---

## 3. S3 Storage & Security

- **Storage**: Reports are stored in a private S3 bucket with restricted access.
- **Signed URLs**: Email links use time-limited (1-hour) pre-signed URLs.
- **Auto-Cleanup**: A lifecycle policy automatically deletes report files after 30 days to ensure data privacy and manage storage costs.
