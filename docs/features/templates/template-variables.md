---
title: "Template Variables"
description: "Dynamic content insertion with merge tags, default values, conditional blocks, and personalization variables"
level: "2"
status: "PLANNED"
roadmap_timeline: "Q2 2026"
priority: "High"
related_features:


  - templates/template-editor


  - templates/template-management


  - campaigns/personalization-system


  - leads/leads-management
related_tasks:


  - epic-6-templates-content
---

{% raw %}

# Template Variables

**Quick Access**: Personalize emails at scale with dynamic variables, conditional content, and merge tags that automatically populate with contact data.

## Overview

Template Variables enable you to create dynamic, personalized email content that adapts to each recipient. Use merge tags to insert contact information, conditional logic to show/hide content, and default values to handle missing data gracefully.

### Key Capabilities

- **Merge Tags**: Insert contact data with `{{variable_name}}`

- **Default Values**: Fallback content when data is missing

- **Conditional Blocks**: Show/hide content based on conditions

- **Custom Variables**: Workspace-specific variables

- **Dynamic Content**: Personalize images, links, and text

- **Testing & Preview**: Test with sample data before sending

- **Nested Variables**: Complex data structures

- **Date Formatting**: Display dates in any format

---

## Level 1: Quick Start Guide

### Basic Merge Tags

#### Standard Contact Fields

```text

Hi {{first_name}},

Welcome to {{company}}! We're excited to have you on board.

Your account email is: {{email}}

Best regards,
The {{workspace_name}} Team


```

**Output Example:**

```text

Hi John,

Welcome to Acme Inc! We're excited to have you on board.

Your account email is: john@acme.com

Best regards,
The PenguinMails Team


```

#### Available Standard Variables

```yaml
Contact Information:
  {{first_name}}        # John
  {{last_name}}         # Doe
  {{full_name}}         # John Doe
  {{email}}             # john@example.com
  {{phone}}             # +1-555-123-4567
  {{company}}           # Acme Inc
  {{job_title}}         # Marketing Director

Location:
  {{city}}              # San Francisco
  {{state}}             # California
  {{country}}           # United States
  {{timezone}}          # America/Los_Angeles

Account:
  {{lead_score}}        # 87
  {{created_at}}        # 2025-10-15
  {{last_activity}}     # 2025-11-24

Workspace:
  {{workspace_name}}    # PenguinMails
  {{workspace_url}}     # https://app.penguinmails.com
  {{sender_name}}       # Sarah Johnson
  {{sender_email}}      # sarah@penguinmails.com


```

### Default Values

#### Basic Syntax

```text

Hi {{first_name | default: "there"}},

Welcome to {{company | default: "our platform"}}!


```

**When Data Exists:**

```text

Hi John,
Welcome to Acme Inc!


```

**When Data Missing:**

```text

Hi there,
Welcome to our platform!


```

#### Multiple Fallbacks

```text

{{first_name | default: {{contact_name}} | default: "Valued Customer"}}


```

**Fallback Chain:**

1. Try `first_name`

2. If empty, try `contact_name`

3. If empty, use "Valued Customer"

### Conditional Content

#### Simple If/Else

```text

{% if lead_score >= 75 %}
  You're a VIP customer! Here's an exclusive offer...
{% else %}
  Check out our latest features...
{% endif %}


```

#### If/Elsif/Else

```text

{% if lead_score >= 90 %}
  🌟 Platinum Tier - Exclusive Access
{% elsif lead_score >= 75 %}
  ⭐ Gold Tier - Premium Benefits
{% elsif lead_score >= 50 %}
  ✨ Silver Tier - Great Perks
{% else %}
  👋 Welcome - Getting Started
{% endif %}


```

#### Checking for Empty Values

```text

{% if company %}
  We noticed you work at {{company}}.
{% else %}
  Tell us about your company!
{% endif %}


```

### Quick Examples

#### Personalized Greeting

```text

{% if first_name %}
  Hi {{first_name}},
{% else %}
  Hello,
{% endif %}

Thanks for being a valued customer!


```

#### Location-Based Content

```text

{% if country == "United States" %}
  Free shipping on orders over $50!
{% elsif country == "Canada" %}
  Free shipping on orders over $75 CAD!
{% else %}
  International shipping available!
{% endif %}


```

#### Account Type Messaging

```text

{% if custom.account_type == "trial" %}
  Your trial expires in {{custom.trial_days_remaining}} days.
  [Upgrade Now →]
{% elsif custom.account_type == "paid" %}
  Thanks for being a premium customer!
{% else %}
  [Start Your Free Trial →]
{% endif %}


```

---

## Level 2: Advanced Variable Usage

### Custom Fields

#### Accessing Custom Fields

```text

Standard Syntax:
  {{custom.industry}}
  {{custom.company_size}}
  {{custom.annual_revenue}}

Nested Custom Fields:
  {{custom.preferences.email_frequency}}
  {{custom.settings.notifications_enabled}}


```

#### Custom Field Examples

```text

Industry-Specific Content:
  {% if custom.industry == "SaaS" %}
    Discover how {{company}} can scale with our API...
  {% elsif custom.industry == "E-commerce" %}
    Boost your online sales with our platform...
  {% endif %}

Company Size Targeting:
  {% if custom.company_size >= 200 %}
    Enterprise solutions for large teams
  {% elsif custom.company_size >= 50 %}
    Team plans for growing businesses
  {% else %}
    Starter plans for small teams
  {% endif %}


```

### Advanced Conditionals

#### Multiple Conditions (AND)

```text

{% if lead_score >= 75 and custom.account_type == "trial" %}
  You're a highly engaged trial user!
  [Upgrade to unlock premium features →]
{% endif %}


```

#### Multiple Conditions (OR)

```text

{% if country == "United States" or country == "Canada" %}
  North American customers get free shipping!
{% endif %}


```

#### Complex Logic

```text

{% if (lead_score >= 75 and custom.account_type == "trial") or custom.is_vip == true %}
  🎁 Special offer just for you!

  {% if custom.account_type == "trial" %}
    Upgrade now and get 20% off your first year!
  {% else %}
    Exclusive VIP discount: 15% off your next renewal!
  {% endif %}
{% endif %}


```

#### Comparison Operators

```yaml
Equals:
  {% if status == "active" %}

Not Equals:
  {% if status != "cancelled" %}

Greater Than:
  {% if lead_score > 50 %}

Greater Than or Equal:
  {% if lead_score >= 75 %}

Less Than:
  {% if days_inactive < 30 %}

Less Than or Equal:
  {% if age <= 65 %}

Contains:
  {% if tags contains "vip" %}

Not Contains:
  {% if tags not_contains "unsubscribed" %}


```

### Dynamic Links

#### Personalized URLs

```text

Track your order:
<a href="https://example.com/orders/{{order_id}}?email={{email}}">
  View Order #{{order_id}}
</a>

Personalized landing page:
<a href="https://example.com/welcome?name={{first_name}}&ref={{campaign_id}}">
  Get Started
</a>


```

#### UTM Parameters

```text

<a href="{{landing_page_url}}?utm_source=email&utm_medium=campaign&utm_campaign={{campaign_name}}&utm_content={{email}}">
  Click Here
</a>

Output:
https://example.com/offer?utm_source=email&utm_medium=campaign&utm_campaign=welcome_series&utm_content=john@example.com


```

### Dynamic Images

#### Personalized Images

```text

<img src="https://api.example.com/badge/{{first_name}}/{{lead_score}}"
     alt="Your Score: {{lead_score}}">

<img src="{{cdn_url}}/images/{{custom.industry}}-hero.jpg"
     alt="{{custom.industry}} Solutions">


```

#### Conditional Images

```text

{% if lead_score >= 90 %}
  <img src="{{cdn_url}}/badges/platinum.png" alt="Platinum Member">
{% elsif lead_score >= 75 %}
  <img src="{{cdn_url}}/badges/gold.png" alt="Gold Member">
{% elsif lead_score >= 50 %}
  <img src="{{cdn_url}}/badges/silver.png" alt="Silver Member">
{% endif %}


```

### Date & Time Formatting

#### Date Filters

```text

Account created:
  {{created_at | date: "MMMM DD, YYYY"}}
  Output: November 24, 2025

Last activity:
  {{last_activity | date: "MMM D, YYYY"}}
  Output: Nov 24, 2025

Short date:
  {{created_at | date: "MM/DD/YY"}}
  Output: 11/24/25

Relative time:
  {{last_activity | time_ago}}
  Output: 2 hours ago


```

#### Date Calculations

```text

Trial expiration:
  {% assign trial_end = created_at | date_add: 14, "days" %}
  Your trial expires on {{trial_end | date: "MMMM DD, YYYY"}}

Days remaining:
  {% assign days_left = trial_end_date | days_from_now %}
  {{days_left}} days left in your trial


```

### Loops & Iterations

#### Loop Through Lists

```text

Your recent purchases:

{% for item in recent_purchases %}


  - {{item.name}} - ${{item.price}}
{% endfor %}

Output:
Your recent purchases:


  - Widget Pro - $49.99


  - Gadget Plus - $29.99


  - Tool Kit - $79.99


```

#### Loop with Conditionals

```text

{% for tag in tags %}
  {% if tag == "vip" %}
    🌟 VIP Member
  {% elsif tag == "enterprise" %}
    🏢 Enterprise Customer
  {% endif %}
{% endfor %}


```

#### Loop Limits

```text

Top 3 products:

{% for product in recommended_products limit: 3 %}
  {{forloop.index}}. {{product.name}} - ${{product.price}}
{% endfor %}


```

### String Manipulation

#### Text Filters

```text

Uppercase:
  {{company | upcase}}
  Output: ACME INC

Lowercase:
  {{email | downcase}}
  Output: john@example.com

Capitalize:
  {{first_name | capitalize}}
  Output: John

Title Case:
  {{company | titlecase}}
  Output: Acme Inc

Truncate:
  {{description | truncate: 50}}
  Output: This is a long description that will be...

Strip HTML:
  {{bio | strip_html}}
  Removes all HTML tags


```

#### String Operations

```text

Concatenation:
  {{first_name}} {{last_name}}
  Output: John Doe

Replace:
  {{phone | replace: "-", " "}}
  Input: 555-123-4567
  Output: 555 123 4567

Split:
  {% assign name_parts = full_name | split: " " %}
  First: {{name_parts[0]}}
  Last: {{name_parts[1]}}


```

### Number Formatting

#### Number Filters

```text

Currency:
  {{revenue | currency}}
  Output: $1,234.56

  {{revenue | currency: "EUR"}}
  Output: €1,234.56

Percentage:
  {{conversion_rate | percentage}}
  Output: 12.5%

Round:
  {{lead_score | round}}
  Output: 87

Thousands separator:
  {{subscribers | number_with_delimiter}}
  Output: 1,234,567


```

### Math Operations

```text

Addition:
  {% assign total = price + tax %}
  Total: ${{total}}

Subtraction:
  {% assign discount_price = price - discount %}
  Sale Price: ${{discount_price}}

Multiplication:
  {% assign total = quantity * price %}
  Total: ${{total}}

Division:
  {% assign monthly = annual_price | divided_by: 12 %}
  Monthly: ${{monthly}}


```

---

## Level 3: Technical Implementation

### Database Schema

```sql
-- Template variables (workspace-level)
CREATE TABLE template_variables (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  workspace_id UUID REFERENCES workspaces(id),

  -- Variable definition
  variable_key VARCHAR(255) NOT NULL,
  variable_name VARCHAR(255),
  description TEXT,

  -- Value
  default_value TEXT,
  variable_type VARCHAR(50),  -- string, number, boolean, date, url

  -- Validation
  is_required BOOLEAN DEFAULT FALSE,
  validation_rules JSONB,

  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),

  UNIQUE(tenant_id, workspace_id, variable_key)
);

CREATE INDEX idx_template_variables_tenant ON template_variables(tenant_id);
CREATE INDEX idx_template_variables_workspace ON template_variables(workspace_id);

-- Variable usage tracking
CREATE TABLE variable_usage (
  id UUID PRIMARY KEY,
  template_id UUID REFERENCES templates(id),
  variable_key VARCHAR(255),

  usage_count INTEGER DEFAULT 0,
  last_used_at TIMESTAMP,

  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_variable_usage_template ON variable_usage(template_id);


```

### Variable Parser Service

```typescript
interface VariableContext {
  contact: Contact;
  workspace: Workspace;
  campaign?: Campaign;
  customVariables?: Record<string, any>;
}

interface ParseOptions {
  strictMode?: boolean;  // Throw error on missing variables
  escapeHtml?: boolean;
  trackUsage?: boolean;
}

class VariableParser {
  async parseTemplate(
    templateContent: string,
    context: VariableContext,
    options: ParseOptions = {}
  ): Promise<string> {
    let parsed = templateContent;

    // Parse merge tags
    parsed = await this.parseMergeTags(parsed, context, options);

    // Parse conditional blocks
    parsed = await this.parseConditionals(parsed, context);

    // Parse loops
    parsed = await this.parseLoops(parsed, context);

    // Escape HTML if needed
    if (options.escapeHtml) {
      parsed = this.escapeHtml(parsed);
    }

    return parsed;
  }

  private async parseMergeTags(
    content: string,
    context: VariableContext,
    options: ParseOptions
  ): Promise<string> {
    // Match {{variable_name}} or {{variable_name | filter: "arg"}}
    const mergeTagRegex = /\{\{([^}]+)\}\}/g;

    return content.replace(mergeTagRegex, (match, variable) => {
      const parts = variable.split('|').map(p => p.trim());
      const variableName = parts[0];
      const filters = parts.slice(1);

      // Get variable value
      let value = this.getVariableValue(variableName, context);

      // Apply filters
      for (const filter of filters) {
        value = this.applyFilter(value, filter);
      }

      // Handle missing values
      if (value === null || value === undefined) {
        if (options.strictMode) {
          throw new Error(`Variable not found: ${variableName}`);
        }
        return '';
      }

      // Track usage
      if (options.trackUsage) {
        this.trackVariableUsage(variableName);
      }

      return String(value);
    });
  }

  private getVariableValue(
    variableName: string,
    context: VariableContext
  ): any {
    // Handle nested properties (e.g., "custom.industry")
    const parts = variableName.split('.');
    let value: any = context;

    for (const part of parts) {
      if (value && typeof value === 'object') {
        value = value[part];
      } else {
        return null;
      }
    }

    return value;
  }

  private applyFilter(value: any, filter: string): any {
    const [filterName, ...args] = filter.split(':').map(s => s.trim());

    switch (filterName) {
      case 'default':
        return value || args[0]?.replace(/['"]/g, '');

      case 'upcase':
        return String(value).toUpperCase();

      case 'downcase':
        return String(value).toLowerCase();

      case 'capitalize':
        return String(value).charAt(0).toUpperCase() + String(value).slice(1);

      case 'titlecase':
        return String(value).replace(/\w\S*/g, (txt) =>
          txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()
        );

      case 'truncate':
        const length = parseInt(args[0]) || 50;
        return String(value).length > length
          ? String(value).substring(0, length) + '...'
          : value;

      case 'date':
        const format = args[0]?.replace(/['"]/g, '') || 'YYYY-MM-DD';
        return this.formatDate(value, format);

      case 'currency':
        const currency = args[0]?.replace(/['"]/g, '') || 'USD';
        return this.formatCurrency(value, currency);

      case 'percentage':
        return `${(parseFloat(value) * 100).toFixed(1)}%`;

      case 'round':
        return Math.round(parseFloat(value));

      case 'number_with_delimiter':
        return parseFloat(value).toLocaleString();

      default:
        return value;
    }
  }

  private async parseConditionals(
    content: string,
    context: VariableContext
  ): Promise<string> {
    // Match {% if condition %} ... {% endif %}
    const conditionalRegex = /\{% if (.+?) %\}([\s\S]*?)\{% endif %\}/g;

    return content.replace(conditionalRegex, (match, condition, body) => {
      // Parse elsif and else
      const parts = body.split(/\{% elsif (.+?) %\}|\{% else %\}/);

      // Evaluate main condition
      if (this.evaluateCondition(condition, context)) {
        return parts[0];
      }

      // Check elsif conditions
      for (let i = 1; i < parts.length; i += 2) {
        if (parts[i] && this.evaluateCondition(parts[i], context)) {
          return parts[i + 1] || '';
        }
      }

      // Return else block if exists
      return parts[parts.length - 1] || '';
    });
  }

  private evaluateCondition(
    condition: string,
    context: VariableContext
  ): boolean {
    // Parse condition (e.g., "lead_score >= 75")
    const operators = ['>=', '<=', '==', '!=', '>', '<', 'contains', 'not_contains'];

    for (const op of operators) {
      if (condition.includes(op)) {
        const [left, right] = condition.split(op).map(s => s.trim());

        const leftValue = this.getVariableValue(left, context);
        const rightValue = right.replace(/['"]/g, '');

        switch (op) {
          case '==':
            return leftValue == rightValue;
          case '!=':
            return leftValue != rightValue;
          case '>':
            return parseFloat(leftValue) > parseFloat(rightValue);
          case '<':
            return parseFloat(leftValue) < parseFloat(rightValue);
          case '>=':
            return parseFloat(leftValue) >= parseFloat(rightValue);
          case '<=':
            return parseFloat(leftValue) <= parseFloat(rightValue);
          case 'contains':
            return String(leftValue).includes(rightValue);
          case 'not_contains':
            return !String(leftValue).includes(rightValue);
        }
      }
    }

    // Simple truthy check
    return !!this.getVariableValue(condition, context);
  }

  private async parseLoops(
    content: string,
    context: VariableContext
  ): Promise<string> {
    // Match {% for item in items %} ... {% endfor %}
    const loopRegex = /\{% for (\w+) in (\w+)(?: limit: (\d+))? %\}([\s\S]*?)\{% endfor %\}/g;

    return content.replace(loopRegex, (match, itemVar, arrayVar, limit, body) => {
      const array = this.getVariableValue(arrayVar, context);

      if (!Array.isArray(array)) {
        return '';
      }

      const limitNum = limit ? parseInt(limit) : array.length;
      const items = array.slice(0, limitNum);

      return items.map((item, index) => {
        const loopContext = {
          ...context,
          [itemVar]: item,
          forloop: {
            index: index + 1,
            index0: index,
            first: index === 0,
            last: index === items.length - 1,
            length: items.length,
          },
        };

        return this.parseMergeTags(body, loopContext, {});
      }).join('');
    });
  }

  private formatDate(value: any, format: string): string {
    const date = new Date(value);

    // Simple date formatting (use library like date-fns in production)
    const formats: Record<string, string> = {
      'YYYY-MM-DD': date.toISOString().split('T')[0],
      'MMMM DD, YYYY': date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      }),
      'MMM D, YYYY': date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
      }),
      'MM/DD/YY': date.toLocaleDateString('en-US', {
        year: '2-digit',
        month: '2-digit',
        day: '2-digit'
      }),
    };

    return formats[format] || date.toISOString();
  }

  private formatCurrency(value: any, currency: string): string {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency,
    }).format(parseFloat(value));
  }

  private escapeHtml(content: string): string {
    return content
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }

  private trackVariableUsage(variableName: string): void {
    // Track which variables are being used
    // Useful for analytics and cleanup
  }
}


```

### API Endpoints

```typescript
// Parse template with test data
app.post('/api/templates/:id/parse', authenticate, async (req, res) => {
  const { testData } = req.body;

  const template = await db.templates.findById(req.params.id);
  const parser = new VariableParser();

  const context: VariableContext = {
    contact: testData.contact || {},
    workspace: await db.workspaces.findById(template.workspaceId),
    customVariables: testData.customVariables || {},
  };

  const parsed = await parser.parseTemplate(
    template.htmlContent,
    context,
    { escapeHtml: false }
  );

  return res.json({ parsed });
});

// Get available variables
app.get('/api/templates/variables', authenticate, async (req, res) => {
  const standardVariables = [
    { key: 'first_name', name: 'First Name', type: 'string' },
    { key: 'last_name', name: 'Last Name', type: 'string' },
    { key: 'email', name: 'Email', type: 'string' },
    { key: 'company', name: 'Company', type: 'string' },
    { key: 'lead_score', name: 'Lead Score', type: 'number' },
    // ... more standard variables
  ];

  const customVariables = await db.templateVariables.findAll({
    where: { tenantId: req.user.tenantId },
  });

  return res.json({
    standard: standardVariables,
    custom: customVariables,
  });
});

// Create custom variable
app.post('/api/templates/variables', authenticate, async (req, res) => {
  const { variableKey, variableName, defaultValue, variableType } = req.body;

  const variable = await db.templateVariables.create({
    tenantId: req.user.tenantId,
    workspaceId: req.body.workspaceId,
    variableKey,
    variableName,
    defaultValue,
    variableType,
  });

  return res.json(variable);
});


```

---

## Related Documentation

- **[Template Editor](/docs/features/templates/template-editor)** - Visual template creation

- **[Template Management](/docs/features/templates/template-management)** - Template organization

- **[Personalization System](/docs/features/campaigns/personalization-system)** - Advanced personalization

- **[Leads Management](/docs/features/leads/leads-management)** - Contact data source

---

**Last Updated:** November 25, 2025
**Status:** Planned - High Priority (Level 2)
**Target Release:** Q2 2026
**Owner:** Templates Team

{% endraw %}
