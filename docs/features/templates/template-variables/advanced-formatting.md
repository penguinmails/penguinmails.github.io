---
title: "Template Variables - Advanced Formatting"
description: "Advanced variable formatting including links, images, dates, loops, and iterations."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# Template Variables - Advanced Formatting

### Links & Parameters

#### Personalized Links

```text
<a href="https://example.com/start?email={{email}}" style="background: blue; color: white; padding: 10px;">
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
<img src="https://api.example.com/badge/{{first_name}}/{{lead_score}}" alt="Your Badge" />
```

### Date Formatting

#### Custom Date Formats

Format: `{{variable | date: "format"}}`

```text
Current Date: {{ "now" | date: "MMMM DD, YYYY" }}
Output: February 24, 2026

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

### Advanced Filters

#### String Manipulation

```text
Lowercase: {{first_name | downcase}}
Uppercase: {{last_name | upcase}}

Replace:
  {{phone | replace: "-", " "}}
  Input: 555-123-4567
  Output: 555 123 4567

Split:
  {% assign name_parts = full_name | split: " " %}
  First: {{name_parts[0]}}
  Last: {{name_parts[1]}}
```

#### Number Formatting

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
  {{user_count | number_with_delimiter}}
  Output: 1,500,000
```
