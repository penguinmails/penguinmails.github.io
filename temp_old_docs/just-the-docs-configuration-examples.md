# Just the Docs Configuration Examples - PenguinMails

## _config.yml Configuration

```yaml
# Theme Configuration
theme: 
  name: just-the-docs
  config: just-the-docs

# Repository Configuration
repository:
  owner: penguinmails
  name: docs

# Title and Description
title: "🐧 PenguinMails Documentation"
description: "Comprehensive documentation for PenguinMails cold email infrastructure platform"

# Just the Docs Theme Configuration
just_the_docs:
  # Homepage Configuration
  home_page_title: "Documentation Home"
  home_page_subtitle: "Your Cold Email Infrastructure & Campaign Management Platform"

  # Navigation Configuration
  topnav:
    - title: "Quick Start"
      url: "#quick-start"
    - title: "Business"
      url: "#business"
    - title: "Technical"  
      url: "#technical"
    - title: "Operations"
      url: "#operations"

  # Auxiliary Links (shown on all pages)
  aux_links:
    "GitHub Repository":
      - "https://github.com/penguinmails/docs"
    "Support Email":
      - "mailto:support@penguinmails.com"
    "Company Website":
      - "https://penguinmails.com"

  # Footer Configuration
  footer_start: "© 2024 PenguinMails. All rights reserved."
  footer_end: "Last updated: {: %Y-%m-%d %H:%M :}"

  # Back to Top Configuration
  back_to_top: true
  back_to_top_text: "Back to top"

  # Collections Configuration
  collections:
    user_journeys:
      name: "User Journeys"
      nav_fold: true
      search_exclude: false
    
    operations_runbooks:
      name: "Operations Runbooks"
      nav_fold: true  
      search_exclude: false
    
    technical_implementation:
      name: "Technical Implementation"
      nav_fold: true
      search_exclude: false

# Jekyll Collections Configuration
collections:
  user_journeys:
    output: true
    permalink: /:collection/:title/
  
  operations_runbooks:
    output: true
    permalink: /:collection/:title/
  
  technical_implementation:
    output: true
    permalink: /:collection/:title/

# Default Frontmatter Values
defaults:
  # All documents
  - scope:
      path: ""
      type: "pages"
    values:
      layout: "page"
      toc: true
      search_exclude: false

  # User Journey documents
  - scope:
      path: ""
      type: "user_journeys"
    values:
      layout: "page"
      parent: "User Experience & Design"
      nav_order: 20
      has_children: true
      collection: user_journeys

  # Operations Runbooks
  - scope:
      path: ""
      type: "operations_runbooks" 
    values:
      layout: "page"
      parent: "Operations & Procedures"
      nav_order: 42
      has_children: true
      collection: operations_runbooks
```

## Frontmatter Templates

### Main Category Pages
```yaml
---
title: "Business & Strategy"
nav_order: 1
has_children: true
children:
  - "Product Strategy"
  - "Value Proposition" 
  - "Market Analysis"
  - "Business Model"
---
```

### Child Pages
```yaml
---
title: "Product Strategy"
parent: "Business & Strategy"
nav_order: 1
---
```

### Collection Pages
```yaml
---
title: "User Journeys"
parent: "User Experience & Design"
nav_order: 1
has_children: true
collection: user_journeys
children:
  - "Authentication Journeys"
  - "Payment Journeys"
  - "Campaign Journeys"
  - "Analytics Journeys"
---
```

## Document Organization Examples

### Business & Strategy Category Structure

Create directory: `business-strategy/`

#### Main Category Page
`business-strategy/index.md`
```yaml
---
title: "Business & Strategy"
nav_order: 10
has_children: true
---

# Business & Strategy

This section contains all business-focused documentation including product strategy, value propositions, market analysis, and business planning documents.

## Documents in this Section

1. **Product Strategy** - Overall vision and objectives
2. **Value Proposition** - Customer problems we solve
3. **Market Analysis** - Market research and competitive analysis
4. **Business Model** - Revenue model and business operations
5. **Roadmap** - Feature priorities and timeline
6. **Business Documentation Proposal** - Documentation strategy

## Related Sections

- [Technical Architecture](technical-architecture/) - Technical specifications and decisions
- [Implementation Guides](implementation-guides/) - How to implement features
- [Operations & Procedures](operations-procedures/) - Day-to-day operations
```

#### Individual Business Documents
`business-strategy/product-strategy.md`
```yaml
---
title: "Product Strategy"
parent: "Business & Strategy"
nav_order: 1
---

# Product Strategy

## Overview
[Content here]
```

### Technical Architecture Category Structure

Create directory: `technical-architecture/`

#### Main Category Page  
`technical-architecture/index.md`
```yaml
---
title: "Technical Architecture"
nav_order: 20
has_children: true
children:
  - "Architecture Overview"
  - "Database Architecture"
  - "Analytics Architecture" 
  - "Infrastructure Documentation"
---

# Technical Architecture

This section contains technical documentation including system architecture, database design, analytics systems, and infrastructure management.

## Core Architecture Documents

1. **Architecture Overview** - High-level system design
2. **Database Architecture** - 4-tier database structure
3. **Analytics Architecture** - Analytics system design
4. **Infrastructure Documentation** - System infrastructure

## Database Architecture Sub-Section

The database architecture includes detailed guides for each tier:

- [OLTP Schema Guide](database-architecture/oltp-schema/) - Operational database
- [Content Database Schema](database-architecture/content-database/) - Heavy content storage
- [OLAP Analytics Schema](database-architecture/olap-analytics/) - Business intelligence
- [Queue System Schema](database-architecture/queue-system/) - Job processing

## Related Sections

- [User Experience & Design](user-experience-design/) - User journey and design system
- [Implementation Guides](implementation-guides/) - Step-by-step implementation
- [Operations & Procedures](operations-procedures/) - Operational procedures
```

#### Database Architecture Sub-Category
`technical-architecture/database-architecture/index.md`
```yaml
---
title: "Database Architecture"
parent: "Technical Architecture"
nav_order: 2
has_children: true
children:
  - "OLTP Schema Guide"
  - "Content Database Schema"
  - "OLAP Analytics Schema"
  - "Queue System Schema"
---

# Database Architecture

PenguinMails implements a **4-tier database architecture** designed for scalability, performance, and clear separation of concerns.

## Architecture Overview

The 4-tier architecture consists of:

1. **OLTP (Operational Database)** - Fast transactional operations
2. **Content Database** - Heavy content storage and email archives  
3. **OLAP Analytics Database** - Business intelligence and reporting
4. **Queue System** - Job processing and reliability

## Detailed Schema Guides

- [OLTP Schema Guide](oltp-schema/) - Operational database schema
- [Content Database Schema](content-database/) - Heavy content storage schema
- [OLAP Analytics Schema](olap-analytics/) - Analytics database schema  
- [Queue System Schema](queue-system/) - Job processing schema

## Performance & Security

- [Performance Optimization](performance-optimization/) - Query optimization strategies
- [Security & Multi-Tenancy](security/) - Row-level security and data protection
```

### User Experience & Design Category Structure

Create directory: `user-experience-design/`

#### Main Category Page
`user-experience-design/index.md`
```yaml
---
title: "User Experience & Design"
nav_order: 30
has_children: true
children:
  - "User Journeys"
  - "User Personas"
  - "Design System"
  - "UI Library"
  - "Component Library"
---

# User Experience & Design

This section contains user experience documentation including journey mapping, personas, design systems, and component libraries.

## User Experience Documents

1. **User Journeys** - Complete user flow documentation
2. **User Personas** - User research and personas  
3. **Design System** - Visual language and principles
4. **UI Library** - User interface components
5. **Component Library** - Reusable UI components

## User Journey Collections

The user journeys are organized as a collection with automatic folding:

- [Authentication Journeys](user-journeys/authentication/) - Login and access control flows
- [Payment Journeys](user-journeys/payment/) - Stripe integration and billing flows
- [Campaign Journeys](user-journeys/campaigns/) - Email campaign management flows
- [Analytics Journeys](user-journeys/analytics/) - Analytics and reporting flows
- [Onboarding Journeys](user-journeys/onboarding/) - User onboarding flows
- [Emergency Journeys](user-journeys/emergency/) - Crisis and support flows

## Design System Documents

- [Design Principles](design-system/principles/) - Core design philosophy
- [Design Tokens](design-system/tokens/) - Colors, typography, spacing
- [Component Library](component-library/) - Reusable UI components
- [Accessibility Guidelines](accessibility/) - Inclusive design standards
- [Interaction Patterns](interaction-patterns/) - User flow patterns

## Related Sections

- [Business & Strategy](business-strategy/) - Business context and requirements
- [Technical Architecture](technical-architecture/) - Technical implementation details
- [Implementation Guides](implementation-guides/) - Step-by-step guides
```

### Implementation Guides Category Structure  

Create directory: `implementation-guides/`

#### Main Category Page
`implementation-guides/index.md`
```yaml
---
title: "Implementation Guides"
nav_order: 40
has_children: true
children:
  - "Onboarding & Authentication"
  - "Stripe Integration" 
  - "IP Management"
  - "Email System Implementation"
  - "Queue System Implementation"
---

# Implementation Guides

This section contains step-by-step implementation guides for core system components and integrations.

## Core Implementation Guides

1. **Onboarding & Authentication** - Complete authentication flow implementation
2. **Stripe Integration** - Payment processing and billing setup
3. **IP Management** - Email infrastructure and deliverability
4. **Email System Implementation** - Email processing and delivery
5. **Queue System Implementation** - Job processing and reliability

## Technical Implementation Collection

Additional technical implementation guides are available in the [Technical Implementation](technical-implementation/) collection:

- [DNS Integration Guide](technical-implementation/dns-integration/) - DNS configuration and management
- [Optimization Migration](technical-implementation/optimization-migration/) - System optimization strategies
- [Migration Scripts](technical-implementation/migration-scripts/) - Database and system migrations

## Related Sections

- [Technical Architecture](technical-architecture/) - System design and architecture
- [Operations & Procedures](operations-procedures/) - Operational procedures
- [User Experience & Design](user-experience-design/) - Design system and user flows
```

### Operations & Procedures Category Structure

Create directory: `operations-procedures/`

#### Main Category Page
`operations-procedures/index.md`
```yaml
---
title: "Operations & Procedures" 
nav_order: 50
has_children: true
children:
  - "Onboarding Guide"
  - "Operations Runbooks"
  - "Customer Onboarding Process"
  - "QA Testing Protocols"
  - "Compliance Procedures"
  - "Incident Response Plan"
  - "Security Documentation"
  - "SOP Guidelines"
---

# Operations & Procedures

This section contains operational documentation including procedures, runbooks, compliance guidelines, and best practices.

## Core Operations Documents

1. **Onboarding Guide** - Team member onboarding and procedures
2. **Customer Onboarding Process** - Customer acquisition and setup
3. **QA Testing Protocols** - Quality assurance procedures
4. **Compliance Procedures** - Legal and regulatory compliance
5. **Incident Response Plan** - Crisis management and response
6. **Security Documentation** - Security practices and procedures
7. **SOP Guidelines** - Standard operating procedures

## Operations Runbooks Collection

Critical operational procedures organized as runbooks:

- [Backup & Recovery](operations-runbooks/backup-recovery/) - Data backup and recovery procedures
- [Database Operations](operations-runbooks/database-operations/) - Database management and maintenance
- [Performance Monitoring](operations-runbooks/performance-monitoring/) - System monitoring and optimization
- [Connection Pooling](operations-runbooks/connection-pooling/) - Database connection management
- [Migration & Deployment](operations-runbooks/migration-deployment/) - System deployment and migration

## Related Sections

- [Implementation Guides](implementation-guides/) - Technical implementation details
- [Technical Architecture](technical-architecture/) - System infrastructure
- [Analytics & Monitoring](analytics-monitoring/) - Performance metrics and analytics
```

### Analytics & Monitoring Category Structure

Create directory: `analytics-monitoring/`

#### Main Category Page
`analytics-monitoring/index.md`
```yaml
---
title: "Analytics & Monitoring"
nav_order: 60
has_children: true
children:
  - "User Analytics"
  - "Product Analytics" 
  - "Growth Metrics"
  - "Financial Metrics"
  - "Metrics & KPIs"
  - "User Journeys Analytics"
---

# Analytics & Monitoring

This section contains analytics documentation including user behavior tracking, product metrics, growth analysis, and business intelligence.

## Analytics Documents

1. **User Analytics** - User behavior and engagement metrics
2. **Product Analytics** - Feature usage and product performance
3. **Growth Metrics** - User acquisition and retention metrics
4. **Financial Metrics** - Revenue and profitability analysis
5. **Metrics & KPIs** - Key performance indicators and targets
6. **User Journeys Analytics** - Journey-specific analytics

## Related Sections

- [Technical Architecture](technical-architecture/) - Analytics system architecture
- [Operations & Procedures](operations-procedures/) - Operational metrics and monitoring
- [Implementation Guides](implementation-guides/) - Analytics implementation guides
```

## Navigation Order Strategy

### Primary Categories (nav_order: 1-100)
| Category | nav_order Range | Purpose |
|----------|----------------|---------|
| Home | 1 | Documentation hub and quick start |
| Business & Strategy | 10-19 | Business planning and strategy |
| Technical Architecture | 20-29 | System design and architecture |
| User Experience & Design | 30-39 | UX/UI and user journeys |
| Implementation Guides | 40-49 | Step-by-step implementation |
| Operations & Procedures | 50-59 | Day-to-day operations |
| Analytics & Monitoring | 60-69 | Metrics and business intelligence |
| Implementation Planning | 70-79 | Project planning and roadmaps |

### Secondary Pages (within categories)
| Page Type | nav_order Range | Example |
|-----------|----------------|---------|
| Category Overview | 1-10 | Technical Architecture (20) |
| Major Sections | 11-50 | Database Architecture (22) |
| Child Pages | 51-99 | OLTP Schema Guide (51) |
| Sub-child Pages | 51-99 | Performance Optimization (52) |

## Collections vs. Directory Structure

### When to Use Collections
- **User Journeys**: Multiple similar documents with consistent structure
- **Operations Runbooks**: Operational procedures with standard formatting
- **Technical Implementation**: Implementation guides with similar patterns

### When to Use Directory Structure
- **Business Documents**: Mixed document types requiring flexibility
- **Architecture Sections**: Hierarchical technical documentation
- **Design System**: Structured design documentation

This hybrid approach provides the best of both worlds: automatic organization through collections and flexible hierarchy through directory structure.