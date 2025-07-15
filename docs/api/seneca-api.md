# Seneca API Reference

API reference for the Seneca visualization dashboard.

## Overview

Seneca provides a RESTful API for integrating with the dashboard and accessing visualization data.

## Base URL

```
Development: http://localhost:3000/api
Production: https://seneca.marcus-ai.dev/api
```

## Authentication

Seneca uses the same authentication tokens as Marcus:

```bash
curl -H "Authorization: Bearer YOUR_API_TOKEN" \
     https://seneca.marcus-ai.dev/api/dashboards
```

## Dashboards API

### List Dashboards

```bash
GET /dashboards
```

Response:
```json
{
  "dashboards": [
    {
      "id": "dash-123",
      "name": "Agent Performance",
      "description": "Monitor agent metrics",
      "type": "system",
      "widgets": 6,
      "created_at": "2024-01-15T10:00:00Z",
      "updated_at": "2024-01-15T14:30:00Z"
    }
  ],
  "total": 5
}
```

### Get Dashboard

```bash
GET /dashboards/{dashboard_id}
```

Response:
```json
{
  "id": "dash-123",
  "name": "Agent Performance",
  "description": "Monitor agent metrics",
  "type": "custom",
  "layout": {
    "columns": 12,
    "rows": 8
  },
  "widgets": [
    {
      "id": "widget-456",
      "type": "line_chart",
      "title": "Task Completion Rate",
      "position": { "x": 0, "y": 0, "w": 6, "h": 4 },
      "config": {
        "metric": "task.completion_rate",
        "period": "24h",
        "interval": "1h"
      }
    }
  ],
  "filters": {
    "timeRange": "last_24h",
    "agents": ["agent-123", "agent-456"]
  }
}
```

### Create Dashboard

```bash
POST /dashboards
Content-Type: application/json

{
  "name": "Custom Metrics",
  "description": "Project-specific metrics",
  "layout": {
    "columns": 12,
    "rows": 8
  },
  "widgets": [
    {
      "type": "number",
      "title": "Active Tasks",
      "position": { "x": 0, "y": 0, "w": 3, "h": 2 },
      "config": {
        "metric": "tasks.active_count"
      }
    }
  ]
}
```

### Update Dashboard

```bash
PUT /dashboards/{dashboard_id}
Content-Type: application/json

{
  "name": "Updated Dashboard Name",
  "widgets": [...]
}
```

### Delete Dashboard

```bash
DELETE /dashboards/{dashboard_id}
```

### Export Dashboard

```bash
GET /dashboards/{dashboard_id}/export
```

Response:
```json
{
  "dashboard": {...},
  "version": "1.0",
  "exported_at": "2024-01-15T16:00:00Z"
}
```

### Import Dashboard

```bash
POST /dashboards/import
Content-Type: application/json

{
  "dashboard": {...},
  "version": "1.0"
}
```

## Widgets API

### Widget Types

Available widget types:
- `line_chart` - Time series data
- `bar_chart` - Categorical data
- `pie_chart` - Distribution data
- `number` - Single metric
- `gauge` - Progress/percentage
- `heatmap` - Matrix data
- `table` - Tabular data
- `log_viewer` - Real-time logs
- `agent_status` - Agent overview
- `task_timeline` - Gantt chart

### Create Widget

```bash
POST /dashboards/{dashboard_id}/widgets
Content-Type: application/json

{
  "type": "line_chart",
  "title": "CPU Usage",
  "position": { "x": 0, "y": 0, "w": 6, "h": 4 },
  "config": {
    "metrics": ["system.cpu_usage"],
    "period": "1h",
    "interval": "1m",
    "aggregation": "avg"
  }
}
```

### Update Widget

```bash
PUT /widgets/{widget_id}
Content-Type: application/json

{
  "title": "Updated Title",
  "config": {
    "period": "24h"
  }
}
```

### Delete Widget

```bash
DELETE /widgets/{widget_id}
```

### Widget Data

```bash
GET /widgets/{widget_id}/data
```

Parameters:
- `start` - Start timestamp (ISO 8601)
- `end` - End timestamp (ISO 8601)
- `interval` - Data point interval
- `aggregation` - avg, sum, min, max

Response:
```json
{
  "widget_id": "widget-456",
  "data": {
    "series": [
      {
        "name": "CPU Usage",
        "data": [
          { "timestamp": "2024-01-15T10:00:00Z", "value": 45.2 },
          { "timestamp": "2024-01-15T10:01:00Z", "value": 48.7 }
        ]
      }
    ],
    "metadata": {
      "unit": "percent",
      "aggregation": "avg"
    }
  }
}
```

## Visualizations API

### Get Available Metrics

```bash
GET /metrics/catalog
```

Response:
```json
{
  "metrics": [
    {
      "name": "system.cpu_usage",
      "description": "CPU usage percentage",
      "unit": "percent",
      "type": "gauge",
      "tags": ["system", "performance"]
    },
    {
      "name": "tasks.completion_rate",
      "description": "Task completion rate",
      "unit": "percent",
      "type": "gauge",
      "tags": ["tasks", "performance"]
    }
  ]
}
```

### Query Metrics

```bash
POST /metrics/query
Content-Type: application/json

{
  "metrics": ["system.cpu_usage", "system.memory_usage"],
  "filters": {
    "agent_id": ["agent-123"],
    "time_range": {
      "start": "2024-01-15T10:00:00Z",
      "end": "2024-01-15T16:00:00Z"
    }
  },
  "aggregation": {
    "interval": "5m",
    "function": "avg"
  }
}
```

### Real-time Stream

```bash
GET /metrics/stream
```

WebSocket endpoint for real-time metrics:

```javascript
const ws = new WebSocket('wss://seneca.marcus-ai.dev/api/metrics/stream');

ws.onmessage = (event) => {
  const metric = JSON.parse(event.data);
  console.log('Metric update:', metric);
};

// Subscribe to specific metrics
ws.send(JSON.stringify({
  action: 'subscribe',
  metrics: ['system.cpu_usage', 'tasks.active_count']
}));
```

## Alerts API

### List Alerts

```bash
GET /alerts
```

Parameters:
- `status` - active, resolved, acknowledged
- `severity` - critical, high, medium, low
- `source` - Source system/agent

### Create Alert Rule

```bash
POST /alerts/rules
Content-Type: application/json

{
  "name": "High CPU Usage",
  "description": "Alert when CPU exceeds 80%",
  "condition": {
    "metric": "system.cpu_usage",
    "operator": ">",
    "threshold": 80,
    "duration": "5m"
  },
  "severity": "high",
  "notifications": {
    "email": ["ops@example.com"],
    "webhook": "https://example.com/alerts"
  }
}
```

### Acknowledge Alert

```bash
POST /alerts/{alert_id}/acknowledge

{
  "message": "Investigating issue"
}
```

### Resolve Alert

```bash
POST /alerts/{alert_id}/resolve

{
  "resolution": "Increased server capacity"
}
```

## Reports API

### Generate Report

```bash
POST /reports/generate
Content-Type: application/json

{
  "type": "performance",
  "period": {
    "start": "2024-01-01T00:00:00Z",
    "end": "2024-01-31T23:59:59Z"
  },
  "include": [
    "agent_performance",
    "task_statistics",
    "system_metrics"
  ],
  "format": "pdf"
}
```

### List Reports

```bash
GET /reports
```

### Download Report

```bash
GET /reports/{report_id}/download
```

### Schedule Report

```bash
POST /reports/schedules
Content-Type: application/json

{
  "name": "Weekly Performance Report",
  "type": "performance",
  "schedule": {
    "frequency": "weekly",
    "day": "monday",
    "time": "09:00"
  },
  "recipients": ["team@example.com"],
  "format": "pdf"
}
```

## Themes API

### Get Available Themes

```bash
GET /themes
```

Response:
```json
{
  "themes": [
    {
      "id": "light",
      "name": "Light Theme",
      "preview": "https://..."
    },
    {
      "id": "dark",
      "name": "Dark Theme",
      "preview": "https://..."
    },
    {
      "id": "custom-123",
      "name": "Company Theme",
      "preview": "https://..."
    }
  ]
}
```

### Get Current Theme

```bash
GET /user/theme
```

### Set Theme

```bash
PUT /user/theme
Content-Type: application/json

{
  "theme_id": "dark"
}
```

### Create Custom Theme

```bash
POST /themes
Content-Type: application/json

{
  "name": "Custom Theme",
  "colors": {
    "primary": "#1976d2",
    "secondary": "#dc004e",
    "background": "#ffffff",
    "surface": "#f5f5f5",
    "error": "#f44336",
    "warning": "#ff9800",
    "info": "#2196f3",
    "success": "#4caf50"
  },
  "typography": {
    "fontFamily": "Inter, sans-serif",
    "fontSize": 14
  }
}
```

## User Preferences API

### Get Preferences

```bash
GET /user/preferences
```

Response:
```json
{
  "theme": "dark",
  "language": "en",
  "timezone": "America/New_York",
  "notifications": {
    "email": true,
    "browser": true,
    "sound": false
  },
  "dashboard": {
    "default": "dash-123",
    "refresh_interval": 30
  }
}
```

### Update Preferences

```bash
PUT /user/preferences
Content-Type: application/json

{
  "notifications": {
    "sound": true
  },
  "dashboard": {
    "refresh_interval": 60
  }
}
```

## Export API

### Export Data

```bash
POST /export
Content-Type: application/json

{
  "type": "metrics",
  "format": "csv",
  "data": {
    "metrics": ["system.cpu_usage"],
    "time_range": {
      "start": "2024-01-15T00:00:00Z",
      "end": "2024-01-15T23:59:59Z"
    }
  }
}
```

Supported formats:
- `csv` - Comma-separated values
- `json` - JSON format
- `xlsx` - Excel spreadsheet
- `parquet` - Apache Parquet

### Export Status

```bash
GET /export/{export_id}/status
```

Response:
```json
{
  "id": "export-123",
  "status": "completed",
  "progress": 100,
  "download_url": "https://...",
  "expires_at": "2024-01-16T00:00:00Z"
}
```

## WebSocket API

### Connection

```javascript
const ws = new WebSocket('wss://seneca.marcus-ai.dev/api/ws');

ws.onopen = () => {
  // Authenticate
  ws.send(JSON.stringify({
    type: 'auth',
    token: 'your-api-token'
  }));
};
```

### Subscribe to Updates

```javascript
// Subscribe to dashboard updates
ws.send(JSON.stringify({
  type: 'subscribe',
  channel: 'dashboard',
  id: 'dash-123'
}));

// Subscribe to metric updates
ws.send(JSON.stringify({
  type: 'subscribe',
  channel: 'metrics',
  metrics: ['system.cpu_usage']
}));
```

### Message Types

```javascript
// Dashboard update
{
  "type": "dashboard.update",
  "data": {
    "dashboard_id": "dash-123",
    "changes": {...}
  }
}

// Metric update
{
  "type": "metric.update",
  "data": {
    "metric": "system.cpu_usage",
    "value": 45.2,
    "timestamp": "2024-01-15T16:00:00Z"
  }
}

// Alert notification
{
  "type": "alert.triggered",
  "data": {
    "alert_id": "alert-456",
    "rule": "High CPU Usage",
    "severity": "high"
  }
}
```

## Rate Limiting

Same as Marcus API:
- 1000 requests per hour
- 100 requests per minute

Real-time endpoints have separate limits:
- 10 concurrent WebSocket connections
- 100 messages per minute per connection

## Error Handling

Standard error format:

```json
{
  "error": {
    "code": "INVALID_WIDGET_TYPE",
    "message": "Widget type 'custom' is not supported",
    "details": {
      "supported_types": ["line_chart", "bar_chart", ...]
    }
  }
}
```

## SDK Support

### JavaScript/React

```javascript
import { SenecaClient } from '@marcus-ai/seneca-sdk';

const client = new SenecaClient({
  apiKey: 'your-api-key'
});

// Create dashboard
const dashboard = await client.dashboards.create({
  name: 'My Dashboard',
  widgets: [...]
});

// Subscribe to updates
client.subscribe('dashboard', dashboard.id, (update) => {
  console.log('Dashboard updated:', update);
});
```

### Python

```python
from seneca import SenecaClient

client = SenecaClient(api_key='your-api-key')

# Query metrics
data = client.metrics.query(
    metrics=['system.cpu_usage'],
    time_range={'start': '2024-01-15T00:00:00Z', 'end': 'now'},
    interval='5m'
)

# Create alert rule
rule = client.alerts.create_rule(
    name='High Memory',
    metric='system.memory_usage',
    threshold=90,
    severity='high'
)
```

## Next Steps

- Explore [Widget Gallery](https://seneca.marcus-ai.dev/gallery)
- Read [Visualization Guide](../guides/visualizations.md)
- Try [Live Demo](https://demo.seneca.marcus-ai.dev)