---
title: "The Safe Migration Guide: Moving to PenguinMails Without Losing Reputation"
description: "A step-by-step guide to migrating from Instantly or Smartlead to PenguinMails while protecting your sender reputation and campaign continuity."
last_modified_date: "2025-12-05"
status: ACTIVE
keywords: "migration guide, instantly alternative, smartlead alternative, switch email platforms, reputation protection"
---

# The Safe Migration Guide: Moving to PenguinMails

Switching email platforms is scary. You've spent months building your sender reputation, and the last thing you want is to torch it because of a bad migration.

We built PenguinMails specifically to handle "high-stakes" migrations for agencies. This guide will show you how to move your infrastructure, contacts, and campaigns without missing a beat (or an inbox).

## 🛑 Phase 1: Pre-Migration Checklist

**Do not cancel your old account yet.** You need a 48-hour overlap period to ensure a smooth DNS transition.

### 1. The "Cool Down" Strategy

If you have active campaigns sending 100+ emails/day per account:

1. **Stop adding new leads** to campaigns in your old platform 3 days before migration.
2. Let existing sequences finish their current step.
3. **Pause all campaigns** on the day of migration.

### 2. Export Your Data

* **Instantly Users**: Go to `Leads` -> `Select All` -> `Export as CSV`. Make sure to include "Status" columns so you know who has already replied.
* **Smartlead Users**: Go to `All Leads` -> `Export`.

### 3. Prepare Your DNS

If you are moving domains to PenguinMails infrastructure (hosting them on our VPS):

* Log into your domain registrar (Namecheap, GoDaddy, etc.).
* Lower the **TTL (Time to Live)** on your DNS records to **300 seconds (5 minutes)**.
* *Why?* This ensures that when you update your records to point to PenguinMails, the changes propagate instantly instead of taking 24 hours.

## 📦 Phase 2: Importing Data

### 1. Using the Import Tool

Navigate to **Audience** -> **Import** in your PenguinMails dashboard.

* Upload your CSV file.
* **Critical Step**: Map your "Status" field.
  * Map `Replied` -> `PenguinMails: Replied` (so we don't email them again).
  * Map `Unsubscribed` -> `PenguinMails: Unsubscribed` (compliance is key).

### 2. Recreating Campaigns

* Copy/paste your best-performing scripts.
* **Tip**: This is a great time to A/B test a new subject line. Migrations often give a slight "fresh IP" boost—use it!

## 🛡️ Phase 3: Reputation Continuity (The "Soft Landing")

This is the most important part. Even if your domains are warm, your **IP address** is new.

### The "Soft Landing" Warmup Schedule

Do not immediately blast 50 sends/day. Use this 7-day ramp-up for migrated accounts:

| Day | Warmup Emails | Active Campaign Emails | Total Volume |
| :--- | :--- | :--- | :--- |
| **Day 1** | 20 | 0 | 20 |
| **Day 2** | 25 | 10 | 35 |
| **Day 3** | 30 | 20 | 50 |
| **Day 4** | 30 | 30 | 60 |
| **Day 5** | 20 | 40 | 60 |
| **Day 6** | 10 | 50 | 60 |
| **Day 7** | 5 | Full Volume | Normal |

### Why this works

1. **Signals Trust**: It tells ESPs (Google/Outlook) that this new IP is behaving responsibly.
2. **Tests Connection**: If there's a misconfiguration, you catch it with 10 emails, not 1,000.

## ❓ Common Questions

**Will my old tracking links break?**
Yes, if you cancel your old account. We recommend keeping your old account active for 30 days (downgraded to the cheapest plan) to catch any straggler clicks, or simply accepting that old tracking links will 404.

**Can I migrate tracking domains?**
Yes. You will simply update the CNAME record in your DNS settings to point to `track.penguinmails.com` (or your custom white-label value) instead of your old provider.

---

**Need help moving 50+ accounts?**
Our "White-Glove Migration Team" can handle the heavy lifting for agency partners. Contact support to schedule a migration call.
