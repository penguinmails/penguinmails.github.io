---
title: "Webhook Technical Specification"
description: "Database schema, delivery service architecture, and backend implementation for webhooks."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers, Architects"
---

# Webhook Technical Specification

The Webhook system is designed for high-throughput event delivery with guaranteed ordering and strong encryption.

## Database Schema

### `webhooks`

Stores configuration for each user-defined endpoint.

- `endpoint_url`: HTTPS destination.
- `secret_key`: Used for signing (`aes-256-gcm` encrypted).
- `enabled_events`: Array of strings defining the subscrptions.

### `webhook_events`

The source of truth for all events generated in the system. Used for persistence and replay.

- `type`: e.g., `email.opened`.
- `data`: JSONB payload.

### `webhook_deliveries`

Tracks every attempt to send an event to an endpoint.

- `status`: `success`, `failing`, `permanent_failure`.
- `attempt_number`: Current retry count.
- `next_retry_at`: Scheduled timestamp for the next attempt.

## Architecture & Flow

1. **Event Emission**: System components (e.g., Campaign Engine) emit events to a central Redis pub/sub or event bus.
2. **Persistence**: A consumer writes the event to the `webhook_events` table.
3. **Dispatch**: The Delivery Service identifies active webhooks matching the event type and creates records in `webhook_deliveries`.
4. **Execution**: A dedicated worker pool picks up pending deliveries, signs the payload, and makes the HTTPS request.
5. **Backoff**: If an attempt fails, the worker calculates the next retry time and updates the record.

## Signature Algorithm

```typescript
const signature = crypto
  .createHmac('sha256', secret)
  .update(rawBody)
  .digest('hex');
```

## Scaling Considerations

- **Concurrency**: Delivery workers are horizontally scalable.
- **Fan-out**: A single high-volume event (e.g., campaign started) can trigger thousands of webhook deliveries simultaneously. We use prioritized queues to ensure critical events (like billing) are delivered before large batch engagement updates.
