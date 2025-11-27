---
title: "Customer View Specifications"
description: "Detailed widget and data requirements for Customer and Agency views"
---


# Customer Workspace Views

*The core product experience for paying users.*


## 1. Campaign Performance Dashboard


* **Target**: Marketing Managers, Business Owners


* **Route**: `/dashboard/workspaces/[slug]/campaigns/[id]`


* **Goal**: Optimize current email campaigns.


* **Key Questions**: Did my emails land in the inbox? Did people reply?


### Widgets


* **Engagement Funnel**: Sent → Delivered → Opened → Clicked → Replied.


* **Deliverability Score**: 0-100 score based on inbox placement.


* **Hourly Engagement Chart**: Best time to send analysis.


* **Device/Client Breakdown**: Mobile vs Desktop, Gmail vs Outlook.


## 2. Agency Command Center


* **Target**: Agency Owners (Multi-Tenant View)


* **Route**: `/dashboard/workspaces` (Agency Role)


* **Goal**: Manage multiple clients efficiently.


* **Key Questions**: Which client needs attention? Who is performing best?


### Widgets


* **Client Health Matrix**: Table of all clients with "Red/Yellow/Green" status columns for Deliverability, Spend, and Results.


* **Global Revenue**: Aggregated revenue generated for all clients.


* **Alert Feed**: "Client A domain blacklisted", "Client B budget exhausted".


## 3. Client Report Portal (White-Label)


* **Target**: The Agency's Clients (End-Viewers)


* **Route**: `/dashboard/workspaces/[slug]` (Client View)


* **Goal**: Prove agency value to their clients.


* **Key Questions**: What am I paying you for? What are the results?


* **Design Note**: Simplified, branded view. No configuration options.


### Widgets


* **ROI Summary**: Cost vs Revenue Generated.


* **Campaign Highlights**: "Best performing subject line", "Top engaged prospect".


* **Monthly Trend**: Line chart of leads generated over time.
