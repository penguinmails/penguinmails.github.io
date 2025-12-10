---
title: "Sentiment Analysis & Tone Detection"
description: "Use AI to analyze message sentiment and tone"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Managers"
parent: "/docs/roadmap/product/inbox/README.md"
---

# Sentiment Analysis & Tone Detection

## Overview

**Priority**: P1 (High Value)
**Timeline**: Q2 2026
**Effort**: 3-5 days

**Description**:
Use Google Gemini AI to analyze message sentiment and tone, enabling sales reps to tailor responses based on prospect emotions.

## Use Case

Detect if a prospect is Frustrated, Enthusiastic, or Skeptical and provide tone-based reply suggestions.

## Acceptance Criteria

- Pass message content to Gemini AI for sentiment analysis
- Add `sentiment` and `tone` fields to message storage
- Display sentiment indicators in thread list and conversation view
- Provide tone-based reply suggestions
- Add sentiment filtering
- Track sentiment trends over time

## Dependencies

- Unified Inbox MVP completion
