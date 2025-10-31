---
last_modified_date: "2025-10-28"
---

# Development Guidelines

---

## Executive Summary

These development guidelines ensure consistent, maintainable, and scalable code across the PenguinMails platform. Following these standards enables efficient collaboration, reduces technical debt, and supports long-term system evolution.

## Code Organization

### Directory Structure
```
src/
├── components/          # Reusable UI components
│   ├── common/         # Generic components (Button, Input, etc.)
│   ├── forms/          # Form-related components
│   ├── layout/         # Layout components
│   └── domain/         # Domain-specific components
├── pages/              # Page components
├── hooks/              # Custom React hooks
├── utils/              # Utility functions
├── services/           # API service layer
├── stores/             # State management
├── types/              # TypeScript type definitions
├── constants/          # Application constants
└── styles/             # Global styles and design tokens
```

### File Naming Conventions
- **Components**: PascalCase (`UserProfile.tsx`)
- **Utilities**: camelCase (`formatDate.ts`)
- **Constants**: UPPER_SNAKE_CASE (`API_ENDPOINTS.ts`)
- **Types**: PascalCase with suffix (`UserProfile.ts`)
- **Tests**: Same as component with `.test.tsx`

## Coding Standards

### TypeScript Guidelines

#### Type Definitions
```typescript
// Good: Explicit typing
interface User {
  id: string;
  email: string;
  profile: UserProfile;
  createdAt: Date;
}

// Good: Union types for constraints
type UserRole = 'admin' | 'member' | 'viewer';

// Good: Generic constraints
function findById<T extends { id: string }>(
  items: T[], 
  id: string
): T | undefined {
  return items.find(item => item.id === id);
}
```

#### Type Safety
- Use `strict` mode in `tsconfig.json`
- Avoid `any` type except in migration scenarios
- Prefer interfaces over type aliases for object shapes
- Use discriminated unions for complex state

### React Guidelines

#### Component Structure
```tsx
// Good: Functional component with hooks
interface UserCardProps {
  user: User;
  onEdit?: (user: User) => void;
}

export function UserCard({ user, onEdit }: UserCardProps) {
  const [isEditing, setIsEditing] = useState(false);

  return (
    <div className="user-card">
      <h3>{user.name}</h3>
      <p>{user.email}</p>
      {onEdit && (
        <button onClick={() => onEdit(user)}>
          Edit
        </button>
      )}
    </div>
  );
}
```

#### Hooks Usage
- Custom hooks for reusable logic
- Hooks follow naming convention: `use*`
- Avoid conditional hook calls
- Prefer built-in hooks over custom implementations

#### State Management
```tsx
// Good: Local state for component concerns
function Counter() {
  const [count, setCount] = useState(0);
  // ...
}

// Good: Context for app-wide state
const ThemeContext = createContext<Theme>('light');

// Good: External store for complex state
const useUserStore = createStore((set) => ({
  user: null,
  setUser: (user) => set({ user }),
}));
```

### API Integration

#### Service Layer Pattern
```typescript
// services/userService.ts
export class UserService {
  async getUsers(params?: UserQuery): Promise<User[]> {
    const response = await api.get('/users', { params });
    return response.data;
  }

  async createUser(userData: CreateUserRequest): Promise<User> {
    const response = await api.post('/users', userData);
    return response.data;
  }

  async updateUser(id: string, updates: UpdateUserRequest): Promise<User> {
    const response = await api.patch(`/users/${id}`, updates);
    return response.data;
  }
}

export const userService = new UserService();
```

#### Error Handling
```typescript
// Good: Centralized error handling
try {
  const users = await userService.getUsers();
  setUsers(users);
} catch (error) {
  if (error instanceof ApiError) {
    toast.error(error.message);
  } else {
    console.error('Unexpected error:', error);
    toast.error('An unexpected error occurred');
  }
}
```

### Testing Guidelines

#### Test Structure
```typescript
// UserCard.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { UserCard } from './UserCard';

describe('UserCard', () => {
  const mockUser = {
    id: '1',
    name: 'John Doe',
    email: 'john@example.com',
  };

  it('renders user information', () => {
    render(<UserCard user={mockUser} />);
    
    expect(screen.getByText('John Doe')).toBeInTheDocument();
    expect(screen.getByText('john@example.com')).toBeInTheDocument();
  });

  it('calls onEdit when edit button is clicked', () => {
    const mockOnEdit = jest.fn();
    render(<UserCard user={mockUser} onEdit={mockOnEdit} />);
    
    fireEvent.click(screen.getByRole('button', { name: /edit/i }));
    
    expect(mockOnEdit).toHaveBeenCalledWith(mockUser);
  });
});
```

#### Testing Strategy
- **Unit Tests**: Individual functions and components
- **Integration Tests**: Component interactions and API calls
- **E2E Tests**: Critical user journeys
- **Coverage Target**: 80% minimum

### Performance Optimization

#### Component Optimization
```tsx
// Good: Memoization for expensive computations
const ExpensiveComponent = React.memo(({ data }: Props) => {
  const processedData = useMemo(() => {
    return expensiveComputation(data);
  }, [data]);

  return <div>{processedData}</div>;
});
```

#### Bundle Optimization
- Code splitting for route-based lazy loading
- Tree shaking for unused dependencies
- Image optimization and lazy loading
- CDN usage for static assets

### Security Best Practices

#### Input Validation
```typescript
// Good: Server-side validation with client-side feedback
const emailSchema = z.string().email('Invalid email format');

function handleSubmit(email: string) {
  try {
    emailSchema.parse(email);
    // Proceed with submission
  } catch (error) {
    setError(error.message);
  }
}
```

#### Authentication & Authorization
- JWT tokens with secure storage
- Role-based access control (RBAC)
- Secure API endpoints with proper validation
- Regular security audits and dependency updates

### Database Guidelines

#### Schema Design
- Use migrations for schema changes
- Proper indexing for query performance
- Foreign key constraints for data integrity
- Audit trails for sensitive operations

#### Query Optimization
```sql
-- Good: Indexed query with selective columns
SELECT id, email, created 
FROM users 
WHERE created > $1 
ORDER BY created DESC 
LIMIT 100;
```

#### Data Validation
- Application-level validation before database writes
- Database constraints as safety nets
- Sanitization of user inputs

## Code Quality Tools

### Linting & Formatting
```json
// .eslintrc.js
module.exports = {
  extends: [
    'react-app',
    'react-app/jest',
    '@typescript-eslint/recommended',
  ],
  rules: {
    '@typescript-eslint/no-unused-vars': 'error',
    '@typescript-eslint/explicit-function-return-type': 'warn',
    'react-hooks/exhaustive-deps': 'error',
  },
};
```

### Pre-commit Hooks
```bash
# .husky/pre-commit
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

npm run lint
npm run test
npm run type-check
```

## Documentation Standards

### Code Comments
```typescript
/**
 * Calculates the total campaign performance score
 * @param metrics - Campaign performance metrics
 * @returns Normalized score between 0-100
 */
function calculatePerformanceScore(metrics: CampaignMetrics): number {
  // Implementation details...
}
```

### README Files
- Required for all new components and features
- Include usage examples and API documentation
- Update when functionality changes

### API Documentation
- OpenAPI 3.0 specifications for all endpoints
- Clear parameter descriptions and examples
- Error response documentation

## Deployment & CI/CD

### Branch Strategy
- `main`: Production-ready code
- `develop`: Integration branch
- `feature/*`: Feature branches
- `hotfix/*`: Critical fixes

### CI Pipeline
```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install dependencies
        run: npm ci
      - name: Run tests
        run: npm test
      - name: Build
        run: npm run build
```

### Environment Configuration
```typescript
// config/index.ts
const config = {
  development: {
    apiUrl: 'http://localhost:3001',
    debug: true,
  },
  staging: {
    apiUrl: 'https://api-staging.penguinmails.com',
    debug: false,
  },
  production: {
    apiUrl: 'https://api.penguinmails.com',
    debug: false,
  },
};

export const getConfig = () => {
  const env = process.env.NODE_ENV || 'development';
  return config[env];
};
```

## Monitoring & Logging

### Application Monitoring
- Error tracking with Sentry
- Performance monitoring with real user monitoring
- Custom metrics and alerts

### Logging Standards
```typescript
// Good: Structured logging
logger.info('User login successful', {
  userId: user.id,
  ipAddress: request.ip,
  userAgent: request.headers['user-agent'],
});

// Good: Error logging with context
logger.error('Database connection failed', {
  error: error.message,
  connectionString: sanitizeConnectionString(dbUrl),
  retryCount: 3,
});
```

## Accessibility Guidelines

### WCAG 2.1 Compliance
- Semantic HTML elements
- Proper ARIA labels and roles
- Keyboard navigation support
- Sufficient color contrast ratios
- Screen reader compatibility

### Component Accessibility
```tsx
// Good: Accessible form controls
<label htmlFor="email">Email Address</label>
<input
  id="email"
  type="email"
  aria-describedby="email-help"
  aria-invalid={hasError}
/>
<div id="email-help">We'll use this to send you updates</div>
```

## Contributing Guidelines

### Pull Request Process
1. Create feature branch from `develop`
2. Implement changes with tests
3. Ensure CI passes
4. Create PR with clear description
5. Code review and approval
6. Squash merge to `develop`

### Commit Message Format
```
type(scope): description

[optional body]

[optional footer]
```

Types: feat, fix, docs, style, refactor, test, chore

---

## Related Documents
- [API Reference](api_reference.md) - API usage and integration
- [Architecture Overview](architecture_overview.md) - System design principles
- [Security Documentation](security_documentation.md) - Security protocols and practices
- [SOP Guidelines](sop_guidelines.md) - Operational procedures