# Environment Variables

This project validates required environment variables at startup through `lib/env.ts`.

## Required Variables

- `DATABASE_URL`: PostgreSQL connection string used by Drizzle and migrations.
- `REDIS_URL`: Redis connection string used by the singleton Redis service.
- `NILE_URL`: NileDB API base URL.
- `NILE_DATABASE_ID`: NileDB database identifier.
- `NILE_API_KEY`: NileDB API key.
- `NODE_ENV`: Runtime mode (`development`, `test`, `production`).
- `NEXT_PUBLIC_APP_URL`: Public app URL exposed to client-side code.

## Setup

1. Copy `.env.example` to `.env.local`.
2. Replace placeholder values with real credentials.
3. Run `npm run dev` or any script; invalid or missing values fail fast with clear errors.
