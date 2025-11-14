# Developer Quick Start Templates

## Language-Specific Templates

### Python Templates

#### Basic Email Campaign Script
```python
#!/usr/bin/env python3
"""
Basic PenguinMails email campaign template
"""

from penguinmails import Client
import json
from datetime import datetime

def create_basic_campaign():
    """Create a basic email campaign"""
    client = Client(api_key="YOUR_API_KEY")
    
    campaign = {
        "name": "Welcome Campaign",
        "subject": "Welcome to PenguinMails!",
        "template_id": "welcome-template",
        "audience": {
            "segment_id": "new_subscribers"
        },
        "schedule": {
            "type": "immediate"
        }
    }
    
    result = client.campaigns.create(campaign)
    return result

# Usage
campaign = create_basic_campaign()
print(f"Campaign created: {campaign['id']}")
```

#### Flask/FastAPI Integration Example
```python
from flask import Flask, request, jsonify
from penguinmails import Client
import os

app = Flask(__name__)
client = Client(api_key=os.getenv("PENGUINMAILS_API_KEY"))

@app.route('/send-welcome', methods=['POST'])
def send_welcome_email():
    """Send welcome email to new user"""
    data = request.json
    email = data.get('email')
    name = data.get('name')
    
    try:
        campaign = client.campaigns.send_immediate({
            "template_id": "welcome-template",
            "recipient": email,
            "variables": {
                "name": name,
                "company": "PenguinMails"
            }
        })
        
        return jsonify({"success": True, "campaign_id": campaign['id']})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 400

if __name__ == '__main__':
    app.run(debug=True)
```

### JavaScript/Node.js Templates

#### Express.js Integration Template
```javascript
const express = require('express');
const { PenguinMails } = require('penguinmails-sdk');

const app = express();
app.use(express.json());

const client = new PenguinMails({
  apiKey: process.env.PENGUINMAILS_API_KEY
});

// Send notification email
app.post('/send-notification', async (req, res) => {
  const { email, message, type } = req.body;
  
  try {
    const result = await client.campaigns.sendImmediate({
      templateId: 'notification-template',
      recipient: email,
      variables: {
        message,
        type,
        timestamp: new Date().toISOString()
      }
    });
    
    res.json({ success: true, campaignId: result.id });
  } catch (error) {
    res.status(400).json({ success: false, error: error.message });
  }
});

// Campaign creation endpoint
app.post('/create-campaign', async (req, res) => {
  const { name, subject, templateId, segmentId } = req.body;
  
  try {
    const campaign = await client.campaigns.create({
      name,
      subject,
      templateId,
      audience: {
        segmentId
      },
      schedule: {
        type: 'scheduled',
        time: new Date(Date.now() + 24 * 60 * 60 * 1000) // 24 hours from now
      }
    });
    
    res.json({ success: true, campaign });
  } catch (error) {
    res.status(400).json({ success: false, error: error.message });
  }
});

app.listen(3000, () => {
  console.log('PenguinMails integration server running on port 3000');
});
```

#### Next.js Component Example
```jsx
'use client';

import { useState } from 'react';

export default function EmailCampaignManager() {
  const [campaign, setCampaign] = useState({
    name: '',
    subject: '',
    templateId: '',
    scheduledDate: ''
  });
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    
    try {
      const response = await fetch('/api/create-campaign', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(campaign)
      });
      
      const result = await response.json();
      if (result.success) {
        alert('Campaign created successfully!');
      } else {
        alert('Error creating campaign: ' + result.error);
      }
    } catch (error) {
      alert('Error: ' + error.message);
    }
    
    setIsLoading(false);
  };

  return (
    <div className="max-w-md mx-auto p-6">
      <h1 className="text-2xl font-bold mb-4">Create Email Campaign</h1>
      
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium mb-1">Campaign Name</label>
          <input
            type="text"
            value={campaign.name}
            onChange={(e) => setCampaign({...campaign, name: e.target.value})}
            className="w-full border rounded px-3 py-2"
            required
          />
        </div>
        
        <div>
          <label className="block text-sm font-medium mb-1">Subject</label>
          <input
            type="text"
            value={campaign.subject}
            onChange={(e) => setCampaign({...campaign, subject: e.target.value})}
            className="w-full border rounded px-3 py-2"
            required
          />
        </div>
        
        <button
          type="submit"
          disabled={isLoading}
          className="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600 disabled:opacity-50"
        >
          {isLoading ? 'Creating...' : 'Create Campaign'}
        </button>
      </form>
    </div>
  );
}
```

### PHP Templates

#### Laravel Integration Example
```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use PenguinMails\PenguinMailsService;

class CampaignController extends Controller
{
    protected $penguinMails;

    public function __construct(PenguinMailsService $penguinMails)
    {
        $this->penguinMails = $penguinMails;
    }

    public function sendWelcomeEmail(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'name' => 'required|string'
        ]);

        try {
            $result = $this->penguinMails->sendImmediate([
                'template_id' => 'welcome-template',
                'recipient' => $request->email,
                'variables' => [
                    'name' => $request->name,
                    'company' => 'PenguinMails',
                    'timestamp' => now()->toISOString()
                ]
            ]);

            return response()->json([
                'success' => true,
                'campaign_id' => $result['id']
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 400);
        }
    }

    public function createCampaign(Request $request)
    {
        $request->validate([
            'name' => 'required|string',
            'subject' => 'required|string',
            'template_id' => 'required|string',
            'segment_id' => 'required|string'
        ]);

        try {
            $campaign = $this->penguinMails->createCampaign([
                'name' => $request->name,
                'subject' => $request->subject,
                'template_id' => $request->template_id,
                'audience' => [
                    'segment_id' => $request->segment_id
                ],
                'schedule' => [
                    'type' => 'scheduled',
                    'time' => now()->addDay()->toISOString()
                ]
            ]);

            return response()->json([
                'success' => true,
                'campaign' => $campaign
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 400);
        }
    }
}
```

### Go Templates

#### Microservice Integration
```go
package main

import (
    "encoding/json"
    "fmt"
    "net/http"
    "time"

    "github.com/penguinmails/sdk-go"
)

type CampaignRequest struct {
    Name        string `json:"name"`
    Subject     string `json:"subject"`
    TemplateID  string `json:"template_id"`
    SegmentID   string `json:"segment_id"`
    ScheduleTime string `json:"schedule_time,omitempty"`
}

type EmailRequest struct {
    Email       string `json:"email"`
    TemplateID  string `json:"template_id"`
    Variables   map[string]interface{} `json:"variables"`
}

func main() {
    client := penguinmails.NewClient(&penguinmails.Config{
        APIKey: "your-api-key",
        BaseURL: "https://api.penguinmails.com",
    })

    http.HandleFunc("/send-email", func(w http.ResponseWriter, r *http.Request) {
        var req EmailRequest
        if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
            http.Error(w, err.Error(), 400)
            return
        }

        result, err := client.Campaigns.SendImmediate(&penguinmails.SendRequest{
            TemplateID: req.TemplateID,
            Recipient:  req.Email,
            Variables:  req.Variables,
        })

        if err != nil {
            http.Error(w, err.Error(), 400)
            return
        }

        json.NewEncoder(w).Encode(map[string]interface{}{
            "success": true,
            "campaign_id": result.ID,
        })
    })

    http.HandleFunc("/create-campaign", func(w http.ResponseWriter, r *http.Request) {
        var req CampaignRequest
        if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
            http.Error(w, err.Error(), 400)
            return
        }

        scheduleTime := time.Now()
        if req.ScheduleTime != "" {
            if parsedTime, err := time.Parse(time.RFC3339, req.ScheduleTime); err == nil {
                scheduleTime = parsedTime
            }
        }

        campaign := &penguinmails.Campaign{
            Name:       req.Name,
            Subject:    req.Subject,
            TemplateID: req.TemplateID,
            Audience: penguinmails.Audience{
                SegmentID: req.SegmentID,
            },
            Schedule: penguinmails.Schedule{
                Type: penguinmails.Scheduled,
                Time: &scheduleTime,
            },
        }

        result, err := client.Campaigns.Create(campaign)
        if err != nil {
            http.Error(w, err.Error(), 400)
            return
        }

        json.NewEncoder(w).Encode(map[string]interface{}{
            "success": true,
            "campaign": result,
        })
    })

    fmt.Println("PenguinMails integration server running on :8080")
    http.ListenAndServe(":8080", nil)
}
```

## Development Workflow Templates

### Environment Setup Template
```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - PENGUINMAILS_API_KEY=${PENGUINMAILS_API_KEY}
      - PENGUINMAILS_ENV=${PENGUINMAILS_ENV:-sandbox}
    volumes:
      - .:/app
      - /app/node_modules

  # Optional: Redis for queue management
  redis:
    image: redis:alpine
    ports:
      - "6379:6379"
```

### Package.json Template
```json
{
  "name": "penguinmails-integration",
  "version": "1.0.0",
  "description": "PenguinMails Email Campaign Integration",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js",
    "test": "jest",
    "test:watch": "jest --watch",
    "lint": "eslint .",
    "build": "webpack --mode production"
  },
  "dependencies": {
    "penguinmails-sdk": "^1.0.0",
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^7.0.0",
    "dotenv": "^16.3.1",
    "winston": "^3.10.0"
  },
  "devDependencies": {
    "nodemon": "^3.0.1",
    "jest": "^29.6.4",
    "supertest": "^6.3.3",
    "eslint": "^8.47.0"
  },
  "engines": {
    "node": ">=16.0.0",
    "npm": ">=8.0.0"
  }
}
```

### Configuration Template
```javascript
// config/penguinmails.js
module.exports = {
  development: {
    apiKey: process.env.PENGUINMAILS_API_KEY,
    baseURL: 'https://api.penguinmails.com',
    timeout: 30000,
    retries: 3,
    rateLimit: {
      requests: 100,
      period: 60000 // 1 minute
    }
  },
  production: {
    apiKey: process.env.PENGUINMAILS_API_KEY,
    baseURL: 'https://api.penguinmails.com',
    timeout: 30000,
    retries: 3,
    rateLimit: {
      requests: 1000,
      period: 60000
    }
  }
};
```

## Cross-Domain Integration Requirements

### Sales Integration
- **CRM System Coordination**: Synchronize campaign data with CRM systems
- **Lead Attribution**: Track email campaign engagement for sales pipeline attribution
- **Sales Alert Integration**: Send alerts for high-value prospect engagement

### Marketing Integration  
- **Campaign Performance Analytics**: Coordinate with marketing analytics platforms
- **Customer Segment Sync**: Real-time synchronization of customer segments
- **Cross-Channel Coordination**: Coordinate email with other marketing channels

### Customer Success Integration
- **Health Score Correlation**: Link email engagement to customer health scores
- **Success Campaign Coordination**: Coordinate email campaigns with success initiatives
- **Retention Campaign Automation**: Automate retention campaigns based on customer signals

### Finance Integration
- **Revenue Attribution**: Track revenue attribution from email campaigns
- **Cost Allocation**: Allocate marketing costs to appropriate budget categories
- **ROI Tracking**: Coordinate email campaign ROI with financial reporting

## Quick Start Checklist

- [ ] Set up development environment with Docker
- [ ] Configure API keys and environment variables
- [ ] Install and configure PenguinMails SDK
- [ ] Test basic email sending functionality
- [ ] Set up error handling and logging
- [ ] Configure rate limiting and retry logic
- [ ] Implement cross-domain integrations
- [ ] Set up monitoring and alerting
- [ ] Configure production deployment
- [ ] Implement comprehensive testing

This template library provides developers with proven starting points for PenguinMails integration across multiple languages and frameworks.