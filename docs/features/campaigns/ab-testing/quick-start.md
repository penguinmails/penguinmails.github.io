---
title: "A/B Testing Quick Start"
description: "How to set up and run your first split test campaign in PenguinMails."
last_modified_date: "2026-02-24"
level: "2"
persona: "Campaign Managers, Marketers"
---

# A/B Testing Quick Start

A/B testing (or split testing) allows you to send different versions of an email to small groups of your audience to see which one performs best before sending the winner to the rest.

## 1. Create an A/B Test Campaign

When creating a new campaign, enable the **A/B Testing** toggle in the configuration step.

### Choose Your Test Type

- **Subject Line**: Test which headline gets more opens.
- **Email Content**: Test different bodies, images, or CTAs.
- **Sender Name**: Test if "Jane from PenguinMails" or just "PenguinMails" performs better.
- **Send Time**: Test different hours or days of the week.

## 2. Configure Variants

Define Version A (Control) and Version B (Variant).

**Example (Subject Line Test):**

- **Variant A**: "Check out our new features!"
- **Variant B**: "{{firstName}}, we have something special for you"

## 3. Set Test Parameters

- **Sample Size**: What percentage of your list gets the test (e.g., 20%).
- **Winning Metric**: What determines the winner (e.g., Open Rate or Click Rate).
- **Test Duration**: How long to wait before picking a winner (e.g., 4 hours).

## 4. Automatic Selection

Once the duration is up, PenguinMails automatically:

1. Calculates the winner based on your selected metric.
2. Sends the winning variant to the remaining 80% of your audience.
3. Provides a full report comparing the performance of all variants.
