
# CORE-3.1: Install and Configure NileDB Server SDK

**Ticket ID:** CORE-3.1  
**Milestone:** 3 - The Secure, Multi-Tenant Core  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Install the `@niledatabase/server` package. Configure the Nile client by adding the required Nile environment variables (`NILE_URL`, `NILE_DATABASE_ID`, etc.) to the `.env` files.

## Context

According to the [High-Level Architecture](/docs/quick-access/high-level-architecture), PenguinMails uses:

- **NileDB** for authentication and multi-tenant management
- **Multi-tenant architecture** with complete data isolation

NileDB provides built-in authentication, session management, and tenant isolation, which is essential for the multi-tenant SaaS architecture.

## Acceptance Criteria

1. ✅ The `@niledatabase/server` package is a dependency in `package.json`
2. ✅ The application starts without errors related to Nile configuration
3. ✅ All required Nile variables are present in `.env.example`:
   - `NILE_URL`
   - `NILE_DATABASE_ID`
   - `NILE_API_KEY` (or other required credentials)
4. ✅ A Nile client instance is created and exported from a central location (e.g., `/lib/nile/index.ts`)
5. ✅ The Nile client can be imported and used in other parts of the application

## Technical Details

### Required Package

```json
{
  "dependencies": {
    "@niledatabase/server": "^latest"
  }
}
```

### Environment Variables

```env
# NileDB Configuration
NILE_URL=https://api.thenile.dev
NILE_DATABASE_ID=your_database_id
NILE_API_KEY=your_api_key
```

### Nile Client Configuration

```typescript
// lib/nile/index.ts
import { Nile } from '@niledatabase/server';

export const nile = new Nile({
  basePath: process.env.NILE_URL,
  databaseId: process.env.NILE_DATABASE_ID,
  apiKey: process.env.NILE_API_KEY,
});
```

## Implementation Notes

- Follow NileDB's official documentation for SDK setup
- Ensure environment variables are validated (can use the validation from CORE-1.5)
- Create a singleton Nile client instance to avoid multiple connections
- Handle configuration errors gracefully with clear error messages
- Consider adding connection health checks

## Related Documentation

- [High-Level Architecture](/docs/quick-access/high-level-architecture) - Authentication architecture
- [Implementation & Getting Started](/docs/implementation-getting-started/index) - NileDB setup

## Dependencies

- [CORE-1.5](/docs/features/core/tasks/CORE-1.5-setup-environment-variables) - Environment variables must be set up
- [CORE-1.1](/docs/features/core/tasks/CORE-1.1-initialize-nextjs-project) - Next.js project must be initialized

## Testing

- [ ] Verify NileDB package is installed correctly
- [ ] Test that the Nile client can be imported without errors
- [ ] Verify environment variables are read correctly
- [ ] Test application startup with valid Nile configuration
- [ ] Verify application fails gracefully with missing Nile configuration
- [ ] Test Nile client initialization with invalid credentials (should handle errors)

---

## Cross-References

- **Routes**: [public-auth.md]()
- **API**: [platform-api/](/docs/implementation-technical/api/platform-api/)
