---
title: "CRM Integration Roadmap"
timeline: "Q1 2026"
status: "planned"
priority: "high"
completion: "0%"
dependencies: ["campaign-management", "enhanced-analytics"]
blocks: []
---


# CRM Integration Roadmap


## Overview

Bi-directional integration with major CRM platforms (Salesforce, HubSpot, Pipedrive) enabling automatic contact sync, campaign activity tracking, and lead scoring updates.

**Business Value**: Eliminates manual data entry, provides complete customer journey visibility, improves sales-marketing alignment by 50%.


## Timeline


- **Target Quarter**: Q1 2026


- **Start Date**: 2026-02-15


- **Target Completion**: 2026-03-31


- **Current Status**: Planned


- **Next Milestone**: CRM API research and partnership


## Dependencies


### Required Before Starting


- ⏳ **[Campaign Management](./campaign-management.md)** - Need campaign data to sync (Q1 2026)


- ⏳ **[Enhanced Analytics](./enhanced-analytics.md)** - Engagement data for lead scoring (Q1 2026)


- ⏳ Webhook infrastructure - Planned


- ⏳ OAuth 2.0 implementation - Planned


### Blocks (Features Waiting on This)


- None (integration feature, not blocking)


## Milestones


- [ ] **M1: Research & Partnership** (Weeks 1-2)


  - [ ] Salesforce API research and partnership application


  - [ ] HubSpot API research and app creation


  - [ ] Pipedrive API research


  - [ ] OAuth 2.0 flow design


  - [ ] Data mapping strategy
  

- [ ] **M2: Salesforce Integration** (Weeks 3-5)


  - [ ] OAuth authentication


  - [ ] Contact sync (bi-directional)


  - [ ] Campaign activity logging


  - [ ] Lead scoring updates


  - [ ] Custom field mapping
  

- [ ] **M3: HubSpot Integration** (Weeks 6-8)


  - [ ] OAuth authentication


  - [ ] Contact/company sync


  - [ ] Email activity tracking


  - [ ] Workflow integration


  - [ ] Custom property mapping
  

- [ ] **M4: Additional CRMs & Testing** (Weeks 9-10)


  - [ ] Pipedrive integration (if time permits)


  - [ ] Integration testing with real CRM data


  - [ ] Sync reliability testing


  - [ ] User acceptance testing


  - [ ] Documentation and setup guides


## Related Documentation


### Feature Specification


- **[CRM Integration Feature](../../features/crm-integration.md)** - Requirements (to be created)


### Technical Specifications


- **[Frontend: CRM Settings](../../design/routes/dashboard-settings-integrations.md)** - UI specification


- **[API: CRM Sync Endpoints](../../implementation-technical/api/platform-api/integrations.md)** - Backend API


- **[OAuth Flow](../../technical/architecture/oauth-implementation.md)** - Authentication architecture


### User Workflows


- **[Marketing Journey](../../user-journeys/marketing-journey.md)** - CRM sync in campaign workflow


### Implementation Tasks


- **[CRM Integration Epic](../../../tasks/crm-integration/)** - Development tasks


## Technical Details


### Supported CRMs (Q1 2026)


#### 1. **Salesforce** (Priority 1)


##### OAuth Authentication Flow


```yaml
salesforce_oauth:
  authorization_endpoint: https://login.salesforce.com/services/oauth2/authorize
  token_endpoint: https://login.salesforce.com/services/oauth2/token
  scopes:


    - api  # Access to Salesforce APIs


    - refresh_token  # Offline access


    - full  # Full access to data
  
  flow:


    1. User clicks "Connect Salesforce"


    2. Redirect to Salesforce login


    3. User authorizes PenguinMails app


    4. Receive authorization code


    5. Exchange for access + refresh tokens


    6. Store encrypted tokens in database


```


##### Salesforce Object Mapping

**Contacts:**


```yaml
salesforce_contact:
  standard_fields:
    Email → email
    FirstName → first_name
    LastName → last_name
    Company → company
    Phone → phone
    Title → job_title
    MailingCity → city
    MailingState → state
    MailingCountry → country
    LeadSource → lead_source
    
  custom_fields:
    PenguinMails_Lead_Score__c → lead_score
    PenguinMails_Last_Email_Opened__c → last_email_opened
    PenguinMails_Total_Opens__c → total_opens
    PenguinMails_Total_Clicks__c → total_clicks
    PenguinMails_Unsubscribed__c → unsubscribed


```

**Leads:**


```yaml
salesforce_lead:
  standard_fields:
    Email → email
    FirstName → first_name
    LastName → last_name
    Company → company
    Phone → phone
    Title → job_title
    City → city
    State → state
    Country → country
    Status → lead_status
    Rating → lead_rating
    
  custom_fields:
    PenguinMails_Engagement_Score__c → engagement_score
    PenguinMails_Last_Campaign__c → last_campaign_id


```

**Activities (Tasks):**


```yaml
salesforce_task:
  fields:
    Subject: "Email: {campaign_name}"
    Description: "Email {action} by {contact_name}"
    WhoId: contact_id
    ActivityDate: event_timestamp
    Status: "Completed"
    Type: "Email"
    
  activity_types:


    - Email Sent


    - Email Opened


    - Email Clicked


    - Email Replied


    - Email Bounced


```


##### Salesforce Sync Rules


```yaml
sync_rules:
  contact_sync:
    direction: bidirectional
    frequency: real_time  # via webhooks
    fallback: hourly_batch
    
    penguinmails_to_salesforce:


      - on: email_sent
        action: create_task
        


      - on: email_opened
        action: update_custom_field
        field: PenguinMails_Last_Email_Opened__c
        


      - on: email_clicked
        action: increment_field
        field: PenguinMails_Total_Clicks__c
        


      - on: unsubscribed
        action: update_field
        field: PenguinMails_Unsubscribed__c
        value: true
        
    salesforce_to_penguinmails:


      - on: contact_created
        action: import_contact
        add_to_segment: "Salesforce Contacts"
        


      - on: contact_updated
        action: update_contact
        conflict_resolution: salesforce_wins
        


      - on: contact_deleted
        action: soft_delete_contact


```


##### Salesforce API Endpoints


```typescript
// Salesforce REST API Integration
class SalesforceService {
  async syncContact(contactId: string): Promise<void> {
    const contact = await db.contacts.findById(contactId);
    
    // Check if contact exists in Salesforce
    const sfContact = await this.findSalesforceContact(contact.email);
    
    if (sfContact) {
      // Update existing
      await this.updateSalesforceContact(sfContact.Id, {
        PenguinMails_Lead_Score__c: contact.leadScore,
        PenguinMails_Last_Email_Opened__c: contact.lastEmailOpened,
        PenguinMails_Total_Opens__c: contact.totalOpens,
        PenguinMails_Total_Clicks__c: contact.totalClicks,
      });
    } else {
      // Create new
      await this.createSalesforceContact({
        Email: contact.email,
        FirstName: contact.firstName,
        LastName: contact.lastName,
        Company: contact.company,
        PenguinMails_Lead_Score__c: contact.leadScore,
      });
    }
  }
  
  async logEmailActivity(
    contactId: string,
    activityType: string,
    campaignName: string
  ): Promise<void> {
    const sfContact = await this.findSalesforceContact(contactId);
    
    await this.createTask({
      WhoId: sfContact.Id,
      Subject: `Email: ${campaignName}`,
      Description: `Email ${activityType}`,
      ActivityDate: new Date().toISOString(),
      Status: 'Completed',
      Type: 'Email',
    });
  }
}


```


#### 2. **HubSpot** (Priority 2)


##### OAuth Authentication Flow


```yaml
hubspot_oauth:
  authorization_endpoint: https://app.hubspot.com/oauth/authorize
  token_endpoint: https://api.hubapi.com/oauth/v1/token
  scopes:


    - contacts  # Read/write contacts


    - timeline  # Create timeline events


    - automation  # Trigger workflows
    
  flow:


    1. User clicks "Connect HubSpot"


    2. Redirect to HubSpot OAuth


    3. User selects HubSpot account


    4. Receive authorization code


    5. Exchange for access + refresh tokens


    6. Store encrypted tokens


```


##### HubSpot Object Mapping

**Contacts:**


```yaml
hubspot_contact:
  standard_properties:
    email → email
    firstname → first_name
    lastname → last_name
    company → company
    phone → phone
    jobtitle → job_title
    city → city
    state → state
    country → country
    
  custom_properties:
    penguinmails_lead_score → lead_score
    penguinmails_last_email_opened → last_email_opened
    penguinmails_total_opens → total_opens
    penguinmails_total_clicks → total_clicks
    penguinmails_unsubscribed → unsubscribed
    penguinmails_last_campaign → last_campaign_id


```

**Companies:**


```yaml
hubspot_company:
  properties:
    name → company_name
    domain → company_domain
    industry → industry
    numberofemployees → company_size
    annualrevenue → annual_revenue


```

**Timeline Events:**


```yaml
hubspot_timeline_event:
  event_types:


    - email_sent


    - email_opened


    - email_clicked


    - email_replied


    - email_bounced
    
  event_template:
    eventTypeId: "penguinmails_email_activity"
    email: contact_email
    timestamp: event_timestamp
    extraData:
      campaign_name: campaign_name
      subject_line: subject
      action: action_type


```


##### HubSpot Sync Rules


```yaml
sync_rules:
  contact_sync:
    direction: bidirectional
    frequency: real_time
    
    penguinmails_to_hubspot:


      - on: email_sent
        action: create_timeline_event
        event_type: email_sent
        


      - on: email_opened
        action: update_property
        property: penguinmails_last_email_opened
        


      - on: email_clicked
        action: create_timeline_event
        event_type: email_clicked
        trigger_workflow: true  # Optional
        


      - on: high_engagement
        condition: lead_score >= 75
        action: trigger_workflow
        workflow_id: "sales_qualified_lead"
        
    hubspot_to_penguinmails:


      - on: contact_created
        action: import_contact
        


      - on: contact_updated
        action: update_contact
        


      - on: list_membership_changed
        action: update_segments


```


##### HubSpot API Integration


```typescript
class HubSpotService {
  async syncContact(contactId: string): Promise<void> {
    const contact = await db.contacts.findById(contactId);
    
    // Find or create HubSpot contact
    const hsContact = await this.findHubSpotContact(contact.email);
    
    const properties = {
      email: contact.email,
      firstname: contact.firstName,
      lastname: contact.lastName,
      company: contact.company,
      penguinmails_lead_score: contact.leadScore,
      penguinmails_total_opens: contact.totalOpens,
      penguinmails_total_clicks: contact.totalClicks,
    };
    
    if (hsContact) {
      await this.updateHubSpotContact(hsContact.vid, properties);
    } else {
      await this.createHubSpotContact(properties);
    }
  }
  
  async createTimelineEvent(
    email: string,
    eventType: string,
    campaignName: string
  ): Promise<void> {
    await this.hubspotClient.timeline.create({
      eventTypeId: `penguinmails_${eventType}`,
      email,
      timestamp: Date.now(),
      extraData: {
        campaign_name: campaignName,
        action: eventType,
      },
    });
  }
  
  async triggerWorkflow(
    contactId: string,
    workflowId: string
  ): Promise<void> {
    const hsContact = await this.findHubSpotContact(contactId);
    
    await this.hubspotClient.workflows.enroll(workflowId, {
      contactVid: hsContact.vid,
    });
  }
}


```


### Field Mapping & Sync Rules


#### Field Mapping Configuration


```yaml
field_mapping:
  mapping_types:


    - direct  # 1:1 field mapping


    - formula  # Calculated fields


    - conditional  # Based on conditions


    - aggregation  # Sum, count, etc.
    
  examples:
    direct_mapping:
      crm_field: Email
      penguinmails_field: email
      direction: bidirectional
      
    formula_mapping:
      crm_field: Full_Name__c
      formula: "{{first_name}} {{last_name}}"
      direction: to_crm
      
    conditional_mapping:
      crm_field: Lead_Status__c
      condition: "lead_score >= 75"
      value_if_true: "Hot"
      value_if_false: "Warm"
      direction: to_crm
      
    aggregation_mapping:
      crm_field: Total_Email_Engagement__c
      formula: "SUM(opens + clicks)"
      direction: to_crm


```


#### Bi-Directional Sync Logic


```typescript
interface SyncRule {
  direction: 'to_crm' | 'from_crm' | 'bidirectional';
  frequency: 'real_time' | 'hourly' | 'daily';
  conflictResolution: 'crm_wins' | 'penguinmails_wins' | 'newest_wins' | 'manual';
  filters?: any;
}

class CRMSyncService {
  async syncBidirectional(
    integration: Integration,
    syncRule: SyncRule
  ): Promise<void> {
    // Sync from CRM to PenguinMails
    if (syncRule.direction === 'from_crm' || syncRule.direction === 'bidirectional') {
      await this.syncFromCRM(integration);
    }
    
    // Sync from PenguinMails to CRM
    if (syncRule.direction === 'to_crm' || syncRule.direction === 'bidirectional') {
      await this.syncToCRM(integration);
    }
  }
  
  private async syncFromCRM(integration: Integration): Promise<void> {
    const lastSyncTime = integration.lastSyncAt;
    
    // Get updated contacts from CRM
    const updatedContacts = await this.getCRMUpdates(
      integration,
      lastSyncTime
    );
    
    for (const crmContact of updatedContacts) {
      const localContact = await db.contacts.findByEmail(crmContact.email);
      
      if (localContact) {
        // Handle conflict
        await this.handleConflict(
          localContact,
          crmContact,
          integration.conflictResolution
        );
      } else {
        // Create new contact
        await db.contacts.create({
          ...this.mapCRMFields(crmContact, integration.fieldMapping),
          source: 'crm_sync',
          crmId: crmContact.id,
        });
      }
    }
  }
  
  private async syncToCRM(integration: Integration): Promise<void> {
    const lastSyncTime = integration.lastSyncAt;
    
    // Get updated contacts from PenguinMails
    const updatedContacts = await db.contacts.findAll({
      where: {
        updatedAt: { [Op.gt]: lastSyncTime },
        tenantId: integration.tenantId,
      },
    });
    
    for (const contact of updatedContacts) {
      if (contact.crmId) {
        // Update existing CRM contact
        await this.updateCRMContact(
          integration,
          contact.crmId,
          this.mapLocalFields(contact, integration.fieldMapping)
        );
      } else {
        // Create new CRM contact
        const crmId = await this.createCRMContact(
          integration,
          this.mapLocalFields(contact, integration.fieldMapping)
        );
        
        await db.contacts.update(contact.id, { crmId });
      }
    }
  }
}


```


#### Conflict Resolution


```yaml
conflict_resolution_strategies:
  crm_wins:
    description: "CRM data always overwrites PenguinMails data"
    use_case: "CRM is source of truth for contact info"
    
  penguinmails_wins:
    description: "PenguinMails data always overwrites CRM data"
    use_case: "PenguinMails is source of truth for engagement"
    
  newest_wins:
    description: "Most recently updated record wins"
    use_case: "Balanced approach, respects latest changes"
    
  manual:
    description: "Flag conflicts for manual resolution"
    use_case: "High-value data requiring human review"
    
  field_level:
    description: "Different strategies per field"
    example:
      email: crm_wins
      lead_score: penguinmails_wins
      company: newest_wins
      custom_fields: manual


```


```typescript
class ConflictResolver {
  async handleConflict(
    localContact: Contact,
    crmContact: any,
    strategy: string
  ): Promise<void> {
    switch (strategy) {
      case 'crm_wins':
        await this.applyCRMData(localContact, crmContact);
        break;
        
      case 'penguinmails_wins':
        await this.applyCRMData(crmContact, localContact);
        break;
        
      case 'newest_wins':
        if (crmContact.updatedAt > localContact.updatedAt) {
          await this.applyCRMData(localContact, crmContact);
        } else {
          await this.applyCRMData(crmContact, localContact);
        }
        break;
        
      case 'manual':
        await this.flagForManualReview(localContact, crmContact);
        break;
        
      case 'field_level':
        await this.applyFieldLevelResolution(localContact, crmContact);
        break;
    }
  }
  
  private async applyFieldLevelResolution(
    localContact: Contact,
    crmContact: any
  ): Promise<void> {
    const fieldRules = {
      email: 'crm_wins',
      firstName: 'crm_wins',
      lastName: 'crm_wins',
      company: 'newest_wins',
      leadScore: 'penguinmails_wins',
      totalOpens: 'penguinmails_wins',
      totalClicks: 'penguinmails_wins',
    };
    
    const updates: any = {};
    
    for (const [field, strategy] of Object.entries(fieldRules)) {
      if (strategy === 'crm_wins') {
        updates[field] = crmContact[field];
      } else if (strategy === 'newest_wins') {
        updates[field] = crmContact.updatedAt > localContact.updatedAt
          ? crmContact[field]
          : localContact[field];
      }
      // penguinmails_wins: keep local value (no update)
    }
    
    await db.contacts.update(localContact.id, updates);
  }
}


```


### Components


- **Backend**: Node.js integration microservice


- **OAuth**: Passport.js with OAuth 2.0 strategies


- **Database**: PostgreSQL for integration credentials and mappings


- **Queue**: Background job processing for batch syncs


- **Webhooks**: Real-time event processing from CRMs


- **Encryption**: AES-256 for credential storage


### Security


- OAuth 2.0 for secure authentication


- Encrypted credential storage (AES-256)


- Scoped API permissions (minimal access)


- Audit logging for all sync operations


- GDPR compliance for data handling


- Token rotation every 30 days


- Webhook signature verification


## Risks & Mitigation

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| CRM API rate limits | High | High | Implement intelligent batching, retry logic |
| OAuth authentication complexity | Medium | Medium | Use battle-tested libraries (Passport.js) |
| Data sync conflicts | Medium | Medium | Implement conflict resolution rules |
| CRM partnership delays | Medium | Low | Start with API keys for HubSpot/Pipedrive |
| Data privacy compliance | High | Low | Legal review, GDPR compliance built-in |


## Success Criteria


- [ ] Salesforce integration working with 95% sync reliability


- [ ] HubSpot integration working with 95% sync reliability


- [ ] Real-time activity sync latency < 5 minutes


- [ ] Batch sync completes within 1 hour for 10K contacts


- [ ] Zero data loss during sync


- [ ] 80% user satisfaction with integration features


## Integration Setup Flow


### User Experience


1. **Connect**: Click "Connect Salesforce" in settings


2. **Authenticate**: OAuth login to CRM


3. **Configure**: Select objects to sync (Contacts, Leads, etc.)


4. **Map Fields**: Map custom fields between systems


5. **Activate**: Enable bi-directional sync


6. **Monitor**: View sync status and activity logs


### Admin Controls


- Enable/disable specific CRMs


- Configure sync frequency


- Map custom fields


- View sync logs and errors


- Disconnect and reconnect integrations


## Feature Breakdown


### MVP (Q1 2026)


- ✓ Salesforce integration (contacts, leads, activities)


- ✓ HubSpot integration (contacts, companies, activities)


- ✓ Bi-directional contact sync


- ✓ Email activity logging


- ✓ Basic field mapping


- ✓ OAuth authentication


### Level 3 (Q2-Q3 2026)


- Advanced field mapping (formulas)


- Workflow triggers


- Custom object sync


- Additional CRMs (Zoho, Close.io)


- Bulk data import/export


### Enterprise (Q4 2026+)


- Real-time sync (< 1 minute)


- Advanced conflict resolution


- Custom integration builder


- Multi-CRM support per tenant


- Advanced audit logging


## Metrics to Track


- Sync success rate (target: 95%)


- Sync latency (real-time events)


- Batch sync duration


- OAuth authentication success rate


- Integration usage adoption


- User satisfaction score

---

**Last Updated**: 2025-11-24  
**Owner**: Integrations Engineering Team  
**Status**: Planned - Q1 2026 key partnership feature
