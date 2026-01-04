---
title: "Onboarding Flow"
description: "User onboarding experience design and flow"
last_modified_date: "2025-11-24"
type: "design"
status: "DRAFT"
---


# Onboarding Flow Design

**Updated:** January 4, 2026 - Simplified workspace-level tracking approach

## Design Overview

The onboarding experience has been redesigned to use **workspace-level tracking** with minimal database footprint. Instead of complex user-level progress tracking, completion is determined by actual workspace setup data.

## Key Principles

1. **Data-Driven Completion**: Onboarding completion detected from actual workspace setup
2. **Minimal Database Fields**: Only 3 fields stored long-term per workspace
3. **Flexible UX**: Users can navigate freely without complex progress tracking
4. **Analytics Integration**: Posthog events track onboarding lifecycle

## Completion Criteria

Onboarding is considered complete when workspace has:

- ✅ At least one verified domain
- ✅ At least one email account
- ✅ At least one lead imported
- ✅ At least one campaign created

## User Experience Flow

### 1. Workspace Creation

- User creates first workspace after signup
- `onboarding_started_at` timestamp set
- Posthog event: `onboarding_started`

### 2. Setup Steps (Any Order)

Users can complete these in any order:

- **Domain Setup**: Add and verify sending domain
- **Email Account**: Create first sending email address
- **Contacts**: Import or add first leads
- **Campaign**: Create first email campaign

### 3. Automatic Completion Detection

- System monitors workspace data
- When all criteria met → `onboarding_completed_at` set
- Posthog event: `onboarding_finished`
- UI hides onboarding components

## UI Components

### Onboarding Container

- Shows progress based on actual workspace data
- Quick action buttons for incomplete steps
- Progress indicator: "X of 5 steps completed"

### Hide/Show Toggle

- Power users can hide onboarding per workspace
- Sets `hide_onboarding = true`
- Respects user preference

## Database Schema

```sql
ALTER TABLE companies ADD COLUMN onboarding_started_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE companies ADD COLUMN onboarding_completed_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE companies ADD COLUMN hide_onboarding BOOLEAN DEFAULT FALSE;
```

## Benefits

✅ **Simple Implementation**: No complex progress tracking
✅ **Accurate**: Based on actual user setup, not self-reported
✅ **Flexible**: Users can skip steps or complete in any order
✅ **Analytics-Ready**: Posthog integration for time tracking
✅ **User Control**: Can hide onboarding when desired

## Success Metrics

- **Time to First Value**: Duration from `onboarding_started_at` to `onboarding_completed_at`
- **Completion Rate**: % of workspaces that complete onboarding within 7 days
- **Step Completion**: Analytics on which setup steps take longest
- **Drop-off Analysis**: Where users abandon onboarding process

---

**Last Updated:** November 24, 2025
**Status:** In Design
