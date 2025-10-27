# PenguinMails User Onboarding and Authentication Flow

> **Status**: ✅ Current  
> **Last Updated**: October 28, 2025  
> **Owner**: Engineering Lead  
> **Version**: 2.0 (Updated for NileDB + Stripe Connect + Turnstile)

## 0. Architecture Overview

### **Current Tech Stack**
- **Authentication**: NileDB (PostgreSQL + built-in auth) with multi-tenant support
- **CAPTCHA**: Cloudflare Turnstile for bot protection
- **Payments**: Stripe Connect for multi-tenant billing and revenue sharing
- **Analytics**: PostgreSQL + PostHog for email analytics and user behavior tracking
- **Frontend**: Next.js with server-side rendering and API routes

### **Service Architecture**
- **Main App**: `app.penguinmails.com` (Next.js dashboard)
- **Auth Integration**: NileDB authentication with tenant isolation
- **Payment Processing**: Stripe Connect Express accounts for each tenant
- **Domain Management**: Custom domains with CNAME + SSL for tracking

---

## 1. Authentication Flow with NileDB

### **Landing → Authentication Check**

**User opens** `app.penguinmails.com`

→ **If not authenticated**: Redirect to signup/login modal (not separate page)
→ **If authenticated but not email verified**: Show verification prompt
→ **If authenticated and verified**: Check onboarding status → proceed or show onboarding modal

### **Onboarding Status Check**

Check user's onboarding state:
```typescript
interface OnboardingState {
  step: 'signup' | 'verify' | 'plan' | 'payment' | 'workspace' | 'provision' | 'complete';
  email_verified: boolean;
  payment_status: 'none' | 'pending' | 'completed' | 'failed';
  has_workspace: boolean;
  tenant_id: string;
  company_id: string;
}
```

---

## 2. Enhanced Sign-Up Flow

### **Sign-Up Modal Form**

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
- CAPTCHA: Turnstile token verification required

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

  return (
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
```

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
      return NextResponse.json(
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
      return NextResponse.json(
        { success: false, message: "CAPTCHA verification failed" }, 
        { status: 400 }
      );
    }

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error("Turnstile verification error:", error);
    return NextResponse.json(
      { success: false, message: "Internal server error" }, 
      { status: 500 }
    );
  }
}
```

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
    return NextResponse.json(
      { success: false, message: "Failed to create account" },
      { status: 400 }
    );
  }
}

async function sendVerificationEmail(email: string, userId: string) {
  const verificationToken = await generateJWT({ userId, email });
  
  await fetch('https://api.loopex.com/send-transactional', {
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
```

---

## 3. Email Verification with Magic Links

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
    <strong>{{6_digit_code}}</strong>
  </p>
  
  <p style="color: #6B7280; font-size: 14px;">
    Having trouble? <a href="https://app.penguinmails.com/verify">Enter the code manually</a>
  </p>
</div>
```

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
      return NextResponse.redirect('/verify?error=no-token');
    }

    // Verify JWT token
    const decoded = jwt.verify(token, process.env.JWT_SECRET!) as {
      userId: string;
      email: string;
    };

    // Check if token was already used
    const usedToken = await nile.db.query(
      'SELECT id FROM verification_tokens WHERE token = $1 AND used = true',
      [token]
    );

    if (usedToken.rows.length > 0) {
      // Token already used - redirect to dashboard
      return NextResponse.redirect(next);
    }

    // Mark email as verified
    await nile.db.query(
      'UPDATE tenant_users SET email_verified = true WHERE user_id = $1',
      [decoded.userId]
    );

    // Mark token as used
    await nile.db.query(
      'UPDATE verification_tokens SET used = true, used_at = CURRENT_TIMESTAMP WHERE token = $1',
      [token]
    );

    // Create session
    const session = await nile.auth.signin({
      email: decoded.email,
      callbackUrl: next
    });

    // Set session cookie
    const response = NextResponse.redirect(next);
    response.cookies.set('session', session.session_token, {
      httpOnly: true,
      secure: true,
      sameSite: 'lax',
      maxAge: 60 * 60 * 24 * 30 // 30 days
    });

    return response;

  } catch (error) {
    console.error("Verification error:", error);
    return NextResponse.redirect('/verify?error=invalid-token');
  }
}
```

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
        AND vt.expires_at > CURRENT_TIMESTAMP
    `, [email, code]);

    if (verification.rows.length === 0) {
      return NextResponse.json(
        { success: false, message: "Invalid or expired code" },
        { status: 400 }
      );
    }

    const { token, user_id } = verification.rows[0];

    // Use the same flow as magic link verification
    const response = NextResponse.json({ success: true });
    
    // Mark email verified and create session (similar to magic link flow)
    await nile.db.query('UPDATE tenant_users SET email_verified = true WHERE user_id = $1', [user_id]);
    await nile.db.query('UPDATE verification_tokens SET used = true WHERE token = $1', [token]);

    return response;

  } catch (error) {
    console.error("Code verification error:", error);
    return NextResponse.json(
      { success: false, message: "Verification failed" },
      { status: 500 }
    );
  }
}
```

---

## 4. Stripe Connect Onboarding Integration

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
    const response = await fetch('/api/stripe/create-checkout', {
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

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg p-6 max-w-md w-full mx-4">
        {currentStep === 'plan' && (
          <PlanSelection 
            plans={plans}
            onSelect={handlePlanSelect}
          />
        )}
        {currentStep === 'payment' && (
          <PaymentProcessing />
        )}
        {currentStep === 'workspace' && (
          <WorkspaceSetup />
        )}
        {currentStep === 'provision' && (
          <ProvisioningStatus />
        )}
      </div>
    </div>
  );
};
```

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
      return NextResponse.json(
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
    return NextResponse.json(
      { error: 'Failed to create checkout session' },
      { status: 500 }
    );
  }
}

async function createOrGetStripeAccount(tenantId: string, email: string) {
  // Check if Connect account already exists
  const existingAccount = await nile.db.query(
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
  await nile.db.query(
    `INSERT INTO company_stripe_accounts (
      tenant_id, stripe_account_id, status, created_at
    ) VALUES ($1, $2, 'pending', CURRENT_TIMESTAMP)`,
    [tenantId, account.id]
  );

  return account;
}
```

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
  await nile.db.query(
    `UPDATE tenants SET 
      payment_status = 'completed',
      onboarding_step = 'workspace',
      subscription_id = $1,
      updated_at = CURRENT_TIMESTAMP
     WHERE id = $2`,
    [session.subscription, tenantId]
  );

  // Create workspace record
  await nile.db.query(
    `INSERT INTO workspaces (
      tenant_id, name, slug, status, created_at
    ) VALUES ($1, 'My Workspace', $2, 'active', CURRENT_TIMESTAMP)
     ON CONFLICT (tenant_id) DO NOTHING`,
    [tenantId, `workspace-${tenantId.slice(0, 8)}`]
  );
}
```

---

## 5. Workspace Creation and Domain Provisioning

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
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/(^-|-$)/g, '');
  };

  const handleCreate = async () => {
    setIsCreating(true);
    
    try {
      const response = await fetch('/api/workspaces/create', {
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

  return (
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
```

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
        const response = await fetch('/api/provisioning/status');
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

  return (
    <div className="text-center space-y-6">
      <div className="w-16 h-16 mx-auto">
        {status === 'completed' ? (
          <CheckCircle className="w-full h-full text-green-500" />
        ) : (
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

      {status !== 'completed' && (
        <div className="space-y-4">
          <div className="w-full bg-gray-200 rounded-full h-2">
            <div 
              className="bg-indigo-600 h-2 rounded-full transition-all duration-500"
              style={{ width: `${currentStep.progress}%` }}
            ></div>
          </div>
          
          <p className="text-sm font-medium text-indigo-600">
            {currentStep.label}
          </p>
        </div>
      )}

      {status === 'completed' && (
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
```

---

## 6. Login Flow with Turnstile

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
      router.push("/dashboard");

    } catch (err) {
      console.error("Login failed:", err);
      setError(err.message || "Login failed. Please try again.");
    } finally {
      setIsLoading(false);
      setCaptchaToken(""); // Reset CAPTCHA token
    }
  };

  return (
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
            {process.env.NEXT_PUBLIC_TURNSTILE_SITE_KEY ? (
              <Turnstile
                siteKey={process.env.NEXT_PUBLIC_TURNSTILE_SITE_KEY}
                onVerify={(token) => setCaptchaToken(token)}
                onError={() => setCaptchaToken("")}
                onTimeout={() => setCaptchaToken("")}
                theme="light"
                size="normal"
              />
            ) : (
              <p className="text-sm text-red-600">
                CAPTCHA not configured. Please contact support.
              </p>
            )}
          </div>

          {error && (
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
```

### **NileDB Login API**

```typescript
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
      return NextResponse.json(
        { error: "Invalid email or password" },
        { status: 401 }
      );
    }

    // Check if email is verified
    const userData = await nile.db.query(
      'SELECT email_verified, onboarding_step FROM tenant_users WHERE user_id = $1',
      [user.id]
    );

    if (userData.rows.length === 0 || !userData.rows[0].email_verified) {
      return NextResponse.json(
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

    response.cookies.set('session', session.session_token, {
      httpOnly: true,
      secure: true,
      sameSite: 'lax',
      maxAge: 60 * 60 * 24 * 30 // 30 days
    });

    return response;

  } catch (error) {
    console.error("Login error:", error);
    return NextResponse.json(
      { error: "Login failed" },
      { status: 500 }
    );
  }
}
```

---

## 7. Multi-Tenant Session Management

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
      const response = await fetch('/api/auth/me');
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
    const response = await fetch('/api/auth/login', {
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
    const response = await fetch('/api/tenant/me');
    if (response.ok) {
      setTenant(await response.json());
    }
  };

  const signup = async (email: string, password: string, userData: any) => {
    const response = await fetch('/api/auth/signup', {
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
    await fetch('/api/auth/logout', { method: 'POST' });
    setUser(null);
    setTenant(null);
  };

  return (
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
```

---

## 8. Environment Configuration

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
```

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
```

---

## 9. Security Best Practices

### **CAPTCHA Security**
- **Turnstile Benefits**: Privacy-first, no user tracking, GDPR compliant
- **Server-side verification**: Always validate tokens on backend
- **Rate limiting**: Implement rate limiting on auth endpoints
- **Token expiration**: Turnstile tokens expire after 5 minutes

### **NileDB Security**
- **Row Level Security**: All multi-tenant tables use tenant isolation
- **Authentication**: NileDB handles secure password hashing and session management
- **Audit logging**: Log all authentication and authorization events

### **Stripe Security**
- **Webhook verification**: Verify all Stripe webhook signatures
- **Connect accounts**: Use Stripe Connect for multi-tenant payment processing
- **PCI compliance**: Never handle raw credit card data

### **Session Management**
- **Secure cookies**: HttpOnly, Secure, SameSite flags
- **Session timeout**: 30-day sessions with refresh capability
- **CSRF protection**: Implement CSRF tokens for state-changing operations

---

## 10. Error Handling and User Experience

### **Common Error Scenarios**

1. **CAPTCHA Failed**
   - Show user-friendly message
   - Offer retry with audio challenges for accessibility
   - Allow manual verification for legitimate users

2. **Email Verification Issues**
   - Link expired: Offer to resend
   - Token invalid: Clear error with retry option
   - Already verified: Redirect to dashboard

3. **Payment Issues**
   - Stripe payment failed: Show retry option
   - Connect account setup incomplete: Link to account settings
   - Subscription canceled: Grace period handling

4. **Provisioning Failures**
   - Show clear error messages
   - Offer support contact
   - Implement retry mechanisms

### **Accessibility Features**
- **Screen reader support**: All forms have proper ARIA labels
- **Keyboard navigation**: Full keyboard accessibility
- **High contrast**: Support for high contrast mode
- **CAPTCHA alternatives**: Audio challenges and text-based verification

---

## Related Documents

- [Stripe Onboarding Guide](stripe_onboarding_guide.md) - Complete Stripe Connect integration
- [IP Management Guide](ip_management_guide.md) - Email infrastructure and deliverability
- [Analytics Architecture](analytics_architecture.md) - User behavior tracking and analytics
- [Database Schema Guide](database_schema_guide.md) - Multi-tenant database structure
- [Security Documentation](security_documentation.md) - Authentication and security procedures

---

## Conclusion

This updated onboarding flow integrates the current PenguinMails architecture with NileDB authentication, Turnstile CAPTCHA protection, and Stripe Connect payment processing. The flow provides a seamless user experience while maintaining security, compliance, and multi-tenant isolation requirements.

The implementation follows modern best practices for web authentication, payment processing, and user experience design, ensuring scalability and maintainability as the platform grows.