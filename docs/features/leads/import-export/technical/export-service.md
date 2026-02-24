---
title: "Export Service Technical"
description: "Implementation details for the contact export engine, including file generation and S3 storage."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers"
---

# Export Service Technical

**Architecture for generating and delivering large-scale data exports.**

---

## 1. Export Pipeline

Exports are processed in the background to avoid blocking the main API thread.

### Logic Flow

1. **Request**: User triggers export via UI or API.
2. **Queueing**: Job added to `export-queue`.
3. **Fetching**: Worker retrieves contacts based on filters/segment.
4. **Generation**: Content converted to CSV, XLSX, or JSON.
5. **Storage**: File uploaded to S3 with expiration policy.
6. **Notification**: User receives a signed download link.

---

## 2. File Generation

Leverages specialized libraries for memory-efficient file creation.

### Supported Formats

- **CSV**: Generated via `json2csv` or custom stringifier.
- **XLSX**: Multi-sheet support via `exceljs`.
- **JSON**: Standardized format for API integrations.

### Field Selection

Users can select specific fields to include, reducing file size and protecting sensitive metadata.

```typescript
private async generateCSV(contacts: any[], options: ExportOptions) {
  const fields = options.selectedFields || ['email', 'firstName', 'lastName'];
  const csvWriter = createObjectCsvStringifier({
    header: fields.map(f => ({ id: f, title: f })),
  });
  return Buffer.from(csvWriter.getHeaderString() + csvWriter.stringifyRecords(contacts));
}
```

---

## 3. Storage & Cleanup

Files are stored in a protected S3 bucket (`exports/`) with a 7-day Time-to-Live (TTL).

### Cleanup Job

A daily cron job identifies expired exports and removes them from both S3 and the `export_jobs` table.

```typescript
cron.schedule('0 4 * * *', async () => {
  const expired = await db.exportJobs.findExpired();
  for (const job of expired) {
    if (job.fileUrl) await s3.deleteObject(job.fileUrl);
    await db.exportJobs.delete(job.id);
  }
});
```
