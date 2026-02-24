---
title: "API Usage Analytics UI"
description: "Specifications for API volume charts, error analysis, and rate limit monitoring."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers, Designers"
---

# API Usage Analytics UI

**Visualizing API performance, health, and throughput over time.**

---

## 1. Usage Summary

A high-level view of integration health.

### Metrics Cards

- **Total Requests**: Rolling 24h count.
- **Success Rate**: Percentage of `2xx` responses.
- **Avg Latency**: P95 response time for all API calls.
- **Active Keys**: Count of keys currently in use.

---

## 2. Volume & Performance Charts

- **Request Volume**: Time-series line chart showing Total vs Failed requests.
- **Endpoint Popularity**: Horizontal bar chart showing the most used endpoints (e.g., `POST /v1/emails/send`).
- **Latency Heatmap**: Visualizing response times across different geographic nodes.

---

## 3. Error Analysis & Rate Limits

### Error Breakdown

A detailed table or pie chart showing the distribution of `4xx` and `5xx` errors.

- **401**: Auth issues (expired keys).
- **429**: Rate limit hits.
- **400**: Schema validation failures.

### Rate Limit Monitor

A specialized progress bar or gauge showing current throughput vs the account's allocated limit (e.g., 300 Req/Min).

- **Burst Capacity**: Visualization of the "Leaky Bucket" state.
- **Reset Timer**: Real-time countdown until the next rate limit window.

---

## 4. IP Reputation Overlay (Developer View)

Overlaying API usage with sending IP reputation to identify correlations between integration volume and deliverability issues.
