
# BILL-2.2: Implement "Get or Create Stripe Customer" Logic

**Ticket ID:** BILL-2.2  
**Milestone:** 2 - Stripe Checkout Integration  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

In a new `/lib/services/billing.service.ts` file, create a function `getOrCreateStripeCustomer(tenantId, userEmail)`. This function will check the `tenant_config` table for a `stripe_customer_id`. If it doesn't exist, it will use the Stripe API to create a new Customer, and then save the new ID back to our database.

## Context

Stripe Customer management is essential for subscription billing. According to the [Implementation & Getting Started](/docs/implementation-getting-started/index), each tenant needs a Stripe Customer ID to manage subscriptions. This function ensures we have a customer record in Stripe for each tenant.

## Acceptance Criteria

1. ✅ The function correctly retrieves an existing `stripe_customer_id` from `tenant_config`
2. ✅ If no ID exists, it creates a new Stripe Customer using the Stripe API
3. ✅ After creating a customer, it updates the `tenant_config` table with the new ID
4. ✅ The function returns the Stripe Customer ID (either existing or newly created)
5. ✅ The function handles errors gracefully
6. ✅ The function is idempotent (can be called multiple times safely)

## Technical Details

### Service Function Structure

```typescript
// lib/services/billing.service.ts
import { db } from '@/lib/db';
import { tenantConfig } from '@/lib/db/schema';
import { stripe } from '@/lib/stripe';
import { eq } from 'drizzle-orm';

export async function getOrCreateStripeCustomer(
  tenantId: string,
  userEmail: string
): Promise<string> {
  // Check if tenant already has a Stripe customer ID
  const [config] = await db
    .select()
    .from(tenantConfig)
    .where(eq(tenantConfig.tenantId, tenantId))
    .limit(1);

  // If customer ID exists, return it
  if (config?.stripeCustomerId) {
    return config.stripeCustomerId;
  }

  // Create new Stripe customer
  const customer = await stripe.customers.create({
    email: userEmail,
    metadata: {
      tenantId: tenantId,
    },
  });

  // Save customer ID to database
  if (config) {
    // Update existing config
    await db
      .update(tenantConfig)
      .set({
        stripeCustomerId: customer.id,
        updatedAt: new Date(),
      })
      .where(eq(tenantConfig.tenantId, tenantId));
  } else {
    // Create new config
    await db.insert(tenantConfig).values({
      tenantId: tenantId,
      stripeCustomerId: customer.id,
    });
  }

  return customer.id;
}
```

## Implementation Notes

- Check database first before creating Stripe customer (avoid duplicates)
- Use upsert logic (update if exists, insert if not)
- Add tenant ID to Stripe customer metadata for reference
- Handle Stripe API errors gracefully
- Consider adding retry logic for transient failures (future enhancement)
- Log customer creation for audit trail (future enhancement)

## Related Documentation

- [Implementation & Getting Started](/docs/implementation-getting-started/index) - Stripe Connect setup
- [High-Level Architecture](/docs/quick-access/high-level-architecture) - Payment processing

## Dependencies

- [BILL-1.1](/docs/features/payments/tasks/BILL-1.1-define-billing-schemas) - Tenant_config schema must be defined
- [BILL-1.2](/docs/features/payments/tasks/BILL-1.2-generate-apply-billing-migrations) - Tenant_config table must exist in database
- [BILL-2.1](/docs/features/payments/tasks/BILL-2.1-install-configure-stripe) - Stripe SDK must be configured

## Testing

- [ ] Test with tenant that has existing customer ID - verify returns existing ID
- [ ] Test with tenant that has no customer ID - verify creates new customer
- [ ] Verify customer ID is saved to database after creation
- [ ] Test with invalid tenant ID - verify error handling
- [ ] Test with invalid email - verify error handling
- [ ] Verify function is idempotent (can be called multiple times)
- [ ] Test error handling for Stripe API failures
- [ ] Verify tenant ID is added to Stripe customer metadata

---

## Cross-References

- **Routes**: [settings.md]()
- **API**: [platform-api/subscriptions.md]()
