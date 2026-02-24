---
title: "Webhook Replay & Debugging"
description: "Tools and techniques for troubleshooting and recovering webhook data."
last_modified_date: "2026-02-24"
level: "2"
persona: "Developers"
---

# Webhook Replay & Debugging

PenguinMails provides integrated tools to help you develop and troubleshoot your webhook integrations.

## 1. Webhook Replay

If your server was down or a bug caused you to process events incorrectly, you can "replay" events from a specific timeframe.

- **Selective Replay**: Choose a specific event type (e.g., only `email.bounced`) or a specific date range.
- **Bulk Action**: Replay thousands of events with a single click.
- **Process**: Events are added to our delivery queue and sent to your endpoint just like original requests.

## 2. Request Inspector

View the full details of any webhook attempt.

- **Headers**: See exactly what headers were sent, including the signature.
- **Payload**: Inspect the exact JSON sent to your server.
- **Response**: Review the headers and body returned by your application to diagnose logic errors or 500 status codes.

## 3. Testing with a Debugger

Before pointing a webhook to your production server, use a tool like **Webhook.site** or **Beeceptor** to:

1. Generate a temporary test URL.
2. Configure a PenguinMails webhook to point to that URL.
3. Trigger an action (e.g., send a test email).
4. Inspect the payload and headers in the browser.

## 4. Local Development

To test webhooks on your local machine, use a tunneling service like **ngrok** or **Localtunnel** to expose your local port to the public internet:

```bash
ngrok http 3000
```

Then, use the generated `https://...` URL as your Webhook Endpoint URL.
