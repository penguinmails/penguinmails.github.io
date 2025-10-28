# PenguinMails IP Management Guide

> **Status**: Completed Current  
> **Last Updated**: October 27, 2025  
> **Owner**: Operations Lead  
> **Version**: 1.0

## 1. Introduction

### **Purpose of This Document**

This document explains how PenguinMails manages IP addresses for sending cold emails.

It defines how dedicated and shared IPs are assigned, warmed up, monitored, and replaced when needed.

It also covers cost control, scaling rules, and policies for selling extra IPs to users.

The goal is to make sure our IP infrastructure supports both **deliverability** and **profitability** as we grow.

---

### **Why IP Management Is Critical for Cold Email Deliverability**

Every email sent through PenguinMails comes from an IP address.

Email providers like Gmail, Outlook, and Yahoo track the history of that IP to decide whether to deliver emails to the inbox or send them to spam.

If an IP has:

- Low bounce rates, low spam complaints, and steady sending patterns → it builds **high reputation** and inbox placement improves.
- High bounces, spam complaints, or sudden volume spikes → it gets **flagged** or **blacklisted**, causing emails to land in spam for everyone using it.

Good IP management is critical because:

1. **Shared IP Risk** – One bad sender can hurt all senders on that IP.
2. **Dedicated IP Responsibility** – One user's actions directly affect their own deliverability.
3. **Scaling Without Damage** – New IPs must be warmed up slowly to gain trust before full use.
4. **Cost Impact** – Buying too many IPs upfront wastes money, but too few can cause congestion and lower deliverability.

Without proper IP management, even the best cold email copy and targeting will fail because emails never reach inboxes.

---

### **Difference Between Dedicated IPs and Shared IPs**

**Dedicated IP**

- Used by only one user.
- Reputation is affected only by that user's sending behavior.
- Best for high-volume senders or businesses wanting full control over deliverability.
- Included based on plan limits. Extra IPs available for purchase.
- More expensive to maintain, but safer for brand reputation.

**Shared IP**

- Used by multiple users at the same time.
- PenguinMails manages the pool, assigns domains, and controls warmup.
- Lower cost for users, included for free in all plans.
- Risk: If one user abuses it, all senders on that IP can suffer.
- Requires strict monitoring, abuse prevention, and quick replacement policies.

---

### **Business Goals for IP Management**

1. **Maintain High Deliverability**
    - Keep both dedicated and shared IPs in good health through warmup, monitoring, and abuse prevention.
    - Ensure quick replacement or repair if an IP gets flagged.
2. **Control Costs**
    - Avoid buying more IPs than needed.
    - Maintain a small buffer of warmed IPs for emergencies.
    - Make shared IPs the default for low-volume senders to save infrastructure costs.
3. **Scale Smoothly**
    - Use a clear capacity model to know when to add more IPs.
    - Warm up new IPs before demand spikes.
    - Prevent overload on any single IP.
4. **Monetize Extra IPs Without Making Shared IPs Unattractive**
    - Offer extra dedicated IPs at a fixed price ($8) to cover costs and small margin.
    - Keep shared IPs free and reliable so users on lower plans stay happy.
    - Give users the choice between cost-effective shared IPs or higher control with dedicated IPs.

## 2. IP Types in PenguinMails

### **2.1 Dedicated IPs**

### **Definition**

A **Dedicated IP** is an IP address assigned to a single PenguinMails user.

No other customer can send emails from that IP, meaning the sender's deliverability depends only on their own sending practices.

This setup gives the user full control over the IP's reputation and is preferred by businesses that send large volumes or want predictable inbox placement.

---

### **How They Work**

- When a user chooses a dedicated IP for their domain:
    - The IP is reserved only for that domain's mailboxes.
    - All outbound emails from that domain are routed through the assigned IP.
- The IP's reputation builds over time based solely on that user's sending history.
- If the IP is flagged or blacklisted:
    - The user can replace it by purchasing a new dedicated IP.
    - Or switch the affected domain to a shared IP while the old IP is repaired.

---

### **Included IP Count by Plan**

Each plan includes a fixed number of dedicated IPs:

| Plan | Included Dedicated IPs |
| --- | --- |
| **Plan 1** | 1 IP |
| **Plan 2** | 2 IPs |
| **Plan 3** | 3 IPs |
| **Plan 5** | 5 IPs |

---

### **Option to Buy Extra**

- Users can purchase extra dedicated IPs for **$8/IP**. Maybe we can increase this price later.
- This price covers:
    - $6 IP cost from the provider.
    - Small margin to cover Stripe fees and operational costs.
- Extra IPs are billed monthly and remain active as long as the subscription is active.

---

### **Assignment Process**

1. **Domain Connection**
    - When the user connects a domain (via the stepper UI), they choose:
        - **Dedicated IP** (from their plan's quota).
        - Or **Shared IP** (from PenguinMails' shared pool).
2. **If Quota Is Available**
    - If the user has unused dedicated IPs in their plan, they can assign one to the new domain.
3. **If Quota Is Full**
    - The user sees an option to:
        - Assign the domain to a **shared IP** for free.
        - Or **purchase an extra dedicated IP** instantly.
4. **IP Warmup**
    - Any new dedicated IP starts with a warmup schedule to build sending reputation before reaching full volume.

### 2.2 Shared IPs

### **Definition**

A **Shared IP** is an IP address that multiple PenguinMails users share for sending emails.

Emails from different domains and mailboxes are routed through the same IP.

The IP's reputation is built collectively by all senders using it.

---

### **Why They Exist**

1. **Cost Savings**
    - Instead of buying a dedicated IP for every user, multiple senders can use the same IP, reducing infrastructure costs.
2. **Starter Plans**
    - Ideal for users with low sending volume who do not need a dedicated IP.
3. **Backup Option**
    - Serves as a fallback if a dedicated IP gets flagged or if a user has already used their dedicated IP quota but still needs to connect more domains.

---

### **Free for All Plans**

- Every plan includes **free access** to the shared IP pool.
- Users can connect **unlimited domains** and **unlimited mailboxes** to shared IPs without extra charges.
- No sending rights are reduced simply because an IP is shared — limits are based on plan and abuse prevention rules.

---

### **Pool Managed Entirely by PenguinMails**

- PenguinMails owns, configures, and maintains all shared IPs.
- Users cannot modify, reassign, or warm up shared IPs directly — all warmup and monitoring is handled internally.
- PenguinMails decides how many domains/mailboxes go on each shared IP to maintain safe sending volume and deliverability.

---

### **Always Warmed and Monitored**

- Shared IPs are pre-warmed before being assigned to users.
- PenguinMails monitors:
    - Bounce rates.
    - Spam complaints.
    - Blocklist status.
    - Volume patterns.
- If an IP approaches unsafe levels, a new shared IP is warmed and added to the pool.

---

### **Risks**

- **Abuse from One User Affects All**
    - If one sender on a shared IP sends spam, all users on that IP can see reduced deliverability.
- To manage this risk:
    - PenguinMails uses automated abuse detection and rate limits.
    - Problem accounts are paused or migrated to protect others.
    - IP replacement is handled silently so the user experience is not disrupted.

## 3. Capacity Planning & Scaling

### 3.1 Determining Safe Load per Shared IP

### **Key Factor**

To decide how many domains and mailboxes can safely share one IP, we consider:

1. **Emails per Day per Mailbox**
    - The average number of cold emails a mailbox sends daily.
    - For example, a typical cold outreach setup might send 40–60/day per mailbox.
2. **Mailboxes per Domain (Average)**
    - Some domains might have 2 mailboxes, others 5+.
    - We track the real average in our system and use that for capacity planning.
3. **Total Domains per IP**
    - The number of different domains assigned to the same shared IP.
    - Each domain may have multiple mailboxes.

---

### **Example Model**

We can calculate safe capacity using this formula:

> Safe Total Emails/Day per IP = Emails per Mailbox × Mailboxes per Domain × Domains per IP
> 

Example:

- Emails per mailbox: **50/day**
- Mailboxes per domain (avg): **3**
- Domains per IP: **8**
- Safe total/day = 50 × 3 × 8 = **1,200 emails/day**

---

### **Industry Benchmarks**

From email deliverability best practices:

- **New IP (fresh)** — Safe start: **200–500/day**
    - Slowly ramp up to avoid spam flags.
- **Mature Warmed IP** — Safe range: **1,000–2,000/day**
    - Can handle more volume without deliverability loss.

---

### **Conservative Starting Assumption**

- For PenguinMails shared IPs, we start with a conservative limit of **1,200 emails/day per IP**.
- This:
    - Keeps bounce/spam risk low.
    - Gives room for volume spikes without crossing safe thresholds.
- Once we have long-term IP health data, we can decide whether to increase the limit closer to 1,500–1,800/day.

### 3.2 Scaling Model

### **Starting Point for Launch**

- At launch, PenguinMails will keep **3 warmed shared IPs** in the pool.
- This covers early signups without buying excessive unused IPs.
- These initial IPs will be fully warmed before the first user is assigned.

---

### **When to Add New Shared IPs**

- We trigger a new IP warmup when the **current shared IP pool reaches 80% of safe sending capacity**.
- **80% Load Formula**:
    
    > Current Load % = (Total Estimated Emails Sent per Day from IP) ÷ (Safe Limit per IP) × 100
    > 
    - Example:
        - Safe Limit = 1,200 emails/day
        - Current Load = 960 emails/day
        - Load % = 960 ÷ 1,200 × 100 = **80%** → Trigger warmup for new IP.

---

### **Warming New IPs**

- New IPs start at **200–300/day** and ramp up 20–30% every 3–4 days.
- Full warmup takes ~14 days before adding new users at normal volume.
- Warmups for shared IPs are controlled entirely by PenguinMails.

---

### **Maintaining a 20% Warmed IP Buffer**

- Always keep at least **20% extra warmed IP capacity** beyond current demand.
- Purpose:
    - Handle sudden spikes in signups.
    - Replace flagged IPs immediately without waiting for warmup.
- Example:
    - If total active capacity = 10 IPs → keep 2 extra warmed IPs ready.

---

### **IP Warmup Trigger Flow**

1. Monitor daily sending totals for each shared IP.
2. If any IP crosses **80% of safe limit**, check total pool usage.
3. If total pool usage is also near 80%, start warming a new IP.
4. Keep warming until it reaches full sending capacity (~14 days).
5. Move new users or load from high-usage IPs to the warmed IP.

### 3.3 Spreadsheet Model Example

| IP ID | Domains | Avg Mailboxes/Domain | Emails/MB/day | Total/day | Safe Limit | Load % | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| IP-01 | 8 | 3 | 50 | 1,200 | 1,200 | 100% | Full |
| IP-02 | 6 | 3 | 50 | 900 | 1,200 | 75% | Healthy |
| IP-03 | 3 | 3 | 50 | 450 | 1,200 | 37% | Buffer |
| IP-04 | 0 | - | - | 0 | 1,200 | 0% | Spare/Warming |

**How to use this sheet:**

- Track every shared IP's daily sending estimate.
- Color code:
    - **Green** (0–79%) = Healthy
    - **Yellow** (80–99%) = Warm new IP
    - **Red** (100%+) = Overloaded → Move domains/mailboxes ASAP
- Adjust `Avg Mailboxes/Domain` and `Emails/MB/day` with real usage data over time.

## 4. Warmup Policies

### 4.1 IP Warmup

### **Why IPs Need Warming**

Email providers such as Gmail, Outlook, and Yahoo evaluate **IP reputation** as part of their spam filtering process.

A brand-new IP has **no sending history** — this is called a "cold" IP.

If a cold IP suddenly starts sending large volumes of emails, providers see it as suspicious and may:

- Mark messages as spam.
- Temporarily block sending.
- In severe cases, blacklist the IP.

**Warming** is the process of gradually increasing email volume from an IP so providers can observe normal, consistent sending patterns.

This slow growth builds **trust** and establishes the IP as a legitimate sender.

---

### **IP Warmup Steps (Shared or Dedicated)**

1. **Initial Sending Limit**
    - Start at **20–50 emails/day** total from the IP.
    - Evenly distribute volume across all assigned mailboxes/domains.
2. **Gradual Increase**
    - Increase volume by **20–30% every 3–4 days**.
    - Avoid sudden jumps in daily totals.
3. **Full Capacity**
    - Reach the safe limit (e.g., 1,200/day for shared IPs) in **~14 days**.
    - For dedicated IPs with higher safe limits, warming may continue up to 21 days before reaching full potential.
4. **Monitoring During Warmup**
    - Check bounce rates, spam complaints, and engagement after each increase.
    - Pause or slow warmup if negative metrics rise.

---

### **IP Warmup for Shared IPs**

- Managed entirely by **PenguinMails**.
- Users **cannot change warmup speed or limits** on shared IPs.
- New shared IPs are warmed **before** assigning them to end users.
- This ensures new customers never send from a cold IP.

---

### **IP Warmup for Dedicated IPs**

- Begins as soon as the dedicated IP is assigned to a domain.
- Users start sending at low daily volumes (20–50/day per mailbox).
- **Parallel Warmup**:
    - Warmup emails run alongside the user's normal campaigns.
    - Both contribute to building IP reputation.
- Recommended: Users follow gradual volume increases to match warmup schedule for best results.
    
    > ***I think there is no need to discuss anything about warmup for dedicated IPs. Because there is already mailbox warmup and also users will start with less emails per day per mailbox. I am just confused about warmup for shared IP***
    > 

### 4.2 Mailbox Warmup

### **Purpose**

Mailbox warmup focuses on building **trust** for both the sending **domain** and the individual **mailbox**.

It ensures that when you send emails, providers like Gmail and Outlook recognize the sender as safe and relevant — not spammy.

---

### **How It Works**

- Mailbox warmup simulates **real email activity**:
    - Sends emails to other warmup participants.
    - Opens received emails.
    - Marks them as "Not Spam" if in junk folder.
    - Replies to a percentage of them to mimic real conversations.
- These actions signal to email providers that:
    - The mailbox sends wanted emails.
    - People engage with its messages.
    - The sender is trustworthy.

---

### **Mailbox Warmup vs IP Warmup**

- **Mailbox Warmup**: Builds reputation for the **mailbox and domain**.
- **IP Warmup**: Builds reputation for the **IP address**.
- Both are necessary:
    - A healthy IP with a cold mailbox will still get poor deliverability.
    - A warm mailbox on a flagged IP will also struggle.

---

### **PenguinMails Mailbox Warmup Rules**

- Runs separately from IP warmup.
- Can be user-controlled (start/stop, schedule).
- Must run for at least 2–4 weeks for new mailboxes before sending high daily volumes.
- Continues at a lower level in the background to maintain reputation.

### 4.3 Domain + IP Reputation

### **Separate but Connected**

- **IP Reputation**: Email providers track how many spam complaints, bounces, and engagement events occur for that IP.
- **Domain Reputation**: Similar tracking, but for the sending domain.
- They are separate, but both influence whether emails land in inbox or spam.

---

### **When Moving a Domain to a New IP**

- The domain keeps its **domain reputation**.
- The new IP starts with **no sending history** (cold reputation).
- Result:
    - Providers trust the domain but are cautious about the new IP.
    - Deliverability may dip briefly until the IP is warmed and gains trust.

---

### **Why This Matters for PenguinMails**

- If a shared IP is flagged:
    - Healthy domains can be moved to a warmed spare IP to minimize impact.
    - If moved to a cold IP, expect a short-term deliverability drop.
- For dedicated IP users:
    - If their IP is flagged and replaced with a new one, they must warm it again while keeping domain trust intact.

## 5. Monitoring & Detection

### 5.1 Metrics to Monitor

To protect IP health and deliverability, PenguinMails will continuously monitor the following:

1. **Bounce Rates**
    - **What it is:** Percentage of sent emails that fail to deliver.
    - **Why it matters:** High bounce rates signal poor list quality or spam-like behavior, damaging IP and domain reputation.
    - **Safe threshold:** Keep below **5%**; ideally **<3%**.
2. **Spam Complaint Rates**
    - **What it is:** Percentage of recipients who mark an email as spam.
    - **Why it matters:** One of the fastest ways to get an IP flagged.
    - **Safe threshold:** Keep below **0.2%**.
3. **Open & Reply Rates (Secondary Indicator)**
    - **What it is:** Engagement data showing how many recipients open or respond to emails.
    - **Why it matters:** Sudden drops can signal that inbox placement has fallen, often due to IP or domain reputation issues.
    - **Note:** Open rates are unreliable due to privacy changes, but still useful for trend analysis.
4. **Blocklist Status**
    - **What it is:** Whether an IP is listed on major anti-spam blocklists.
    - **Key lists to check:**
        - **Spamhaus**
        - **Barracuda**
        - **Microsoft SNDS reputation**
        - **Google Postmaster Tools IP/domain reputation**

### 5.2 Tools & Methods

### **Free Tools**

1. **Google Postmaster Tools API** (Per IP/Domain)
    - Tracks domain and IP reputation directly from Gmail.
    - Useful for seeing if Gmail trust is dropping.
2. **Microsoft SNDS** (Dashboard or API)
    - Shows IP reputation with Microsoft mail servers.
    - Flags spam, trap hits, and volume spikes.
3. **DNSBL Blocklist Lookups**
    - Queries DNS-based blacklists (Spamhaus, Barracuda, etc.).
    - Can be automated to run daily.

---

### **Paid Tools**

1. **Postmark Monitoring**
    - Tracks bounce and spam complaint rates in real-time.
    - Gives deliverability alerts.
2. **SendForensics**
    - Provides detailed reputation scoring.
    - Can monitor multiple IPs at once.
3. **InboxMonster**
    - Real-time inbox placement testing.
    - Alerts for blocklist appearances.
4. **Warmup Network Alerts**
    - Many warmup networks (including PenguinMails' internal warmup) detect if a mailbox's IP starts landing in spam.
    - Can act as an early warning system for IP health decline.

### 5.3 Automated Flag Detection

### **Daily Health Checks**

PenguinMails will automatically check the health of every shared and dedicated IP **once per day** using internal metrics and integrated APIs (Google Postmaster Tools, Microsoft SNDS, blocklist lookups).

These checks run in the background and do not affect normal sending activity.

---

### **At Risk Criteria**

An IP will be flagged as **"At Risk"** if **any** of the following conditions are met:

1. **Bounce Rate Spike**
    - Condition: Average bounce rate **> 8%** over the last **3 consecutive days**.
    - Reason: Indicates poor data quality or possible spam activity from one or more senders.
2. **High Spam Complaint Rate**
    - Condition: Spam complaint rate **> 0.2%**.
    - Reason: Signals that recipients are actively marking emails as unwanted, which quickly damages reputation.
3. **Blacklist Detection**
    - Condition: IP is listed on any major blocklist (Spamhaus, Barracuda, etc.).
    - Reason: Being listed on a reputable blacklist directly affects inbox placement across most providers.
4. **Sudden Engagement Drop**
    - Condition: Open or reply rates fall **> 50%** compared to the previous 3-day average.
    - Reason: Often an early indicator that emails are being filtered to spam rather than inbox.

---

### **Flagged IP Workflow**

1. IP is tagged as **"At Risk"** in the internal dashboard.
2. System automatically:
    - Pauses adding new domains/mailboxes to that IP.
    - Starts preparing a warmed replacement IP (if not already available in the buffer).
3. If reputation continues to decline over the next 48–72 hours:
    - Healthy domains on that IP are **silently migrated** to another warmed IP.
    - Abusing accounts are paused or restricted.
4. The old IP enters **repair warmup** to recover its reputation.

## 6. Abuse Prevention

Abuse prevention is essential to protect both **shared IP reputation** and **overall deliverability** for all PenguinMails customers.

The following measures are in place to detect, limit, and stop harmful sending activity before it damages IP health.

---

### **6.1 Per-Mailbox Daily Send Limits**

- **Purpose:** Prevents one mailbox from sending excessive emails in a short time, which could trigger spam filters.
- **Policy:**
    - Even dedicated IP users have a daily send cap to protect infrastructure.
    - Default starting cap for new mailboxes: **50 emails/day**.
    - Cap increases gradually for healthy senders based on engagement and bounce history.

---

### **6.2 Bounce Brakes**

- **Purpose:** High bounce rates are a strong signal to providers that the sender is low quality or a spammer.
- **Policy:**
    - If any mailbox exceeds **5% bounce rate** in a 24-hour period:
        - Sending is automatically paused for that mailbox.
        - User receives a notification with instructions to clean their list.
    - For bounce rates over **10%**:
        - Immediate suspension from sending until reviewed by the support team.

---

### **6.3 Spam Complaint Brakes**

- **Purpose:** Protects shared IPs from rapid reputation damage caused by spam reports.
- **Policy:**
    - If any mailbox receives more than **2 spam complaints** in a day (or > 0.2% rate):
        - Sending is auto-paused.
        - User is alerted and required to adjust targeting and messaging before resuming.

---

### **6.4 Pattern Detection**

- **Purpose:** Identifies unusual sending behavior that could harm deliverability.
- **Examples of Patterns Monitored:**
    - Sudden volume spikes (e.g., mailbox sending triples in one day).
    - Many accounts on a shared IP sending to similar recipient lists.
    - Multiple consecutive hard bounces to the same domain.
- **Action:**
    - If a pattern is flagged, the mailbox is reviewed and may be temporarily paused until approved by the system or support team.

---

### **6.5 Terms of Service Enforcement**

- **Purpose:** Legal and operational protection against bad senders.
- **Policy:**
    - Terms of Service clearly prohibit:
        - Purchased email lists.
        - Sending to scraped lists without permission.
        - Illegal, abusive, or deceptive messaging.
    - Violation results in:
        - Immediate suspension of sending privileges.
        - Possible account termination for repeated abuse.

## 7. Replacement & Migration Policy

### 7.1 For Shared IPs

> (We'll get perfect slowly and know how it goes after launch)
> 

### **When an IP Is Flagged**

If a shared IP is detected as "At Risk" or confirmed flagged (Section 5.3 rules), PenguinMails will act immediately to protect inbox placement without alarming users or disrupting sending unnecessarily.

---

### **New Approach to Migration**

1. **Silent Migration Without Pausing**
    - Instead of pausing affected mailboxes, we **quietly reassign domains** on that IP to a warmed spare IP from our buffer.
    - This ensures there is no downtime or disruption for the user.
2. **Load Redistribution**
    - If the replacement IP cannot handle the entire load immediately (due to warmup limits), we distribute domains across multiple warmed IPs in the pool.
    - Priority is given to high-volume accounts so they don't overload a new IP.
3. **Gradual Transition for Low-Volume Accounts**
    - Smaller accounts may be moved in phases over 24–48 hours to avoid sudden spikes on the replacement IPs.
4. **No Immediate Sender Removal**
    - We do **not** instantly remove or suspend any sender unless:
        - Bounce rates exceed **10%** in 24 hours.
        - Spam complaints exceed **0.5%** in 24 hours.
        - Or activity clearly violates our Terms of Service.
    - Instead, we let all accounts continue sending under the new IP and monitor closely for repeat offenders.
5. **IP Repair Warmup**
    - The old flagged IP is moved into a "repair" process:
        - Low, slow sending volume.
        - Engagement-heavy warmup emails.
        - Gradual recovery to see if it can rejoin the pool.
6. **User Experience Goal**
    - The migration process is **completely invisible** to the end user.
    - No alerts, no "your IP is flagged" messages — users simply keep sending as normal.

### 7.2 For Dedicated IPs

If a dedicated IP is flagged:

- The user can:
    - Buy a new dedicated IP for **$8**.
    - Or move their domain to a shared IP (free).
- Notify the user about:
    - The issue with their current IP.
    - The options available for replacement.
    - Recommended warmup steps if moving to a new IP.

## 8. Cost Management

Efficient IP management is not just about deliverability — it's also about controlling infrastructure costs so PenguinMails can remain profitable while scaling.

---

### **8.1 Start with Minimum IPs Possible**

- At launch, maintain only the number of **shared IPs** needed to serve early customers plus a small warmed buffer.
- Avoid buying unused IPs that sit idle and generate cost without revenue.
- For dedicated IPs:
    - Only purchase them when a user's plan or extra purchase requires it.

---

### **8.2 Add IPs Based on Calculated Demand**

- Use the **capacity model** from Section 3 to determine when new IPs are required.
- Shared IP trigger:
    - Warm a new shared IP when total load reaches **80% capacity**.
- Dedicated IP trigger:
    - Purchase instantly when a user assigns a new domain to a dedicated IP slot or buys an extra IP.

---

### **8.3 Avoid Overbuying**

- Never maintain more than **20% above current demand** in total IP count.
- Example:
    - If current demand = 10 IPs → keep at most 12 IPs active/warmed.
- This ensures enough backup for emergencies while preventing waste.

---

### **8.4 Cost Tracking**

Keep a live dashboard showing:

1. **VPS/IP cost per plan**
    - Example (your current setup):
        - Plan 1 & 2 → $5.3 VPS cost per IP.
        - Plan 3 & 4 → $9.3 VPS cost per IP.
2. **Revenue per IP (extra sales)**
    - Extra dedicated IP sold at **$8**.
    - Cost = ~$6.
    - Stripe fee (average 2.9% + $0.30) ≈ $0.40.
    - **Net margin per extra IP/month** = $1.60.

---

### **8.5 Shared IP Cost Control**

- Shared IP costs are spread across all users in the pool.
- The more efficiently we fill each shared IP (without overloading), the lower the cost per user.
- Balance between:
    - Maximizing usage.
    - Protecting deliverability.

## 9. Pricing Policy

The pricing structure for IP allocation in PenguinMails is designed to keep shared IPs attractive for lower-volume users while providing a simple, profitable upsell path for customers who want dedicated IPs.

---

### **9.1 Shared IP Pricing**

- **Price:** **Free** for all plans.
- **Purpose:**
    - Allow unlimited domain and mailbox connections without extra cost.
    - Ensure entry-level and budget-conscious users can still send at reliable deliverability levels.
- **Incentive:**
    - Since shared IPs are included, users can scale domains without worrying about IP costs unless they specifically need dedicated IP benefits.

---

### **9.2 Dedicated IP Pricing**

- **Included in Plan:**
    - Plan 1 → 1 IP
    - Plan 2 → 2 IPs
    - Plan 3 → 3 IPs
    - Plan 5 → 5 IPs
- **Extra IP Cost:** **$8 flat per month**.
    - Covers ~$6 IP cost + Stripe and operational fees, leaving ~$1.60 net margin.
- **No Discounts:**
    - All plans pay the same $8 per extra IP.
    - Keeps pricing simple and predictable.

---

### **9.3 Why Keep Shared IPs Free**

- Encourages adoption from users who don't want to manage multiple dedicated IPs.
- Reduces infrastructure costs for low-volume accounts.
- Keeps the upsell opportunity open for users who outgrow shared IP limitations.

---

### **9.4 Upsell Strategy**

- During domain connection:
    - If the user has unused dedicated IPs → allow selection.
    - If they have reached their limit → offer the $8/month upsell immediately.
- Use in-app messaging and onboarding flows to explain:
    - Benefits of a dedicated IP (control, reputation isolation).
    - When upgrading makes sense (higher send volume, critical deliverability).

## 10. Emergency Handling

Even with strong monitoring, abuse prevention, and capacity planning, there will be situations where IP capacity or deliverability is suddenly at risk.

This section outlines the playbook for handling urgent events to minimize user impact and protect the PenguinMails sending infrastructure.

---

### **10.1 Sudden Blacklist Event**

**Scenario:**

One or more shared or dedicated IPs are unexpectedly listed on a major spam blocklist (Spamhaus, Barracuda, etc.) or flagged by major email providers.

**Action Plan:**

1. **Identify and Prioritize**
    - Flag all domains/mailboxes using the affected IP.
    - Classify them as **critical users** (high volume, paying for dedicated IPs) or **low-volume users**.
2. **Immediate Migration for Critical Users**
    - Move critical users to **warmed spare IPs** from the buffer immediately.
    - Ensure new IPs have capacity to handle their volume.
3. **Contain the Risk**
    - Redirect remaining load to healthy IPs without overloading them.
    - If absolutely necessary, temporarily reduce sending rates for low-priority accounts.
4. **Pause Risky Senders**
    - Accounts with high bounce rates or spam complaints are temporarily paused to avoid damaging fresh replacement IPs.
5. **Repair and Recovery**
    - Place blacklisted IPs into **repair warmup mode** to try restoring reputation.
    - Only return them to the pool after full recovery.
6. **Communication**
    - No public announcement unless required.
    - Handle migrations **silently** so most users remain unaware.

---

### **10.2 Big User Spike**

**Scenario:**

A sudden surge of signups (e.g., post-launch buzz or viral growth) puts unexpected demand on IP capacity.

**Action Plan:**

1. **Load New Users to Buffer IPs First**
    - Assign incoming domains/mailboxes to pre-warmed buffer IPs to avoid using cold IPs.
2. **Start Multiple IP Warmups in Parallel**
    - Immediately begin warming several new IPs at the same time.
    - Use **staggered warmup start dates** so IPs mature at different times for continuous availability.
3. **Dynamic Load Balancing**
    - Spread high-volume senders across different warmed IPs to prevent overload.
    - Temporarily slow the addition of new mailboxes to already busy IPs.
4. **Capacity Tracking**
    - Monitor daily load and forecast usage for the next 7–14 days to ensure new warmups are ready in time.

## 11. Long-term Improvements

While the current IP management process combines automated checks with manual decision-making, the long-term goal is to reduce human intervention, speed up response times, and ensure IP scaling is always ahead of demand.

---

### **11.1 PenguinMails IP Reputation Dashboard**

**Purpose:** Centralized monitoring of IP health for both **internal team visibility** and possible **external transparency** (for users with dedicated IPs).

**Features:**

- **Real-time IP Health Status**
    - Color-coded (Green = Healthy, Yellow = At Risk, Red = Flagged).
- **Key Metrics per IP**
    - Bounce rate, spam complaints, engagement trends, blacklist status.
- **Historical Trends**
    - See how each IP's health changes over time.
- **Integrated Data Sources**
    - Google Postmaster Tools API.
    - Microsoft SNDS API.
    - DNSBL lookups.
    - Internal send volume data.
- **User View (Optional for Dedicated IPs)**
    - Show IP reputation score so customers understand deliverability impact.

---

### **11.2 Auto-Scaling Script for IPs & VPS**

**Purpose:** Reduce manual work and eliminate delays in provisioning.

**How It Works:**

- Connect to VPS provider APIs (e.g., UpCloud).
- Trigger conditions:
    - Shared IP pool > 80% load → auto-purchase + configure new IP/VPS.
    - Dedicated IP purchase by user → instantly provision and warm.
- Automation Tasks:
    1. Buy VPS.
    2. Assign IP(s).
    3. Configure SMTP & warmup settings.
    4. Add to PenguinMails IP pool.
- Include **rollback option** if setup fails.

---

### **11.3 Predictive IP Demand Model**

**Purpose:** Avoid last-minute warmups by forecasting IP needs in advance.

**Model Inputs:**

- **Signup Growth Rate** (last 14–30 days).
- **Average Domains per User**.
- **Average Mailboxes per Domain**.
- **Average Emails per Mailbox/day**.
- **Current IP Pool Usage**.
- **Warmup Timeframe** (~14 days for shared IPs).

**Model Outputs:**

- **Projected IP demand** 2–4 weeks into the future.
- **Warmup schedule** to have spare IPs ready on time.
- Alerts for:
    - Buffer capacity dropping below 20%.
    - Forecasted shortage within 14 days.

## Related Documents

- [Infrastructure Documentation](infrastructure_documentation.md) - System architecture and deployment procedures
- [Analytics Architecture](analytics_architecture.md) - Email tracking and deliverability analytics
- [Security Documentation](security_documentation.md) - Email security and compliance procedures
- [Database Schema Guide](database_schema_guide.md) - Email metrics storage and analysis
- [Business Documentation Proposal](business_documentation_proposal.md) - Operational procedures and customer management

## Conclusion

This IP management guide provides the foundation for maintaining high deliverability while controlling infrastructure costs. By following these policies, PenguinMails can ensure reliable cold email delivery for all users while building a sustainable and profitable email infrastructure.

The key to success lies in proactive monitoring, automated scaling, and transparent operations that protect user deliverability without disrupting their workflow.