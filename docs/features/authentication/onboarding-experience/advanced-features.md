---
title: "Advanced Onboarding Features"
description: "Secondary onboarding features: Checklists, Tooltips, Tutorials, and Milestone Tracking."
last_modified_date: "2026-02-24"
level: "2"
persona: "All Users"
---

## Level 2: Advanced Onboarding Features

Beyond the core flow, these features ensure long-term adoption and user success.

### Interactive Onboarding Checklist

The checklist lives in the sidebar/dashboard and tracks persistent progress.

- **Features:**
  - **Click-to-Navigate:** Clicking a task takes the user directly to the relevant page.
  - **Progress Persistence:** Saved to `workspace_settings` in the database.
  - **Milestone Rewards:** Visual celebrations (confetti) on significant completions.
  - **Collaborative Progress:** Syncs across all team members in a workspace.

### Contextual Tooltips & Tours

Guided tours triggered by specific page entries or feature interactions.

- **Implementation:**
  - React Joyride or Shepherd.js integration.
  - "Highlight" mode for focused learning.
  - Dismissible with "Don't show again" preference.

### Video Tutorials

Short, embedded video clips for complex features (e.g., DNS setup).

- **Location:** Integrated directly into the relevant steps of the onboarding wizard.
- **Hosting:** Mux or Cloudflare Stream for high-performance delivery.

### Onboarding Milestones

Key events tracked for success metrics and proactive support.

- **Milestone 1:** Domain Verified (Time to value check).
- **Milestone 2:** 100 Leads Imported.
- **Milestone 3:** First Campaign Sent.
- **Milestone 4:** First Reply Received (The "True Value" milestone).

---

## Team Onboarding

When a new user is invited to an existing workspace:

1. **Invitation Link:** Secure token-based access.
2. **Simplified Flow:** Skip workspace/domain setup.
3. **Workspace Tour:** Guided overview of existing campaigns and analytics.
4. **Role Understanding:** Explanation of their specific permissions.
