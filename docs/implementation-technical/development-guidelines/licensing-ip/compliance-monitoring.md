---
title: "Compliance Monitoring"
description: "IP compliance monitoring and auditing"
last_modified_date: "2025-12-04"
level: "3"
keywords: "compliance, monitoring, auditing"
---

# Compliance Monitoring

## Compliance Monitoring

### Automated License Scanning

```typescript
// legal/compliance-scanner.ts
import { exec } from 'child_process';
import { promisify } from 'util';
import * as fs from 'fs/promises';
import * as path from 'path';

interface ScanResult {
  dependencies?: DependencyScanResult;
  sourceCode?: SourceCodeScanResult;
  documentation?: DocumentationScanResult;
  thirdPartyCode?: ThirdPartyCodeScanResult;
  error?: string;
}

interface DependencyScanResult {
  packages: Array<{
    name: string;
    version: string;
    license: string;
    status: 'COMPLIANT' | 'VIOLATION' | 'UNKNOWN';
  }>;
  summary: {
    total: number;
    compliant: number;
    violations: number;
    unknown: number;
  };
}

interface SourceCodeScanResult {
  filesScanned: number;
  attributionIssues: Array<{
    file: string;
    issue: string;
    severity: 'LOW' | 'MEDIUM' | 'HIGH';
  }>;
}

interface DocumentationScanResult {
  filesScanned: number;
  attributionIssues: Array<{
    file: string;
    issue: string;
    severity: 'LOW' | 'MEDIUM' | 'HIGH';
  }>;
}

interface ThirdPartyCodeScanResult {
  filesScanned: number;
  violations: Array<{
    file: string;
    license: string;
    issue: string;
    severity: 'LOW' | 'MEDIUM' | 'HIGH';
  }>;
}

interface ComplianceReport {
  scanDate: string;
  projectPath: string;
  totalFilesScanned: number;
  licenseSummary: LicenseSummary;
  complianceIssues: ComplianceIssue[];
  recommendations: string[];
  nextReviewDate: string;
}

interface LicenseSummary {
  totalDependencies: number;
  compliant: number;
  violations: number;
  unknown: number;
  riskLevel: 'LOW' | 'MEDIUM' | 'HIGH';
}

interface ComplianceIssue {
  type: 'LICENSE' | 'ATTRIBUTION' | 'MISSING_NOTICE' | 'INCOMPATIBLE';
  severity: 'LOW' | 'MEDIUM' | 'HIGH';
  description: string;
  affectedFiles: string[];
  recommendedAction: string;
}

interface ComplianceScanner {
  scanProjectCompliance(projectPath: string): Promise<ComplianceReport>;
  generateComplianceReport(scanResults: ScanResult): ComplianceReport;
}

class ComplianceScannerImpl implements ComplianceScanner {
  private licenseScanner: LicenseScanner;
  private reportGenerator: ComplianceReportGenerator;

  constructor() {
    this.licenseScanner = new LicenseScannerImpl();
    this.reportGenerator = new ComplianceReportGeneratorImpl();
  }

  async scanProjectCompliance(projectPath: string): Promise<ComplianceReport> {
    try {
      const scanResults: ScanResult = {
        dependencies: await this.scanDependencies(projectPath),
        sourceCode: await this.scanSourceCode(projectPath),
        documentation: await this.scanDocumentation(projectPath),
        thirdPartyCode: await this.scanThirdPartyCode(projectPath)
      };

      const complianceReport = this.reportGenerator.generate(scanResults);
      return complianceReport;
    } catch (error) {
      throw new Error(`Compliance scan failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  private async scanDependencies(projectPath: string): Promise<DependencyScanResult> {
    try {
      // Mock implementation - would run actual license scanning tools
      const mockResult: DependencyScanResult = {
        packages: [
          {
            name: 'express',
            version: '4.18.0',
            license: 'MIT',
            status: 'COMPLIANT'
          },
          {
            name: 'lodash',
            version: '4.17.21',
            license: 'MIT',
            status: 'COMPLIANT'
          }
        ],
        summary: {
          total: 2,
          compliant: 2,
          violations: 0,
          unknown: 0
        }
      };

      return mockResult;
    } catch (error) {
      return {
        packages: [],
        summary: { total: 0, compliant: 0, violations: 0, unknown: 0 }
      };
    }
  }

  private async scanSourceCode(projectPath: string): Promise<SourceCodeScanResult> {
    // Mock implementation
    return {
      filesScanned: 150,
      attributionIssues: []
    };
  }

  private async scanDocumentation(projectPath: string): Promise<DocumentationScanResult> {
    // Mock implementation
    return {
      filesScanned: 25,
      attributionIssues: []
    };
  }

  private async scanThirdPartyCode(projectPath: string): Promise<ThirdPartyCodeScanResult> {
    // Mock implementation
    return {
      filesScanned: 10,
      violations: []
    };
  }

  generateComplianceReport(scanResults: ScanResult): ComplianceReport {
    const totalFilesScanned =
      (scanResults.sourceCode?.filesScanned || 0) +
      (scanResults.documentation?.filesScanned || 0) +
      (scanResults.thirdPartyCode?.filesScanned || 0);

    const licenseSummary = this.summarizeLicenses(scanResults);
    const complianceIssues = this.identifyIssues(scanResults);
    const recommendations = this.generateRecommendations(scanResults);

    const nextReviewDate = new Date();
    nextReviewDate.setDate(nextReviewDate.getDate() + 90);

    return {
      scanDate: new Date().toISOString(),
      projectPath: '',
      totalFilesScanned,
      licenseSummary,
      complianceIssues,
      recommendations,
      nextReviewDate: nextReviewDate.toISOString()
    };
  }

  private summarizeLicenses(scanResults: ScanResult): LicenseSummary {
    const depResult = scanResults.dependencies;
    if (!depResult) {
      return {
        totalDependencies: 0,
        compliant: 0,
        violations: 0,
        unknown: 0,
        riskLevel: 'LOW'
      };
    }

    const riskLevel = depResult.summary.violations > 0 ? 'HIGH' :
                     depResult.summary.unknown > 0 ? 'MEDIUM' : 'LOW';

    return {
      totalDependencies: depResult.summary.total,
      compliant: depResult.summary.compliant,
      violations: depResult.summary.violations,
      unknown: depResult.summary.unknown,
      riskLevel
    };
  }

  private identifyIssues(scanResults: ScanResult): ComplianceIssue[] {
    const issues: ComplianceIssue[] = [];

    // Check dependencies
    if (scanResults.dependencies?.summary.violations > 0) {
      issues.push({
        type: 'LICENSE',
        severity: 'HIGH',
        description: 'License violations detected in dependencies',
        affectedFiles: ['package.json'],
        recommendedAction: 'Review and replace violating dependencies'
      });
    }

    // Check source code
    if (scanResults.sourceCode?.attributionIssues.length > 0) {
      issues.push({
        type: 'ATTRIBUTION',
        severity: 'MEDIUM',
        description: 'Missing or incorrect attribution in source code',
        affectedFiles: scanResults.sourceCode.attributionIssues.map(issue => issue.file),
        recommendedAction: 'Add proper attribution comments'
      });
    }

    return issues;
  }

  private generateRecommendations(scanResults: ScanResult): string[] {
    const recommendations: string[] = [];

    if (scanResults.dependencies?.summary.unknown > 0) {
      recommendations.push('Investigate unknown licenses and update package metadata');
    }

    if (scanResults.sourceCode?.attributionIssues.length > 0) {
      recommendations.push('Review source code for proper attribution requirements');
    }

    recommendations.push('Run compliance scan monthly to catch new issues');
    recommendations.push('Establish process for reviewing third-party integrations');

    return recommendations;
  }
}

// Supporting classes
class LicenseScanner {
  // Mock implementation
}

class ComplianceReportGenerator {
  generate(scanResults: ScanResult): ComplianceReport;
}

class ComplianceReportGeneratorImpl implements ComplianceReportGenerator {
  generate(scanResults: ScanResult): ComplianceReport {
    const scanner = new ComplianceScannerImpl();
    return scanner.generateComplianceReport(scanResults);
  }
}

// Usage example
async function runComplianceScan(projectPath: string): Promise<ComplianceReport> {
  const scanner = new ComplianceScannerImpl();
  return await scanner.scanProjectCompliance(projectPath);
}

```

### Annual Compliance Review

```markdown

