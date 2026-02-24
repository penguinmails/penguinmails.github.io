---
title: "Template Variables - API Reference"
description: "API endpoints for parsing templates and managing custom variables."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# Template Variables - API Reference

## API Endpoints

### Parse Template

Parse a template with test data to verify variable resolution.

**Endpoint:** `POST /api/templates/:id/parse`

**Request Body:**

```json
{
  "testData": {
    "first_name": "John",
    "company": "Acme Inc",
    "recent_purchases": [
      { "name": "Widget", "price": 49.99 }
    ]
  }
}
```

**Response:**

```json
{
  "parsedContent": "Hi John, Welcome to Acme Inc!...",
  "variablesUsed": ["first_name", "company", "recent_purchases"],
  "missingVariables": []
}
```

---

### Get Available Variables

Retrieve all standard and custom variables available for a workspace.

**Endpoint:** `GET /api/templates/variables`

**Response:**

```json
{
  "standard": [
    { "key": "first_name", "category": "Contact" },
    { "key": "email", "category": "Contact" },
    { "key": "company", "category": "Workspace" }
  ],
  "custom": [
    { "key": "loyalty_points", "name": "Loyalty Points", "type": "number" }
  ]
}
```

---

### Create Custom Variable

Register a new custom variable for use in templates.

**Endpoint:** `POST /api/templates/variables`

**Request Body:**

```json
{
  "variableKey": "discount_code",
  "variableName": "Personalized Discount Code",
  "variableType": "string",
  "defaultValue": "WELCOME10"
}
```

---

## Related Documentation

- **[Email Templates](/docs/features/templates/email-templates)** - Creating and managing templates
- **[Campaign Sequences](/docs/features/campaigns/campaign-sequences)** - Using templates in automated workflows
- **[Leads Management](/docs/features/leads/leads-management)** - Contact data source
