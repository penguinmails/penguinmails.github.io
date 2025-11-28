# Documentation Verification

Quick reference for maintaining documentation quality.


## Quick Check

Run the automated verification script:


```bash

./verify-docs.sh


```text

This checks for:


- ✅ Missing frontmatter fields


- ✅ Keywords in body (should be in frontmatter)


- ✅ Links to non-Jekyll files


- ✅ Jekyll incompatible links (.md extensions)


- ✅ Tech stack compliance


- ✅ Navigation structure


- ✅ Orphaned documents


## Detailed Verification

For comprehensive verification commands and fixes:


```

cat .kiro/steering/verification-checklist.md


```text


## Common Issues & Quick Fixes


### Missing Frontmatter

All Jekyll docs (`index.md` and `docs/`) need:


```

---
title: "Page Title"
description: "Page description"
last_modified_date: "YYYY-MM-DD"
level: "2"                          # 1=overview, 2=detailed, 3=implementation
persona: "Documentation Users"
---


```


### Links to Non-Jekyll Files

❌ **Don't link to:**


- `tasks/` folder


- `user-journeys/` folder


- `CONTRIBUTING.md`


- Root `README.md`

These files are not shipped by Jekyll and links will break.


### Jekyll Incompatible Links

❌ Wrong: `[Link](/docs/page.md)`
✅ Correct: `[Link](/docs/page)`

Remove `.md` extensions from internal links.


### Tech Stack Compliance

❌ **Forbidden:**


- Python, Ruby, PHP, C# code examples


- Prisma, BullMQ, MySQL, Kafka

✅ **Use:**


- TypeScript or JavaScript only


- Drizzle ORM, PostgreSQL, Redis


## Monthly Review


- [ ] Run `./verify-docs.sh`


- [ ] Fix identified issues


- [ ] Update `last_modified_date` for changed files


- [ ] Run markdown linting: `docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest markdownlint docs/ --config .markdownlint.json --fix`


## More Information


- **Detailed verification commands:** `.kiro/steering/verification-checklist.md`


- **Tech stack standards:** `CONTRIBUTING.md#tech-stack-compliance-standards`


- **Markdown linting:** `MARKDOWN_LINTING.md`


- **Frontmatter standards:** `CONTRIBUTING.md#frontmatter-standards`

---

**Quick Start:** Run `./verify-docs.sh` to check documentation health.