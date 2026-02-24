---
title: "Interactive Docs UI"
description: "Design for the documentation browser, code snippets, and live API tester interface."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers, Designers"
---

# Interactive Docs UI

**Enabling developers to explore and test the PenguinMails API directly in the browser.**

---

## 1. Documentation Browser

A structured layout for navigating API references and guides.

### Navigation Sidebar

- **Quick Start**: Auth, Rate Limits, Errors.
- **Endpoint Groups**: Emails, Campaigns, Contacts, Analytics.
- **Resources**: SDKs, Webhook events, Changelog.

### Content Tabs

Each endpoint includes:

- **Specifications**: Path, Headers, Body params.
- **Examples**: Language-specific code snippets (cURL, Node, Python).
- **Responses**: Standard Success and Error JSON payloads.

---

## 2. Live API Tester

A "Try it out" feature allowing developers to make real requests using their own keys.

### Features

- **Key Selector**: Dropdown to select one of the user's active keys.
- **JSON Editor**: Integrated editor with syntax validation for the request body.
- **Live Console**: Displays status code, headers, and the raw JSON response.

---

## 3. SDK & Code Generator

- **Language Support**: Tabs for cURL, Node.js (TypeScript), Python, Ruby, and PHP.
- **Dynamic Insertion**: When a user is logged in and selects a key, code snippets are auto-populated with that key (masked) for easy copy-pasting.
- **Installation Helpers**: One-click copy for `npm install` or `pip install` commands.
