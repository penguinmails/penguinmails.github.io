---
title: "Onboarding Experience"
description: "User onboarding flow and technical implementation in PenguinMails"
last_modified_date: "2026-02-24"
level: "2"
persona: "All"
category: "Product"
status: "PLANNED"
target_release: "Q1 2026"
---

# Onboarding Experience

**A guided journey from account creation to your first successful campaign.**

---

## Implementation Modules

Explore the following modules for detailed specifications and walkthroughs:

### 1. [Core Onboarding Flow](/docs/features/authentication/onboarding-experience/onboarding-flow)

Step-by-step walkthrough of account creation, workspace setup, domain verification, and first campaign launch.

### 2. [Advanced Features](/docs/features/authentication/onboarding-experience/advanced-features)

Interactive checklists, contextual tooltips, video tutorials, and milestone tracking designed for long-term user success.

### 3. [Technical Implementation](/docs/features/authentication/onboarding-experience/technical-implementation)

Developer-focused details on state management, database schema, React component architecture, and release planning.

---

## Strategic Goals

- **Time to Value:** Reducing the time between signup and first sent campaign to under 15 minutes.
- **Educational Friction:** Using interactive elements to teach core concepts without overwhelming the user.
- **Zero-to-Hero:** Ensuring customers without technical DNS knowledge can successfully verify domains and send email.

---

## Key Milestones

| Milestone | Requirement | Progress |
|-----------|-------------|----------|
| **Workspace Setup** | Name, Slug, Team Members | 100% |
| **Domain Verification** | DNS TXT/MX records verified | 100% |
| **Mailbox Creation** | Set up @verified-domain.com | 100% |
| **First Lead Import** | CSV or manual entry | 100% |
| **First Campaign** | Send to audience | 100% |

---

## Related Documentation

- **[User Management](/docs/features/authentication/user-management)** - Post-onboarding account and team management
- **[HestiaCP Integration](/docs/implementation-technical/integration-services/hestia-cp)** - Technical details on domain and mailbox creation
- **[Email Verification](/docs/features/deliverability/verification-status)** - Understanding DNS and deliverability states

---

**Last Updated:** 2026-02-24
**Status:** Planned / Active Development
**Release Horizon:** Q1 2026
