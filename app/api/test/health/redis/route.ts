import { NextResponse } from 'next/server';
import { redis } from '@/lib/redis';

export async function GET() {
  const timestamp = new Date().toISOString();

  try {
    if (redis.status === 'wait') {
      await redis.connect();
    }

    const response = await redis.ping();

    return NextResponse.json(
      {
        status: 'ok',
        service: 'redis',
        response,
        timestamp,
      },
      { status: 200 }
    );
  } catch (error) {
    return NextResponse.json(
      {
        status: 'error',
        service: 'redis',
        error: error instanceof Error ? error.message : 'Unknown Redis error',
        timestamp,
      },
      { status: 503 }
    );
  }
}
