---
title: "Contributor License Agreement"
description: "CLA requirements and individual contributor agreement"
last_modified_date: "2025-12-04"
level: "3"
keywords: "CLA, contributor agreement, licensing"
---

# Contributor License Agreement

## Contributor License Agreement (CLA)

### Individual CLA

By contributing to PenguinMails, you agree that your contributions will be licensed under the MIT License and that you have the right to contribute this work.

#### Key Terms

```markdown

## Individual Contributor License Agreement

By making a contribution to this project, I certify that:

1. The contribution was created in whole or in part by me and I have the right to submit it under the MIT License.

2. I understand and agree that this project and the contribution are public and that a record of the contribution is maintained indefinitely.

3. I am granting the project a non-exclusive, royalty-free, irrevocable, perpetual license to use, reproduce, modify, and distribute the contribution.

**Contact Information:**

- Email: contributor@example.com

- Name: [Your Full Name]

- Address: [Your Address]

- Phone: [Your Phone Number]

**Signature:**
Signature: ________________________
Date: ________________________

```

### Corporate CLA

For corporate contributors, additional agreements may be required for large contributions or IP transfers.

#### Corporate Contribution Process

```typescript
// legal/corporate-contribution.ts
interface CorporateAgreement {
  companyName: string;
  contributionScope: string;
  agreementType: 'IP_TRANSFER' | 'CONTRIBUTOR_LICENSE' | 'DUAL_LICENSE';
  clauses: AgreementClause[];
}

interface AgreementClause {
  type: 'INTELLECTUAL_PROPERTY' | 'WARRANTY' | 'LIABILITY' | 'TERMINATION';
  content: string;
  mandatory: boolean;
}

interface ApprovalRequest {
  id: string;
  approvers: string[];
  agreement: CorporateAgreement;
  legalReviewRequired: boolean;
  status: 'PENDING' | 'APPROVED' | 'REJECTED';
  submittedAt: Date;
  reviewedAt?: Date;
}

interface CorporateContribution {
  initiateCorporateContribution(companyName: string, contributionScope: string): Promise<ApprovalRequest | null>;
  requiresCorporateAgreement(contributionScope: string): boolean;
  generateCorporateAgreement(companyName: string, contributionScope: string): CorporateAgreement;
}

class CorporateContributionImpl implements CorporateContribution {
  private agreementTemplates: Map<string, CorporateAgreement> = new Map();
  private approvalWorkflow: ApprovalWorkflow;

  constructor() {
    this.approvalWorkflow = new ApprovalWorkflowImpl();
  }

  async initiateCorporateContribution(companyName: string, contributionScope: string): Promise<ApprovalRequest | null> {
    // Determine if agreement is needed
    if (this.requiresCorporateAgreement(contributionScope)) {
      const agreement = this.generateCorporateAgreement(companyName, contributionScope);

      // Start approval workflow
      const approvalRequest = await this.approvalWorkflow.createRequest({
        approvers: this.getRequiredApprovers(companyName),
        agreement,
        legalReview: true
      });

      return approvalRequest;
    }

    return null;
  }

  requiresCorporateAgreement(contributionScope: string): boolean {
    const highValueIndicators = [
      'core_functionality',
      'proprietary_algorithms',
      'substantial_codebase_changes',
      'third_party_integrations'
    ];

    return highValueIndicators.some(indicator =>
      contributionScope.toLowerCase().includes(indicator)
    );
  }

  generateCorporateAgreement(companyName: string, contributionScope: string): CorporateAgreement {
    return {
      companyName,
      contributionScope,
      agreementType: 'CONTRIBUTOR_LICENSE',
      clauses: [
        {
          type: 'INTELLECTUAL_PROPERTY',
          content: `Company ${companyName} grants non-exclusive license for ${contributionScope}`,
          mandatory: true
        },
        {
          type: 'WARRANTY',
          content: 'Company warrants right to contribute specified code',
          mandatory: true
        },
        {
          type: 'LIABILITY',
          content: 'Company liability limitations as per standard contribution agreement',
          mandatory: false
        }
      ]
    };
  }

  private getRequiredApprovers(companyName: string): string[] {
    // Mock approver determination based on company size/type
    const corporateApprovers = ['legal-team@penguinmails.com'];

    if (companyName.includes('Inc') || companyName.includes('Corp')) {
      corporateApprovers.push('corporate-contributor@penguinmails.com');
    }

    return corporateApprovers;
  }
}

// Supporting classes
class ApprovalWorkflow {
  createRequest(options: {
    approvers: string[];
    agreement: CorporateAgreement;
    legalReview: boolean;
  }): Promise<ApprovalRequest>;
}

class ApprovalWorkflowImpl implements ApprovalWorkflow {
  async createRequest(options: {
    approvers: string[];
    agreement: CorporateAgreement;
    legalReview: boolean;
  }): Promise<ApprovalRequest> {
    return {
      id: `approval_${Date.now()}`,
      approvers: options.approvers,
      agreement: options.agreement,
      legalReviewRequired: options.legalReview,
      status: 'PENDING',
      submittedAt: new Date()
    };
  }
}

```

