import { NextRequest, NextResponse } from 'next/server';
import { ZodError } from 'zod';
import { signupSchema } from '@/lib/schemas/auth.schemas';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const result = signupSchema.parse(body);

    return NextResponse.json(
      {
        success: true,
        message: 'Validation passed',
        data: result,
      },
      { status: 200 }
    );
  } catch (error) {
    if (error instanceof ZodError) {
      return NextResponse.json(
        {
          success: false,
          message: 'Validation failed',
          errors: error.issues.map(issue => ({
            path: issue.path.join('.'),
            message: issue.message,
          })),
        },
        { status: 400 }
      );
    }

    if (error instanceof SyntaxError) {
      return NextResponse.json(
        {
          success: false,
          message: 'Invalid JSON payload',
        },
        { status: 400 }
      );
    }

    return NextResponse.json(
      {
        success: false,
        message: 'Internal server error',
      },
      { status: 500 }
    );
  }
}
