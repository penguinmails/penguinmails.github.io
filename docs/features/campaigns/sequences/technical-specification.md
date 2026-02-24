---
title: "Email Sequences Technical Specification"
description: "Workflow engine architecture, graph-based routing, and enrollment state management."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers, Data Engineers"
---

# Email Sequences Technical Specification

The sequence engine treats automated workflows as Directed Acyclic Graphs (DAGs) where nodes represent actions or delays and edges represent logic paths.

## Database Schema

### `sequences`

The parent record defining global settings and trigger conditions.

### `sequence_steps`

Individual nodes in the workflow.

- `step_type`: `email`, `delay`, `branch`, `goal`, `internal_action`.
- `payload`: JSONB configuration for the specific step.

### `contact_sequences` (Enrollment State)

Tracks the progress of a specific contact through a sequence.

- `current_step_id`: Pointer to the next node to be executed.
- `next_execution_at`: Timestamp for the next worker check.
- `status`: `active`, `paused`, `completed`, `exited_on_goal`.

## Sequence Engine Architecture

The engine runs as a periodic background process (every minute) with the following lifecycle:

1. **Check Due**: Query `contact_sequences` where `next_execution_at <= NOW()`.
2. **Execute Step**: Determine the step type and execute its logic.
   - **Email**: Render with [Personalization System](/docs/features/campaigns/personalization-system) and send via [Email Service](/docs/features/infrastructure/email-infrastructure-setup).
   - **Delay**: Update `next_execution_at` and exit the worker.
   - **Branch**: Evaluate the `condition_expression` and move the `current_step_id` to the appropriate child node.
3. **Next Step Pointer**: Upon successful execution (non-delay), move the pointer to the next child node and re-evaluate.

## Reliability & Scalability

- **Idempotency**: Every step execution is wrapped in a transaction to ensure pointers are only moved after successful action (e.g., email successfully queued).
- **Concurrency**: The processor is horizontally scalable across multiple regions.
- **Fail-safe**: Steps that fail consistently (e.g., API unreachable) are marked as `dead_letter` and trigger a tenant notification.
