---
title: "Security Standards"
description: "Security protocols and best practices for secure code"
last_modified_date: "2025-12-04"
level: "3"
persona: "Senior Developers"
keywords: "security, input validation, XSS, SQL injection, CSRF"
---

# Security Standards

## Security Standards

### Input Validation

```typescript
// Security-focused validation example

interface SecureCampaignRequest {
  name: string;
  subject: string;
  content: EmailContent;
  recipients: EmailRecipient[];
}

interface EmailContent {
  html: string;
  text: string;
  templateId?: string;
}

interface EmailRecipient {
  email: string;
  name?: string;
  personalization?: Record<string, string | number | boolean>;
}

interface ValidationResult {
  isValid: boolean;
  errors: string[];
}

interface PersonalizationSanitizer {
  [key: string]: string | number | boolean;
}

/**

 * Security-focused validation service
 */
class SecureCampaignValidationService {
  private readonly emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  private readonly invalidNamePattern = /[<>\"']/;
  private readonly invalidSubjectPattern = /[\r\n]/;

  /**

   * Validate campaign request with security considerations
   */
  validateCampaignRequest(request: SecureCampaignRequest): ValidationResult {
    const errors: string[] = [];

    // Validate name
    const nameValidation = this.validateName(request.name);
    if (!nameValidation.isValid) {
      errors.push(...nameValidation.errors);
    }

    // Validate subject
    const subjectValidation = this.validateSubject(request.subject);
    if (!subjectValidation.isValid) {
      errors.push(...subjectValidation.errors);
    }

    // Validate content
    const contentValidation = this.validateContent(request.content);
    if (!contentValidation.isValid) {
      errors.push(...contentValidation.errors);
    }

    // Validate recipients
    const recipientsValidation = this.validateRecipients(request.recipients);
    if (!recipientsValidation.isValid) {
      errors.push(...recipientsValidation.errors);
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }

  private validateName(name: string): ValidationResult {
    const errors: string[] = [];

    if (!name || name.trim().length === 0) {
      errors.push("Name is required");
      return { isValid: false, errors };
    }

    if (name.length > 100) {
      errors.push("Name must be less than 100 characters");
    }

    if (this.invalidNamePattern.test(name)) {
      errors.push("Name contains invalid characters");
    }

    return { isValid: errors.length === 0, errors };
  }

  private validateSubject(subject: string): ValidationResult {
    const errors: string[] = [];

    if (!subject || subject.trim().length === 0) {
      errors.push("Subject is required");
      return { isValid: false, errors };
    }

    if (subject.length > 200) {
      errors.push("Subject must be less than 200 characters");
    }

    if (this.invalidSubjectPattern.test(subject)) {
      errors.push("Subject contains invalid characters");
    }

    return { isValid: errors.length === 0, errors };
  }

  private validateContent(content: EmailContent): ValidationResult {
    const errors: string[] = [];

    if (!content.html || content.html.trim().length === 0) {
      errors.push("HTML content is required");
    }

    if (!content.text || content.text.trim().length === 0) {
      errors.push("Text content is required");
    }

    return { isValid: errors.length === 0, errors };
  }

  private validateRecipients(recipients: EmailRecipient[]): ValidationResult {
    const errors: string[] = [];

    if (!recipients || recipients.length === 0) {
      errors.push("At least one recipient is required");
      return { isValid: false, errors };
    }

    if (recipients.length > 10000) {
      errors.push("Maximum 10,000 recipients allowed");
      return { isValid: false, errors };
    }

    for (let i = 0; i < recipients.length; i++) {
      const recipient = recipients[i];
      const recipientErrors = this.validateRecipient(recipient, i);
      errors.push(...recipientErrors);
    }

    return { isValid: errors.length === 0, errors };
  }

  private validateRecipient(recipient: EmailRecipient, index: number): string[] {
    const errors: string[] = [];
    const prefix = `Recipient ${index + 1}`;

    if (!recipient.email) {
      errors.push(`${prefix}: Email is required`);
      return errors;
    }

    if (!this.emailPattern.test(recipient.email)) {
      errors.push(`${prefix}: Invalid email address: ${recipient.email}`);
    }

    if (recipient.personalization) {
      const sanitized = this.sanitizePersonalization(recipient.personalization);
      if (Object.keys(sanitized).length !== Object.keys(recipient.personalization).length) {
        errors.push(`${prefix}: Personalization contains invalid data`);
      }
    }

    return errors;
  }

  /**

   * Sanitize personalization data to prevent injection
   */
  private sanitizePersonalization(data: PersonalizationSanitizer): PersonalizationSanitizer {
    if (!data || typeof data !== 'object') {
      return {};
    }

    const sanitized: PersonalizationSanitizer = {};

    for (const [key, value] of Object.entries(data)) {
      // Only allow safe string/number/boolean values
      if (typeof value === 'string' || typeof value === 'number' || typeof value === 'boolean') {
        if (typeof value === 'string') {
          // Basic XSS prevention - escape HTML
          sanitized[key] = value
            .replace(/</g, '<')
            .replace(/>/g, '>')
            .replace(/"/g, '"')
            .replace(/'/g, '&#x27;');
        } else {
          sanitized[key] = value;
        }
      }
    }

    return sanitized;
  }
}

```

### Authentication & Authorization

```typescript
// Secure authentication patterns
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';

export class AuthenticationService {
  private readonly jwtSecret: string;
  private readonly jwtExpiresIn = '24h';

  constructor(jwtSecret: string) {
    this.jwtSecret = jwtSecret;
  }

  async hashPassword(password: string): Promise<string> {
    // Use appropriate salt rounds (12+ for production)
    return bcrypt.hash(password, 12);
  }

  async verifyPassword(password: string, hashedPassword: string): Promise<boolean> {
    return bcrypt.compare(password, hashedPassword);
  }

  generateToken(user: User): string {
    return jwt.sign(
      {
        userId: user.id,
        email: user.email,
        role: user.role,
        permissions: user.permissions
      },
      this.jwtSecret,
      {
        expiresIn: this.jwtExpiresIn,
        issuer: 'penguinmails.com',
        audience: 'penguinmails-users'
      }
    );
  }

  verifyToken(token: string): DecodedToken {
    try {
      return jwt.verify(token, this.jwtSecret, {
        issuer: 'penguinmails.com',
        audience: 'penguinmails-users'
      }) as DecodedToken;
    } catch (error) {
      throw new AuthenticationError('Invalid or expired token');
    }
  }

  hasPermission(decodedToken: DecodedToken, requiredPermission: string): boolean {
    return decodedToken.permissions.includes(requiredPermission) ||
           decodedToken.permissions.includes('admin:*');
  }
}

// Authorization middleware
export function requirePermission(permission: string) {
  return (req: Request, res: Response, next: NextFunction) => {
    const token = extractTokenFromRequest(req);

    if (!token) {
      return res.status(401).json({ error: 'Authentication required' });
    }

    try {
      const decoded = authService.verifyToken(token);

      if (!authService.hasPermission(decoded, permission)) {
        return res.status(403).json({ error: 'Insufficient permissions' });
      }

      // Attach user info to request
      req.user = decoded;
      next();
    } catch (error) {
      return res.status(401).json({ error: 'Invalid authentication' });
    }
  };
}

```
