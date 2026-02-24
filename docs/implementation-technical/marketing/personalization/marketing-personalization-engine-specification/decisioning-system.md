---
title: "Personalization Engine - Decisioning System"
description: "Implementation of the real-time decisioning engine using contextual bandits and ML models."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# Personalization Engine - Decisioning System

## Real-Time Decisioning System

### Contextual Bandit Implementation

```typescript
interface ContentItem {
  id: string;
  type: 'article' | 'product' | 'video' | 'email' | 'banner';
  title: string;
  category: string;
  tags: string[];
  attributes: Record<string, string | number>;
}

interface PersonalizationContext {
  availableItems: ContentItem[];
  location?: string;
  deviceType?: string;
  timeOfDay?: string;
  season?: string;
}

interface PersonalizationDecision {
  selectedContent: ContentItem;
  confidenceScore: number;
  reasoning: string;
  alternativeOptions: ContentItem[];
  explorationUsed: boolean;
}

interface MLModel {
  predict(features: number[]): Promise<number[]>;
}

class ContextualBanditDecisionEngine {
  private models: Record<string, MLModel>;
  private featureStore: FeatureStore;
  private explorationRate: number = 0.1; // 10% exploration
  private minExplorationBonus: number = 0;
  private maxExplorationBonus: number = 0.2;

  constructor(models: Record<string, MLModel>, featureStore: FeatureStore) {
    this.models = models;
    this.featureStore = featureStore;
  }

  async selectPersonalizedContent(
    customerId: string,
    context: PersonalizationContext
  ): Promise<PersonalizationDecision> {
    // Retrieve customer features
    const customerFeatures = await this.featureStore.getCustomerFeatures(customerId, [
      'engagement_score',
      'recency_score',
      'frequency_score',
      'monetary_score',
      'category_preferences'
    ]);

    const explorationBonus = this.shouldExplore() ? this.getExplorationBonus() : 0;
    const scores: Array<{ item: ContentItem; score: number }> = [];

    for (const item of context.availableItems) {
      const inputFeatures = this.buildContextFeatures(customerFeatures, item, context);
      const prediction = await this.models[item.type].predict(inputFeatures);
      
      // Predicted probability of selection/conversion
      const baseScore = prediction[0];
      const finalScore = baseScore + explorationBonus;
      
      scores.push({ item, score: finalScore });
    }

    // Sort by score descending
    const sortedScores = scores.sort((a, b) => b.score - a.score);
    const bestScore = sortedScores[0];
    const selectedContent = bestScore.item;
    const confidenceScore = bestScore.score;

    // Select alternative options (top 3 excluding the selected)
    const alternativeOptions = sortedScores
      .slice(1, 4)
      .map(score => score.item);

    // Generate reasoning
    const reasoning = this.generateReasoning(selectedContent, customerFeatures, confidenceScore);

    return {
      selectedContent,
      confidenceScore,
      reasoning,
      alternativeOptions,
      explorationUsed: explorationBonus > 0
    };
  }

  private buildContextFeatures(
    customerFeatures: Record<string, number>,
    contentItem: ContentItem,
    context: PersonalizationContext
  ): number[] {
    const features: number[] = [];

    // Customer features (5)
    features.push(customerFeatures.engagement_score || 0);
    features.push(customerFeatures.recency_score || 0);
    features.push(customerFeatures.frequency_score || 0);
    features.push(customerFeatures.monetary_score || 0);
    features.push(customerFeatures.category_preferences?.[contentItem.category] || 0);

    // Content features (2)
    features.push(this.encodeCategory(contentItem.category));
    features.push(contentItem.tags.length);

    // Context features (3)
    features.push(context.deviceType === 'mobile' ? 1 : 0);
    features.push(this.encodeTimeOfDay(context.timeOfDay));
    features.push(this.encodeSeason(context.season));

    return features;
  }

  private shouldExplore(): boolean {
    return Math.random() < this.explorationRate;
  }

  private getExplorationBonus(): number {
    return this.minExplorationBonus +
           Math.random() * (this.maxExplorationBonus - this.minExplorationBonus);
  }

  private encodeCategory(category: string): number {
    // Simple category encoding (in production, would use proper encoding)
    const categories = ['article', 'product', 'video', 'email', 'banner'];
    const index = categories.indexOf(category);
    return index !== -1 ? index / categories.length : 0;
  }

  private encodeTimeOfDay(time?: string): number {
    const hours = time ? parseInt(time.split(':')[0]) : new Date().getHours();
    return hours / 24;
  }

  private encodeSeason(season?: string): number {
    const seasons = ['spring', 'summer', 'fall', 'winter'];
    const currentSeason = season || this.getCurrentSeason();
    return seasons.indexOf(currentSeason) / seasons.length;
  }

  private getCurrentSeason(): string {
    const month = new Date().getMonth();
    if (month >= 2 && month <= 4) return 'spring';
    if (month >= 5 && month <= 7) return 'summer';
    if (month >= 8 && month <= 10) return 'fall';
    return 'winter';
  }

  private generateReasoning(selectedContent: ContentItem, customerFeatures: Record<string, number>, confidenceScore: number): string {
    const reasons: string[] = [];
    if (customerFeatures.category_preferences?.[selectedContent.category] > 0.7) {
      reasons.push(`strong preference for ${selectedContent.category}`);
    }
    if (customerFeatures.engagement_score > 0.8) {
      reasons.push('high overall engagement');
    }
    if (confidenceScore > 0.8) {
      reasons.push('high prediction confidence');
    }
    if (reasons.length === 0) {
      reasons.push('best overall match based on customer profile');
    }
    return `Selected due to ${reasons.join(', ')}`;
  }
}
```
