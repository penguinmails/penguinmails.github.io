---
title: "Webhook Retry & Reliability"
description: "How PenguinMails handles delivery failures and ensures event consistency."
last_modified_date: "2026-02-24"
level: "2"
persona: "Developers, DevOps"
---

# Webhook Retry & Reliability

Network issues or server downtime shouldn't cause you to miss critical data. PenguinMails implements a robust retry mechanism for all webhook deliveries.

## 1. Retry Logic

If your server returns anything other than a `2xx` status code (or fails to respond within 5 seconds), PenguinMails will retry the delivery up to 5 times with exponential backoff:

- **Retry #1**: 5 minutes after first failure.
- **Retry #2**: 15 minutes later.
- **Retry #3**: 1 hour later.
- **Retry #4**: 6 hours later.
- **Retry #5**: 24 hours later.

## 2. Webhook Health Status

We track the delivery success rate of each webhook.

- **Active**: Healthy, delivering events.
- **Failing**: Last delivery failed, pending retry.
- **Paused**: Webhook has been automatically disabled after 100 consecutive failures or manual intervention.

## 3. Monitoring Deliveries

The Webhook Detail view in your dashboard provides a live log of recent deliveries, including:

- **Status Code**: (e.g., `200`, `500`, `404`).
- **Response Body**: The first 1KB of the response returned by your server.
- **Latency**: Time taken for your server to respond.

## 4. Handling Idempotency

Because webhooks can be retried, your server might receive the same event more than once.

- **Best Practice**: Use the `id` field (e.g., `evt_abc123`) in the payload to track which events you have already processed and avoid duplicate actions in your system.
