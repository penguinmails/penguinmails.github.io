import { migrate } from 'drizzle-orm/node-postgres/migrator';
import { db, pool } from '../lib/db';

async function main() {
  try {
    console.log('Applying database migrations...');
    await migrate(db, { migrationsFolder: './migrations' });
    console.log('Database migrations applied successfully.');
  } catch (error) {
    console.error('Database migration failed:', error);
    process.exitCode = 1;
  } finally {
    await pool.end();
  }
}

void main();
