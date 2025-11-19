# CORE-1.5: Set up Environment Variable Management

**Ticket ID:** CORE-1.5  
**Milestone:** 1 - Project Initialization & Code Quality  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a system for managing environment variables securely. This includes a template for other developers and validation to ensure all required variables are present at runtime.

## Context

Environment variables are essential for configuration management across different environments (development, staging, production). According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture), PenguinMails integrates with multiple services that require configuration:

- **Database:** PostgreSQL connection strings
- **Authentication:** NileDB configuration (NILE_URL, NILE_DATABASE_ID)
- **Caching:** Redis connection (REDIS_URL)
- **Payment Processing:** Stripe API keys
- **Email Infrastructure:** Hostwind VPS API keys

## Acceptance Criteria

1. ✅ An `.env.local` file is added to the `.gitignore` file to prevent secrets from being committed
2. ✅ An `.env.example` file is created in the repository with placeholder values for all required variables
3. ✅ Environment variable validation is implemented (either at startup or via a validation script)
4. ✅ Documentation is added explaining which variables are required and their purpose
5. ✅ Next.js environment variable conventions are followed (e.g., `NEXT_PUBLIC_` prefix for client-side variables)

## Technical Details

### Required Environment Variables (Initial Set)

```env
# Database
DATABASE_URL=postgresql://user:password@host:port/database

# NileDB Authentication
NILE_URL=https://api.thenile.dev
NILE_DATABASE_ID=your_database_id
NILE_API_KEY=your_api_key

# Redis
REDIS_URL=redis://localhost:6379

# Application
NODE_ENV=development
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### Validation Approach

- Use a validation library like `zod` or `envalid` to validate environment variables at startup
- Create a `/lib/env.ts` file that exports validated environment variables
- Fail fast if required variables are missing

## Implementation Notes

- Follow Next.js conventions for environment variables
- Use `NEXT_PUBLIC_` prefix only for variables that need to be exposed to the browser
- Keep sensitive variables (API keys, secrets) server-side only
- Document each variable's purpose and where it's used
- Consider creating a validation schema that can be reused

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture) - External service integrations
- [Implementation & Getting Started](../../docs/implementation-getting-started/index) - Environment setup

## Dependencies

- **CORE-1.1** - Next.js project must be initialized

## Testing

- [ ] Verify `.env.local` is in `.gitignore` and not tracked by Git
- [ ] Verify `.env.example` contains all required variables with placeholder values
- [ ] Test that the application fails to start if required variables are missing
- [ ] Verify environment variable validation provides clear error messages
- [ ] Test that client-side variables (with `NEXT_PUBLIC_` prefix) are accessible in browser code
