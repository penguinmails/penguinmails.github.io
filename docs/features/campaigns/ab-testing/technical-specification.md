---
title: "A/B Testing Technical Specification"
description: "Backend architecture, database schema, and randomization logic for split testing."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers"
---

# A/B Testing Technical Specification

The A/B testing engine is integrated into the Campaign Service, handling randomization, metric tracking, and automatic winner deployment.

## Database Schema

### `ab_tests`

Stores the parent test configuration.

- `win_metric`: 'open_rate', 'click_rate', etc.
- `test_duration_hours`: How long the test runs before auto-selection.
- `winner_variant_id`: References the winning `ab_test_variants` record.

### `ab_test_variants`

Stores the content and configuration for each variation.

- `is_control`: Boolean flag for the primary version.
- `sample_size_percent`: What portion of the test sample this variant gets.

### `ab_test_assignments`

Tracks which contact was assigned to which variant.

- `UNIQUE(ab_test_id, contact_id)`: Ensures a contact only sees one version of a specific test.

## Test Execution Workflow

1. **Initiation**: When a campaign starts, the `ABTestService` calculates the total test sample size.
2. **Randomization**: Contacts are shuffled and assigned to variants based on the `sample_size_percent`.
3. **Tracking**: As emails are sent and opened, the `EventMonitor` updates the aggregate metrics (opens, clicks) for each `variant_id`.
4. **Conclusion**: When `test_duration_hours` expires, the `WinnerSelector` calculates significance and selects the top performer.
5. **Deployment**: The remaining contacts (not in the test sample) are immediately sent the content from the winning `variant_id`.

## Statistical Calculation (Z-Score)

We use a standard Z-score calculation for the difference between two proportions:

```typescript
const pooled = (n1 * p1 + n2 * p2) / (n1 + n2);
const se = Math.sqrt(pooled * (1 - pooled) * (1/n1 + 1/n2));
const z = Math.abs(p1 - p2) / se;
```

The resulting Z-score is then mapped to a confidence level (e.g., Z > 1.96 = 95% confidence).
