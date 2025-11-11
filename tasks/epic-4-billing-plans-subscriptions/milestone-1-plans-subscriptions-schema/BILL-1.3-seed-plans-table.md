# BILL-1.3: Seed the plans Table

**Ticket ID:** BILL-1.3  
**Milestone:** 1 - Plans and Subscriptions Schema Setup  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a simple seed script to populate the `plans` table with the initial subscription tiers (e.g., Free, Pro, Enterprise). This data is needed for the pricing page and for creating subscriptions.

## Context

Initial plan data is essential for the pricing page and subscription creation. According to the [Implementation & Getting Started](../../docs/implementation-getting-started/index.md), PenguinMails offers:
- **Starter Plan:** $99/month
- **Professional Plan:** $299/month
- **Enterprise Plan:** Custom pricing

The seed script will populate these plans with their Stripe Price IDs and feature limits.

## Acceptance Criteria

1. ✅ A `seed.ts` script is created (or `seed-plans.ts`)
2. ✅ After running the script, the `plans` table contains the defined subscription plans
3. ✅ The `price_monthly` and `price_yearly` fields in the table should correspond to the Price IDs in your Stripe account
4. ✅ The script can be run multiple times safely (idempotent)
5. ✅ An `npm run db:seed` script is added to `package.json` (or similar)

## Technical Details

### Seed Script Structure

```typescript
// scripts/seed-plans.ts
import { db } from '../lib/db';
import { plans } from '../lib/db/schema';

const initialPlans = [
  {
    name: 'Starter',
    stripePriceIdMonthly: process.env.STRIPE_PRICE_STARTER_MONTHLY!,
    priceMonthly: '99.00',
    features: {
      domains: 1,
      sharedIPs: 1,
      emailsPerMonth: 500,
      support: 'community',
    },
    isActive: true,
  },
  {
    name: 'Professional',
    stripePriceIdMonthly: process.env.STRIPE_PRICE_PROFESSIONAL_MONTHLY!,
    priceMonthly: '299.00',
    features: {
      domains: 5,
      dedicatedIPs: 3,
      emailsPerMonth: 50000,
      support: 'email',
    },
    isActive: true,
  },
  {
    name: 'Enterprise',
    stripePriceIdMonthly: process.env.STRIPE_PRICE_ENTERPRISE_MONTHLY!,
    priceMonthly: '0.00', // Custom pricing
    features: {
      domains: -1, // Unlimited
      dedicatedIPs: -1, // Unlimited
      emailsPerMonth: -1, // Unlimited
      support: 'dedicated',
    },
    isActive: true,
  },
];

async function seedPlans() {
  console.log('Seeding plans...');

  for (const plan of initialPlans) {
    // Check if plan already exists
    const existing = await db
      .select()
      .from(plans)
      .where(eq(plans.name, plan.name))
      .limit(1);

    if (existing.length === 0) {
      await db.insert(plans).values(plan);
      console.log(`✓ Created plan: ${plan.name}`);
    } else {
      console.log(`- Plan already exists: ${plan.name}`);
    }
  }

  console.log('Plans seeding completed!');
}

seedPlans()
  .then(() => {
    console.log('Seed script completed successfully');
    process.exit(0);
  })
  .catch((error) => {
    console.error('Seed script failed:', error);
    process.exit(1);
  });
```

### Package.json Script

```json
{
  "scripts": {
    "db:seed": "tsx scripts/seed-plans.ts"
  }
}
```

## Implementation Notes

- Make the script idempotent (check if plan exists before inserting)
- Use environment variables for Stripe Price IDs
- Store feature limits as JSON in the features column
- Consider adding yearly pricing (future enhancement)
- Add proper error handling and logging
- Document which Stripe Price IDs correspond to which plans

## Related Documentation

- [Implementation & Getting Started](../../docs/implementation-getting-started/index.md) - Subscription tiers
- [Goals & Competitive Edge](../../docs/goals-competitive-edge/index.md) - Pricing strategy

## Dependencies

- **BILL-1.1** - Plans schema must be defined
- **BILL-1.2** - Plans table must exist in database
- **CORE-2.1** - Drizzle ORM must be configured

## Testing

- [ ] Run seed script and verify plans are created
- [ ] Verify all three plans exist in database
- [ ] Verify Stripe Price IDs are correctly stored
- [ ] Verify feature limits are correctly stored
- [ ] Run script multiple times - verify idempotency
- [ ] Test with missing environment variables - verify error handling
- [ ] Verify prices match documentation

