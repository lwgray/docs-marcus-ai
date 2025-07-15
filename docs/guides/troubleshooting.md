# Troubleshooting Guide

This comprehensive guide helps you diagnose and resolve common issues with Marcus AI and Seneca.

## Quick Diagnostics

Run this command to check system status:

```bash
marcus diagnose --verbose
```

This will check:
- Service connectivity
- Database health
- Message queue status
- Agent availability
- Configuration validity

## Common Issues

### Installation Problems

#### Issue: Installation fails with dependency errors

**Symptoms:**
```
ERROR: Could not find a version that satisfies the requirement
```

**Solution:**
1. Update pip: `pip install --upgrade pip`
2. Clear pip cache: `pip cache purge`
3. Use virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install marcus-ai
   ```

#### Issue: Permission denied errors

**Symptoms:**
```
PermissionError: [Errno 13] Permission denied
```

**Solution:**
1. Check file permissions: `ls -la`
2. Fix ownership: `sudo chown -R $USER:$USER .`
3. Use user install: `pip install --user marcus-ai`

### Connection Issues

#### Issue: Cannot connect to Marcus server

**Symptoms:**
- "Connection refused" errors
- Timeouts when accessing API

**Diagnosis:**
```bash
# Check if Marcus is running
ps aux | grep marcus

# Check port availability
netstat -tuln | grep 8000

# Test connection
curl -I http://localhost:8000/health
```

**Solutions:**
1. Start Marcus service:
   ```bash
   marcus start
   # Or with systemd
   sudo systemctl start marcus
   ```

2. Check firewall rules:
   ```bash
   # Ubuntu/Debian
   sudo ufw status
   sudo ufw allow 8000
   
   # RHEL/CentOS
   sudo firewall-cmd --list-all
   sudo firewall-cmd --add-port=8000/tcp --permanent
   ```

3. Verify configuration:
   ```python
   # config.py
   MARCUS_HOST = "0.0.0.0"  # Not just localhost
   MARCUS_PORT = 8000
   ```

#### Issue: Database connection failures

**Symptoms:**
```
psycopg2.OperationalError: could not connect to server
```

**Solutions:**
1. Check PostgreSQL status:
   ```bash
   sudo systemctl status postgresql
   sudo systemctl start postgresql
   ```

2. Verify credentials:
   ```bash
   psql -U marcus_user -d marcus_db -h localhost
   ```

3. Check connection string:
   ```python
   DATABASE_URL = "postgresql://user:pass@localhost:5432/marcus"
   ```

### Agent Issues

#### Issue: Agents not responding

**Symptoms:**
- Tasks stuck in "pending" state
- No progress on assigned tasks

**Diagnosis:**
```python
# Check agent status
marcus agent list
marcus agent status <agent_id>
```

**Solutions:**
1. Restart stuck agents:
   ```bash
   marcus agent restart <agent_id>
   # Or restart all
   marcus agent restart --all
   ```

2. Check resource limits:
   ```python
   # config.py
   AGENT_MAX_MEMORY = "8G"
   AGENT_TIMEOUT = 3600  # seconds
   ```

3. Review agent logs:
   ```bash
   tail -f logs/agent_*.log
   ```

#### Issue: Agent memory leaks

**Symptoms:**
- Gradually increasing memory usage
- System becomes unresponsive

**Solutions:**
1. Enable memory monitoring:
   ```python
   # agent_config.py
   ENABLE_MEMORY_PROFILING = True
   MEMORY_LIMIT_MB = 4096
   ```

2. Implement auto-restart:
   ```python
   @agent.on_memory_exceed
   def handle_memory_limit():
       agent.restart()
   ```

3. Use memory-efficient patterns:
   ```python
   # Process in chunks
   for chunk in process_in_chunks(data, chunk_size=1000):
       process_chunk(chunk)
   ```

### Performance Issues

#### Issue: Slow task execution

**Symptoms:**
- Tasks taking longer than expected
- High system load

**Diagnosis:**
```bash
# Check system resources
htop
iostat -x 1
vmstat 1

# Profile task execution
marcus task profile <task_id>
```

**Solutions:**
1. Optimize database queries:
   ```sql
   -- Add indexes
   CREATE INDEX idx_tasks_status_created 
   ON tasks(status, created_at);
   
   -- Analyze query performance
   EXPLAIN ANALYZE SELECT * FROM tasks WHERE status = 'pending';
   ```

2. Enable caching:
   ```python
   # config.py
   CACHE_TYPE = "redis"
   CACHE_REDIS_URL = "redis://localhost:6379/0"
   CACHE_DEFAULT_TIMEOUT = 300
   ```

3. Adjust worker settings:
   ```python
   # worker_config.py
   WORKER_CONCURRENCY = 4
   WORKER_PREFETCH_MULTIPLIER = 2
   ```

#### Issue: High CPU usage

**Solutions:**
1. Limit concurrent tasks:
   ```python
   CONCURRENT_TASK_LIMIT = 10
   ```

2. Enable CPU throttling:
   ```python
   import resource
   
   # Limit to 80% CPU
   resource.setrlimit(
       resource.RLIMIT_CPU,
       (int(0.8 * resource.RLIM_INFINITY), resource.RLIM_INFINITY)
   )
   ```

### Seneca Dashboard Issues

#### Issue: Dashboard not loading

**Symptoms:**
- Blank page
- "Cannot connect to API" error

**Solutions:**
1. Check API endpoint:
   ```javascript
   // seneca.config.js
   export default {
     api: {
       url: process.env.API_URL || 'http://localhost:8000'
     }
   }
   ```

2. Verify CORS settings:
   ```python
   # marcus/config.py
   CORS_ORIGINS = ["http://localhost:3000", "https://seneca.example.com"]
   ```

3. Check browser console:
   - Open Developer Tools (F12)
   - Check Console tab for errors
   - Check Network tab for failed requests

#### Issue: Real-time updates not working

**Solutions:**
1. Check WebSocket connection:
   ```javascript
   // Check in browser console
   const ws = new WebSocket('ws://localhost:8000/ws');
   ws.onopen = () => console.log('Connected');
   ws.onerror = (e) => console.error('Error:', e);
   ```

2. Verify MCP server:
   ```bash
   marcus mcp status
   marcus mcp restart
   ```

### Data Issues

#### Issue: Data corruption or inconsistencies

**Symptoms:**
- Unexpected task states
- Missing or duplicate records

**Solutions:**
1. Run integrity checks:
   ```bash
   marcus db check
   marcus db repair --dry-run
   marcus db repair --confirm
   ```

2. Restore from backup:
   ```bash
   # List available backups
   marcus backup list
   
   # Restore specific backup
   marcus backup restore --timestamp 2024-01-15-10-30
   ```

#### Issue: Storage full

**Solutions:**
1. Clean up old data:
   ```bash
   # Remove completed tasks older than 30 days
   marcus cleanup --older-than 30d --status completed
   
   # Clean logs
   find logs/ -name "*.log" -mtime +7 -delete
   ```

2. Archive to S3:
   ```python
   # archive_config.py
   ARCHIVE_ENABLED = True
   ARCHIVE_DESTINATION = "s3://marcus-archive"
   ARCHIVE_AFTER_DAYS = 30
   ```

## Advanced Debugging

### Enable Debug Mode

```python
# .env
DEBUG=True
LOG_LEVEL=DEBUG

# Or via command line
marcus start --debug
```

### Trace Execution

```python
# Enable tracing
import marcus.tracing

marcus.tracing.enable()

# Trace specific function
@marcus.trace
def problematic_function():
    pass
```

### Memory Profiling

```python
# memory_profile.py
from memory_profiler import profile

@profile
def memory_intensive_task():
    # Your code here
    pass

# Run with: python -m memory_profiler memory_profile.py
```

### Performance Profiling

```bash
# Profile CPU usage
python -m cProfile -o profile.stats marcus_script.py

# Analyze results
python -m pstats profile.stats
```

## Log Analysis

### Log Locations

```bash
# Default log locations
/var/log/marcus/marcus.log      # Main application log
/var/log/marcus/agent_*.log     # Individual agent logs
/var/log/marcus/error.log       # Error log
/var/log/marcus/access.log      # API access log
```

### Log Searching

```bash
# Find errors
grep -i error /var/log/marcus/*.log

# Find specific task
grep "task_id=12345" /var/log/marcus/*.log

# Real-time monitoring
tail -f /var/log/marcus/marcus.log | grep ERROR
```

### Log Rotation

```bash
# /etc/logrotate.d/marcus
/var/log/marcus/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 marcus marcus
    sharedscripts
    postrotate
        systemctl reload marcus
    endscript
}
```

## Getting Help

### Collect Diagnostic Information

```bash
# Generate diagnostic report
marcus diagnose --output diagnostic_report.txt

# Include:
# - System information
# - Configuration
# - Recent logs
# - Error traces
```

### Community Support

1. **Discord**: Join our [Discord server](https://discord.gg/marcus-ai)
2. **GitHub Issues**: Report bugs at [github.com/marcus-ai/marcus](https://github.com/marcus-ai/marcus/issues)
3. **Stack Overflow**: Tag questions with `marcus-ai`

### Professional Support

For enterprise support, contact: support@marcus-ai.dev

## Preventive Measures

### Health Checks

```python
# health_check.py
@app.route('/health')
def health_check():
    checks = {
        'database': check_database(),
        'redis': check_redis(),
        'agents': check_agents(),
        'storage': check_storage()
    }
    
    status = 'healthy' if all(checks.values()) else 'unhealthy'
    return jsonify({'status': status, 'checks': checks})
```

### Monitoring Setup

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'marcus'
    static_configs:
      - targets: ['localhost:8000']
    metric_relabel_configs:
      - source_labels: [__name__]
        regex: 'marcus_.*'
        action: keep
```

### Regular Maintenance

```bash
# maintenance.sh
#!/bin/bash

# Weekly maintenance script
marcus db vacuum
marcus cache clear
marcus logs rotate
marcus backup create
```

## Next Steps

- Set up [Monitoring](../marcus/systems/11-monitoring-systems.md)
- Configure [Logging](../marcus/systems/02-logging-system.md)
- Join our [Community](../community/support.md) for help