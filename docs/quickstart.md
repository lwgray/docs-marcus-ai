# Quick Start

Get your first AI agent workflow running in 5 minutes.

## Prerequisites

- Python 3.9+ or Node.js 18+
- A text editor
- 5 minutes of your time

## 1. Install Marcus

=== "Python"

    ```bash
    pip install marcus-ai
    ```

=== "npm"

    ```bash
    npm install -g marcus-ai
    ```

## 2. Create Your First Project

```bash
marcus create my-first-project
cd my-first-project
```

This creates a new project with:
- Pre-configured AI agents
- Basic task structure
- Integration with your preferred Kanban board

## 3. Start Marcus

```bash
marcus start
```

Marcus will:
1. Initialize the cognitive memory system
2. Register available AI agents
3. Begin task coordination
4. Open the project dashboard

## 4. Monitor with Seneca

In a new terminal:

```bash
seneca start
```

Seneca automatically discovers your Marcus instance and provides:
- Real-time agent conversation monitoring
- Task progress visualization
- System health metrics

Visit http://localhost:5000 to see your agents in action!

## 5. Interact with Your Agents

Try these commands in the Marcus dashboard:

```bash
# Check project status
marcus project status

# View active agents
marcus agent list

# See task progress
marcus task list
```

## What's Happening?

Behind the scenes, Marcus is:

1. **Analyzing your project** - Understanding dependencies and requirements
2. **Assigning tasks to agents** - Matching capabilities to needs
3. **Coordinating work** - Managing dependencies and communication
4. **Learning from results** - Improving future task assignments

## Next Steps

!!! success "Congratulations!"
    You've successfully set up your first AI agent workflow!

**Ready to dive deeper?**

<div class="grid cards" markdown>

-   :material-book-open-variant: **[First Project Tutorial](first-project.md)**
    
    Build a complete application with AI agents

-   :material-api: **[API Reference](api/marcus-api.md)**
    
    Learn about available MCP tools and commands

-   :material-head-cog: **[Understanding Marcus](marcus/README.md)**
    
    Explore the 32 integrated systems

-   :material-chart-line: **[Seneca Visualization](seneca/index.md)**
    
    Master the monitoring dashboard

</div>

## Common Issues

??? question "Marcus can't find my project"
    Make sure you're in the project directory when running `marcus start`.

??? question "Seneca shows 'No Marcus instance found'"
    1. Verify Marcus is running: `marcus status`
    2. Check the service registry: `ls ~/.marcus/services/`
    3. Try manual connection: `seneca start --marcus-server /path/to/marcus`

??? question "Agents aren't picking up tasks"
    1. Check agent status: `marcus agent list`
    2. Verify tasks exist: `marcus task list`
    3. Review logs: `marcus logs --tail 50`

## Get Help

- 📚 [Full Documentation](https://docs.marcus-ai.dev)
- 💬 [GitHub Discussions](https://github.com/lwgray/marcus/discussions)
- 🐛 [Report Issues](https://github.com/lwgray/marcus/issues)