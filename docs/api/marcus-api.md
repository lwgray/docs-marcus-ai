# Marcus API Reference

Complete API reference for Marcus AI orchestration platform.

## Base URL

```
Development: http://localhost:8000/api/v1
Production: https://api.marcus-ai.dev/v1
```

## Authentication

All API requests require authentication using Bearer tokens:

```bash
curl -H "Authorization: Bearer YOUR_API_TOKEN" \
     https://api.marcus-ai.dev/v1/agents
```

### Obtaining a Token

```bash
POST /auth/token
Content-Type: application/json

{
  "username": "your-username",
  "password": "your-password"
}
```

Response:
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "token_type": "bearer",
  "expires_in": 3600,
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

## Agents API

### List Agents

```bash
GET /agents
```

Query Parameters:
- `status` - Filter by status (active, idle, offline)
- `capability` - Filter by capability
- `limit` - Number of results (default: 20)
- `offset` - Pagination offset

Response:
```json
{
  "agents": [
    {
      "id": "agent-123",
      "name": "research_agent",
      "status": "active",
      "capabilities": ["web_search", "analysis"],
      "current_task": "task-456",
      "created_at": "2024-01-15T10:00:00Z",
      "last_seen": "2024-01-15T14:30:00Z"
    }
  ],
  "total": 42,
  "limit": 20,
  "offset": 0
}
```

### Get Agent Details

```bash
GET /agents/{agent_id}
```

Response:
```json
{
  "id": "agent-123",
  "name": "research_agent",
  "status": "active",
  "capabilities": ["web_search", "analysis"],
  "configuration": {
    "max_concurrent_tasks": 5,
    "timeout": 3600,
    "memory_limit": "4GB"
  },
  "metrics": {
    "tasks_completed": 156,
    "success_rate": 0.95,
    "avg_completion_time": 300
  },
  "current_task": {
    "id": "task-456",
    "title": "Market research",
    "progress": 65
  }
}
```

### Create Agent

```bash
POST /agents
Content-Type: application/json

{
  "name": "code_reviewer",
  "capabilities": ["code_analysis", "testing"],
  "configuration": {
    "language_support": ["python", "javascript"],
    "max_file_size": "10MB"
  }
}
```

Response:
```json
{
  "id": "agent-789",
  "name": "code_reviewer",
  "status": "initializing",
  "capabilities": ["code_analysis", "testing"],
  "created_at": "2024-01-15T15:00:00Z"
}
```

### Update Agent

```bash
PUT /agents/{agent_id}
Content-Type: application/json

{
  "configuration": {
    "max_concurrent_tasks": 10,
    "priority": "high"
  }
}
```

### Delete Agent

```bash
DELETE /agents/{agent_id}
```

### Agent Actions

#### Pause Agent
```bash
POST /agents/{agent_id}/pause
```

#### Resume Agent
```bash
POST /agents/{agent_id}/resume
```

#### Restart Agent
```bash
POST /agents/{agent_id}/restart
```

## Tasks API

### List Tasks

```bash
GET /tasks
```

Query Parameters:
- `status` - Filter by status (pending, in_progress, completed, failed)
- `agent_id` - Filter by assigned agent
- `priority` - Filter by priority (low, medium, high, critical)
- `created_after` - ISO 8601 timestamp
- `created_before` - ISO 8601 timestamp

Response:
```json
{
  "tasks": [
    {
      "id": "task-123",
      "title": "Analyze security vulnerabilities",
      "description": "Scan codebase for security issues",
      "status": "in_progress",
      "priority": "high",
      "assigned_to": "agent-456",
      "progress": 45,
      "created_at": "2024-01-15T10:00:00Z",
      "started_at": "2024-01-15T10:05:00Z"
    }
  ],
  "total": 128,
  "stats": {
    "pending": 23,
    "in_progress": 5,
    "completed": 95,
    "failed": 5
  }
}
```

### Get Task Details

```bash
GET /tasks/{task_id}
```

Response:
```json
{
  "id": "task-123",
  "title": "Analyze security vulnerabilities",
  "description": "Scan codebase for security issues",
  "status": "in_progress",
  "priority": "high",
  "assigned_to": "agent-456",
  "progress": 45,
  "steps": [
    {
      "name": "Clone repository",
      "status": "completed",
      "duration": 5
    },
    {
      "name": "Install dependencies",
      "status": "completed",
      "duration": 120
    },
    {
      "name": "Run security scan",
      "status": "in_progress",
      "progress": 45
    }
  ],
  "metadata": {
    "repository": "https://github.com/example/repo",
    "branch": "main",
    "commit": "abc123"
  },
  "created_at": "2024-01-15T10:00:00Z",
  "started_at": "2024-01-15T10:05:00Z",
  "estimated_completion": "2024-01-15T11:00:00Z"
}
```

### Create Task

```bash
POST /tasks
Content-Type: application/json

{
  "title": "Generate API documentation",
  "description": "Create comprehensive API docs",
  "priority": "medium",
  "requirements": {
    "format": "markdown",
    "include_examples": true
  },
  "assign_to": "agent-789"
}
```

Response:
```json
{
  "id": "task-456",
  "title": "Generate API documentation",
  "status": "pending",
  "priority": "medium",
  "assigned_to": "agent-789",
  "created_at": "2024-01-15T16:00:00Z"
}
```

### Update Task

```bash
PUT /tasks/{task_id}
Content-Type: application/json

{
  "priority": "high",
  "metadata": {
    "additional_requirements": ["Include diagrams"]
  }
}
```

### Task Actions

#### Cancel Task
```bash
POST /tasks/{task_id}/cancel

{
  "reason": "Requirements changed"
}
```

#### Retry Task
```bash
POST /tasks/{task_id}/retry
```

#### Get Task Logs
```bash
GET /tasks/{task_id}/logs
```

Response:
```json
{
  "logs": [
    {
      "timestamp": "2024-01-15T10:05:00Z",
      "level": "info",
      "message": "Task started",
      "metadata": {}
    },
    {
      "timestamp": "2024-01-15T10:05:05Z",
      "level": "debug",
      "message": "Cloning repository",
      "metadata": {
        "repo": "https://github.com/example/repo"
      }
    }
  ]
}
```

## Projects API

### List Projects

```bash
GET /projects
```

Response:
```json
{
  "projects": [
    {
      "id": "proj-123",
      "name": "E-commerce Platform",
      "description": "Build online store",
      "status": "active",
      "progress": 72,
      "task_count": 45,
      "tasks_completed": 32,
      "created_at": "2024-01-01T00:00:00Z"
    }
  ],
  "total": 12
}
```

### Create Project

```bash
POST /projects
Content-Type: application/json

{
  "name": "Mobile App",
  "description": "Cross-platform mobile application",
  "tasks": [
    {
      "title": "Design UI mockups",
      "priority": "high"
    },
    {
      "title": "Set up development environment",
      "priority": "high"
    }
  ]
}
```

### Get Project Details

```bash
GET /projects/{project_id}
```

Response includes tasks, agents, and timeline.

## Metrics API

### System Metrics

```bash
GET /metrics/system
```

Response:
```json
{
  "timestamp": "2024-01-15T16:00:00Z",
  "cpu_usage": 45.2,
  "memory_usage": 62.8,
  "disk_usage": 35.1,
  "agents": {
    "total": 10,
    "active": 7,
    "idle": 2,
    "offline": 1
  },
  "tasks": {
    "queued": 23,
    "in_progress": 7,
    "completed_today": 156,
    "failed_today": 3
  }
}
```

### Agent Metrics

```bash
GET /metrics/agents/{agent_id}
```

Parameters:
- `period` - Time period (hour, day, week, month)
- `metric` - Specific metric (tasks, performance, errors)

### Task Analytics

```bash
GET /metrics/tasks
```

Parameters:
- `group_by` - Grouping (status, priority, agent)
- `period` - Time period

## Webhooks API

### List Webhooks

```bash
GET /webhooks
```

### Create Webhook

```bash
POST /webhooks
Content-Type: application/json

{
  "url": "https://example.com/webhook",
  "events": ["task.completed", "agent.error"],
  "secret": "webhook-secret-key"
}
```

### Webhook Events

Available events:
- `task.created`
- `task.started`
- `task.completed`
- `task.failed`
- `agent.online`
- `agent.offline`
- `agent.error`
- `system.alert`

### Webhook Payload

```json
{
  "event": "task.completed",
  "timestamp": "2024-01-15T16:00:00Z",
  "data": {
    "task_id": "task-123",
    "agent_id": "agent-456",
    "duration": 3600,
    "result": "success"
  }
}
```

## Error Responses

### Error Format

```json
{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "Agent not found",
    "details": {
      "agent_id": "agent-999"
    },
    "request_id": "req-123"
  }
}
```

### Common Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `INVALID_REQUEST` | 400 | Invalid request format |
| `UNAUTHORIZED` | 401 | Missing or invalid auth |
| `FORBIDDEN` | 403 | Insufficient permissions |
| `RESOURCE_NOT_FOUND` | 404 | Resource doesn't exist |
| `CONFLICT` | 409 | Resource conflict |
| `RATE_LIMITED` | 429 | Too many requests |
| `INTERNAL_ERROR` | 500 | Server error |

## Rate Limiting

Rate limits:
- 1000 requests per hour per token
- 100 requests per minute per token

Headers:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1704067200
```

## Pagination

Standard pagination parameters:
- `limit` - Results per page (max: 100)
- `offset` - Skip N results
- `cursor` - Cursor-based pagination

Response includes:
```json
{
  "data": [...],
  "pagination": {
    "total": 1234,
    "limit": 20,
    "offset": 40,
    "next_cursor": "eyJ0aW1lc3RhbXAiOjE3MDQwNjcyMDB9"
  }
}
```

## SDK Examples

### Python

```python
from marcus import MarcusClient

client = MarcusClient(api_key="your-api-key")

# Create task
task = client.tasks.create(
    title="Analyze code",
    priority="high"
)

# Monitor progress
while task.status != "completed":
    task.refresh()
    print(f"Progress: {task.progress}%")
    time.sleep(5)
```

### JavaScript

```javascript
import { MarcusClient } from '@marcus-ai/sdk';

const client = new MarcusClient({
  apiKey: 'your-api-key'
});

// Create agent
const agent = await client.agents.create({
  name: 'helper',
  capabilities: ['research']
});

// Assign task
const task = await client.tasks.create({
  title: 'Research topic',
  assignTo: agent.id
});
```

### Go

```go
import "github.com/marcus-ai/marcus-go"

client := marcus.NewClient("your-api-key")

// List active agents
agents, err := client.Agents.List(marcus.AgentListOptions{
    Status: "active",
})

// Create task
task, err := client.Tasks.Create(marcus.TaskCreateOptions{
    Title:    "Generate report",
    Priority: "medium",
})
```

## API Versioning

The API uses URL versioning:
- Current version: `v1`
- Version in URL: `/api/v1/`
- Deprecation notice: 6 months
- Sunset period: 12 months

## Next Steps

- Try the [Interactive API Explorer](https://api.marcus-ai.dev/explorer)
- Read [Authentication Guide](../guides/authentication.md)
- View [SDK Documentation](https://github.com/marcus-ai/sdks)