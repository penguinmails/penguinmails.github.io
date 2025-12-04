---
title: "Tech Stack"
description: "UI library technology stack"
last_modified_date: "2025-12-04"
level: "3"
keywords: "tech stack, React, TypeScript, Tailwind"
---

# Tech Stack

## Tech Stack

### Frontend Framework

**Next.js 15** (App Router)

- Server Components by default

- Server Actions for MVP (BFF pattern)

- Progressive migration to REST API calls post-MVP

- File-based routing in `app/` directory

### Styling & Design System

**Tailwind CSS v4** + **shadcn/ui**

- Utility-first CSS framework (v4)

- shadcn/ui for pre-built accessible components

- Custom design tokens in `tailwind.config.ts`

- Global styles in `app/globals.css`

### Form Management

**react-hook-form** + **zod**

- Type-safe form validation

- Schema-based validation with Zod

- Minimal re-renders

- Built-in error handling

**Example Pattern**:

```typescript
// Define schema
const campaignSchema = z.object({
  name: z.string().min(1, "Campaign name required"),
  subject: z.string().min(1, "Subject required"),
  recipients: z.array(z.string().email()).min(1)
});

// Use in form
const form = useForm({
  resolver: zodResolver(campaignSchema)
});


```

### Icons

### lucide-react

- Consistent icon library

- Tree-shakeable

- TypeScript support

- Example: `import { Mail, Send, Users } from 'lucide-react'`

### Animation & Motion

**tw-animate-css** + **CSS Transitions**

- Use `tw-animate-css` for standard animations (fade, slide, bounce)

- Use standard CSS transitions for hover states and micro-interactions

- Avoid heavy JS animation libraries like Framer Motion unless absolutely necessary for complex gestures

### Dark Mode

**Tailwind Dark Mode** (`selector` strategy)

- Use `darkMode: 'selector'` in Tailwind config

- Toggle class `dark` on the `<html>` element

- Use `dark:` prefix for dark mode styles (e.g., `bg-white dark:bg-slate-900`)

### State Management

**React Context** (for simple global state)

- Theme preferences

- User session

- Feature flags

**Zustand** (for complex state, if needed)

- Campaign editor state

- Multi-step form state

### Data Fetching

**MVP**: Server Actions (Next.js 15)

```typescript
'use server';
export async function getCampaigns() {
  const data = await db.campaigns.findMany();
  return data;
}


```

**Post-MVP**: REST API with fetch/axios

```typescript
const campaigns = await fetch('/api/v1/campaigns').then(r => r.json());


```

---

