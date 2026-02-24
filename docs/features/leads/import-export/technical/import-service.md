---
title: "Import Service Technical"
description: "Implementation details for the PenguinMails contact import engine, including parsing and row processing."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers"
---

# Import Service Technical

**Engine logic for handling high-volume contact ingestion and validation.**

---

## 1. Import Workflow

The import process follows a multi-stage asynchronous pipeline to ensure stability and rollback capability.

### Processing Logic

```typescript
class ImportService {
  async processImport(jobId: string, options: ImportOptions) {
    const job = await db.importJobs.findById(jobId);
    
    // 1. Download and Parse
    const fileContent = await s3.getObject(options.fileUrl);
    const rows = await this.parseFile(fileContent, options.fileType);

    // 2. Row Processing Loop
    for (let i = 0; i < rows.length; i++) {
      const mappedData = this.mapFields(rows[i], options.fieldMapping);
      const validation = await this.validateContact(mappedData, options);

      if (validation.valid) {
        await this.handleContactStrategy(mappedData, options);
      } else {
        await this.logError(jobId, i, validation.error);
      }
    }
  }
}
```

---

## 2. File Parsing & Validation

Supports CSV, Excel (XLSX), and JSON formats with strict schema validation.

### Parsers

- **CSV**: Stream-based parsing via `csv-parser`.
- **Excel**: Sheet-to-JSON conversion via `xlsx` library.
- **JSON**: Standard `JSON.parse` for smaller batch payloads.

### Validation Rules

```typescript
private async validateContact(data: any, options: ImportOptions) {
  if (!data.email) return { valid: false, error: 'Email required' };
  
  if (options.validateEmail) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(data.email)) return { valid: false, error: 'Invalid format' };
  }
  
  return { valid: true };
}
```

---

## 3. Duplicate Strategies

- **Skip**: Ignore the row if email exists.
- **Update**: Overwrite existing contact fields with new data.
- **Create**: (Default) Create new record if no conflict exists.

### Rollback Support

The service stores `previous_data` in `import_events` for every 'update' action, allowing a 1-click rollback of any import job within 7 days.
