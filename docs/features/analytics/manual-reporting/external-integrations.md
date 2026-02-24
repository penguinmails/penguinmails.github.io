---
title: "External Tools & Data Export"
description: "Integrating PenguinMails analytics with external tools like Google Sheets, Excel, and BI platforms."
last_modified_date: "2026-02-24"
level: "2"
persona: "Analyst, Developers"
---

# External Tools & Data Export

**Extending PenguinMails analytics into your existing BI ecosystem.**

---

## 1. Manual Data Exports

Flexible export formats are available across all analytics views:

- **CSV**: Universal format for data processing.
- **Excel (.xlsx)**: Pre-formatted spreadsheets with charts.
- **JSON**: Structured data for custom scripts and integration.

### Exportable Datasets

- Campaign engagement logs.
- Lead scoring distributions.
- Domain health history.
- Global suppression lists.

---

## 2. Google Sheets Integration

Automated sync between PenguinMails and Google Sheets for real-time collaborative reporting.

### Setup Process

1. **Authorize**: Connect your Google account in Settings.
2. **Select Sheet**: Choose an existing spreadsheet or create a new one.
3. **Configure Sync**:
   - **Frequency**: Daily, Hourly, or On-Demand.
   - **Mode**: *Append* (add new rows) or *Overwrite* (refresh entire sheet).

---

## 3. BI & API Integration

For teams using Tableau, PowerBI, or custom dashboards.

### API-Based Export

Developers can programmatically trigger exports and retrieve data via the Platform API.

```typescript
// Example: Requesting a custom CSV export
const response = await api.post('/v1/exports/create', {
  exportType: 'campaign_metrics',
  dateRange: { from: '2025-01-01', to: '2025-01-31' },
  format: 'csv'
});
```

### Future Formats

Support for **Parquet** and **Avro** is planned for Q2 2026 to facilitate large-scale ingestion into data lakes (AWS S3, Snowflake).
