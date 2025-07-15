# Your First Project

This guide walks you through creating your first AI-powered project with Marcus.

## Project Setup

### 1. Create a New Project

```bash
marcus create todo-app
cd todo-app
```

This creates a project structure:
```
todo-app/
├── .marcus/
│   └── config.yml
├── tasks/
├── agents/
└── README.md
```

### 2. Start Marcus

```bash
marcus start
```

Marcus will:
- Initialize the project
- Register available agents
- Begin monitoring for tasks

### 3. Create Your First Task

```bash
marcus task create "Set up database schema"
```

### 4. Monitor Progress

In a new terminal:

```bash
seneca start
```

Visit http://localhost:5000 to see:
- Agent activity
- Task progress
- System health

## Understanding the Workflow

### Agent Assignment

Marcus automatically:
1. Analyzes task requirements
2. Matches with agent capabilities
3. Assigns to best-suited agent
4. Monitors progress

### Task Completion

Agents will:
1. Accept assigned tasks
2. Report progress updates
3. Complete implementation
4. Request review if needed

## Next Steps

- [AI Workflows Guide](guides/ai-workflows.md)
- [Marcus Systems](marcus/systems/README.md)
- [API Reference](marcus/api/README.md)