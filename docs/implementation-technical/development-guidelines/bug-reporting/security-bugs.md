---
title: "Security Bug Patterns"
description: "Security vulnerabilities and input validation issues"
last_modified_date: "2025-12-04"
level: "3"
persona: "Quality Assurance"
keywords: "security bugs, input validation, XSS, SQL injection, CSRF"
---

# Security Bug Patterns

## Security Bug Patterns

### Input Validation

```typescript
// validation/campaign-validator.ts
import { z } from 'zod';

// Comprehensive validation using Zod schema
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const htmlTagRegex = /<[^>]*>/g;

const RecipientSchema = z.object({
  email: z.string()
    .email('Invalid email format')
    .min(1, 'Email is required')
    .max(254, 'Email too long'),
  name: z.string()
    .max(100, 'Name too long')
    .optional()
    .transform(val => val?.trim())
}).strict();

const CampaignCreateRequestSchema = z.object({
  name: z.string()
    .min(1, 'Name cannot be empty')
    .max(100, 'Name too long')
    .trim()
    .refine(val => !htmlTagRegex.test(val), 'Name contains invalid HTML tags'),
  content: z.string()
    .min(1, 'Content cannot be empty')
    .max(50000, 'Content too long')
    .trim(),
  recipients: z.array(RecipientSchema)
    .min(1, 'At least one recipient required')
    .max(10000, 'Too many recipients'),
  scheduledAt: z.string()
    .datetime('Invalid date format')
    .optional(),
  tags: z.array(z.string().max(50, 'Tag too long'))
    .max(10, 'Too many tags')
    .optional()
}).strict();

interface ValidationResult {
  success: boolean;
  data?: CampaignCreateRequest;
  errors?: ValidationError[];
}

interface ValidationError {
  field: string;
  message: string;
  code: string;
}

interface CampaignCreateRequest {
  name: string;
  content: string;
  recipients: EmailRecipient[];
  scheduledAt?: string;
  tags?: string[];
}

interface EmailRecipient {
  email: string;
  name?: string;
}

interface CampaignValidator {
  validateCreateRequest(data: unknown): ValidationResult;
  sanitizeInput(data: string): string;
  validateEmail(email: string): boolean;
}

class CampaignValidatorImpl implements CampaignValidator {
  validateCreateRequest(data: unknown): ValidationResult {
    try {
      const validatedData = CampaignCreateRequestSchema.parse(data);

      return {
        success: true,
        data: validatedData
      };
    } catch (error) {
      if (error instanceof z.ZodError) {
        const errors: ValidationError[] = error.errors.map(err => ({
          field: err.path.join('.'),
          message: err.message,
          code: this.mapErrorCode(err.code)
        }));

        return {
          success: false,
          errors
        };
      }

      return {
        success: false,
        errors: [{
          field: 'general',
          message: 'Validation failed',
          code: 'VALIDATION_ERROR'
        }]
      };
    }
  }

  sanitizeInput(input: string): string {
    // Remove HTML tags to prevent XSS
    let sanitized = input.replace(htmlTagRegex, '');

    // Trim whitespace
    sanitized = sanitized.trim();

    // Remove null bytes and control characters
    sanitized = sanitized.replace(/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/g, '');

    return sanitized;
  }

  validateEmail(email: string): boolean {
    return emailRegex.test(email) && email.length <= 254;
  }

  validateHtmlContent(html: string): ValidationResult {
    try {
      // Basic HTML validation - in production, use a proper HTML sanitizer
      if (html.includes('<script')) {
        return {
          success: false,
          errors: [{
            field: 'content',
            message: 'Script tags not allowed',
            code: 'INVALID_HTML'
          }]
        };
      }

      if (html.includes('javascript:')) {
        return {
          success: false,
          errors: [{
            field: 'content',
            message: 'JavaScript in URLs not allowed',
            code: 'INVALID_HTML'
          }]
        };
      }

      return { success: true };
    } catch (error) {
      return {
        success: false,
        errors: [{
          field: 'content',
          message: 'HTML validation failed',
          code: 'VALIDATION_ERROR'
        }]
      };
    }
  }

  private mapErrorCode(code: z.ZodIssueCode): string {
    switch (code) {
      case 'invalid_string':
        return 'INVALID_FORMAT';
      case 'too_small':
        return 'TOO_SHORT';
      case 'too_big':
        return 'TOO_LONG';
      case 'invalid_email':
        return 'INVALID_EMAIL';
      case 'invalid_datetime':
        return 'INVALID_DATE';
      case 'unrecognized_keys':
        return 'UNKNOWN_FIELD';
      default:
        return 'VALIDATION_ERROR';
    }
  }
}

// Usage examples with different validation approaches

// Manual validation (for complex custom logic)
class ManualCampaignValidator {
  validateCreateRequest(data: unknown): ValidationResult {
    const errors: ValidationError[] = [];

    if (!data || typeof data !== 'object') {
      return {
        success: false,
        errors: [{
          field: 'general',
          message: 'Invalid request data',
          code: 'INVALID_DATA'
        }]
      };
    }

    const campaignData = data as CampaignCreateRequest;

    // Validate name
    if (!campaignData.name || campaignData.name.trim().length === 0) {
      errors.push({
        field: 'name',
        message: 'Name cannot be empty',
        code: 'REQUIRED_FIELD'
      });
    } else if (campaignData.name.length > 100) {
      errors.push({
        field: 'name',
        message: 'Name too long (max 100 characters)',
        code: 'TOO_LONG'
      });
    }

    // Prevent XSS in name
    if (campaignData.name && /<[^>]*>/.test(campaignData.name)) {
      errors.push({
        field: 'name',
        message: 'Name contains invalid HTML tags',
        code: 'INVALID_INPUT'
      });
    }

    // Validate content
    if (!campaignData.content || campaignData.content.trim().length === 0) {
      errors.push({
        field: 'content',
        message: 'Content cannot be empty',
        code: 'REQUIRED_FIELD'
      });
    } else if (campaignData.content.length > 50000) {
      errors.push({
        field: 'content',
        message: 'Content too long (max 50,000 characters)',
        code: 'TOO_LONG'
      });
    }

    // Validate recipients
    if (!Array.isArray(campaignData.recipients)) {
      errors.push({
        field: 'recipients',
        message: 'Recipients must be an array',
        code: 'INVALID_TYPE'
      });
    } else if (campaignData.recipients.length === 0) {
      errors.push({
        field: 'recipients',
        message: 'At least one recipient required',
        code: 'REQUIRED_FIELD'
      });
    } else if (campaignData.recipients.length > 10000) {
      errors.push({
        field: 'recipients',
        message: 'Too many recipients (max 10,000)',
        code: 'TOO_MANY'
      });
    } else {
      // Validate each recipient
      campaignData.recipients.forEach((recipient, index) => {
        const fieldPrefix = `recipients[${index}]`;

        if (!recipient.email || typeof recipient.email !== 'string') {
          errors.push({
            field: `${fieldPrefix}.email`,
            message: 'Valid email address is required',
            code: 'INVALID_EMAIL'
          });
        } else if (!emailRegex.test(recipient.email)) {
          errors.push({
            field: `${fieldPrefix}.email`,
            message: 'Invalid email format',
            code: 'INVALID_EMAIL'
          });
        }

        if (recipient.name && typeof recipient.name !== 'string') {
          errors.push({
            field: `${fieldPrefix}.name`,
            message: 'Name must be a string',
            code: 'INVALID_TYPE'
          });
        } else if (recipient.name && recipient.name.length > 100) {
          errors.push({
            field: `${fieldPrefix}.name`,
            message: 'Name too long (max 100 characters)',
            code: 'TOO_LONG'
          });
        }
      });
    }

    if (errors.length > 0) {
      return { success: false, errors };
    }

    return { success: true, data: campaignData };
  }
}

// Express middleware for request validation
function validateCampaignRequest(req: unknown, res: unknown, next: Function): void {
  const validator = new CampaignValidatorImpl();
  const result = validator.validateCreateRequest((req as any).body);

  if (!result.success) {
    res.status(400).json({
      success: false,
      errors: result.errors,
      message: 'Validation failed'
    });
    return;
  }

  // Replace request body with validated and sanitized data
  (req as any).validatedData = result.data;
  next();
}

// Usage example
async function demonstrateValidation() {
  const validator = new CampaignValidatorImpl();

  // Test valid data
  const validData = {
    name: 'Monthly Newsletter',
    content: '<p>Welcome to our monthly newsletter!</p>',
    recipients: [
      { email: 'user@example.com', name: 'John Doe' },
      { email: 'user2@example.com', name: 'Jane Smith' }
    ]
  };

  const result1 = validator.validateCreateRequest(validData);
  console.log('Valid data result:', result1);

  // Test invalid data
  const invalidData = {
    name: '', // Empty name
    content: 'Valid content',
    recipients: [] // Empty recipients
  };

  const result2 = validator.validateCreateRequest(invalidData);
  console.log('Invalid data result:', result2);

  // Test HTML content validation
  const invalidHtml = {
    name: 'Test',
    content: '<script>alert("xss")</script>Content',
    recipients: [{ email: 'test@example.com' }]
  };

  const result3 = validator.validateHtmlContent(invalidHtml.content);
  console.log('HTML validation result:', result3);
}

```
