---
title: "Optimization Engine - Online Learning & Drift"
description: "Adaptive learning systems, online gradient updates, and automated drift detection mechanisms."
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---

# Optimization Engine - Online Learning & Drift

## 4. Model Adaptation and Drift Control

### Online Learning System

The system continuously adapts to changing market conditions using incremental model updates.

```typescript
interface FeedbackData {
  features: number[];
  actualOutcome: number;
  timestamp: string;
  campaignId: string;
}

interface DriftDetectionResult {
  hasDrift: boolean;
  driftScore: number;
  confidence: number;
}

class OnlineLearningSystem {
  private updateBuffer: FeedbackData[] = [];
  private driftDetector: DriftDetector;
  private model: CampaignPerformanceModel;
  private learningRate: number = 0.001;
  private maxBufferSize: number = 10000;

  async onNewFeedback(feedback: FeedbackData): Promise<void> {
    this.updateBuffer.push(feedback);

    if (this.updateBuffer.length >= 100) {
      await this.processBuffer();
    }

    const drift = await this.driftDetector.update(feedback.actualOutcome);
    if (drift.hasDrift && drift.driftScore > 0.1) {
      await this.handleSignificantDrift(drift);
    }
  }

  private async processBuffer(): Promise<void> {
    const batch = this.updateBuffer.splice(0, 100);
    const gradients = await this.computeGradientsParallel(batch);
    await this.applyGradients(gradients);
  }

  private async computeLoss(prediction: number, actualOutcome: number): Promise<number> {
    // Mean Squared Error loss
    return Math.pow(prediction - actualOutcome, 2);
  }

  private async computeGradients(features: number[], loss: number): Promise<number[]> {
    // Simplified gradient computation
    return features.map(feature => feature * loss * this.learningRate);
  }

  private async handleSignificantDrift(drift: DriftDetectionResult): Promise<void> {
    console.warn(`Significant drift detected: ${drift.driftScore}`);
    await this.initiateRetrainingProcess();
  }

  private async initiateRetrainingProcess(): Promise<void> {
    console.log("Triggering model retraining due to drift detection");
  }
}

class DriftDetector {
  private baselineDistribution: number[] = [];
  private currentDistribution: number[] = [];
  private driftThreshold: number = 0.05;

  async update(actualOutcome: number): Promise<DriftDetectionResult> {
    this.currentDistribution.push(actualOutcome);
    if (this.currentDistribution.length > 1000) {
      this.currentDistribution.shift();
    }

    const currentMean = this.calculateMean(this.currentDistribution);
    const baselineMean = this.calculateMean(this.baselineDistribution);
    const driftScore = Math.abs(currentMean - baselineMean);

    return {
      hasDrift: driftScore > this.driftThreshold,
      driftScore,
      confidence: Math.min(this.currentDistribution.length / 100, 1)
    };
  }

  private calculateMean(data: number[]): number {
    if (data.length === 0) return 0;
    return data.reduce((sum, val) => sum + val, 0) / data.length;
  }
}
```
