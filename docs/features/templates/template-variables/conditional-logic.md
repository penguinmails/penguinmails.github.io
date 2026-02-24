---
title: "Template Variables - Conditional Logic"
description: "Advanced conditional logic, tags, and complex Boolean expressions for personalized content."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# Template Variables - Conditional Logic

### If/Else Blocks

#### Regional Content

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

### Complex Logic

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

#### Grouped Expressions

```text
{% if (lead_score >= 75 and custom.account_type == "trial") or custom.is_vip == true %}
  Exclusive VIP Offer Inside!
{% endif %}
```
