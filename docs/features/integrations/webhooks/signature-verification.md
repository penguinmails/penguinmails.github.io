---
title: "Webhook Signature Verification"
description: "Securing your webhook endpoint by verifying the authenticity of incoming requests."
last_modified_date: "2026-02-24"
level: "2"
persona: "Developers"
---

# Webhook Signature Verification

To ensure that incoming requests are actually from PenguinMails and haven't been tampered with, we sign every payload with a secret key unique to each webhook.

## 1. Obtain Your Secret

When you create or edit a webhook in the dashboard, you will find a **Secret Key** (e.g., `whsec_abc123...`). Keep this secret secure in your environment variables.

## 2. Verification Protocol

PenguinMails includes an `X-PenguinMails-Signature` header in every request. The signature is an HMAC-SHA256 hash of the raw request body.

**Verification Steps:**

1. Retrieve the signature from the `X-PenguinMails-Signature` header.
2. Compute the HMAC-SHA256 signature using your secret key and the raw (unparsed) request body.
3. Compare your computed signature with the header signature using a timing-safe comparison function.

## 3. Implementation Example (Node.js)

```javascript
const crypto = require('crypto');

function verifySignature(payload, signature, secret) {
  const hmac = crypto.createHmac('sha256', secret);
  hmac.update(payload); // use the raw buffer/string body
  const expected = `sha256=${hmac.digest('hex')}`;
  
  // Use timingSafeEqual to prevent timing attacks
  return crypto.timingSafeEqual(
    Buffer.from(expected),
    Buffer.from(signature)
  );
}
```

## Security Best Practices

- **Use Raw Bodies**: Always verify using the raw request body before it is parsed into a JSON object to avoid issues with whitespace or property ordering.
- **Timing Safety**: Always use a timing-safe comparison function (like `crypto.timingSafeEqual`) when comparing signatures.
- **Secret Rotation**: Rotate your webhook secret if you suspect it has been compromised.
