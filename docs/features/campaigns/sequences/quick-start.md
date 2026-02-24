---
title: "Email Sequences Quick Start"
description: "How to design and launch your first automated email funnel."
last_modified_date: "2026-02-24"
level: "2"
persona: "Marketers, Sales Teams"
---

# Email Sequences Quick Start

Email Sequences (also known as drip campaigns or automated workflows) allow you to nurture leads through a series of timed messages without manual intervention.

## 1. Define the Trigger

Every sequence starts with an entry point. Common triggers include:

- **Segment Join**: A contact is added to a specific segment (e.g., "New Signups").
- **Form Submission**: A user fills out a web form.
- **Manual Enrollment**: You manually add an individual contact or a list to the sequence.
- **API Event**: Your application triggers enrollment via the API.

## 2. Build Your Flow

Creating a basic 3-email welcome series:

1. **Email 1 (Immediate)**: "Welcome to PenguinMails! Here's how to start."
2. **Delay**: Wait 2 days.
3. **Email 2**: "3 key features you should know about."
4. **Delay**: Wait 3 days.
5. **Email 3**: "Join our next webinar for advanced tips."

## 3. Configuration Tips

- **Send Windows**: Restrict sends to specific days (e.g., Mon-Fri) or times (e.g., 9 AM - 5 PM).
- **Test Mode**: Send every email in the sequence to yourself before activating it for live contacts.
- **Throttling**: Limit how many new contacts enter the sequence per day to maintain deliverability.

## 4. Activation

Once satisfied, click **Activate Sequence**. This will begin enrolling any *new* contacts who meet the trigger criteria.
