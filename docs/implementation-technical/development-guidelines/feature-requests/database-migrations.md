---
title: "Feature Request - Database Migrations"
description: "Guidelines and examples for managing database schema changes when implementing new features."
last_modified_date: "2026-02-24"
level: "2"
persona: "Architecture Support"
---

# Feature Request - Database Migrations

## Migration Framework

All features requiring schema changes must provide an automated migration script with both `upgrade` and `downgrade` (rollback) capabilities.

```typescript
interface DatabaseMigration {
  upgrade(): Promise<MigrationResult>;
  downgrade(): Promise<MigrationResult>;
}

class AIOptimizationMigration implements DatabaseMigration {
  async upgrade(): Promise<MigrationResult> {
    try {
      // Create AI optimization cache table
      await sql`
        CREATE TABLE ai_optimization_cache (
          id SERIAL PRIMARY KEY,
          content_hash VARCHAR(64) NOT NULL,
          optimized_payload JSONB NOT NULL,
          expires_at TIMESTAMP
        );`;

      await sql`CREATE INDEX ix_optimization_cache_content_hash ON ai_optimization_cache(content_hash);`;

      // Update campaigns table
      await sql`ALTER TABLE campaigns ADD COLUMN last_optimization TIMESTAMP;`;

      return { success: true, message: 'Migration completed' };
    } catch (error) {
      return { success: false, message: `Migration failed: ${error}` };
    }
  }

  async downgrade(): Promise<MigrationResult> {
    await sql`DROP TABLE IF EXISTS ai_optimization_cache;`;
    await sql`ALTER TABLE campaigns DROP COLUMN IF EXISTS last_optimization;`;
    return { success: true, message: 'Rollback completed' };
  }
}
```

## Quality Gates for Migrations

Before a migration can be merged:

- [ ] Rollback has been tested and verified.
- [ ] Indexing strategy has been reviewed for performance.
- [ ] No long-running locks are introduced on large tables.
- [ ] Data integrity checks are included in the migration script.
