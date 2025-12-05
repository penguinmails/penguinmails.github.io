---
title: "Performance Bug Detection"
description: "Memory leaks and performance optimization strategies"
last_modified_date: "2025-12-04"
level: "3"
persona: "Quality Assurance"
keywords: "performance debugging, memory leaks, optimization, profiling"
---

# Performance Bug Detection

## Performance Bug Detection

### Memory Leaks

```typescript
// utils/memory-profiler.ts
import * as process from 'process';
import * as v8 from 'v8';

interface MemorySnapshot {
  heapUsed: number;
  heapTotal: number;
  external: number;
  arrayBuffers: number;
}

interface MemoryAnalysis {
  functionName: string;
  memoryBefore: number;
  memoryAfter: number;
  memoryDiff: number;
  timestamp: Date;
  warning?: string;
}

interface MemoryProfiler {
  profileFunction<T>(func: (...args: unknown[]) => T, ...args: unknown[]): T;
  profileAsyncFunction<T>(func: (...args: unknown[]) => Promise<T>, ...args: unknown[]): Promise<T>;
  getMemorySnapshot(): MemorySnapshot;
  getHeapStatistics(): v8.HeapInfo;
}

class MemoryProfilerImpl implements MemoryProfiler {
  private readonly WARNING_THRESHOLD = 50; // MB
  private readonly CRITICAL_THRESHOLD = 100; // MB
  private analyses: MemoryAnalysis[] = [];

  profileFunction<T>(func: (...args: unknown[]) => T, ...args: unknown[]): T {
    const memoryBefore = this.getMemoryUsage();
    const functionName = func.name || 'anonymous';

    try {
      const result = func(...args);

      const memoryAfter = this.getMemoryUsage();
      const memoryDiff = memoryAfter.heapUsed - memoryBefore.heapUsed;

      this.recordAnalysis({
        functionName,
        memoryBefore: memoryBefore.heapUsed,
        memoryAfter: memoryAfter.heapUsed,
        memoryDiff,
        timestamp: new Date(),
        warning: this.getMemoryWarning(memoryDiff)
      });

      return result;
    } catch (error) {
      this.recordAnalysis({
        functionName,
        memoryBefore: memoryBefore.heapUsed,
        memoryAfter: this.getMemoryUsage().heapUsed,
        memoryDiff: 0,
        timestamp: new Date(),
        warning: `Function failed with error: ${error}`
      });
      throw error;
    }
  }

  async profileAsyncFunction<T>(func: (...args: unknown[]) => Promise<T>, ...args: unknown[]): Promise<T> {
    const memoryBefore = this.getMemoryUsage();
    const functionName = func.name || 'anonymous';

    try {
      const result = await func(...args);

      const memoryAfter = this.getMemoryUsage();
      const memoryDiff = memoryAfter.heapUsed - memoryBefore.heapUsed;

      this.recordAnalysis({
        functionName,
        memoryBefore: memoryBefore.heapUsed,
        memoryAfter: memoryAfter.heapUsed,
        memoryDiff,
        timestamp: new Date(),
        warning: this.getMemoryWarning(memoryDiff)
      });

      return result;
    } catch (error) {
      this.recordAnalysis({
        functionName,
        memoryBefore: memoryBefore.heapUsed,
        memoryAfter: this.getMemoryUsage().heapUsed,
        memoryDiff: 0,
        timestamp: new Date(),
        warning: `Async function failed with error: ${error}`
      });
      throw error;
    }
  }

  getMemorySnapshot(): MemorySnapshot {
    const usage = process.memoryUsage();
    return {
      heapUsed: usage.heapUsed / (1024 * 1024), // Convert to MB
      heapTotal: usage.heapTotal / (1024 * 1024),
      external: usage.external / (1024 * 1024),
      arrayBuffers: usage.arrayBuffers / (1024 * 1024)
    };
  }

  getHeapStatistics(): v8.HeapInfo {
    return v8.getHeapStatistics();
  }

  getAnalyses(): MemoryAnalysis[] {
    return [...this.analyses];
  }

  clearAnalyses(): void {
    this.analyses = [];
  }

  private getMemoryUsage(): MemorySnapshot {
    return this.getMemorySnapshot();
  }

  private getMemoryWarning(memoryDiff: number): string | undefined {
    const diffMB = memoryDiff / (1024 * 1024); // Convert to MB

    if (diffMB >= this.CRITICAL_THRESHOLD) {
      return `Critical memory usage increase: ${diffMB.toFixed(2)}MB`;
    } else if (diffMB >= this.WARNING_THRESHOLD) {
      return `High memory usage increase: ${diffMB.toFixed(2)}MB`;
    }

    return undefined;
  }

  private recordAnalysis(analysis: MemoryAnalysis): void {
    this.analyses.push(analysis);

    if (analysis.warning) {
      console.warn(`[Memory Profiler] ${analysis.warning} in ${analysis.functionName}`);
    }
  }
}

// Decorator function
function monitorMemoryUsage(target: unknown, propertyKey: string, descriptor: PropertyDescriptor): PropertyDescriptor {
  const originalMethod = descriptor.value;
  const profiler = new MemoryProfilerImpl();

  if (typeof originalMethod === 'function') {
    descriptor.value = function (...args: unknown[]) {
      return profiler.profileFunction(originalMethod, ...args);
    };
  }

  return descriptor;
}

// Higher-order function for monitoring
function createMemoryMonitor(threshold: number = 50) {
  return function <T extends (...args: unknown[]) => unknown>(func: T): T {
    const profiler = new MemoryProfilerImpl();
    return ((...args: unknown[]) => {
      return profiler.profileFunction(func, ...args);
    }) as T;
  };
}

// Usage examples
class CampaignProcessor {
  @monitorMemoryUsage
  processLargeCampaign(campaignData: unknown[]): void {
    // Process large amounts of data
    for (const item of campaignData) {
      // Simulate processing
      const processed = JSON.stringify(item);
      console.log(`Processing item: ${processed.substring(0, 50)}...`);
    }
  }

  @createMemoryMonitor(25) // Lower threshold for testing
  async processEmailBatch(recipients: EmailRecipient[]): Promise<void> {
    // Simulate processing emails in batch
    const chunks = this.chunkArray(recipients, 100);

    for (const chunk of chunks) {
      // Process chunk
      await this.processChunk(chunk);

      // Force garbage collection if available
      if (global.gc) {
        global.gc();
      }
    }
  }

  private chunkArray<T>(array: T[], size: number): T[][] {
    const chunks: T[][] = [];
    for (let i = 0; i < array.length; i += size) {
      chunks.push(array.slice(i, i + size));
    }
    return chunks;
  }

  private async processChunk(chunk: EmailRecipient[]): Promise<void> {
    // Mock processing
    console.log(`Processing chunk of ${chunk.length} recipients`);
    await new Promise(resolve => setTimeout(resolve, 10));
  }
}

// Memory leak detection utility
class MemoryLeakDetector {
  private profiler = new MemoryProfilerImpl();
  private baselineMemory: number | null = null;

  initializeBaseline(): void {
    // Force garbage collection if available
    if (global.gc) {
      global.gc();
    }

    this.baselineMemory = this.profiler.getMemorySnapshot().heapUsed;
    console.log(`Memory baseline established: ${(this.baselineMemory / (1024 * 1024)).toFixed(2)}MB`);
  }

  checkForLeaks(): void {
    if (!this.baselineMemory) {
      throw new Error('Baseline not established. Call initializeBaseline() first.');
    }

    const currentMemory = this.profiler.getMemorySnapshot().heapUsed;
    const memoryDiff = currentMemory - this.baselineMemory;

    console.log(`Current memory: ${(currentMemory / (1024 * 1024)).toFixed(2)}MB`);
    console.log(`Memory change: ${(memoryDiff / (1024 * 1024)).toFixed(2)}MB`);

    if (memoryDiff > 10 * 1024 * 1024) { // 10MB increase
      console.warn(`Potential memory leak detected: ${(memoryDiff / (1024 * 1024)).toFixed(2)}MB increase`);
    }
  }
}

// Supporting interface
interface EmailRecipient {
  email: string;
  name?: string;
}

// Usage example
async function demonstrateMemoryMonitoring() {
  const processor = new CampaignProcessor();
  const detector = new MemoryLeakDetector();

  detector.initializeBaseline();

  // Test large campaign processing
  const largeCampaign = Array.from({ length: 10000 }, (_, i) => ({
    id: i,
    subject: `Email ${i}`,
    content: `Content for email ${i}`
  }));

  processor.processLargeCampaign(largeCampaign);
  detector.checkForLeaks();

  // Test async processing
  const recipients = Array.from({ length: 1000 }, (_, i) => ({
    email: `user${i}@example.com`,
    name: `User ${i}`
  }));

  await processor.processEmailBatch(recipients);
  detector.checkForLeaks();

  // Print analysis summary
  const analyses = processor.profiler.getAnalyses();
  console.log('\nMemory Analysis Summary:');
  analyses.forEach(analysis => {
    console.log(`Function: ${analysis.functionName}`);
    console.log(`Memory change: ${(analysis.memoryDiff / (1024 * 1024)).toFixed(2)}MB`);
    if (analysis.warning) {
      console.log(`Warning: ${analysis.warning}`);
    }
  });
}

```

### Database Performance

```sql
-- Identify slow queries
SELECT query, mean_time, calls, total_time
FROM pg_stat_statements
WHERE mean_time > 100  -- Queries taking more than 100ms on average
ORDER BY mean_time DESC
LIMIT 10;

-- Check for missing indexes
SELECT schemaname, tablename, attname, n_distinct, correlation
FROM pg_stats
WHERE tablename IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public')
  AND n_distinct > 100  -- Columns with high cardinality
  AND attname NOT IN (
    SELECT indexname FROM pg_indexes
    WHERE indexname LIKE '%' || attname || '%'
  );

```
