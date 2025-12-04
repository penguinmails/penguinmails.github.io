---
title: "Library Best Practices"
description: "Best practices for template library"
last_modified_date: "2025-12-04"
level: "2"
keywords: "best practices, optimization, organization"
---

    rating: number,
    review?: string
  ): Promise<void> {
    // Create or update rating
    await db.templateRatings.upsert({
      libraryTemplateId,
      userId,
      rating,
      review,
    });

    // Recalculate average rating
    const ratings = await db.templateRatings.findAll({
      where: { libraryTemplateId },
    });

    const avgRating = ratings.reduce((sum, r) => sum + r.rating, 0) / ratings.length;

    await db.templateLibrary.update(libraryTemplateId, {
      rating: avgRating,
      ratingCount: ratings.length,
    });
  }

  async getTemplateAnalytics(
    libraryTemplateId: string
  ): Promise<any> {
    // Get all campaigns using this template
    const usage = await db.templateLibraryUsage.findAll({
      where: { libraryTemplateId },
      include: [{ model: db.templates, include: [{ model: db.campaigns }] }],
    });

    // Calculate aggregate metrics
    let totalSends = 0;
    let totalOpens = 0;
    let totalClicks = 0;
    let totalConversions = 0;

    for (const use of usage) {
      if (use.template && use.template.campaigns) {
        for (const campaign of use.template.campaigns) {
          totalSends += campaign.sentCount || 0;
          totalOpens += campaign.openCount || 0;
          totalClicks += campaign.clickCount || 0;
          totalConversions += campaign.conversionCount || 0;
        }
      }
    }

    return {
      usageCount: usage.length,
      totalSends,
      avgOpenRate: totalSends > 0 ? (totalOpens / totalSends) * 100 : 0,
      avgClickRate: totalSends > 0 ? (totalClicks / totalSends) * 100 : 0,
      avgConversionRate: totalSends > 0 ? (totalConversions / totalSends) * 100 : 0,
    };
  }
}

```

### Background Jobs

```typescript
// Update template analytics daily
cron.schedule('0 3 * * *', async () => {  // 3 AM daily
  const templates = await db.templateLibrary.findAll({
    where: { isActive: true },
  });

  const service = new TemplateLibraryService();

  for (const template of templates) {
    const analytics = await service.getTemplateAnalytics(template.id);

    await db.templateLibrary.update(template.id, {
      avgOpenRate: analytics.avgOpenRate,
      avgClickRate: analytics.avgClickRate,
      avgConversionRate: analytics.avgConversionRate,
    });
  }
});

```

### API Endpoints

```typescript
// Browse template library
app.get('/api/template-library', async (req, res) => {
  const service = new TemplateLibraryService();

  const result = await service.browseTemplates(
    {
      category: req.query.category,
      industryTags: req.query.industryTags?.split(','),
      complexityLevel: req.query.complexityLevel,
      search: req.query.search,
    },
    {
      offset: parseInt(req.query.offset) || 0,
      limit: parseInt(req.query.limit) || 20,
    }
  );

  return res.json(result);
});

// Use template from library
app.post('/api/template-library/:id/use', authenticate, async (req, res) => {
  const service = new TemplateLibraryService();

  const template = await service.useTemplate(
    req.params.id,
    req.user.tenantId,
    req.body.workspaceId,
    {
      name: req.body.name,
      brandPreset: req.body.brandPreset,
    }
  );

  return res.json(template);
});

// Rate template
app.post('/api/template-library/:id/rate', authenticate, async (req, res) => {
  const service = new TemplateLibraryService();

  await service.rateTemplate(
    req.params.id,
    req.user.id,
    req.body.rating,
    req.body.review
  );

  return res.json({ success: true });
});

// Get template analytics
app.get('/api/template-library/:id/analytics', authenticate, async (req, res) => {
  const service = new TemplateLibraryService();
  const analytics = await service.getTemplateAnalytics(req.params.id);

  return res.json(analytics);
});

```

---

## Related Documentation

- **[Template Editor](/docs/features/templates/template-editor/overview)** - Customize library templates

- **[Template Variables](/docs/features/templates/template-variables)** - Personalize template content

- **[Template Management](/docs/features/templates/template-management)** - Organize your templates

- **[Campaign Management](/docs/features/campaigns/campaign-management/hub)** - Use templates in campaigns

---

**Last Updated:** November 25, 2025
**Status:** Planned - High Priority (Level 2)
**Target Release:** Q2 2026
**Owner:** Templates Team

{% endraw %}
