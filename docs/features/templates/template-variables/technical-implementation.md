---
title: "Template Variables - Technical Implementation"
description: "Database schema and technical implementation of the template variable parser."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# Template Variables - Technical Implementation

## Database Infrastructure

### **template_variables** - Custom Variable Schema

```sql
CREATE TABLE template_variables (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL,
  workspace_id UUID NOT NULL,
  
  -- Variable metadata
  variable_key VARCHAR(50) NOT NULL, -- e.g., "discount_percent"
  variable_name VARCHAR(100) NOT NULL, -- e.g., "Holiday Discount Percentage"
  variable_type VARCHAR(20) DEFAULT 'string', -- string, number, boolean, date
  default_value TEXT,
  
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
  variable_id UUID REFERENCES template_variables(id),
  campaign_id UUID,
  usage_count BIGINT DEFAULT 0,
  last_used TIMESTAMP
);
```

## Variable Parser Implementation

```typescript
interface VariableContext {
  customer: Customer;
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

    // Parse loops first so they can contain merge tags
    parsed = await this.parseLoops(parsed, context);

    // Parse conditionals
    parsed = await this.parseConditionals(parsed, context);

    // Parse merge tags
    parsed = await this.parseMergeTags(parsed, context, options);

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
      const parts = variable.trim().split('|').map(s => s.trim());
      const baseVariable = parts[0];
      const filters = parts.slice(1);

      let value = this.getVariableValue(baseVariable, context);

      // Apply filters
      for (const filter of filters) {
        value = this.applyFilter(value, filter);
      }

      if (value === null || value === undefined) {
        if (options.strictMode) {
          throw new Error(`Variable ${baseVariable} not found in context`);
        }
        return '';
      }

      return String(value);
    });
  }

  private getVariableValue(path: string, context: VariableContext): any {
    const parts = path.split('.');
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
      const isTrue = this.evaluateCondition(condition, context);
      
      const parts = body.split(/\{% (?:elsif .+?|else) %\}/);
      if (isTrue) {
        return parts[0];
      }
      
      // Basic recursive elseif/else logic would go here
      return '';
    });
  }

  private evaluateCondition(
    condition: string,
    context: VariableContext
  ): boolean {
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
      const items = this.getVariableValue(arrayVar, context);
      if (!Array.isArray(items)) return '';

      const itemsToProcess = limit ? items.slice(0, parseInt(limit)) : items;

      return itemsToProcess.map((item, index) => {
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

  private escapeHtml(unsafe: string): string {
    return unsafe
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }
}
```
