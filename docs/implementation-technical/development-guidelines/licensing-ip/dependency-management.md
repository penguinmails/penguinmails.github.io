---
title: "Dependency Management"
description: "Dependency licensing and management"
last_modified_date: "2025-12-04"
level: "3"
keywords: "dependencies, licensing, npm, packages"
---

# Dependency Management

## Dependency Management

### License Compatibility Matrix

```typescript
// legal/license-compatibility.ts
interface Dependency {
  name: string;
  version: string;
  license: string;
  copyrightYear: string;
  copyrightHolder: string;
  repositoryUrl: string;
}

interface CompatibilityResult {
  compatible: boolean | null;
  message: string;
  riskLevel: 'LOW' | 'MEDIUM' | 'HIGH';
}

interface AttributionNotice {
  text: string;
  required: boolean;
}

interface LicenseCompatibility {
  checkCompatibility(projectLicense: string, dependencyLicense: string): CompatibilityResult;
  generateAttributionNotice(dependencies: Dependency[]): AttributionNotice[];
  getLicenseRiskLevel(license: string): 'LOW' | 'MEDIUM' | 'HIGH';
}

class LicenseCompatibilityImpl implements LicenseCompatibility {
  private readonly COMPATIBLE_LICENSES: Record<string, string[]> = {
    'mit': ['mit', 'bsd', 'apache-2.0', 'isc', 'unlicense'],
    'apache-2.0': ['apache-2.0', 'mit', 'bsd', 'isc'],
    'bsd': ['bsd', 'mit', 'apache-2.0', 'isc'],
    'gpl-3.0': ['gpl-3.0', 'agpl-3.0'],
    'lgpl-3.0': ['lgpl-3.0', 'gpl-3.0', 'apache-2.0', 'mit']
  };

  private readonly INCOMPATIBLE_LICENSES: Record<string, string[]> = {
    'gpl-3.0': ['mit', 'apache-2.0', 'bsd', 'proprietary'],
    'agpl-3.0': ['mit', 'apache-2.0', 'bsd', 'proprietary'],
    'proprietary': ['gpl-3.0', 'agpl-3.0', 'copyleft']
  };

  checkCompatibility(projectLicense: string, dependencyLicense: string): CompatibilityResult {
    const compatibleLicenses = this.COMPATIBLE_LICENSES[projectLicense.toLowerCase()] || [];
    const incompatibleLicenses = this.INCOMPATIBLE_LICENSES[projectLicense.toLowerCase()] || [];

    if (compatibleLicenses.includes(dependencyLicense.toLowerCase())) {
      return {
        compatible: true,
        message: `Compatible: ${dependencyLicense} works with ${projectLicense}`,
        riskLevel: 'LOW'
      };
    } else if (incompatibleLicenses.includes(dependencyLicense.toLowerCase())) {
      return {
        compatible: false,
        message: `Incompatible: ${dependencyLicense} conflicts with ${projectLicense}`,
        riskLevel: 'HIGH'
      };
    } else {
      return {
        compatible: null,
        message: `Unknown compatibility: ${dependencyLicense} with ${projectLicense}`,
        riskLevel: 'MEDIUM'
      };
    }
  }

  generateAttributionNotice(dependencies: Dependency[]): AttributionNotice[] {
    const notices: AttributionNotice[] = [];

    dependencies.forEach(dep => {
      if (!['unlicense', 'public_domain'].includes(dep.license.toLowerCase())) {
        const notice: AttributionNotice = {
          text: `${dep.name} v${dep.version}
Copyright (c) ${dep.copyrightYear} ${dep.copyrightHolder}
License: ${dep.license}
Source: ${dep.repositoryUrl}`,
          required: true
        };
        notices.push(notice);
      }
    });

    return notices;
  }

  getLicenseRiskLevel(license: string): 'LOW' | 'MEDIUM' | 'HIGH' {
    const lowRiskLicenses = ['mit', 'apache-2.0', 'bsd', 'isc', 'unlicense'];
    const highRiskLicenses = ['gpl-3.0', 'agpl-3.0', 'copyleft'];

    const lowerLicense = license.toLowerCase();

    if (lowRiskLicenses.includes(lowerLicense)) {
      return 'LOW';
    } else if (highRiskLicenses.includes(lowerLicense)) {
      return 'HIGH';
    } else {
      return 'MEDIUM';
    }
  }
}

// Usage example
async function validateDependencies(dependencies: Dependency[]): Promise<void> {
  const licenseCompat = new LicenseCompatibilityImpl();
  const projectLicense = 'mit';

  for (const dep of dependencies) {
    const result = licenseCompat.checkCompatibility(projectLicense, dep.license);

    if (!result.compatible) {
      console.warn(`License warning for ${dep.name}: ${result.message}`);
    }

    if (result.riskLevel === 'HIGH') {
      throw new Error(`High-risk license detected: ${dep.name} (${dep.license})`);
    }
  }
}

```

### Third-Party Integration Guidelines

```markdown

# Third-Party Integration License Compliance

