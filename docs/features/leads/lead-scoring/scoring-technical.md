---
title: "Technical Implementation: Lead Scoring"
description: "Database schema, scoring engine logic, and background processing for the lead scoring system."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers"
---

# Technical Implementation: Lead Scoring

**High-performance scoring engine and persistence layer specifications.**

---

## 1. Database Schema

Tables governing model configuration and score state.

```sql
-- Lead scoring configuration
CREATE TABLE lead_scoring_models (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  name VARCHAR(255) NOT NULL,
  scoring_rules JSONB NOT NULL,
  decay_enabled BOOLEAN DEFAULT true,
  decay_rate DECIMAL(5,2) DEFAULT 5.0,
  decay_interval_days INTEGER DEFAULT 30,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Contact scores persistence
CREATE TABLE contact_scores (
  contact_id UUID NOT NULL REFERENCES contacts(id),
  scoring_model_id UUID REFERENCES lead_scoring_models(id),
  total_score INTEGER DEFAULT 0,
  engagement_score INTEGER DEFAULT 0,
  fit_score INTEGER DEFAULT 0,
  intent_score INTEGER DEFAULT 0,
  last_calculated_at TIMESTAMP DEFAULT NOW(),
  last_activity_at TIMESTAMP,
  PRIMARY KEY (contact_id, scoring_model_id)
);

-- Event log for analytics/audit
CREATE TABLE score_events (
  id UUID PRIMARY KEY,
  contact_id UUID NOT NULL,
  event_type VARCHAR(100),
  points_added INTEGER,
  score_after INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## 2. Scoring Engine Logic

Typescript execution engine for processing actions and applying rules.

```typescript
class LeadScoringEngine {
  async scoreAction(contactId: string, action: string, metadata: any) {
    const model = await this.getScoringModel(contactId);
    const rule = model.rules.find(r => r.action === action);
    
    if (!rule) return;

    let points = rule.points;
    points = this.applyRecencyBoost(points, new Date());

    const current = await this.getScore(contactId);
    const newTotal = Math.max(0, Math.min(100, current.total + points));

    await this.persist(contactId, newTotal);
    await this.checkTriggers(contactId, current.total, newTotal);
  }

  private applyRecencyBoost(base: number, date: Date): number {
    const hours = differenceInHours(new Date(), date);
    if (hours < 24) return base * 2.0;
    if (hours < 168) return base * 1.5;
    return base;
  }
}
```

---

## 3. Background Processing

Handling score decay and daily recalibration via cron/jobs.

```typescript
// Daily decay job
cron.schedule('0 3 * * *', async () => {
  const activeContacts = await db.contacts.findActive();
  for (const contact of activeContacts) {
    await queue.add('apply-decay', { contactId: contact.id });
  }
});

// Worker logic
queue.process('apply-decay', async (job) => {
  const engine = new LeadScoringEngine();
  await engine.applyDecay(job.data.contactId);
});
```
