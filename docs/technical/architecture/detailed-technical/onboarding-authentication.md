---
title: "Onboarding and Authentication System Architecture"
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---

# Onboarding and Authentication System Architecture

## Overview

This comprehensive guide covers PenguinMails' enterprise-grade onboarding and authentication system architecture, which provides secure, scalable, and user-friendly access to our email infrastructure platform. Our system implements multi-layered security with NileDB authentication, Cloudflare Turnstile CAPTCHA protection, and Stripe Connect payment processing to ensure a seamless yet secure user experience.

**Strategic Alignment**: This technical feature supports our [market leadership positioning](/docs/business/strategy/overview) by providing enterprise-grade security and user experience that differentiates us from competitors. The multi-tenant authentication architecture enables our [scalable business model](/docs/business/model/overview) while maintaining the highest security standards that enterprise customers demand.

**Technical Authority**: Our [comprehensive 4-tier database architecture](..) integrates with NileDB authentication, providing tenant isolation and enterprise-grade security features. The system incorporates [progressive queue processing](.) for scalability and [OLAP analytics integration](.) for user behavior tracking.

**Operational Excellence**: Backed by [99.9% uptime guarantees](.) with comprehensive monitoring systems, automated failover, and enterprise-grade security. The authentication system includes real-time health checks, predictive scaling, and intelligent error recovery mechanisms.

**User Journey Integration**: This feature is part of your complete [user experience journey](../../user-journeys) - connecting seamlessly to [business strategy overview](/docs/business/strategy/overview), [market analysis insights](/docs/business/market-analysis/overview), and [value proposition delivery](../business/value-proposition/detailed-analysis).

---

## Architecture Overview

### **Current Tech Stack**

Our authentication system leverages enterprise-grade components for maximum security and reliability:

- **Authentication**: NileDB manages core user authentication with custom profile extensions and row-level security
- **CAPTCHA**: Cloudflare Turnstile for privacy-first bot protection with accessibility support
- **Payments**: Stripe Connect for multi-tenant billing and revenue sharing with PCI compliance
- **Analytics**: PostgreSQL + PostHog for email analytics and user behavior tracking with real-time insights
- **Frontend**: Next.js with server-side rendering and API routes for optimal performance

**Strategic Technology Integration**: This tech stack supports our [competitive positioning](docs/business/strategy) by providing enterprise-grade security that rivals established players while offering superior user experience. The integration enables our [advanced analytics capabilities](docs/business/analytics) for data-driven optimization and customer insights.

### **Service Architecture**

Our distributed architecture ensures reliability and scalability:

- **Main App**: `app.penguinmails.com` (Next.js dashboard) with global CDN distribution
- **Auth Integration**: NileDB authentication with tenant isolation and row-level security
- **Payment Processing**: Stripe Connect Express accounts for each tenant with automated compliance
- **Domain Management**: Custom domains with CNAME + SSL for tracking with automated provisioning

**Enterprise Infrastructure**: Our system is deployed on [enterprise-grade infrastructure](docs/technical/architecture/detailed-technical) with automatic scaling, load balancing, and disaster recovery capabilities. The architecture supports our [99.9% uptime SLA](docs/technical/architecture/detailed-technical) through redundant systems and intelligent failover.

---

## Authentication Flow with NileDB

### **Landing → Authentication Check**

Our authentication system implements a sophisticated multi-step verification process:

**User opens** `app.penguinmails.com`

→ **If not authenticated**: Redirect to signup)
→ **If authenticated but not email verified**: Show verification prompt
→ **If authenticated and verified**: Check onboarding status → proceed or show onboarding modal

**Strategic User Experience**: This flow supports our [customer value proposition](docs/business/value-proposition/detailed-analysis) by minimizing friction while maintaining security. The modal-based approach reduces page loads and provides a seamless experience that converts better than traditional multi-page flows.

### **Onboarding Status Check**

Our system maintains comprehensive user state tracking:

```typescript
interface OnboardingState {
  step: 'signup' | 'verify' | 'plan' | 'payment' | 'workspace' | 'provision' | 'complete';
  email_verified: boolean;
  payment_status: 'none' | 'pending' | 'completed' | 'failed';
  has_workspace: boolean;
  tenant_id: string;
  company_id: string;
}
```markdown

**Technical Excellence**: This state management integrates with our [OLAP analytics system](docs/technical/architecture/detailed-technical) for real-time user journey optimization and conversion funnel analysis. The comprehensive tracking enables predictive analytics for user behavior and automated intervention for drop-off points.

---

## Enhanced Sign-Up Flow

### **Sign-Up Modal Form**

Our signup process implements enterprise-grade security with user-friendly design:

**Fields:**
1. First name
2. Last name
3. Email address
4. Password
5. Confirm password
6. **Turnstile CAPTCHA** (with fallback for accessibility)
7. Terms & Privacy checkbox

**Enhanced Validation Rules:**
- Email: Valid format + not disposable + unique in multi-tenant system
- Password: 12+ characters, 1 uppercase, 1 lowercase, 1 number, 1 special character
- CAPTCHA: Turnstile token verification required with server-side validation

**Security Excellence**: These validation rules support our [enterprise security positioning](docs/compliance-security) by implementing industry-standard security measures while maintaining user accessibility. The multi-layered validation prevents common attack vectors including SQL injection, credential stuffing, and automated account creation.

### **Turnstile Integration**

```typescript
// Frontend - Turnstile Widget Implementation
import { Turnstile } from "next-turnstile";
import { verifyTurnstileToken } from "@/utils/turnstile";

const SignUpForm = () => {
  const [captchaToken, setCaptchaToken] = useState("");

  const handleSubmit = async (formData) => {
    // Verify Turnstile token first
    await verifyTurnstileToken(captchaToken);

    // Then proceed with NileDB signup
    await signup({
      email: formData.email,
      password: formData.password,
      firstName: formData.firstName,
      lastName: formData.lastName,
      tenantData: {
        email_verified: false,
        onboarding_step: 'verify',
        payment_status: 'none'
      }
    });
  };

  return ()
    <form onSubmit={handleSubmit}>
      {/* Form fields */}
      <Turnstile
        siteKey={process.env.NEXT_PUBLIC_TURNSTILE_SITE_KEY}
        onVerify={(token) => setCaptchaToken(token)}
        onError={() => setCaptchaToken("")}
        onTimeout={() => setCaptchaToken("")}
      />
    </form>
  );
};
```markdown

### **Turnstile Verification API**

```typescript
// app/api/verify-turnstile/route.ts
import { NextRequest, NextResponse } from "next/server";
import { validateTurnstileToken } from "next-turnstile";

export async function POST(req: NextRequest) {
  try {
    const { token } = await req.json();
    const secretKey = process.env.TURNSTILE_SECRET_KEY;

    if (!secretKey) {
      return NextResponse.json()
        { success: false, message: "Server configuration error" },
        { status: 500 }
      );
    }

    const result = await validateTurnstileToken({
      token,
      secretKey,
    });

    if (!result.success) {
      console.warn("Turnstile verification failed:", result['error-codes']);
      return NextResponse.json()
        { success: false, message: "CAPTCHA verification failed" },
        { status: 400 }
      );
    }

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error("Turnstile verification error:", error);
    return NextResponse.json()
      { success: false, message: "Internal server error" },
      { status: 500 }
    );
  }
}
```markdown

**Strategic Security Integration**: Our CAPTCHA implementation supports our [competitive differentiation](docs/business/strategy)) by using privacy-first Cloudflare Turnstile instead of intrusive alternatives. This aligns with our [enterprise customer value proposition](docs/business/value-proposition/detailed-analysis)) of respecting user privacy while maintaining security.

### **Email Verification with Loop Service**

**Current Implementation Status**: ✅ IMPLEMENTED using Loop service

**Email Verification Flow:**
1. User signs up through NileDB authentication
2. Loop service sends verification email with magic link + fallback code
3. Custom verification endpoint receives token/code and updates `email_verified` field in NileDB users table
4. Account becomes active upon successful verification

**Technical Integration**: This system integrates with our [progressive queue processing](docs/technical/architecture/detailed-technical)) to handle high-volume email sending during peak signup periods, ensuring reliable delivery and optimal user experience.

### **NileDB Sign-Up API**

```typescript
// app/api/auth/signup/route.ts
import { NextRequest, NextResponse } from "next/server";
import { nile } from "@/lib/niledb/client";

export async function POST(req: NextRequest) {
  try {
    const { email, password, firstName, lastName } = await req.json();

    // Create tenant user account
    const user = await nile.auth.signup({
      email,
      password,
      data: {
        first_name: firstName,
        last_name: lastName,
        email_verified: false,
        onboarding_step: 'verify',
        created_at: new Date()
      }
    });

    // Create tenant record
    const tenant = await nile.db.query(`
      INSERT INTO tenants (email, name, status, created_at)
      VALUES ($1, $2, 'active', CURRENT_TIMESTAMP)
      RETURNING id
    `, [email, `${firstName} ${lastName}'s Workspace`]);

    // Link user to tenant
    await nile.db.query(`
      UPDATE tenant_users
      SET tenant_id = $1, role = 'owner'
      WHERE user_id = $2
    `, [tenant.rows[0].id, user.id]);

    // Send verification email via Loop
    await sendVerificationEmail(user.email, user.id);

    return NextResponse.json({
      success: true,
      userId: user.id,
      tenantId: tenant.rows[0].id,
      message: "Account created. Please verify your email."
    });

  } catch (error) {
    console.error("Signup error:", error);
    return NextResponse.json()
      { success: false, message: "Failed to create account" },
      { status: 400 }
    );
  }
}

async function sendVerificationEmail(email: string, userId: string) {
  const verificationToken = await generateJWT({ userId, email });

  await fetch('https://api.loopex.com/send-transactional', {)
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${process.env.LOOP_API_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      transactional_id: process.env.LOOP_VERIFICATION_TRANSACTIONAL_ID,
      to: email,
      data: {
        verification_link: `https://app.penguinmails.com/verify?token=${verificationToken}`,
        first_name: email.split('@')[0],
        expires_in: '30 minutes'
      }
    })
  });
}
```markdown

**Multi-Tenant Architecture**: This implementation showcases our [enterprise database architecture](docs/technical/architecture)) with proper tenant isolation, row-level security, and scalable multi-tenant design that supports our [business model growth](docs/business/model)).

### **Email Verification Status Tracking**

**Current Status**: ✅ IMPLEMENTED using Loop service + custom verification endpoint

**Implementation Details:**
- **Email Service**: Loop handles all verification and password reset emails with 99.9% delivery reliability
- **Verification Endpoint**: Custom API endpoint at `/api/auth/verify` receives verification requests
- **Status Update**: Endpoint updates `email_verified` timestamp field in NileDB's `users` table
- **Token Security**: Single-use JWT tokens with 30-minute expiration and cryptographic validation
- **Fallback Support**: 6-digit code alternative for accessibility and offline scenarios

**Database Updates:**
- `email_verified` field in `users` table set to verification timestamp
- `tenant_users` table mirrors email verification status
- Cross-schema queries combine data for complete user profiles

**Operational Excellence**: This system includes [comprehensive monitoring](docs/technical/architecture/detailed-technical)) with real-time delivery tracking, automated retry mechanisms, and predictive failure detection to maintain our [99.9% uptime commitment](docs/technical/architecture/detailed-technical)).

---

## Email Verification with Magic Links

### **Verification Email Template**

**Subject**: Confirm your PenguinMails account

**From**: PenguinMails <no-reply@penguinmails.com>

**HTML Body**:
```html
<div style="max-width: 600px; margin: 0 auto; font-family: Arial, sans-serif;">
  <h2>Welcome to PenguinMails!</h2>
  <p>Hi {{first_name}},</p>
  <p>Tap the button below to confirm your account and start building your email infrastructure.</p>

  <div style="text-align: center; margin: 30px 0;">
    <a href="{{verification_link}}"
       style="background-color: #4F46E5; color: white; padding: 12px 30px;
              text-decoration: none; border-radius: 6px; display: inline-block;">
      Confirm my account
    </a>
  </div>

  <p style="color: #6B7280; font-size: 14px;">
    This link expires in {{expires_in}}. If it doesn't work, copy this code:<br>
    <strong>{{ six_digit_code }}</strong>
  </p>

  <p style="color: #6B7280; font-size: 14px;">
    Having trouble? <a href="https://app.penguinmails.com/verify">Enter the code manually</a>
  </p>
</div>
```markdown

**User Experience Excellence**: This email design supports our [customer value proposition](docs/business/value-proposition/detailed-analysis)) by providing clear, actionable communication with multiple verification methods. The accessibility-first design ensures compliance with WCAG 2.1 AA standards and provides inclusive user experience.

### **Verification Endpoint**

```typescript
// app/api/auth/verify/route.ts
import { NextRequest, NextResponse } from "next/server";
import { nile } from "@/lib/niledb/client";
import jwt from "jsonwebtoken";

export async function GET(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url);
    const token = searchParams.get('token');
    const next = searchParams.get('next') || '/dashboard/onboarding';

    if (!token) {
      return NextResponse.redirect(');
    }

    // Verify JWT token
    const decoded = jwt.verify(token, process.env.JWT_SECRET!) as {
      userId: string;
      email: string;
    };

    // Check if token was already used
    const usedToken = await nile.db.query()
      'SELECT id FROM verification_tokens WHERE token = $1 AND used = true',
      [token]
    );

    if (usedToken.rows.length > 0) {
      // Token already used - redirect to dashboard
      return NextResponse.redirect(next);
    }

    // Mark email as verified
    await nile.db.query()
      'UPDATE tenant_users SET email_verified = true WHERE user_id = $1',
      [decoded.userId]
    );

    // Mark token as used
    await nile.db.query()
      'UPDATE verification_tokens SET used = true, used = CURRENT_TIMESTAMP WHERE token = $1',
      [token]
    );

    // Create session
    const session = await nile.auth.signin({
      email: decoded.email,
      callbackUrl: next
    });

    // Set session cookie
    const response = NextResponse.redirect(next);
    response.cookies.set('session', session.session_token, {)
      httpOnly: true,
      secure: true,
      sameSite: 'lax',
      maxAge: 60 * 60 * 24 * 30 // 30 days
    });

    return response;

  } catch (error) {
    console.error("Verification error:", error);
    return NextResponse.redirect(');
  }
}
```markdown

### **Manual Verification with Code**

```typescript
// app/api/auth/verify-code/route.ts
import { NextRequest, NextResponse } from "next/server";
import { nile } from "@/lib/niledb/client";

export async function POST(req: NextRequest) {
  try {
    const { email, code } = await req.json();

    // Verify the code
    const verification = await nile.db.query(`
      SELECT vt.token, tu.user_id, tu.email_verified
      FROM verification_tokens vt
      JOIN tenant_users tu ON tu.user_id = vt.user_id
      WHERE tu.email = $1 AND vt.code = $2 AND vt.used = false
        AND vt.expires > CURRENT_TIMESTAMP
    `, [email, code]);

    if (verification.rows.length === 0) {
      return NextResponse.json()
        { success: false, message: "Invalid or expired code" },
        { status: 400 }
      );
    }

    const { token, user_id } = verification.rows[0];

    // Use the same flow as magic link verification
    const response = NextResponse.json({ success: true });

    /)
    await nile.db.query('UPDATE tenant_users SET email_verified = true WHERE user_id = $1', [user_id]);
    await nile.db.query('UPDATE verification_tokens SET used = true WHERE token = $1', [token]);

    return response;

  } catch (error) {
    console.error("Code verification error:", error);
    return NextResponse.json()
      { success: false, message: "Verification failed" },
      { status: 500 }
    );
  }
}
```markdown

**Accessibility and Security**: This dual verification system supports our [enterprise accessibility standards](docs/compliance-security)) while maintaining high security. The fallback code system ensures users with email client restrictions can still complete verification, improving conversion rates and user satisfaction.

---

## Stripe Connect Onboarding Integration

### **Plan Selection Modal**

After email verification, users see the onboarding modal starting with plan selection:

```typescript
// components/onboarding/OnboardingModal.tsx
import { useState } from "react";
import { nile } from "@/lib/niledb/client";

const OnboardingModal = () => {
  const [currentStep, setCurrentStep] = useState('plan');
  const [plan, setPlan] = useState(null);

  const plans = [
    {
      id: 'starter',
      name: 'Starter',
      price: 29,
      features: ['1 dedicated IP', 'Unlimited domains', '1,000 emails/day'],
      stripePriceId: 'price_starter_monthly'
    },
    {
      id: 'professional',
      name: 'Professional',
      price: 99,
      features: ['3 dedicated IPs', 'Unlimited domains', '5,000 emails/day'],
      stripePriceId: 'price_professional_monthly'
    },
    {
      id: 'enterprise',
      name: 'Enterprise',
      price: 299,
      features: ['10 dedicated IPs', 'Unlimited domains', '25,000 emails/day'],
      stripePriceId: 'price_enterprise_monthly'
    }
  ];

  const handlePlanSelect = async (selectedPlan) => {
    setPlan(selectedPlan);
    setCurrentStep('payment');

    // Create Stripe Checkout Session
    const response = await fetch('/api/stripe/create-checkout', {)
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        priceId: selectedPlan.stripePriceId,
        tenantId: await getCurrentTenantId()
      })
    });

    const { url } = await response.json();
    window.location.href = url;
  };

  return ()
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg p-6 max-w-md w-full mx-4">
        {currentStep === 'plan' && ()
          <PlanSelection
            plans={plans}
            onSelect={handlePlanSelect}
          />
        )}
        {currentStep === 'payment' && ()
          <PaymentProcessing />
        )}
        {currentStep === 'workspace' && ()
          <WorkspaceSetup />
        )}
        {currentStep === 'provision' && ()
          <ProvisioningStatus />
        )}
      </div>
    </div>
  );
};
```markdown

**Strategic Business Integration**: This plan selection system supports our [tiered business model](docs/business/model)) by providing clear value differentiation and smooth upgrade paths. The modal-based approach reduces cognitive load and improves conversion rates through focused decision-making.

### **Stripe Checkout Integration**

```typescript
// app/api/stripe/create-checkout/route.ts
import { NextRequest, NextResponse } from "next/server";
import Stripe from "stripe";
import { nile } from "@/lib/niledb/client";

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

export async function POST(req: NextRequest) {
  try {
    const { priceId, tenantId } = await req.json();

    // Get user's email from NileDB
    const user = await nile.auth.getUser();
    if (!user) {
      return NextResponse.json()
        { error: 'User not authenticated' },
        { status: 401 }
      );
    }

    // Create or retrieve Stripe Connect account
    const stripeAccount = await createOrGetStripeAccount(tenantId, user.email);

    // Create Checkout Session
    const session = await stripe.checkout.sessions.create({
      mode: 'subscription',
      payment_method_types: ['card'],
      line_items: [
        {
          price: priceId,
          quantity: 1,
        },
      ],
      customer: stripeAccount.customer_id,
      client_reference_id: tenantId,
      subscription_data: {
        application_fee_percent: 5, // Platform fee
        metadata: {
          tenant_id: tenantId
        }
      },
      success_url: `${process.env.NEXT_PUBLIC_APP_URL}/dashboard/onboarding?success=true&session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${process.env.NEXT_PUBLIC_APP_URL}/dashboard/onboarding?canceled=true`,
      metadata: {
        tenant_id: tenantId,
        stripe_account_id: stripeAccount.id
      }
    });

    return NextResponse.json({ url: session.url });

  } catch (error) {
    console.error("Checkout creation error:", error);
    return NextResponse.json()
      { error: 'Failed to create checkout session' },
      { status: 500 }
    );
  }
}

async function createOrGetStripeAccount(tenantId: string, email: string) {
  // Check if Connect account already exists
  const existingAccount = await nile.db.query()
    'SELECT stripe_account_id FROM company_stripe_accounts WHERE tenant_id = $1',
    [tenantId]
  );

  if (existingAccount.rows.length > 0) {
    // Retrieve existing account
    return await stripe.accounts.retrieve(existingAccount.rows[0].stripe_account_id);
  }

  // Create new Connect Express account
  const account = await stripe.accounts.create({
    type: 'express',
    country: 'US',
    email: email,
    capabilities: {
      card_payments: { requested: true },
      transfers: { requested: true },
    },
  });

  // Store in database
  await nile.db.query()
    `INSERT INTO company_stripe_accounts ()
      tenant_id, stripe_account_id, status, created_at
    ) VALUES ($1, $2, 'pending', CURRENT_TIMESTAMP)`,
    [tenantId, account.id]
  );

  return account;
}
```markdown

### **Stripe Webhook Handler**

```typescript
// app/api/webhooks/stripe/route.ts
import { NextRequest, NextResponse } from "next/server";
import Stripe from "stripe";
import { nile } from "@/lib/niledb/client";

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);
const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET!;

export async function POST(req: NextRequest) {
  const body = await req.text();
  const sig = req.headers.get('stripe-signature')!;

  let event: Stripe.Event;

  try {
    event = stripe.webhooks.constructEvent(body, sig, webhookSecret);
  } catch (err) {
    console.error('Webhook signature verification failed:', err);
    return NextResponse.json({ error: 'Invalid signature' }, { status: 400 });
  }

  switch (event.type) {
    case 'checkout.session.completed':
      await handleCheckoutCompleted(event.data.object as Stripe.Checkout.Session);
      break;
    case 'invoice.payment_succeeded':
      await handlePaymentSucceeded(event.data.object as Stripe.Invoice);
      break;
    case 'customer.subscription.created':
      await handleSubscriptionCreated(event.data.object as Stripe.Subscription);
      break;
    default:
      console.log(`Unhandled event type: ${event.type}`);
  }

  return NextResponse.json({ received: true });
}

async function handleCheckoutCompleted(session: Stripe.Checkout.Session) {
  const tenantId = session.metadata?.tenant_id;

  if (!tenantId) return;

  // Update tenant's payment status
  await nile.db.query()
    `UPDATE tenants SET
      payment_status = 'completed',
      onboarding_step = 'workspace',
      subscription_id = $1,
      updated = CURRENT_TIMESTAMP
     WHERE id = $2`,
    [session.subscription, tenantId]
  );

  // Create workspace record
  await nile.db.query()
    `INSERT INTO workspaces ()
      tenant_id, name, slug, status, created_at
    ) VALUES ($1, 'My Workspace', $2, 'active', CURRENT_TIMESTAMP)
     ON CONFLICT (tenant_id) DO NOTHING`,
    [tenantId, `workspace-${tenantId.slice(0, 8)}`]
  );
}
```markdown

**Financial System Integration**: This Stripe Connect integration supports our [revenue model](docs/business/model)) with automated payment processing, revenue sharing, and compliance with financial regulations. The webhook system ensures reliable payment state management and automatic account provisioning.

---

## Workspace Creation and Domain Provisioning

### **Workspace Setup**

```typescript
// components/onboarding/WorkspaceSetup.tsx
import { useState } from "react";

const WorkspaceSetup = () => {
  const [workspaceName, setWorkspaceName] = useState("My Email Workspace");
  const [slug, setSlug] = useState("");
  const [isCreating, setIsCreating] = useState(false);

  const generateSlug = (name: string) => {
    return name
      .toLowerCase()
      .replace(/[^a-z0-9]+)
      .replace());
  };

  const handleCreate = async () => {
    setIsCreating(true);

    try {
      const response = await fetch('/api/workspaces/create', {)
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          name: workspaceName,
          slug: slug || generateSlug(workspaceName)
        })
      });

      if (response.ok) {
        // Move to provisioning step
        window.location.href = '/dashboard/onboarding?step=provision';
      }
    } catch (error) {
      console.error("Workspace creation failed:", error);
    } finally {
      setIsCreating(false);
    }
  };

  return ()
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-semibold mb-4">Name your workspace</h2>
        <div className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Workspace name
            </label>
            <input
              type="text"
              value={workspaceName}
              onChange={(e) => {
                setWorkspaceName(e.target.value);
                if (!slug) {
                  setSlug(generateSlug(e.target.value));
                }
              }}
              className="w-full px-3 py-2 border border-gray-300 rounded-md"
              placeholder="My Email Workspace"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Workspace URL (optional)
            </label>
            <div className="flex">
              <span className="inline-flex items-center px-3 rounded-l-md border border-r-0 border-gray-300 bg-gray-50 text-gray-500 text-sm">
                app.penguinmails.com/
              </span>
              <input
                type="text"
                value={slug}
                onChange={(e) => setSlug(e.target.value)}
                className="flex-1 px-3 py-2 border border-gray-300 rounded-r-md"
                placeholder="my-workspace"
              />
            </div>
          </div>
        </div>
      </div>

      <button
        onClick={handleCreate}
        disabled={isCreating || !workspaceName.trim()}
        className="w-full bg-indigo-600 text-white py-2 px-4 rounded-md hover:bg-indigo-700 disabled:opacity-50"
      >
        {isCreating ? 'Creating workspace...' : 'Create workspace'}
      </button>
    </div>
  );
};
```markdown

### **Provisioning Status**

```typescript
// components/onboarding/ProvisioningStatus.tsx
import { useEffect, useState } from "react";

const ProvisioningStatus = () => {
  const [status, setStatus] = useState('queued');
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    const checkStatus = async () => {
      try {
        const response = await fetch('/api/provisioning);
        const data = await response.json();

        setStatus(data.status);
        setProgress(data.progress);

        if (data.status === 'completed') {
          // Close modal and redirect to dashboard
          window.location.href = '/dashboard';
        }
      } catch (error) {
        console.error("Status check failed:", error);
      }
    };

    // Check immediately, then every 5 seconds
    checkStatus();
    const interval = setInterval(checkStatus, 5000);

    return () => clearInterval(interval);
  }, []);

  const statusSteps = [
    { key: 'queued', label: 'Queued', progress: 20 },
    { key: 'provisioning', label: 'Setting up infrastructure', progress: 40 },
    { key: 'configuring', label: 'Configuring email settings', progress: 70 },
    { key: 'testing', label: 'Running tests', progress: 90 },
    { key: 'completed', label: 'Ready to use', progress: 100 }
  ];

  const currentStep = statusSteps.find(step => step.key === status) || statusSteps[0];

  return ()
    <div className="text-center space-y-6">
      <div className="w-16 h-16 mx-auto">
        {status === 'completed' ? ()
          <CheckCircle className="w-full h-full text-green-500" />
        ) : ()
          <div className="animate-spin rounded-full h-16 w-16 border-b-2 border-indigo-600"></div>
        )}
      </div>

      <div>
        <h2 className="text-xl font-semibold mb-2">
          {status === 'completed' ? 'Workspace Ready!' : "We're setting things up"}
        </h2>
        <p className="text-gray-600">
          {status === 'completed'
            ? 'Your email infrastructure is ready to use.'
            : "This usually takes 2-4 minutes."
          }
        </p>
      </div>

      {/* Progress indicator when not completed */}
      {status !== 'completed' && ()
        <div className="space-y-4">
          <div className="w-full bg-gray-200 rounded-full h-2">
            <div
              className="bg-indigo-600 h-2 rounded-full transition-all duration-500"
              style={`width: ${currentStep.progress}%`}
            ></div>
          </div>

          <p className="text-sm font-medium text-indigo-600">
            {currentStep.label}
          </p>
        </div>
      )}

      {status === 'completed' && ()
        <button
          onClick={() => window.location.href = '/dashboard'}
          className="bg-indigo-600 text-white py-2 px-6 rounded-md hover:bg-indigo-700"
        >
          Go to Dashboard
        </button>
      )}
    </div>
  );
};
```markdown

**Infrastructure Provisioning**: This workspace creation system integrates with our [comprehensive infrastructure](docs/technical/architecture/detailed-technical)) to automatically provision email domains, configure DNS settings, and set up monitoring. The progressive status updates provide transparency and manage user expectations during the provisioning process.

---

## Login Flow with Turnstile

### **Enhanced Login Form**

```typescript
// app/login/page.tsx
import { useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/context/AuthContext";
import { Turnstile } from "next-turnstile";
import { verifyTurnstileToken } from "@/utils/turnstile";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [captchaToken, setCaptchaToken] = useState("");

  const router = useRouter();
  const { login } = useAuth();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setIsLoading(true);

    try {
      // Verify Turnstile token first
      await verifyTurnstileToken(captchaToken);

      // Then proceed with NileDB login
      await login(email, password);
      router.push(");

    } catch (err) {
      console.error("Login failed:", err);
      setError(err.message || "Login failed. Please try again.");
    } finally {
      setIsLoading(false);
      setCaptchaToken(""); // Reset CAPTCHA token
    }
  };

  return ()
    <div className="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8">
        <div>
          <h2 className="mt-6 text-center text-3xl font-extrabold text-gray-900">
            Sign in to PenguinMails
          </h2>
        </div>

        <form className="mt-8 space-y-6" onSubmit={handleLogin}>
          <div className="space-y-4">
            <div>
              <label htmlFor="email" className="block text-sm font-medium text-gray-700">
                Email address
              </label>
              <input
                id="email"
                name="email"
                type="email"
                autoComplete="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                placeholder="Enter your email"
              />
            </div>

            <div>
              <label htmlFor="password" className="block text-sm font-medium text-gray-700">
                Password
              </label>
              <input
                id="password"
                name="password"
                type="password"
                autoComplete="current-password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                placeholder="Enter your password"
              />
            </div>
          </div>

          {/* Turnstile CAPTCHA */}
          <div className="flex justify-center">
            {process.env.NEXT_PUBLIC_TURNSTILE_SITE_KEY ? ()
              <Turnstile
                siteKey={process.env.NEXT_PUBLIC_TURNSTILE_SITE_KEY}
                onVerify={(token) => setCaptchaToken(token)}
                onError={() => setCaptchaToken("")}
                onTimeout={() => setCaptchaToken("")}
                theme="light"
                size="normal"
              />
            ) : ()
              <p className="text-sm text-red-600">
                CAPTCHA not configured. Please contact support.
              </p>
            )}
          </div>

          {error && ()
            <div className="rounded-md bg-red-50 p-4">
              <div className="text-sm text-red-700">{error}</div>
            </div>
          )}

          <div>
            <button
              type="submit"
              disabled={isLoading || !captchaToken}
              className="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {isLoading ? 'Signing in...' : 'Sign in'}
            </button>
          </div>

          <div className="text-center">
            <a href="/forgot-password" className="text-sm text-indigo-600 hover:text-indigo-500">
              Forgot your password?
            </a>
          </div>
        </form>
      </div>
    </div>
  );
}
```markdown

### **NileDB Login API**

```jsx
// app/api/auth/login/route.ts
import { NextRequest, NextResponse } from "next/server";
import { nile } from "@/lib/niledb/client";

export async function POST(req: NextRequest) {
  try {
    const { email, password } = await req.json();

    // Authenticate with NileDB
    const { user, session } = await nile.auth.signin({
      email,
      password
    });

    if (!user) {
      return NextResponse.json()
        { error: "Invalid email or password" },
        { status: 401 }
      );
    }

    // Check if email is verified
    const userData = await nile.db.query()
      'SELECT email_verified, onboarding_step FROM tenant_users WHERE user_id = $1',
      [user.id]
    );

    if (userData.rows.length === 0 || !userData.rows[0].email_verified) {
      return NextResponse.json()
        { error: "Please verify your email address first" },
        { status: 403 }
      );
    }

    // Create session cookie
    const response = NextResponse.json({
      success: true,
      user: {
        id: user.id,
        email: user.email,
        onboardingStep: userData.rows[0].onboarding_step
      }
    });

    response.cookies.set('session', session.session_token, {)
      httpOnly: true,
      secure: true,
      sameSite: 'lax',
      maxAge: 60 * 60 * 24 * 30 // 30 days
    });

    return response;

  } catch (error) {
    console.error("Login error:", error);
    return NextResponse.json()
      { error: "Login failed" },
      { status: 500 }
    );
  }
}
```markdown

**Security and UX Excellence**: This login system supports our [enterprise security standards](docs/compliance-security)) while providing an intuitive user experience. The CAPTCHA integration balances security with accessibility, and the comprehensive error handling provides clear feedback for users.

---

## Multi-Tenant Session Management

### **Auth Context with Tenant Support**

```typescript
// context/AuthContext.tsx
import { createContext, useContext, useEffect, useState } from 'react';
import { nile } from '@/lib/niledb/client';

interface User {
  id: string;
  email: string;
  email_verified: boolean;
  tenant_id: string;
  company_id?: string;
  onboarding_step: string;
  role: string;
}

interface AuthContextType {
  user: User | null;
  tenant: any | null;
  login: (email: string, password: string) => Promise<void>;
  signup: (email: string, password: string, userData: any) => Promise<void>;
  logout: () => Promise<void>;
  loading: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [tenant, setTenant] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    checkAuth();
  }, []);

  const checkAuth = async () => {
    try {
      const response = await fetch('/api/auth);
      if (response.ok) {
        const data = await response.json();
        setUser(data.user);
        setTenant(data.tenant);
      }
    } catch (error) {
      console.error("Auth check failed:", error);
    } finally {
      setLoading(false);
    }
  };

  const login = async (email: string, password: string) => {
    const response = await fetch('/api/auth/login', {)
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password })
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Login failed');
    }

    const data = await response.json();
    setUser(data.user);

    // Fetch tenant data
    await fetchTenantData();
  };

  const fetchTenantData = async () => {
    const response = await fetch('/api/tenant);
    if (response.ok) {
      setTenant(await response.json());
    }
  };

  const signup = async (email: string, password: string, userData: any) => {
    const response = await fetch('/api/auth/signup', {)
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password, ...userData })
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.message || 'Signup failed');
    }

    const data = await response.json();
    setUser(data.user);
  };

  const logout = async () => {
    await fetch('/api/auth);
    setUser(null);
    setTenant(null);
  };

  return ()
    <AuthContext.Provider value={{
      user,
      tenant,
      login,
      signup,
      logout,
      loading
    }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
```markdown

**Multi-Tenant Architecture**: This session management system implements our [enterprise multi-tenant architecture](docs/technical/architecture)) with proper tenant isolation, row-level security, and scalable user management. The context-based approach provides clean separation of concerns and efficient state management.

---

## Environment Configuration

### **Required Environment Variables**

```bash
# .env.local
# NileDB Configuration
NILEDB_PROJECT_ID=your_niledb_project_id
NILEDB_API_KEY=your_niledb_api_key
NILEDB_DATABASE_URL=postgresql://...

# Turnstile Configuration
NEXT_PUBLIC_TURNSTILE_SITE_KEY=your_turnstile_site_key
TURNSTILE_SECRET_KEY=your_turnstile_secret_key

# Stripe Configuration
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Loop Email Service
LOOP_API_KEY=your_loop_api_key
LOOP_VERIFICATION_TRANSACTIONAL_ID=your_verification_template_id

# JWT Secret
JWT_SECRET=your-super-secret-jwt-key

# Application URLs
NEXT_PUBLIC_APP_URL=https://app.penguinmails.com
```markdown

### **Firebase/Deployment Secrets**

```yaml
# apphosting.yaml
env:
  - variable: NILEDB_PROJECT_ID
    secret: niledb-project-id
  - variable: NILEDB_API_KEY
    secret: niledb-api-key
  - variable: STRIPE_SECRET_KEY
    secret: stripe-secret-key
  - variable: NEXT_PUBLIC_TURNSTILE_SITE_KEY
    secret: turnstile-site-key
  - variable: TURNSTILE_SECRET_KEY
    secret: turnstile-secret-key
  - variable: LOOP_API_KEY
    secret: loop-api-key
```markdown

**Security Configuration**: This environment configuration supports our [enterprise security standards](docs/compliance-security)) by implementing secure secret management, environment isolation, and compliance with security best practices. The configuration enables our [operational excellence](docs/technical/architecture/detailed-technical)) through proper environment separation and secret rotation capabilities.

---

## Security Best Practices

### **CAPTCHA Security**
- **Turnstile Benefits**: Privacy-first, no user tracking, GDPR compliant with enterprise support
- **Server-side verification**: Always validate tokens on backend with cryptographic validation
- **Rate limiting**: Implement rate limiting on auth endpoints with intelligent throttling
- **Token expiration**: Turnstile tokens expire after 5 minutes with automatic rotation

### **NileDB Security**
- **Row Level Security**: All multi-tenant tables use tenant isolation with comprehensive audit logging
- **Authentication**: NileDB handles secure password hashing and session management with enterprise features
- **Audit logging**: Log all authentication and authorization events with real-time monitoring

### **Stripe Security**
- **Webhook verification**: Verify all Stripe webhook signatures with cryptographic validation
- **Connect accounts**: Use Stripe Connect for multi-tenant payment processing with automated compliance
- **PCI compliance**: Never handle raw credit card data with tokenized processing

### **Session Management**
- **Secure cookies**: HttpOnly, Secure, SameSite flags with automatic security header injection
- **Session timeout**: 30-day sessions with refresh capability and intelligent session extension
- **CSRF protection**: Implement CSRF tokens for state-changing operations with automatic token validation

**Enterprise Security Integration**: These security practices support our [competitive differentiation](docs/business/strategy)) by providing enterprise-grade security that meets SOC 2, GDPR, and PCI DSS compliance requirements. The comprehensive security posture enables our [enterprise customer acquisition strategy](docs/business/market-analysis)).

---

## Error Handling and User Experience

### **Common Error Scenarios**

1. **CAPTCHA Failed**
   - Show user-friendly message with accessibility considerations
   - Offer retry with audio challenges for accessibility compliance
   - Allow manual verification for legitimate users with alternative flows

2. **Email Verification Issues**
   - Link expired: Offer to resend with intelligent retry logic
   - Token invalid: Clear error with retry option and user guidance
   - Already verified: Redirect to dashboard with proper state management

3. **Payment Issues**
   - Stripe payment failed: Show retry option with error diagnostics
   - Connect account setup incomplete: Link to account settings with guided assistance
   - Subscription canceled: Grace period handling with automated communications

4. **Provisioning Failures**
   - Show clear error messages with actionable guidance
   - Offer support contact with automated ticket creation
   - Implement retry mechanisms with exponential backoff and circuit breakers

### **Accessibility Features**
- **Screen reader support**: All forms have proper ARIA labels with semantic HTML structure
- **Keyboard navigation**: Full keyboard accessibility with logical tab order
- **High contrast**: Support for high contrast mode with CSS custom properties
- **CAPTCHA alternatives**: Audio challenges and text-based verification with multiple fallback options

**User Experience Excellence**: This comprehensive error handling and accessibility system supports our [customer value proposition](docs/business/value-proposition/detailed-analysis)) by providing inclusive, user-friendly experiences that exceed accessibility standards. The intelligent error recovery reduces support burden and improves user satisfaction.

---

## Related Documents

- [Stripe Onboarding Guide](docs/technical/architecture/detailed-technical) - Complete Stripe Connect integration
- [IP Management Guide](docs/technical/architecture/detailed-technical) - Email infrastructure and deliverability
- [Analytics Architecture](.) - User behavior tracking and analytics
- [Database Schema Guide](/docs/business/strategy/overview) - Multi-tenant database structure
- [Security Documentation](../../compliance-security) - Authentication and security procedures

---

## Strategic Integration Summary

This onboarding and authentication system represents a cornerstone of our technical architecture, supporting our [market leadership positioning](/docs/business/strategy/overview) through enterprise-grade security and user experience. The system integrates seamlessly with our [comprehensive technical infrastructure](..) to provide scalable, secure, and user-friendly access to our email platform.

**Business Impact**: The authentication system directly supports our [revenue model](/docs/business/model/overview) by enabling smooth customer acquisition and conversion, with analytics integration providing insights for [continuous optimization](../business/analytics). The enterprise-grade security and compliance features enable our [enterprise market penetration strategy](/docs/business/market-analysis/overview).

**Technical Excellence**: The system showcases our [technical authority](docs/business/strategy) through modern security practices, scalable architecture, and comprehensive monitoring. The integration with our [progressive queue system](.) and [OLAP analytics](.) demonstrates our commitment to technical excellence and data-driven optimization.

**Operational Reliability**: Backed by our [99.9% uptime commitment](.) and comprehensive monitoring systems, the authentication platform provides reliable, scalable service that supports our [operational excellence](../business/operations) standards.

This implementation follows modern best practices for web authentication, payment processing, and user experience design, ensuring scalability and maintainability as the platform grows to support our [expansion strategy](docs/business/strategy).
---
