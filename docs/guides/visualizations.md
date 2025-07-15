# Visualization Guide

Learn how to create powerful visualizations with Seneca dashboard for monitoring your Marcus AI agents and workflows.

## Overview

Seneca provides a comprehensive set of visualization tools to help you:
- Monitor agent performance in real-time
- Track task progress and bottlenecks
- Analyze system metrics and trends
- Create custom dashboards for specific needs

## Getting Started

### Basic Dashboard Setup

1. **Access Seneca Dashboard**
   ```bash
   seneca start
   # Visit http://localhost:3000
   ```

2. **Create Your First Dashboard**
   - Click "New Dashboard"
   - Choose a template or start blank
   - Add widgets from the library

## Widget Types

### Metrics Widgets

#### Number Widget
Display single metrics with trend indicators:

```javascript
{
  type: "number",
  title: "Active Agents",
  metric: "agents.active_count",
  format: "integer",
  trend: true
}
```

#### Gauge Widget
Show progress or percentage values:

```javascript
{
  type: "gauge",
  title: "CPU Usage",
  metric: "system.cpu_usage",
  min: 0,
  max: 100,
  thresholds: {
    warning: 70,
    critical: 90
  }
}
```

### Time Series Charts

#### Line Chart
Perfect for trending data over time:

```javascript
{
  type: "line_chart",
  title: "Task Completion Rate",
  metrics: ["tasks.completion_rate"],
  period: "24h",
  interval: "5m",
  yAxis: {
    min: 0,
    max: 100,
    label: "Percentage"
  }
}
```

#### Area Chart
Visualize cumulative values:

```javascript
{
  type: "area_chart",
  title: "Memory Usage",
  metrics: [
    "system.memory_used",
    "system.memory_cached"
  ],
  stacked: true
}
```

### Distribution Charts

#### Bar Chart
Compare categorical data:

```javascript
{
  type: "bar_chart",
  title: "Tasks by Status",
  metric: "tasks.by_status",
  orientation: "vertical",
  colors: {
    completed: "#4caf50",
    in_progress: "#2196f3",
    failed: "#f44336"
  }
}
```

#### Pie Chart
Show proportions:

```javascript
{
  type: "pie_chart",
  title: "Agent Utilization",
  metric: "agents.by_status",
  showLegend: true,
  showValues: true
}
```

### Specialized Widgets

#### Agent Status Grid
Monitor all agents at a glance:

```javascript
{
  type: "agent_status",
  title: "Agent Fleet",
  showMetrics: ["cpu", "memory", "tasks"],
  layout: "grid",
  refreshInterval: 5000
}
```

#### Task Timeline
Gantt-style task visualization:

```javascript
{
  type: "task_timeline",
  title: "Project Timeline",
  groupBy: "agent",
  showDependencies: true,
  timeRange: "7d"
}
```

#### Log Viewer
Real-time log streaming:

```javascript
{
  type: "log_viewer",
  title: "System Logs",
  filters: {
    level: ["error", "warning"],
    source: ["agent-*"]
  },
  maxLines: 1000
}
```

## Custom Visualizations

### Creating Custom Widgets

```javascript
// CustomWidget.jsx
import { useMetric, useTheme } from '@marcus-ai/seneca-sdk';
import { LineChart, Line, XAxis, YAxis } from 'recharts';

export function CustomMetric({ config }) {
  const data = useMetric(config.metric, {
    period: config.period,
    interval: config.interval
  });
  
  const theme = useTheme();
  
  return (
    <LineChart data={data}>
      <XAxis dataKey="timestamp" />
      <YAxis />
      <Line 
        type="monotone" 
        dataKey="value" 
        stroke={theme.primary} 
      />
    </LineChart>
  );
}
```

### Registering Custom Widgets

```javascript
// widgets/index.js
import { registerWidget } from '@marcus-ai/seneca-sdk';
import { CustomMetric } from './CustomMetric';

registerWidget({
  type: 'custom_metric',
  component: CustomMetric,
  configSchema: {
    metric: { type: 'string', required: true },
    period: { type: 'string', default: '1h' }
  }
});
```

## Dashboard Layouts

### Grid Layout
Flexible grid-based positioning:

```javascript
{
  layout: "grid",
  columns: 12,
  rows: 8,
  widgets: [
    {
      id: "cpu-gauge",
      position: { x: 0, y: 0, w: 3, h: 2 }
    },
    {
      id: "task-timeline",
      position: { x: 0, y: 2, w: 12, h: 6 }
    }
  ]
}
```

### Responsive Design
Automatic layout adjustments:

```javascript
{
  layout: "responsive",
  breakpoints: {
    mobile: { columns: 1 },
    tablet: { columns: 2 },
    desktop: { columns: 4 }
  }
}
```

## Real-time Updates

### WebSocket Integration

```javascript
// Enable real-time updates
const dashboard = new Dashboard({
  realtime: true,
  updateInterval: 1000, // milliseconds
  transport: 'websocket'
});

// Subscribe to specific metrics
dashboard.subscribe([
  'agents.*',
  'tasks.active_count',
  'system.cpu_usage'
]);
```

### Handling Updates

```javascript
dashboard.on('metric:update', (event) => {
  console.log(`${event.metric}: ${event.value}`);
  
  // Update visualization
  updateWidget(event.metric, event.value);
});
```

## Performance Optimization

### Data Aggregation

```javascript
// Reduce data points for better performance
{
  type: "line_chart",
  metric: "system.requests",
  aggregation: {
    method: "avg",
    interval: "5m"
  },
  maxDataPoints: 100
}
```

### Lazy Loading

```javascript
// Load widgets on demand
{
  type: "heavy_widget",
  lazy: true,
  placeholder: "Click to load visualization"
}
```

### Caching Strategies

```javascript
// Cache widget data
{
  type: "expensive_metric",
  cache: {
    enabled: true,
    ttl: 300, // seconds
    key: "metric_cache_key"
  }
}
```

## Advanced Features

### Alerting Integration

```javascript
// Add alert indicators to widgets
{
  type: "gauge",
  metric: "cpu_usage",
  alerts: {
    enabled: true,
    rules: [
      {
        condition: "value > 80",
        severity: "warning"
      },
      {
        condition: "value > 95",
        severity: "critical"
      }
    ]
  }
}
```

### Drill-down Navigation

```javascript
// Enable interactive exploration
{
  type: "bar_chart",
  metric: "errors_by_service",
  drillDown: {
    enabled: true,
    target: "service_details",
    params: ["service_id"]
  }
}
```

### Export Options

```javascript
// Configure export capabilities
{
  export: {
    formats: ["png", "svg", "csv"],
    filename: "agent_metrics_{{timestamp}}"
  }
}
```

## Best Practices

### Dashboard Design

1. **Information Hierarchy**
   - Most important metrics at top
   - Group related widgets
   - Use consistent color schemes

2. **Performance Metrics**
   - Limit widgets per dashboard (10-15)
   - Use appropriate refresh intervals
   - Aggregate data when possible

3. **User Experience**
   - Provide clear labels
   - Include help tooltips
   - Make dashboards shareable

### Color Usage

```javascript
// Define consistent color palette
const palette = {
  success: "#4caf50",
  warning: "#ff9800",
  error: "#f44336",
  info: "#2196f3",
  neutral: "#9e9e9e"
};
```

## Troubleshooting

### Common Issues

**Widgets not updating**
- Check WebSocket connection
- Verify metric names
- Review browser console

**Performance problems**
- Reduce update frequency
- Limit number of widgets
- Enable data aggregation

**Data not displaying**
- Verify API connectivity
- Check authentication
- Validate metric queries

## Examples

### Agent Monitoring Dashboard

```javascript
{
  name: "Agent Monitoring",
  layout: "grid",
  widgets: [
    {
      type: "agent_status",
      position: { x: 0, y: 0, w: 12, h: 4 }
    },
    {
      type: "line_chart",
      title: "Task Throughput",
      metric: "tasks.completed_per_minute",
      position: { x: 0, y: 4, w: 6, h: 4 }
    },
    {
      type: "gauge",
      title: "Success Rate",
      metric: "tasks.success_rate",
      position: { x: 6, y: 4, w: 6, h: 4 }
    }
  ]
}
```

### System Health Dashboard

```javascript
{
  name: "System Health",
  widgets: [
    {
      type: "number",
      title: "Uptime",
      metric: "system.uptime",
      format: "duration"
    },
    {
      type: "line_chart",
      title: "Resource Usage",
      metrics: ["cpu_usage", "memory_usage"],
      period: "1h"
    },
    {
      type: "heatmap",
      title: "Error Distribution",
      metric: "errors.by_service_and_time"
    }
  ]
}
```

## Next Steps

- Explore [Seneca API](../api/seneca-api.md) for programmatic access
- Learn about [Custom Widget Development](../seneca/development.md)
- Set up [Alert Rules](troubleshooting.md#monitoring-and-debugging)