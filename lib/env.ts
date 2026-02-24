import 'server-only';
import { z } from 'zod';
import { config } from 'dotenv';

config({ path: '.env.local' });

const envSchema = z.object({
  DATABASE_URL: z.string().url('DATABASE_URL must be a valid URL'),
  REDIS_URL: z.string().url('REDIS_URL must be a valid URL'),
  NILE_URL: z.string().url('NILE_URL must be a valid URL'),
  NILE_DATABASE_ID: z.string().min(1, 'NILE_DATABASE_ID is required'),
  NILE_API_KEY: z.string().min(1, 'NILE_API_KEY is required'),
  NODE_ENV: z
    .enum(['development', 'test', 'production'])
    .default('development'),
  NEXT_PUBLIC_APP_URL: z
    .string()
    .url('NEXT_PUBLIC_APP_URL must be a valid URL'),
});

const parsed = envSchema.safeParse(process.env);

if (!parsed.success) {
  const issues = parsed.error.issues
    .map(issue => `${issue.path.join('.')}: ${issue.message}`)
    .join('\n');
  throw new Error(`Invalid environment variables:\n${issues}`);
}

export const env = parsed.data;
