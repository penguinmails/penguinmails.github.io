---
title: "Data Display Components"
description: "Information visualization components: Table and Card."
last_modified_date: "2026-02-24"
level: "3"
persona: "Documentation Users"
---

## Data Display Components

### Table

```jsx
import { Table } from '@/components/data-display/Table';

interface TableColumn<T> {
  key: keyof T;
  header: string;
  sortable?: boolean;
  filterable?: boolean;
  width?: string | number;
  align?: 'left' | 'center' | 'right';
  render?: (value: any, row: T) => React.ReactNode;
}

interface TableProps<T> {
  data: T[];
  columns: TableColumn<T>[];
  loading?: boolean;
  selectable?: boolean;
  pagination?: boolean;
  pageSize?: number;
  emptyState?: React.ReactNode;
  onSort?: (key: keyof T, direction: 'asc' | 'desc') => void;
  onSelect?: (selectedRows: T[]) => void;
  onRowClick?: (row: T) => void;
}

// Usage Example
<Table
  data={campaigns}
  columns={[
    {
      key: 'name',
      header: 'Campaign Name',
      sortable: true,
      render: (value, row) => (
        <Link to={`/campaigns/${row.id}`}>{value}</Link>
      )
    },
    {
      key: 'status',
      header: 'Status',
      filterable: true,
      render: (value) => <StatusBadge status={value} />
    },
    {
      key: 'sent',
      header: 'Sent',
      sortable: true,
      align: 'right'
    },
    {
      key: 'openRate',
      header: 'Open Rate',
      sortable: true,
      align: 'right',
      render: (value) => `${(value * 100).toFixed(1)}%`
    }
  ]}
  pagination
  pageSize={25}
  selectable
  onSelect={handleSelection}
  onRowClick={handleRowClick}
/>
```

### Card

```typescript
import { Card, CardHeader, CardContent, CardFooter } from '@/components/data-display/Card';

interface CardProps {
  variant?: 'default' | 'elevated' | 'outlined' | 'filled';
  size?: 'sm' | 'md' | 'lg';
  padding?: 'none' | 'sm' | 'md' | 'lg';
  hoverable?: boolean;
  clickable?: boolean;
  fullWidth?: boolean;
  onClick?: () => void;
  children: React.ReactNode;
}

// Usage Example
<Card variant="elevated" hoverable clickable onClick={handleCardClick}>
  <CardHeader>
    <Avatar src={campaign.creator.avatar} size="md" />
    <div>
      <h3 className="card-title">{campaign.name}</h3>
      <p className="card-subtitle">{campaign.description}</p>
    </div>
    <Badge variant={campaign.status.variant}>
      {campaign.status.label}
    </Badge>
  </CardHeader>

  <CardContent>
    <div className="metrics-grid">
      <Metric label="Recipients" value={campaign.recipientCount} />
      <Metric label="Open Rate" value={`${campaign.openRate}%`} />
      <Metric label="Click Rate" value={`${campaign.clickRate}%`} />
    </div>
  </CardContent>

  <CardFooter>
    <Button variant="secondary" size="sm">
      View Details
    </Button>
    <Button variant="primary" size="sm">
      Edit Campaign
    </Button>
  </CardFooter>
</Card>
```
