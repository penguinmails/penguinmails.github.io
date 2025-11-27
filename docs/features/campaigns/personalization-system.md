---
title: "Personalization System"
description: "Dynamic email personalization with merge tags, conditional content, and custom fields"
level: "2"
status: "PLANNED"
roadmap_timeline: "Q1 2026"
priority: "High"
related_features:


  - campaigns/campaign-management/overview


  - campaigns/ab-testing


  - templates/template-management


  - leads/leads-management
related_tasks:


  - epic-6-core-email-pipeline


  - epic-7-leads-management
---


# Personalization System

**Quick Access**: Create dynamic, personalized emails using merge tags, conditional content blocks, and custom data fields.


## Overview

The Personalization System enables 1:1 email customization at scale by dynamically inserting contact data, displaying conditional content, and adapting messaging based on recipient attributes and behavior.


### Key Capabilities


- **Merge Tags**: Insert contact data ({{firstName}}, {{company}}, etc.)


- **Conditional Content**: Show/hide blocks based on conditions


- **Custom Fields**: Use any contact attribute for personalization


- **Fallback Values**: Default content when data is missing


- **Preview & Testing**: Test personalization before sending

---


## Level 1: Quick Start Guide


### Basic Merge Tags

Insert contact information directly into your emails:


```

Hi {{firstName}},

I noticed you're from {{company}} in {{city}}. 
We've helped companies like yours increase email 
performance by {{customField.industryBenchmark}}%.

Best regards,
{{senderName}}


```

**Standard Merge Tags:**


```shell


- `{{firstName}}` - Contact's first name


- `{{lastName}}` - Contact's last name


- `{{email}}` - Email address


- `{{company}}` - Company name


- `{{jobTitle}}` - Job title


- `{{city}}` - City


- `{{state}}` - State/Province


- `{{country}}` - Country


```


### Fallback Values

Provide defaults when data is missing:


```

Hi {{firstName|there}},

{{company|Your company}} could benefit from...


```

**Result:**


- If firstName exists: "Hi Sarah,"


- If firstName missing: "Hi there,"


### Using Custom Fields

Access any custom field from your contact records:


```

{{customField.subscribedDate}}
{{customField.leadScore}}
{{customField.industry}}
{{customField.lastPurchaseAmount}}


```


### Preview Personalization

Before sending, preview how emails appear to different contacts:


1. Click "Preview Personalization"


2. Select contact or enter test data


3. View rendered email


4. Test multiple contacts to ensure formatting

---


## Level 2: Advanced Personalization


### Conditional Content

Show different content blocks based on contact attributes:

**Basic Conditional:**


```

{% if company %}
  We've helped companies like {{company}} achieve...
{% else %}
  We've helped businesses like yours achieve...
{% endif %}


```

**Multiple Conditions:**


```

{% if leadScore > 50 %}
  You're a valued customer! Here's an exclusive offer...
{% elsif leadScore > 20 %}
  Thanks for your interest! Let us show you more...
{% else %}
  Welcome! Here's how we can help...
{% endif %}


```

**Conditional by Industry:**


```

{% if customField.industry == "SaaS" %}
  Our platform integrates seamlessly with your tech stack.
{% elsif customField.industry == "E-commerce" %}
  Boost your cart abandonment recovery by 35%.
{% else %}
  Discover how email automation can grow your business.
{% endif %}


```


### Personalized CTAs

Adapt call-to-action based on contact status:


```

{% if customField.trialUser %}
  <a href="{{upgradeLink}}">Upgrade to Premium</a>
{% elsif customField.freeUser %}
  <a href="{{trialLink}}">Start Your Free Trial</a>
{% else %}
  <a href="{{signupLink}}">Get Started Free</a>
{% endif %}


```


### Date-Based Personalization

Use date fields for dynamic content:


```

{% if customField.subscriptionRenewalDate < now + 30days %}
  Your subscription renews on {{customField.subscriptionRenewalDate|date('F j, Y')}}.
  Renew now and save 20%!
{% endif %}


```


### Behavioral Personalization

Personalize based on past actions:


```

{% if customField.lastPurchaseDate > now - 90days %}
  Thanks for your recent purchase! Here's what's new...
{% else %}
  We miss you! Come back and save 15%...
{% endif %}


```


### Dynamic Product Recommendations

Show relevant products:


```

Based on your interest in {{customField.lastViewedProduct}}, 
you might also like:

{% for product in relatedProducts %}


  - {{product.name}} - ${{product.price}}
{% endfor %}


```


### Localization

Adapt content by location:


```

{% if country == "United States" %}
  Free shipping on orders over $50!
{% elsif country == "Canada" %}
  Free shipping on orders over CAD $75!
{% elsif country == "United Kingdom" %}
  Free shipping on orders over £40!
{% endif %}


```


### A/B Testing with Personalization

Combine with A/B testing:


```

Test A: Hi {{firstName}},
Test B: Hi {{firstName}}, fellow {{customField.industry}} professional,


```

---


## Level 3: Technical Implementation


### Templating Engine

Uses Liquid-based syntax for compatibility:


```typescript
import { Liquid } from 'liquidjs';

const engine = new Liquid({
  cache: true,
  strictFilters: true,
  strictVariables: false, // Allow missing vars with fallbacks
});

// Register custom filters
engine.registerFilter('phoneFormat', (phone: string) => {
  return phone.replace(/(\d{3})(\d{3})(\d{4})/, '($1) $2-$3');
});

engine.registerFilter('currency', (amount: number, currency = 'USD') => {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency,
  }).format(amount);
});


```


### Merge Tag Resolution


```typescript
interface PersonalizationContext {
  contact: Contact;
  campaign: Campaign;
  customFields: Record<string, any>;
  computed: Record<string, any>;
}

async function renderPersonalizedEmail(
  template: string,
  contact: Contact
): Promise<string> {
  // Build context
  const context: PersonalizationContext = {
    contact: {
      firstName: contact.firstName,
      lastName: contact.lastName,
      email: contact.email,
      company: contact.company,
      // ... other standard fields
    },
    customFields: contact.customFields || {},
    computed: await this.computeDynamicFields(contact),
  };
  
  // Render template
  try {
    const rendered = await engine.parseAndRender(template, context);
    return rendered;
  } catch (error) {
    logger.error('Personalization error:', error);
    // Fallback to unpersonalized template
    return this.stripMergeTags(template);
  }
}

async function computeDynamicFields(contact: Contact): Promise<Record<string, any>> {
  return {
    daysSinceSignup: differenceInDays(new Date(), contact.createdAt),
    isRecentCustomer: contact.lastPurchaseDate && 
      differenceInDays(new Date(), contact.lastPurchaseDate) < 90,
    recommendedProducts: await this.getRecommendations(contact),
  };
}


```


### Database Schema


```sql
-- Contact custom fields (JSONB for flexibility)
CREATE TABLE contacts (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL,
  
  -- Standard fields
  email VARCHAR(255) UNIQUE NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  company VARCHAR(255),
  job_title VARCHAR(100),
  city VARCHAR(100),
  state VARCHAR(100),
  country VARCHAR(100),
  
  -- Custom fields (schemaless)
  custom_fields JSONB DEFAULT '{}',
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Index for custom field queries
CREATE INDEX idx_contacts_custom_fields ON contacts USING GIN(custom_fields);

-- Custom field definitions (for UI/validation)
CREATE TABLE custom_field_definitions (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL,
  
  field_name VARCHAR(100) NOT NULL,
  field_type VARCHAR(50), -- text, number, date, boolean, dropdown
  field_label VARCHAR(255),
  
  -- Validation
  is_required BOOLEAN DEFAULT FALSE,
  default_value TEXT,
  options JSONB, -- For dropdown fields
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  
  UNIQUE(tenant_id, field_name)
);


```


### Personalization Validation

{% raw %}


```typescript
class PersonalizationValidator {
  async validateTemplate(template: string, tenantId: string): Promise<ValidationResult> {
    const errors: ValidationError[] = [];
    const warnings: ValidationWarning[] = [];
    
    // Find all merge tags
    const mergeTags = this.extractMergeTags(template);
    
    for (const tag of mergeTags) {
      // Check if field exists
      const fieldExists = await this.fieldExists(tag, tenantId);
      
      if (!fieldExists) {
        warnings.push({
          tag,
          message: `Field "${tag}" not found in contact schema. Will use fallback.`,
        });
      }
      
      // Check for proper fallback syntax
      if (!tag.includes('|') && !fieldExists) {
        warnings.push({
          tag,
          message: `Consider adding fallback: {{${tag}|default value}}`,
        });
      }
    }
    
    // Find conditional blocks
    const conditionals = this.extractConditionals(template);
    
    for (const conditional of conditionals) {
      try {
        await engine.parse(conditional);
      } catch (error) {
        errors.push({
          block: conditional,
          message: `Syntax error: ${error.message}`,
        });
      }
    }
    
    return {
      isValid: errors.length === 0,
      errors,
      warnings,
    };
  }
  
  private extractMergeTags(template: string): string[] {
    const regex = /\{\{([^}]+)\}\}/g;
    const matches = template.matchAll(regex);
    return Array.from(matches).map(m => m[1].trim().split('|')[0]);
  }
}


```

{% endraw %}


### Performance Optimization


```typescript
// Batch personalization for bulk sends
async function batchPersonalize(
  template: string,
  contacts: Contact[]
): Promise<Map<string, string>> {
  const resultsMap = new Map<string, string>();
  
  // Parse template once
  const parsedTemplate = await engine.parse(template);
  
  // Render for each contact (parallel)
  await Promise.all(
    contacts.map(async (contact) => {
      const context = await this.buildContext(contact);
      const rendered = await engine.render(parsedTemplate, context);
      resultsMap.set(contact.id, rendered);
    })
  );
  
  return resultsMap;
}

// Cache compiled templates
const templateCache = new LRU<string, Template>({
  max: 1000,
  ttl: 1000 * 60 * 60, // 1 hour
});

async function renderCached(templateId: string, context: any): Promise<string> {
  let compiled = templateCache.get(templateId);
  
  if (!compiled) {
    const template = await db.templates.findById(templateId);
    compiled = await engine.parse(template.content);
    templateCache.set(templateId, compiled);
  }
  
  return engine.render(compiled, context);
}


```

---


## Related Documentation


- **[Campaign Management](./campaign-management/overview.md)** - Create personalized campaigns


- **[A/B Testing](./ab-testing.md)** - Test personalized variants


- **[Template Management](../templates/template-management.md)** - Build reusable templates


- **[Leads Management](../leads/leads-management.md)** - Contact data and custom fields

---

**Last Updated:** November 25, 2025  
**Status:** Planned - MVP Feature (Level 2)  
**Target Release:** Q1 2026  
**Owner:** Campaigns Team
