---
title: "Personalization Engine - API Endpoints"
description: "Real-time API endpoints for content personalization and health monitoring."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# Personalization Engine - API Endpoints

### Real-Time API Endpoints

```typescript
import express, { Request, Response } from 'express';

interface PersonalizationRequest {
  customerId: string;
  availableItems: ContentItem[];
  context?: {
    pageUrl?: string;
    referrer?: string;
    deviceType?: string;
  };
}

interface PersonalizationResponse {
  decisionId: string;
  selectedContent: ContentItem;
  confidenceScore: number;
  reasoning: string;
  latencyMs: number;
  alternativeOptions: ContentItem[];
}

interface DecisionEngine {
  selectPersonalizedContent(customerId: string, context: PersonalizationContext): Promise<PersonalizationDecision>;
}

class PersonalizationAPIController {
  private decisionEngine: DecisionEngine;
  private app: express.Application;

  constructor(decisionEngine: DecisionEngine) {
    this.decisionEngine = decisionEngine;
    this.app = express();
    this.setupRoutes();
  }

  private setupRoutes(): void {
    this.app.post('/api/v1/personalize', this.personalizeContent.bind(this));
    this.app.get('/api/v1/health', this.healthCheck.bind(this));
  }

  async personalizeContent(req: Request, res: Response): Promise<void> {
    const startTime = Date.now();

    try {
      const request: PersonalizationRequest = req.body;

      // Validate request
      if (!request.customerId || !request.availableItems || request.availableItems.length === 0) {
        res.status(400).json({
          error: 'Invalid request',
          message: 'customerId and availableItems are required'
        });
        return;
      }

      const context: PersonalizationContext = {
        availableItems: request.availableItems,
        deviceType: request.context?.deviceType,
        // Add more context mapping as needed
      };

      const decision = await this.decisionEngine.selectPersonalizedContent(request.customerId, context);
      
      const latencyMs = Date.now() - startTime;
      const response: PersonalizationResponse = {
        decisionId: Math.random().toString(36).substring(7),
        selectedContent: decision.selectedContent,
        confidenceScore: decision.confidenceScore,
        reasoning: decision.reasoning,
        latencyMs,
        alternativeOptions: decision.alternativeOptions
      };

      // Log decision for analytics
      this.logDecision(request.customerId, decision, latencyMs);

      res.json(response);
    } catch (error) {
      console.error('Personalization error:', error);
      res.status(500).json({
        error: 'Internal server error',
        message: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  private async healthCheck(req: Request, res: Response): Promise<void> {
    try {
      // Check decision engine health
      const testContext: PersonalizationContext = {
        availableItems: [{
          id: 'test',
          type: 'article',
          title: 'Health Check',
          category: 'system',
          tags: [],
          attributes: {}
        }]
      };
      
      await this.decisionEngine.selectPersonalizedContent('health-check-user', testContext);
      
      res.json({
        status: 'ok',
        timestamp: new Date().toISOString(),
        version: '1.2.0'
      });
    } catch (error) {
      res.status(503).json({
        status: 'error',
        message: 'Personalization engine unhealthy'
      });
    }
  }

  private logDecision(
    customerId: string,
    decision: PersonalizationDecision,
    latencyMs: number
  ): void {
    // Log decision for analytics and model improvement
    console.log('Personalization decision', {
      customerId,
      selectedItemId: decision.selectedContent.id,
      confidenceScore: decision.confidenceScore,
      latencyMs,
      timestamp: new Date().toISOString()
    });
  }

  getExpressApp(): express.Application {
    return this.app;
  }
}
```
