---
title: "Data Display Components"
description: "Data presentation components"
last_modified_date: "2025-12-04"
level: "3"
keywords: "data display, tables, cards"
---

# Data Display Components

## Data Display Components

### Table Component

```typescript
interface TableColumn<T> {
  key: keyof T;
  header: string;
  sortable?: boolean;
  filterable?: boolean;
  width?: string | number;
  render?: (value: any, row: T) => React.ReactNode;
}

interface TableProps<T> {
  data: T[];
  columns: TableColumn<T>[];
  loading?: boolean;
  selectable?: boolean;
  pagination?: boolean;
  pageSize?: number;
  onSort?: (key: keyof T, direction: 'asc' | 'desc') => void;
  onSelect?: (selectedRows: T[]) => void;
  onPageChange?: (page: number) => void;
}

// Usage
<Table
  data={campaigns}
  columns={[
    { key: 'name', header: 'Campaign Name', sortable: true },
    { key: 'status', header: 'Status', render: renderStatusBadge },
    { key: 'sent', header: 'Emails Sent', sortable: true },
    { key: 'openRate', header: 'Open Rate', sortable: true, render: formatPercentage }
  ]}
  pagination
  pageSize={25}
  selectable
  onSelect={handleSelection}
/>


```

### Card Component

```typescript
interface CardProps {
  variant?: 'default' | 'elevated' | 'outlined' | 'filled';
  size?: 'sm' | 'md' | 'lg';
  padding?: 'none' | 'sm' | 'md' | 'lg';
  hoverable?: boolean;
  clickable?: boolean;
  fullWidth?: boolean;
  onClick?: () => void;
  header?: React.ReactNode;
  footer?: React.ReactNode;
  children: React.ReactNode;
}

// Usage
<Card variant="elevated" hoverable clickable onClick={handleCardClick}>
  <CardHeader>
    <Avatar src={user.avatar} />
    <div>
      <h3>{campaign.name}</h3>
      <p>{campaign.description}</p>
    </div>
  </CardHeader>
  <div className="card-metrics">
    <Metric label="Sent" value={campaign.sent} />
    <Metric label="Opens" value={campaign.opens} />
    <Metric label="Clicks" value={campaign.clicks} />
  </div>
</Card>


```
