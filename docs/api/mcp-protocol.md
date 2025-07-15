# MCP Protocol Reference

The Marcus Communication Protocol (MCP) enables real-time communication between Marcus components and external systems.

## Overview

MCP is a WebSocket-based protocol that provides:
- Bidirectional communication
- Event streaming
- Command execution
- State synchronization

## Connection

### WebSocket Endpoint

```
ws://localhost:3000/ws
wss://marcus.example.com/ws  # For SSL
```

### Authentication

```javascript
const ws = new WebSocket('ws://localhost:3000/ws');

ws.onopen = () => {
  ws.send(JSON.stringify({
    type: 'auth',
    token: 'your-auth-token'
  }));
};
```

### Connection Options

```javascript
const options = {
  reconnect: true,
  reconnectInterval: 5000,
  maxReconnectAttempts: 10,
  heartbeatInterval: 30000
};
```

## Message Format

All messages follow this structure:

```typescript
interface MCPMessage {
  id: string;          // Unique message ID
  type: string;        // Message type
  topic: string;       // Topic/channel
  payload: any;        // Message data
  timestamp: number;   // Unix timestamp
  metadata?: {         // Optional metadata
    correlationId?: string;
    userId?: string;
    source?: string;
  };
}
```

## Message Types

### System Messages

#### Heartbeat
```json
{
  "type": "heartbeat",
  "topic": "system",
  "payload": {
    "timestamp": 1704067200000
  }
}
```

#### Authentication
```json
{
  "type": "auth",
  "topic": "system",
  "payload": {
    "token": "jwt-token-here",
    "clientId": "client-123"
  }
}
```

#### Error
```json
{
  "type": "error",
  "topic": "system",
  "payload": {
    "code": "AUTH_FAILED",
    "message": "Invalid authentication token",
    "details": {}
  }
}
```

### Agent Messages

#### Agent Status Update
```json
{
  "type": "agent.status",
  "topic": "agents",
  "payload": {
    "agentId": "agent-123",
    "status": "active",
    "capabilities": ["code", "research"],
    "currentTask": "task-456"
  }
}
```

#### Agent Event
```json
{
  "type": "agent.event",
  "topic": "agents",
  "payload": {
    "agentId": "agent-123",
    "event": "task_completed",
    "data": {
      "taskId": "task-456",
      "result": "success",
      "output": "Task completed successfully"
    }
  }
}
```

### Task Messages

#### Task Created
```json
{
  "type": "task.created",
  "topic": "tasks",
  "payload": {
    "taskId": "task-789",
    "title": "Analyze codebase",
    "description": "Perform security analysis",
    "priority": "high",
    "assignedTo": "agent-123"
  }
}
```

#### Task Progress
```json
{
  "type": "task.progress",
  "topic": "tasks",
  "payload": {
    "taskId": "task-789",
    "progress": 65,
    "status": "in_progress",
    "currentStep": "Scanning dependencies"
  }
}
```

#### Task Completed
```json
{
  "type": "task.completed",
  "topic": "tasks",
  "payload": {
    "taskId": "task-789",
    "result": "success",
    "output": {
      "vulnerabilities": 0,
      "codeQuality": "A",
      "report": "https://..."
    },
    "duration": 3600
  }
}
```

### Control Messages

#### Pause Agent
```json
{
  "type": "control.pause",
  "topic": "control",
  "payload": {
    "targetId": "agent-123",
    "reason": "Resource limit reached"
  }
}
```

#### Resume Agent
```json
{
  "type": "control.resume",
  "topic": "control",
  "payload": {
    "targetId": "agent-123"
  }
}
```

#### Cancel Task
```json
{
  "type": "control.cancel",
  "topic": "control",
  "payload": {
    "taskId": "task-789",
    "reason": "User requested cancellation"
  }
}
```

## Topics/Channels

### Available Topics

| Topic | Description | Message Types |
|-------|-------------|---------------|
| `system` | System-level events | heartbeat, error, auth |
| `agents` | Agent-related events | status, event, metrics |
| `tasks` | Task lifecycle events | created, progress, completed |
| `control` | Control commands | pause, resume, cancel |
| `metrics` | Performance metrics | cpu, memory, throughput |
| `logs` | Log streaming | debug, info, warning, error |

### Subscribing to Topics

```javascript
// Subscribe to specific topics
ws.send(JSON.stringify({
  type: 'subscribe',
  topics: ['agents', 'tasks']
}));

// Unsubscribe
ws.send(JSON.stringify({
  type: 'unsubscribe',
  topics: ['logs']
}));
```

## Request-Response Pattern

For synchronous operations:

```javascript
// Request
ws.send(JSON.stringify({
  id: 'req-123',
  type: 'request',
  topic: 'agents',
  payload: {
    method: 'getStatus',
    params: { agentId: 'agent-123' }
  }
}));

// Response
{
  "id": "req-123",
  "type": "response",
  "topic": "agents",
  "payload": {
    "status": "success",
    "data": {
      "agentId": "agent-123",
      "status": "active",
      "uptime": 3600
    }
  }
}
```

## Error Handling

### Error Codes

| Code | Description |
|------|-------------|
| `AUTH_FAILED` | Authentication failed |
| `INVALID_MESSAGE` | Message format invalid |
| `TOPIC_NOT_FOUND` | Topic doesn't exist |
| `RATE_LIMIT` | Rate limit exceeded |
| `INTERNAL_ERROR` | Server error |

### Error Response Format

```json
{
  "type": "error",
  "topic": "system",
  "payload": {
    "code": "INVALID_MESSAGE",
    "message": "Missing required field: type",
    "details": {
      "field": "type",
      "received": null
    },
    "requestId": "req-123"
  }
}
```

## Client Libraries

### JavaScript/TypeScript

```typescript
import { MCPClient } from '@marcus-ai/mcp-client';

const client = new MCPClient({
  url: 'ws://localhost:3000/ws',
  auth: { token: 'your-token' }
});

client.on('agent.status', (data) => {
  console.log('Agent status:', data);
});

client.subscribe(['agents', 'tasks']);
```

### Python

```python
from marcus_mcp import MCPClient

client = MCPClient(
    url='ws://localhost:3000/ws',
    auth_token='your-token'
)

@client.on('agent.status')
def handle_agent_status(data):
    print(f"Agent status: {data}")

client.subscribe(['agents', 'tasks'])
client.connect()
```

### Go

```go
import "github.com/marcus-ai/mcp-go"

client := mcp.NewClient(mcp.Config{
    URL:   "ws://localhost:3000/ws",
    Token: "your-token",
})

client.On("agent.status", func(data interface{}) {
    fmt.Printf("Agent status: %v\n", data)
})

client.Subscribe([]string{"agents", "tasks"})
client.Connect()
```

## Best Practices

### Message Handling

1. **Always validate messages**:
   ```javascript
   function validateMessage(message) {
     if (!message.type || !message.topic) {
       throw new Error('Invalid message format');
     }
   }
   ```

2. **Implement timeout handling**:
   ```javascript
   const timeout = setTimeout(() => {
     throw new Error('Request timeout');
   }, 30000);
   ```

3. **Use correlation IDs**:
   ```javascript
   const correlationId = generateId();
   ws.send(JSON.stringify({
     ...message,
     metadata: { correlationId }
   }));
   ```

### Connection Management

1. **Implement reconnection logic**:
   ```javascript
   let reconnectAttempts = 0;
   
   function reconnect() {
     if (reconnectAttempts < maxAttempts) {
       setTimeout(() => {
         connect();
         reconnectAttempts++;
       }, reconnectInterval);
     }
   }
   ```

2. **Handle connection state**:
   ```javascript
   const states = {
     CONNECTING: 0,
     OPEN: 1,
     CLOSING: 2,
     CLOSED: 3
   };
   ```

### Performance

1. **Batch messages when possible**:
   ```javascript
   const batch = [];
   
   function sendBatch() {
     if (batch.length > 0) {
       ws.send(JSON.stringify({
         type: 'batch',
         messages: batch
       }));
       batch.length = 0;
     }
   }
   ```

2. **Implement backpressure**:
   ```javascript
   if (ws.bufferedAmount > threshold) {
     // Wait before sending more
     await waitForDrain();
   }
   ```

## Security Considerations

### Authentication

- Use JWT tokens with expiration
- Implement token refresh mechanism
- Validate tokens on each message

### Encryption

- Always use WSS in production
- Implement end-to-end encryption for sensitive data

### Rate Limiting

- Implement client-side rate limiting
- Handle rate limit errors gracefully

## Troubleshooting

### Common Issues

1. **Connection drops frequently**
   - Check network stability
   - Verify heartbeat configuration
   - Review server logs

2. **Messages not received**
   - Confirm topic subscription
   - Check message format
   - Verify authentication

3. **High latency**
   - Monitor network latency
   - Check message size
   - Review server performance

### Debug Mode

Enable debug logging:

```javascript
const client = new MCPClient({
  debug: true,
  logLevel: 'verbose'
});
```

## Next Steps

- Explore [Marcus API](marcus-api.md)
- Read [Integration Guide](../guides/integration.md)
- View [Examples](https://github.com/marcus-ai/mcp-examples)