# BILL-1.1: Define Drizzle Schemas for Billing

**Ticket ID:** BILL-1.1  
**Milestone:** 1 - Plans and Subscriptions Schema Setup  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

In the `/lib/db/schema` directory, create new files for the `plans`, `subscriptions`, and `tenant_config` tables. Define the schemas according to the ERD, including all feature limits, prices, and status fields.

## Context

Billing schemas are essential for managing subscriptions and payments. According to the [Implementation & Getting Started](../../docs/implementation-getting-started/index.md), PenguinMails offers:
- **Starter Plan:** $99/month
- **Professional Plan:** $299/month
- **Enterprise Plan:** Custom pricing

The [Goals & Competitive Edge](../../docs/goals-competitive-edge/index.md) document outlines the B2B SaaS subscription model that these schemas will support.

## Acceptance Criteria

1. ✅ `plans.ts`, `subscriptions.ts`, and `tenant_config.ts` schema files are created in `/lib/db/schema`
2. ✅ The schemas correctly define all columns, types, and foreign key relationships
3. ✅ The `tenant_config` table includes a `stripe_customer_id` column, which is crucial for linking our tenants to Stripe customers
4. ✅ The `plans` table includes:
   - `id` (UUID, primary key)
   - `name` (varchar, e.g., 'Starter', 'Professional', 'Enterprise')
   - `stripe_price_id_monthly` (varchar, Stripe Price ID)
   - `stripe_price_id_yearly` (varchar, Stripe Price ID, optional)
   - `price_monthly` (decimal/numeric, price in cents or dollars)
   - `price_yearly` (decimal/numeric, optional)
   - `features` (JSON or separate columns for feature limits)
   - `is_active` (boolean, default true)
   - `created_at`, `updated_at` (timestamps)
5. ✅ The `subscriptions` table includes:
   - `id` (UUID, primary key)
   - `tenant_id` (UUID, foreign key to tenants.id)
   - `plan_id` (UUID, foreign key to plans.id)
   - `stripe_subscription_id` (varchar, unique, Stripe Subscription ID)
   - `status` (varchar, e.g., 'active', 'canceled', 'past_due')
   - `current_period_start` (timestamp)
   - `current_period_end` (timestamp)
   - `cancel_at_period_end` (boolean)
   - `created_at`, `updated_at` (timestamps)
6. ✅ The `tenant_config` table includes:
   - `id` (UUID, primary key)
   - `tenant_id` (UUID, foreign key to tenants.id, unique)
   - `stripe_customer_id` (varchar, unique, Stripe Customer ID)
   - `created_at`, `updated_at` (timestamps)

## Technical Details

### Plans Schema

```typescript
// lib/db/schema/plans.ts
import { pgTable, uuid, varchar, decimal, boolean, timestamp, jsonb } from 'drizzle-orm/pg-core';

export const plans = pgTable('plans', {
  id: uuid('id').primaryKey().defaultRandom(),
  name: varchar('name', { length: 100 }).notNull().unique(),
  stripePriceIdMonthly: varchar('stripe_price_id_monthly', { length: 255 }).notNull(),
  stripePriceIdYearly: varchar('stripe_price_id_yearly', { length: 255 }),
  priceMonthly: decimal('price_monthly', { precision: 10, scale: 2 }).notNull(),
  priceYearly: decimal('price_yearly', { precision: 10, scale: 2 }),
  features: jsonb('features'), // Store feature limits as JSON
  isActive: boolean('is_active').default(true).notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});
```

### Subscriptions Schema

```typescript
// lib/db/schema/subscriptions.ts
import { pgTable, uuid, varchar, boolean, timestamp } from 'drizzle-orm/pg-core';
import { tenants } from './tenants';
import { plans } from './plans';

export const subscriptions = pgTable('subscriptions', {
  id: uuid('id').primaryKey().defaultRandom(),
  tenantId: uuid('tenant_id')
    .notNull()
    .references(() => tenants.id, { onDelete: 'cascade' }),
  planId: uuid('plan_id')
    .notNull()
    .references(() => plans.id),
  stripeSubscriptionId: varchar('stripe_subscription_id', { length: 255 })
    .notNull()
    .unique(),
  status: varchar('status', { length: 50 }).notNull(), // 'active', 'canceled', 'past_due', etc.
  currentPeriodStart: timestamp('current_period_start').notNull(),
  currentPeriodEnd: timestamp('current_period_end').notNull(),
  cancelAtPeriodEnd: boolean('cancel_at_period_end').default(false).notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});
```

### Tenant Config Schema

```typescript
// lib/db/schema/tenant_config.ts
import { pgTable, uuid, varchar, timestamp } from 'drizzle-orm/pg-core';
import { tenants } from './tenants';

export const tenantConfig = pgTable('tenant_config', {
  id: uuid('id').primaryKey().defaultRandom(),
  tenantId: uuid('tenant_id')
    .notNull()
    .unique()
    .references(() => tenants.id, { onDelete: 'cascade' }),
  stripeCustomerId: varchar('stripe_customer_id', { length: 255 }).unique(),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});
```

## Implementation Notes

- Use UUIDs for primary keys to match other tables
- Use `onDelete: 'cascade'` for foreign keys to maintain referential integrity
- Store Stripe IDs as strings (varchar)
- Use JSONB for flexible feature storage (or consider separate columns)
- Add indexes on frequently queried columns (tenant_id, stripe_subscription_id, etc.)
- Consider adding enum types for status fields (future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture.md) - Database schema patterns
- [Implementation & Getting Started](../../docs/implementation-getting-started/index.md) - Subscription tiers
- [Goals & Competitive Edge](../../docs/goals-competitive-edge/index.md) - Business model

## Dependencies

- **CORE-2.2** - Tenants table schema must be defined (from Epic 1)
- **CORE-2.1** - Drizzle ORM must be configured

## Testing

- [ ] Verify all schema files are created in correct location
- [ ] Test that schemas can be imported without TypeScript errors
- [ ] Verify foreign key relationships are correctly defined
- [ ] Verify unique constraints (stripe_customer_id, stripe_subscription_id)
- [ ] Check that required fields are marked as not null
- [ ] Verify cascade delete behavior (when tenant is deleted)
- [ ] Test that optional fields can be null

