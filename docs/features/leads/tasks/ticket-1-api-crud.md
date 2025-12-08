
# [LEADS-2.1] Create Contacts API

## Description

Implement REST API endpoints for creating, reading, updating, and deleting contacts.

## Acceptance Criteria

- [ ] `POST /api/v1/contacts` - Create contact
- [ ] `GET /api/v1/contacts` - List contacts (with pagination & search)
- [ ] `GET /api/v1/contacts/:id` - Get single contact
- [ ] `PUT /api/v1/contacts/:id` - Update contact
- [ ] `DELETE /api/v1/contacts/:id` - Delete contact
- [ ] All endpoints must be tenant-scoped

## Technical Details

- Use Next.js Route Handlers
- Validate input with Zod
- Ensure `tenantId` is injected from session (never from body)

```typescript
// POST /api/v1/contacts
import { db } from '@/lib/db';
import { contacts } from '@/db/schema/leads';

export async function POST(req: Request) {
  const session = await getSession();
  const body = await req.json();
  
  // Validate input with Zod schema
  const contactData = {
    ...body,
    tenantId: session.tenantId
  };
  
  const [contact] = await db.insert(contacts).values(contactData).returning();
  
  return NextResponse.json(contact);
}

// GET /api/v1/contacts
import { and, or, ilike, eq, desc } from 'drizzle-orm';

export async function GET(req: Request) {
  const session = await getSession();
  const { searchParams } = new URL(req.url);
  const page = parseInt(searchParams.get('page') || '1');
  const limit = parseInt(searchParams.get('limit') || '20');
  const search = searchParams.get('search') || '';
  
  const skip = (page - 1) * limit;
  
  const contactResults = await db.select()
    .from(contacts)
    .where(and(eq(contacts.tenantId, session.tenantId), search ? or(
      ilike(contacts.email, `%${search}%`),
      ilike(contacts.firstName, `%${search}%`),
      ilike(contacts.lastName, `%${search}%`)
    ) : undefined))
    .orderBy(desc(contacts.createdAt))
    .limit(limit)
    .offset(skip);
  
  return NextResponse.json({
    data: contactResults,
    pagination: {
      page,
      limit,
      total: contactResults.length
    }
  });
}
```

---

## Cross-References

- **Routes**: [tenant-leads.md]()
- **API**: [tenant-api/](/docs/implementation-technical/api/tenant-api/)
