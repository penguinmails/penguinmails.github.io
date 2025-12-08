
# CORE-1.1: Initialize Next.js 15 Project

**Ticket ID:** CORE-1.1  
**Milestone:** 1 - Project Initialization & Code Quality  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a new Next.js 15 project using `create-next-app`. Configure it with TypeScript, Tailwind CSS, and the App Router. This is the absolute first step in establishing the PenguinMails application foundation.

## Context

This ticket establishes the core framework for PenguinMails. According to the [High-Level Architecture](/docs/quick-access/high-level-architecture), the frontend is built with:

- **React.js** with TypeScript
- **Tailwind CSS** for styling
- **Next.js App Router** for routing and server-side rendering

## Acceptance Criteria

1. ✅ A new Next.js project exists in the Git repository
2. ✅ The project's dependencies are installed via `npm install`
3. ✅ Running `npm run dev` starts the local server successfully and displays the default Next.js page
4. ✅ TypeScript is configured and working
5. ✅ Tailwind CSS is installed and configured
6. ✅ App Router is set up (not Pages Router)

## Technical Details

### Required Configuration

- **Next.js Version:** 15.x
- **TypeScript:** Latest stable version
- **Tailwind CSS:** Latest version with PostCSS
- **App Router:** Enabled (default in Next.js 13+)

### Project Structure

```txt
penguinmails/
├── app/
│   ├── layout.tsx
│   ├── page.tsx
│   └── globals.css
├── public/
├── package.json
├── tsconfig.json
├── tailwind.config.ts
└── next.config.js
```

## Implementation Notes

- Use `create-next-app@latest` with TypeScript and Tailwind CSS flags
- Ensure the project uses the App Router (not Pages Router)
- Verify that the default page renders correctly
- Test that hot module replacement (HMR) works

## Related Documentation

- [High-Level Architecture](/docs/quick-access/high-level-architecture) - System architecture
- [Architecture System Overview](/docs/implementation-technical/architecture-system/architecture-overview) - Technical architecture details
- [Development Standards](/docs/implementation-technical/development-guidelines/development-standards) - Development guidelines
- [Implementation & Getting Started](/docs/implementation-getting-started/index) - Setup guides

## Dependencies

None - This is the first ticket.

## Testing

- [ ] Run `npm run dev` and verify the default page loads
- [ ] Verify TypeScript compilation works without errors
- [ ] Confirm Tailwind CSS styles are applied
- [ ] Test that the development server restarts on file changes

---

## Related Documentation

- **Routes**: [core-app-structure](/docs/design/routes/core-app-structure)
- **API**: [API Reference](/docs/implementation-technical/api/README)
