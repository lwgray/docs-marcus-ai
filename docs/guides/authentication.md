# Authentication Guide

This guide covers authentication methods for accessing Marcus AI APIs and services.

## Overview

Marcus AI uses token-based authentication to secure API access. All API requests must include a valid authentication token.

## Authentication Methods

### API Token Authentication

The primary authentication method uses Bearer tokens:

```bash
curl -H "Authorization: Bearer YOUR_API_TOKEN" \
     https://api.marcus-ai.dev/v1/agents
```

### Obtaining API Tokens

#### Via Dashboard

1. Log in to your Marcus dashboard
2. Navigate to Settings > API Keys
3. Click "Generate New Token"
4. Copy and store the token securely

#### Via CLI

```bash
marcus auth login
# Enter your credentials
marcus auth token create --name "My App"
```

#### Via API

```bash
POST /auth/token
Content-Type: application/json

{
  "username": "your-username",
  "password": "your-password"
}
```

## Token Management

### Token Lifecycle

- **Access tokens** expire after 1 hour by default
- **Refresh tokens** are valid for 30 days
- Tokens can be revoked at any time

### Refreshing Tokens

```bash
POST /auth/refresh
Content-Type: application/json

{
  "refresh_token": "your-refresh-token"
}
```

### Revoking Tokens

```bash
POST /auth/revoke
Content-Type: application/json

{
  "token": "token-to-revoke"
}
```

## Security Best Practices

### Token Storage

- Never commit tokens to version control
- Use environment variables for tokens
- Rotate tokens regularly
- Use least-privilege principle

### Environment Variables

```bash
export MARCUS_API_TOKEN="your-token-here"
```

### Configuration Files

```yaml
# config.yml
marcus:
  api_token: ${MARCUS_API_TOKEN}
  api_url: https://api.marcus-ai.dev/v1
```

## OAuth 2.0 Integration

For third-party applications:

### Authorization Flow

1. Redirect users to authorization URL
2. User approves access
3. Receive authorization code
4. Exchange code for tokens

### Example Implementation

```python
from marcus.auth import OAuth2Client

client = OAuth2Client(
    client_id="your-client-id",
    client_secret="your-client-secret",
    redirect_uri="https://yourapp.com/callback"
)

# Get authorization URL
auth_url = client.get_authorization_url(
    scope=["read:agents", "write:tasks"]
)

# Exchange code for token
tokens = client.exchange_code(authorization_code)
```

## Service Account Authentication

For server-to-server communication:

### Creating Service Accounts

```bash
marcus auth service-account create \
  --name "production-worker" \
  --role "agent-runner"
```

### Using Service Account Keys

```python
from marcus import MarcusClient

client = MarcusClient(
    service_account_key="path/to/key.json"
)
```

## Multi-Factor Authentication

### Enabling MFA

1. Go to Account Settings
2. Enable Two-Factor Authentication
3. Scan QR code with authenticator app
4. Enter verification code

### API Usage with MFA

```bash
POST /auth/token
Content-Type: application/json

{
  "username": "your-username",
  "password": "your-password",
  "mfa_code": "123456"
}
```

## Role-Based Access Control

### Available Roles

- **Admin**: Full access
- **Developer**: Create and manage agents
- **Viewer**: Read-only access
- **Agent**: Limited to agent operations

### Checking Permissions

```python
# Check if user can perform action
if client.can("create:agent"):
    agent = client.agents.create(...)
```

## API Key Scopes

### Available Scopes

- `read:agents` - View agent information
- `write:agents` - Create/modify agents
- `read:tasks` - View tasks
- `write:tasks` - Create/modify tasks
- `admin:system` - System administration

### Creating Scoped Tokens

```bash
marcus auth token create \
  --name "limited-token" \
  --scopes "read:agents,read:tasks"
```

## Troubleshooting

### Common Issues

#### Invalid Token Error

```json
{
  "error": "invalid_token",
  "message": "The access token provided is expired, revoked, malformed, or invalid"
}
```

**Solution**: Refresh your token or obtain a new one

#### Insufficient Permissions

```json
{
  "error": "insufficient_scope",
  "message": "The request requires higher privileges"
}
```

**Solution**: Request appropriate scopes or contact admin

### Debug Authentication

Enable debug logging:

```python
import logging
logging.getLogger('marcus.auth').setLevel(logging.DEBUG)
```

## SDK Authentication

### Python SDK

```python
from marcus import MarcusClient

# API token
client = MarcusClient(api_key="your-api-key")

# OAuth
client = MarcusClient(
    oauth_token="your-oauth-token",
    oauth_refresh_token="your-refresh-token"
)
```

### JavaScript SDK

```javascript
import { MarcusClient } from '@marcus-ai/sdk';

// API token
const client = new MarcusClient({
  apiKey: 'your-api-key'
});

// OAuth
const client = new MarcusClient({
  oauthToken: 'your-oauth-token',
  oauthRefreshToken: 'your-refresh-token'
});
```

## Next Steps

- Set up [API Integration](../api/marcus-api.md)
- Configure [Production Security](production.md#security-configuration)
- Review [Security Best Practices](../marcus/systems/08-error-framework.md)