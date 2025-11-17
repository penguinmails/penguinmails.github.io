---
title: Customer Success Cross-Domain API Documentation
description: Comprehensive API specifications for CS integrations with Marketing, Sales, Product, Finance, Operations
last_modified_date: "2025-11-16"
level: 3
persona: "Customer Success Teams"
---

# Customer Success Cross-Domain API Documentation

## Overview

Centralized API documentation for all Customer Success cross-domain integrations. All APIs follow RESTful conventions with OpenAPI 3.0 specifications, OAuth2 authentication, and comprehensive audit logging.

**Base URL:** `https://api.penguinmails.com/v1/cs-integrations`  
**Auth:** OAuth2 with domain-scoped tokens (cs-marketing, cs-sales, etc.)  
**Rate Limits:** Domain-specific (10-50 req/min)  
**Error Format:** Standard Problem Details (RFC 7807)

---

## Authentication & Authorization

```yaml
securitySchemes:
  oauth2:
    type: oauth2
    flows:
      clientCredentials:
        tokenUrl: /auth/token
        scopes:
          cs-marketing.read: "Marketing integration read"
          cs-marketing.write: "Marketing campaign triggers"
          cs-sales.read: "Sales pipeline visibility"
          # ... domain-specific scopes
```

---

## Marketing Integration APIs

### Health Trigger API
```
POST /marketing/triggers/{customer_id}
Content-Type: application/json

Request:
{
  "health_score": 75,
  "risk_category": "monitor",
  "milestones": ["adoption_complete"]
}

Response 202:
{
  "campaign_id": "camp_123",
  "triggered_sequences": ["onboarding_nurture"],
  "estimated_impact": "15% health_uplift"
}
```

### Campaign Performance API
```
GET /marketing/performance/{campaign_id}
Response 200:
{
  "attribution_to_cs": "42%",
  "health_correlation": 0.87,
  "revenue_impact": "$12,500"
}
```

**Full Spec:** [marketing-integration-map#cs-marketing-apis](marketing-integration-map)

---

## Sales Integration APIs

### Handoff Completion API
```
POST /sales/handoff/complete/{deal_id}
Request:
{
  "success_plan_id": "sp_456",
  "baseline_kpis": {"nps_target": 8.5}
}

Response 200:
{
  "transition_complete": true,
  "knowledge_gaps": [],
  "pipeline_sync": "confirmed"
}
```

### Expansion Opportunity API
```
GET /sales/expansion/{customer_id}
Response 200:
{
  "readiness_score": 92,
  "value_portfolio": ["3x_roi_demonstrated"],
  "white_space": "$150k_annualized"
}
```

**Full Spec:** [sales-integration-map#cs-sales-apis](sales-integration-map)

---

## Product Integration APIs

### Adoption Insights API
```
GET /product/adoption/{feature_id}
Response 200:
{
  "adoption_rate": "68%",
  "health_correlation": 0.76,
  "barriers": ["onboarding_friction"],
  "recommendations": ["targeted_tutorial"]
}
```

### Feedback Submission API
```
POST /product/feedback
Request:
{
  "customer_id": "cust_789",
  "feature_id": "feat_101",
  "impact_score": 9,
  "evidence": "usage_screenshot_url"
}

Response 201:
{
  "ticket_id": "PROD-1234",
  "priority": "P1",
  "roadmap_position": "Q2_target"
}
```

**Full Spec:** [product-integration-map#cs-product-apis](product-integration-map)

---

## Finance Integration APIs

### Value Realization API
```
GET /finance/realization/{contract_id}
Response 200:
{
  "delivery_vs_commit": "102%",
  "utilization_gaps": ["feature_x_45%"],
  "roi_trajectory": "11.8x_projected"
}
```

### Forecast Adjustment API
```
POST /finance/forecast/{customer_id}
Request:
{
  "renewal_probability": 0.94,
  "confidence_interval": [0.88, 0.97],
  "scenarios": {"expansion": "$75k"}
}
```

**Full Spec:** [finance-integration-map#cs-finance-apis](finance-integration-map)

---

## Operations Integration APIs

### Workflow Execution API
```
POST /operations/execute/{workflow_id}/{customer_id}
Request:
{
  "parameters": {"escalation_tier": 2}
}

Response 202:
{
  "execution_id": "exec_567",
  "sla_target": "4h",
  "current_status": "in_progress"
}
```

### Capacity Forecast API
```
GET /operations/capacity/forecast?period=next_90d
Response 200:
{
  "utilization_projection": "82%",
  "skill_gaps": ["enterprise_complexity"],
  "hiring_triggers": ["urgent"]
}
```

**Full Spec:** [operations-integration-map#cs-operations-apis](operations-integration-map)

---

## Common Response Headers

```
X-Request-ID: unique-trace-id
X-RateLimit-Remaining: 47
X-Audit-Trail: audit-log-url
```

## Error Handling

```json
{
  "type": "https://api.penguinmails.com/errors/rate-limit",
  "title": "Rate limit exceeded",
  "detail": "Retry after 60s",
  "instance": "/v1/cs-integrations/marketing/triggers/cust_123"
}
```

---

## OpenAPI Specification

Complete OpenAPI 3.0 spec available at: `/openapi/cs-cross-domain-v1.json`

**Related Documentation:**
- [CS Cross-Domain Overview](../overview)
- [Domain Maps](../*-integration-map)

**Document Classification:** Level 3 - CS API Reference Documentation