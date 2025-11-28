# Hostwinds Automation Best Practices

---

title: "Hostwinds API Automation Best Practices"
description: "Best practices and recommendations for reliable, secure, and efficient Hostwinds API automation"
last_modified_date: "2025-11-19"
level: "3"
persona: "Documentation Users"
---

**For Platform Engineers and Automation Teams**: Comprehensive guide to building reliable, secure, and efficient automation with the Hostwinds API

**Parent Documentation**: [Hostwinds API Overview](/docs/implementation-technical/api/hostwinds/overview)

---

## Error Handling and Logging

### Critical: Check the `result` Field

> [!CAUTION]
> **HTTP 200 Does Not Mean Success**: Hostwinds API returns HTTP 200 for both successful and failed requests. Always check the `result` field in the response body.

```javascript
const response = await fetch(HOSTWINDS_API_URL, {
  method: 'POST',
  body: formData
});

// ❌ WRONG: Assuming 200 = success
if (response.status === 200) {
  const data = await response.json();
  // Process data...
}

// ✅ CORRECT: Check result field
if (response.status === 200) {
  const data = await response.json();
  if (data.result === 'error') {
    throw new Error(`Hostwinds API Error: ${data.message}`);
  }
  // Process successful data...
}


```

---

### Error Response Handling

**Standard Error Format**:

```json
[
  {
    "result": "error",
    "action": "Add Instance",
    "message": "Location Id is invalid.",
    "ERROR": "342432"  // Optional internal code
  }
]


```

**Error Handling Strategy**:

1. **Prioritize the `result` and `message` Fields**:

   - Always check if `result === "error"`

   - Use the `message` field for human-readable debugging

   - Log the full error object for troubleshooting

2. **Handling Proprietary Error Codes**:

   - Log the internal `ERROR` code for Hostwinds support reference

   - **Do not** use this code to drive automation logic

   - Error codes may change without notice

3. **Client vs. Server Errors**:

   - **Client Data Errors**: Invalid input (e.g., "invalid serviceid", "Location Id is invalid")

     - **Do not retry** - Fix the input data

     - Log the error and alert developers

   - **Transient Errors**: Network issues or temporary server problems

     - **Implement exponential backoff**

     - **Retry up to 3 times**

     - Log retry attempts

---

### Logging Best Practices

```javascript
class HostwindsAPILogger {
  logRequest(action, params) {
    console.log({
      timestamp: new Date().toISOString(),
      type: 'request',
      action,
      params: this.sanitizeParams(params), // Remove API key
      correlationId: this.generateCorrelationId()
    });
  }
  
  logResponse(action, response, duration) {
    console.log({
      timestamp: new Date().toISOString(),
      type: 'response',
      action,
      result: response.result,
      message: response.message,
      duration,
      correlationId: this.getCurrentCorrelationId()
    });
  }
  
  logError(action, error, context) {
    console.error({
      timestamp: new Date().toISOString(),
      type: 'error',
      action,
      error: error.message,
      stack: error.stack,
      context,
      correlationId: this.getCurrentCorrelationId()
    });
  }
  
  sanitizeParams(params) {
    const sanitized = { ...params };
    delete sanitized.API; // Never log API keys
    return sanitized;
  }
}


```

---

## Workflow and State Management

### Service ID Validation

> [!IMPORTANT]
> **Always validate service IDs** before executing instance-specific operations.

```javascript
async function safeInstanceOperation(serviceid, operation) {
  // Step 1: Validate service ID exists
  const isValid = await checkServiceId(serviceid);
  if (!isValid) {
    throw new Error(`Invalid service ID: ${serviceid}`);
  }
  
  // Step 2: Get current instance state
  const instance = await getInstance(serviceid);
  if (instance.status === 'suspended') {
    throw new Error(`Instance ${serviceid} is suspended`);
  }
  
  // Step 3: Execute operation
  return await operation(serviceid);
}


```

---

### Asynchronous Operation Handling

Many Hostwinds operations are asynchronous. The success response only means the task was **queued**, not completed.

**Operations Requiring Polling**:

- `add_instance` - Server creation

- `recreate` - Server recreation

- `reinstall_instance` - OS reinstall

- `upgrade_server` - Resource upgrades

- `regenerate_networking` - Network rebuild

**Polling Strategy**:

```javascript
async function pollInstanceStatus(serviceid, expectedStatus, options = {}) {
  const {
    maxAttempts = 60,
    intervalMs = 30000, // 30 seconds
    timeoutMs = 1800000  // 30 minutes
  } = options;
  
  const startTime = Date.now();
  
  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    // Check timeout
    if (Date.now() - startTime > timeoutMs) {
      throw new Error(`Timeout waiting for status: ${expectedStatus}`);
    }
    
    // Get current status
    const instance = await getInstance(serviceid);
    
    // Check for error states
    if (instance.status === 'error') {
      throw new Error(`Instance entered error state: ${instance.disp_status}`);
    }
    
    // Check for expected status
    if (instance.status === expectedStatus) {
      return instance;
    }
    
    // Log progress
    console.log(`Attempt ${attempt}/${maxAttempts}: Status is ${instance.status}, waiting for ${expectedStatus}`);
    
    // Wait before next attempt
    await sleep(intervalMs);
  }
  
  throw new Error(`Max attempts reached waiting for status: ${expectedStatus}`);
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}


```

---

### Billing Workflow (Two-Step Process)

> [!WARNING]
> **Do not apply upgrades before invoice payment**. The two-step upgrade process requires invoice payment between steps.

```javascript
async function upgradeInstanceWorkflow(serviceid, rid) {
  // Step 1: Check for existing upgrade orders
  const existingOrder = await checkUpgradeOrder(serviceid);
  if (existingOrder.success) {
    throw new Error('Pending upgrade order exists. Complete or cancel it first.');
  }
  
  // Step 2: Create upgrade order and invoice
  const order = await upgradeInstance({ serviceid, rid });
  console.log(`Upgrade order created. Invoice ID: ${order.invoiceid}`);
  
  // Step 3: Wait for invoice payment (external process)
  // This could be manual payment or automated billing system
  await waitForInvoicePayment(order.invoiceid);
  
  // Step 4: Apply the upgrade
  const upgrade = await upgradeServer({ serviceid });
  
  // Step 5: Poll for RESIZED status
  const instance = await pollInstanceStatus(serviceid, 'RESIZED');
  
  // Step 6: Confirm the upgrade
  await confirmUpgrade(serviceid);
  
  // Step 7: Verify final status
  await pollInstanceStatus(serviceid, 'active');
  
  console.log(`Upgrade completed successfully for service ${serviceid}`);
}


```

---

## Security and Efficiency

### Secure Credential Storage

> [!CAUTION]
> **Never hardcode API keys** in source code or commit them to version control.

**Recommended Approaches**:

1. **Environment Variables**:

```javascript
// .env file (never commit this)
HOSTWINDS_API_KEY=your_api_key_here

// Application code
const apiKey = process.env.HOSTWINDS_API_KEY;
if (!apiKey) {
  throw new Error('HOSTWINDS_API_KEY environment variable not set');
}


```

1. **Secrets Manager** (AWS, Azure, GCP):

```javascript
const { SecretsManagerClient, GetSecretValueCommand } = require('@aws-sdk/client-secrets-manager');

async function getHostwindsAPIKey() {
  const client = new SecretsManagerClient({ region: 'us-east-1' });
  const response = await client.send(
    new GetSecretValueCommand({ SecretId: 'hostwinds/api-key' })
  );
  return JSON.parse(response.SecretString).apiKey;
}


```

1. **Encrypted Configuration**:

```javascript
const crypto = require('crypto');

function decryptAPIKey(encryptedKey, masterKey) {
  const decipher = crypto.createDecipher('aes-256-cbc', masterKey);
  let decrypted = decipher.update(encryptedKey, 'hex', 'utf8');
  decrypted += decipher.final('utf8');
  return decrypted;
}


```

---

### Input Validation

**Validate all inputs** before sending to Hostwinds API to avoid common errors.

```javascript
class HostwindsInputValidator {
  static validateServiceId(serviceid) {
    if (!serviceid || typeof serviceid !== 'number') {
      throw new Error('Invalid service ID: must be a number');
    }
    if (serviceid <= 0) {
      throw new Error('Invalid service ID: must be positive');
    }
    return serviceid;
  }
  
  static validateIPAddress(ip) {
    const ipRegex = /^(\d{1,3}\.){3}\d{1,3}$/;
    if (!ipRegex.test(ip)) {
      throw new Error(`Invalid IP address: ${ip}`);
    }
    // Validate each octet
    const octets = ip.split('.').map(Number);
    if (octets.some(octet => octet < 0 || octet > 255)) {
      throw new Error(`Invalid IP address: ${ip}`);
    }
    return ip;
  }
  
  static validateLocationId(locationId) {
    const validLocations = [1, 2, 3, 4, 5]; // Update with actual valid IDs
    if (!validLocations.includes(locationId)) {
      throw new Error(`Invalid location ID: ${locationId}`);
    }
    return locationId;
  }
  
  static validateHostname(hostname) {
    const hostnameRegex = /^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?(\.[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?)*$/i;
    if (!hostnameRegex.test(hostname)) {
      throw new Error(`Invalid hostname: ${hostname}`);
    }
    return hostname;
  }
}


```

---

### Rate Limiting

**Implement rate limiting** to prevent hitting Hostwinds API limits and causing transient errors.

```javascript
class RateLimiter {
  constructor(requestsPerSecond = 2) {
    this.requestsPerSecond = requestsPerSecond;
    this.lastRequestTime = 0;
    this.queue = [];
  }
  
  async throttle() {
    const now = Date.now();
    const timeSinceLastRequest = now - this.lastRequestTime;
    const minInterval = 1000 / this.requestsPerSecond;
    
    if (timeSinceLastRequest < minInterval) {
      const delay = minInterval - timeSinceLastRequest;
      await sleep(delay);
    }
    
    this.lastRequestTime = Date.now();
  }
  
  async execute(fn) {
    await this.throttle();
    return await fn();
  }
}

// Usage
const rateLimiter = new RateLimiter(2); // 2 requests per second

async function callHostwindsAPI(action, params) {
  return await rateLimiter.execute(async () => {
    return await hostwindsAPI(action, params);
  });
}


```

---

## Retry and Resilience Patterns

### Exponential Backoff

```javascript
async function exponentialBackoff(fn, options = {}) {
  const {
    maxRetries = 3,
    initialDelayMs = 1000,
    maxDelayMs = 30000,
    backoffMultiplier = 2
  } = options;
  
  let lastError;
  
  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error) {
      lastError = error;
      
      // Don't retry on client errors
      if (isClientError(error)) {
        throw error;
      }
      
      // Don't retry if max attempts reached
      if (attempt === maxRetries) {
        break;
      }
      
      // Calculate delay with exponential backoff
      const delay = Math.min(
        initialDelayMs * Math.pow(backoffMultiplier, attempt),
        maxDelayMs
      );
      
      console.log(`Attempt ${attempt + 1} failed. Retrying in ${delay}ms...`);
      await sleep(delay);
    }
  }
  
  throw new Error(`Max retries (${maxRetries}) exceeded. Last error: ${lastError.message}`);
}

function isClientError(error) {
  const clientErrorMessages = [
    'invalid serviceid',
    'Location Id is invalid',
    'A valid serviceid is required'
  ];
  return clientErrorMessages.some(msg => 
    error.message.toLowerCase().includes(msg.toLowerCase())
  );
}


```

---

### Circuit Breaker Pattern

```javascript
class CircuitBreaker {
  constructor(options = {}) {
    this.failureThreshold = options.failureThreshold || 5;
    this.resetTimeout = options.resetTimeout || 60000; // 1 minute
    this.state = 'CLOSED'; // CLOSED, OPEN, HALF_OPEN
    this.failureCount = 0;
    this.lastFailureTime = null;
  }
  
  async execute(fn) {
    if (this.state === 'OPEN') {
      if (Date.now() - this.lastFailureTime > this.resetTimeout) {
        this.state = 'HALF_OPEN';
      } else {
        throw new Error('Circuit breaker is OPEN');
      }
    }
    
    try {
      const result = await fn();
      this.onSuccess();
      return result;
    } catch (error) {
      this.onFailure();
      throw error;
    }
  }
  
  onSuccess() {
    this.failureCount = 0;
    this.state = 'CLOSED';
  }
  
  onFailure() {
    this.failureCount++;
    this.lastFailureTime = Date.now();
    
    if (this.failureCount >= this.failureThreshold) {
      this.state = 'OPEN';
      console.error(`Circuit breaker opened after ${this.failureCount} failures`);
    }
  }
}


```

---

## Integration Patterns

### Complete Automation Example

```javascript
class HostwindsAutomation {
  constructor(apiKey) {
    this.apiKey = apiKey;
    this.rateLimiter = new RateLimiter(2);
    this.circuitBreaker = new CircuitBreaker();
    this.logger = new HostwindsAPILogger();
  }
  
  async createAndConfigureInstance(config) {
    const { template, rid, locationId, srvrname, rdnsHostname } = config;
    
    try {
      // Step 1: Create instance
      this.logger.logRequest('add_instance', config);
      const createResponse = await this.callAPI('add_instance', {
        template,
        rid,
        location_id: locationId,
        srvrname
      });
      
      // Extract service ID from response
      const serviceid = createResponse.serviceid;
      
      // Step 2: Poll for active status
      const instance = await pollInstanceStatus(serviceid, 'active');
      
      // Step 3: Configure rDNS
      await this.callAPI('set_rdns', {
        serviceid,
        ip: instance.main_ip,
        rdns: rdnsHostname
      });
      
      // Step 4: Set firewall profile
      await this.callAPI('set_instance_firewall', {
        serviceid,
        name: 'smtp'
      });
      
      // Step 5: Update database
      await this.updateDatabase(serviceid, instance);
      
      return {
        serviceid,
        instance,
        status: 'configured'
      };
      
    } catch (error) {
      this.logger.logError('createAndConfigureInstance', error, config);
      throw error;
    }
  }
  
  async callAPI(action, params) {
    return await this.circuitBreaker.execute(async () => {
      return await this.rateLimiter.execute(async () => {
        return await exponentialBackoff(async () => {
          return await hostwindsAPI(action, { ...params, API: this.apiKey });
        });
      });
    });
  }
  
  async updateDatabase(serviceid, instance) {
    // Update vps_instances table
    await db.query(`
      INSERT INTO vps_instances (
        hostwinds_instance_id,
        main_ip,
        approximate_cost,
        status
      ) VALUES ($1, $2, $3, $4)
    `, [serviceid, instance.main_ip, 9.99, instance.status]);
  }
}


```

---

## Monitoring and Observability

### Metrics to Track

**API Performance**:

- Request latency (p50, p95, p99)

- Error rate by action

- Retry rate

- Circuit breaker state changes

**Business Metrics**:

- Instance creation success rate

- Average provisioning time

- Cost per instance

- API call volume by action

**Operational Metrics**:

- Failed validations

- Timeout rate

- Rate limit hits

- Polling duration

### Example Metrics Collection

```javascript
class MetricsCollector {
  constructor() {
    this.metrics = {
      requests: new Map(),
      errors: new Map(),
      latencies: []
    };
  }
  
  recordRequest(action, duration, success) {
    const key = `${action}_${success ? 'success' : 'error'}`;
    this.metrics.requests.set(key, (this.metrics.requests.get(key) || 0) + 1);
    this.metrics.latencies.push({ action, duration, timestamp: Date.now() });
  }
  
  recordError(action, errorType) {
    const key = `${action}_${errorType}`;
    this.metrics.errors.set(key, (this.metrics.errors.get(key) || 0) + 1);
  }
  
  getMetrics() {
    return {
      requests: Object.fromEntries(this.metrics.requests),
      errors: Object.fromEntries(this.metrics.errors),
      latency: this.calculateLatencyStats()
    };
  }
  
  calculateLatencyStats() {
    const latencies = this.metrics.latencies.map(l => l.duration);
    latencies.sort((a, b) => a - b);
    
    return {
      p50: latencies[Math.floor(latencies.length * 0.5)],
      p95: latencies[Math.floor(latencies.length * 0.95)],
      p99: latencies[Math.floor(latencies.length * 0.99)],
      avg: latencies.reduce((a, b) => a + b, 0) / latencies.length
    };
  }
}


```

---

## Related Documentation

- [Hostwinds API Overview](/docs/implementation-technical/api/hostwinds/overview) - Main API overview

- [Hostwinds Server Management API](/docs/implementation-technical/api/hostwinds/server-management ) - Instance operations

- [Hostwinds Networking API](/docs/implementation-technical/api/hostwinds/networking ) - IP and network management

- [Hostwinds Monitoring API](/docs/implementation-technical/api/hostwinds/monitoring ) - Monitoring and diagnostics

- [Development Standards](/implementation-technical/development-guidelines/README.md - General development best practices

---

**Keywords**: Hostwinds automation, API best practices, error handling, retry logic, rate limiting, security, resilience patterns
