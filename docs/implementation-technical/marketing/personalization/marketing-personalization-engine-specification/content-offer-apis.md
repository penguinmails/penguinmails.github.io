---
title: "Personalization Engine - Content & Offer APIs"
description: "Integration with content management systems and batch fetching of content items."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# Personalization Engine - Content & Offer APIs

### Content Management Integration

```typescript
import fetch from 'node-fetch';

interface ContentAPIResponse {
  content_items: ContentItem[];
  pagination: {
    page: number;
    per_page: number;
    total_count: number;
  };
}

interface ContentAPIClient {
  getPersonalizedContent(
    customerSegment: string,
    contentType: string,
    count?: number
  ): Promise<ContentItem[]>;
  getContentByIds(ids: string[]): Promise<ContentItem[]>;
  getContentByCategory(category: string, limit?: number): Promise<ContentItem[]>;
}

class ContentAPIClientImpl implements ContentAPIClient {
  private baseUrl: string;
  private headers: Record<string, string>;
  private defaultTimeout: number = 5000; // 5 seconds

  constructor(baseUrl: string, apiKey: string) {
    this.baseUrl = baseUrl;
    this.headers = {
      'Authorization': `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
  }

  async getPersonalizedContent(
    customerSegment: string,
    contentType: string,
    count: number = 10
  ): Promise<ContentItem[]> {
    try {
      const url = `${this.baseUrl}/api/v2/content/personalized`;
      const params = new URLSearchParams({
        segment: customerSegment,
        type: contentType,
        limit: count.toString(),
      });

      const response = await fetch(`${url}?${params.toString()}`, {
        method: 'GET',
        headers: this.headers,
        timeout: this.defaultTimeout
      });

      if (!response.ok) {
        throw new APIException(`Content API returned ${response.status}: ${await response.text()}`);
      }

      const data: ContentAPIResponse = await response.json();
      return data.content_items;
    } catch (error) {
      if (error instanceof APIException) {
        throw error;
      }
      throw new APIException(`Failed to fetch personalized content: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  async getContentByIds(ids: string[]): Promise<ContentItem[]> {
    try {
      const url = `${this.baseUrl}/api/v2/content/batch`;

      const response = await fetch(url, {
        method: 'POST',
        headers: this.headers,
        body: JSON.stringify({ ids }),
        timeout: this.defaultTimeout
      });

      if (!response.ok) {
        throw new APIException(`Content API returned ${response.status}: ${await response.text()}`);
      }

      const data: ContentAPIResponse = await response.json();
      return data.content_items;
    } catch (error) {
      if (error instanceof APIException) {
        throw error;
      }
      throw new APIException(`Failed to fetch content by IDs: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  async getContentByCategory(category: string, limit: number = 20): Promise<ContentItem[]> {
    try {
      const url = `${this.baseUrl}/api/v2/content/category/${encodeURIComponent(category)}`;
      const params = new URLSearchParams({ limit: limit.toString() });

      const response = await fetch(`${url}?${params.toString()}`, {
        method: 'GET',
        headers: this.headers,
        timeout: this.defaultTimeout
      });

      if (!response.ok) {
        throw new APIException(`Content API returned ${response.status}: ${await response.text()}`);
      }

      const data: ContentAPIResponse = await response.json();
      return data.content_items;
    } catch (error) {
      if (error instanceof APIException) {
        throw error;
      }
      throw new APIException(`Failed to fetch content by category: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }
}

class APIException extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'APIException';
  }
}
```
