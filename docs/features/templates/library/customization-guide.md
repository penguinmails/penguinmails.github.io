---
title: "Template Customization Guide"
description: "Brand consistency, content optimization, and mobile-friendly customization strategies for email templates"
last_modified_date: "2025-12-05"
level: "2"
persona: "Marketing Teams, Brand Managers"
keywords: "template customization, branding, mobile optimization, content optimization"
status: "Active - Customization Guide"
target_audience: "Marketing Teams, Brand Managers"
owner: "Templates Team"
---

# Template Customization Guide

**Quick Access**: Master brand consistency, content optimization, and mobile-friendly customization for email templates.

## Overview

Proper customization transforms good templates into great campaigns. This guide covers essential techniques for branding, content optimization, and mobile experience.

---

## Brand Consistency

### Color Scheme Application

### Primary Brand Colors

```text
1. Primary Brand Color: [#0066CC] - Headers, buttons, links
2. Secondary Brand Color: [#6C757D] - Subheadings, dividers
3. Text Color: [#333333] - Body text, descriptions
4. Background Color: [#FFFFFF] - Main background
5. Accent Color: [#28A745] - Success states, confirmations
```

### Application Strategy

- Apply primary color to all CTAs and links
- Use secondary color for subheadings and icons
- Maintain high contrast for readability
- Test color accessibility for vision impairments

### Typography Standards

### Font Hierarchy

```text
Headers: Inter Bold (24px, 32px line-height)
Subheaders: Inter SemiBold (18px, 28px line-height)  
Body Text: Inter Regular (16px, 24px line-height)
Small Text: Inter Regular (14px, 20px line-height)
Button Text: Inter Medium (16px, 20px line-height)
```

### Readability Guidelines

- Minimum 16px font size for body text
- 1.5x line-height for comfortable reading
- Maximum 60-80 characters per line
- Consistent spacing between sections

---

## Content Optimization

### Template Variables Usage

### Personalization Best Practices

```handlebars
✅ DO: Hi {{contact.first_name}}, welcome to {{company.name}}!
❌ AVOID: Dear Customer,

✅ DO: Your {{product_name}} is ready for pickup
❌ AVOID: Your order is ready

✅ DO: Thanks for being a {{customer_tier}} member!
❌ AVOID: Thanks for your business
```

### Dynamic Content Rules

- Use first name sparingly (not every paragraph)
- Include fallback text for missing data
- Test with empty/null values
- Keep personalization natural and helpful

### Content Structure

### Template Content Checklist

- [ ] Clear, compelling subject line
- [ ] Personalized greeting
- [ ] Single primary message
- [ ] One clear call-to-action
- [ ] Easy-to-scan layout
- [ ] Contact information
- [ ] Unsubscribe link

### Content Length Guidelines

```text
Welcome Emails: 150-300 words
Newsletters: 300-800 words  
Promotional: 100-250 words
Transaction: 50-150 words
```

---

## Mobile Optimization

### Responsive Design Testing

### Test Checklist

- [ ] Readable on screens 320px and larger
- [ ] Tap targets minimum 44px
- [ ] Images scale appropriately
- [ ] Text doesn't require zooming
- [ ] Horizontal scrolling avoided

### Mobile-First Modifications

```text
Desktop Version: 3-column layout
Mobile Version: Single column stack

Desktop Headers: Large, bold typography
Mobile Headers: Scaled appropriately

Desktop Images: Full width or grid
Mobile Images: Full width only
```

### Touch Optimization

### Mobile Interaction Design

- Minimum tap target size: 44px × 44px
- Adequate spacing between interactive elements
- Thumb-friendly navigation placement
- Swipe gesture considerations

---

## Common Customization Mistakes

### Brand Inconsistency

### Avoid These Issues

- Inconsistent color usage across campaigns
- Mixed typography styles
- Inappropriate logo placement
- Conflicting brand voice

### Content Problems

### Watch Out For

- Over-personalization (every sentence has variables)
- Poor fallback text for missing data
- Too much content for mobile screens
- Missing or unclear call-to-actions

### Mobile Issues

### Common Mistakes

- Tiny tap targets (under 44px)
- Horizontal scrolling required
- Text too small to read
- Images not optimized for mobile

---

## Quick Customization Workflow

### 5-Minute Brand Setup

1. **Upload Logo** (Recommended: 600x200px, max 200kb)
2. **Apply Brand Colors** to buttons and links
3. **Set Typography** hierarchy
4. **Add Social Links** to footer
5. **Test Mobile View**

### Content Optimization Checklist

- [ ] Replace generic text with personalized content
- [ ] Ensure clear value proposition
- [ ] Add compelling call-to-action
- [ ] Include proper contact information
- [ ] Verify unsubscribe link functionality

---

## Related Documentation

- **[Selection Guide](/docs/features/templates/library/selection-guide)** - Choose the right templates
- **[Organization Guide](/docs/features/templates/library/organization-guide)** - Template management and workflows
- **[Template Editor](/docs/features/templates/template-editor/overview)** - Detailed customization tools
- **[Template Variables](/docs/features/templates/template-variables)** - Advanced personalization techniques

---
