---
title: "Automation & Enrollment Rules"
description: "Managing how contacts enter, move through, and exit your automated sequences."
last_modified_date: "2026-02-24"
level: "2"
persona: "Marketers, Operations"
---

# Automation & Enrollment Rules

Control the flow and safety of your automated outreach through enrollment and exit settings.

## 1. Exit Goals

Sequences should be result-oriented. An **Exit Goal** allows you to automatically remove a contact from a sequence once they have achieved the desired outcome.

**Example Goal**: "Contact Status changed to Customer."

- As soon as the contact's field updates, they stop receiving emails from the active sequence, preventing awkward "Welcome" emails after they've already bought the product.

## 2. Re-enrollment Settings

Define if and when a contact can go through the same sequence again.

- **One-Time Only**: Standard for Welcome or Onboarding flows.
- **Allow Re-enrollment**: Useful for transactional or periodic flows (e.g., "Monthly Survey").
- **Cooldown Periods**: Allow re-enrollment only after a set amount of time (e.g., "Once every 90 days").

## 3. Global Suppression

Ensure your sequences don't conflict with other marketing efforts.

- **Mutually Exclusive**: Prevent contacts from being in Sequence A and Sequence B simultaneously.
- **Do Not Disturb (DND)**: Respect global blacklists or temporary suppression tags (e.g., `pause-marketing`).

## 4. Sequence Health Analytics

Monitor the lifecycle performance of your workflow:

- **Completion Rate**: What percentage of contacts reach the final step?
- **Mean Time to Conversion**: How many days does the average contact take to reach the goal?
- **Step Fatigue**: Identify which step has the highest unsubscribe rate.
