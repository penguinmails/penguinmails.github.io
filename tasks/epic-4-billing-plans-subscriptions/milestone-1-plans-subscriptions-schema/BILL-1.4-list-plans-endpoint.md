
# BILL-1.4: Create API Endpoint to List Plans (GET /api/plans)

**Ticket ID:** BILL-1.4  
**Milestone:** 1 - Plans and Subscriptions Schema Setup  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a public GET API route at `/api/plans/route.ts`. This endpoint will query the `plans` table using Drizzle and return a list of all active plans. This data will be used to populate the application's pricing page.

## Context

Listing plans is essential for the pricing page. According to the [Features & Capabilities](../../docs/features-capabilities/index), users need to see available subscription options. This endpoint enables the frontend to display pricing information without requiring authentication.

## Acceptance Criteria

1. ✅ The endpoint is public and does not require authentication
2. ✅ It queries the `plans` table and filters for `is_active = true`
3. ✅ It returns a `200 OK` with an array of plan objects
4. ✅ The response includes relevant plan information (name, prices, features, etc.)
5. ✅ Plans are ordered appropriately (e.g., by price or name)
6. ✅ Empty array is returned if no active plans exist

## Technical Details

### API Route Structure

```typescript
// app/api/plans/route.ts
import { NextResponse } from 'next/server';
import { db } from '@/lib/db';
import { plans } from '@/lib/db/schema';
import { eq } from 'drizzle-orm';

export async function GET() {
  try {
    // Query active plans
    const activePlans = await db
      .select({
        id: plans.id,
        name: plans.name,
        priceMonthly: plans.priceMonthly,
        priceYearly: plans.priceYearly,
        features: plans.features,
        stripePriceIdMonthly: plans.stripePriceIdMonthly,
        stripePriceIdYearly: plans.stripePriceIdYearly,
      })
      .from(plans)
      .where(eq(plans.isActive, true))
      .orderBy(plans.priceMonthly); // Order by price ascending

    return NextResponse.json(
      {
        plans: activePlans,
        count: activePlans.length,
      },
      { status: 200 }
    );
  } catch (error) {
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
```

### Expected Response Format

**Success Response (200):**

```json
{
  "plans": [
    {
      "id": "plan-uuid",
      "name": "Starter",
      "priceMonthly": "99.00",
      "priceYearly": null,
      "features": {
        "domains": 1,
        "sharedIPs": 1,
        "emailsPerMonth": 500,
        "support": "community"
      },
      "stripePriceIdMonthly": "price_xxxxx",
      "stripePriceIdYearly": null
    }
  ],
  "count": 3
}
```

## Implementation Notes

- Keep endpoint public (no authentication required) for pricing page
- Filter only active plans
- Order plans by price (ascending) for logical display
- Include Stripe Price IDs for frontend checkout integration
- Consider caching plan data (future enhancement)
- Consider adding plan comparison features (future enhancement)

## Related Documentation

- [Features & Capabilities](../../docs/features-capabilities/index) - Pricing features
- [Implementation & Getting Started](../../docs/implementation-getting-started/index) - Subscription tiers

## Dependencies

- **BILL-1.1** - Plans schema must be defined
- **BILL-1.2** - Plans table must exist in database
- **BILL-1.3** - Plans should be seeded (for testing)

## Testing

- [ ] Test public access - verify 200 response without authentication
- [ ] Test with active plans - verify all active plans returned
- [ ] Test with no active plans - verify empty array returned
- [ ] Verify plans are ordered correctly
- [ ] Verify response includes all relevant plan information
- [ ] Test error handling for database failures
- [ ] Verify response format matches expected structure
