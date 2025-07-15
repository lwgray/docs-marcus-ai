# Contributing to Marcus AI

Thank you for your interest in contributing to Marcus AI! We welcome contributions from the community and are grateful for any help you can provide.

## Code of Conduct

Please read and follow our [Code of Conduct](code-of-conduct.md) to ensure a welcoming environment for all contributors.

## How to Contribute

### Reporting Issues

Found a bug or have a feature request? Please open an issue:

1. Check if the issue already exists
2. Use the appropriate issue template
3. Provide clear description and steps to reproduce
4. Include system information and logs if relevant

### Contributing Code

#### Setting Up Development Environment

1. Fork the repository:
   ```bash
   git clone https://github.com/your-username/marcus.git
   cd marcus
   ```

2. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install development dependencies:
   ```bash
   pip install -e ".[dev]"
   ```

4. Run tests to ensure everything works:
   ```bash
   pytest
   ```

#### Development Workflow

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes following our coding standards

3. Write or update tests for your changes

4. Run the test suite:
   ```bash
   pytest
   tox  # Run tests across multiple Python versions
   ```

5. Check code style:
   ```bash
   flake8 marcus
   black marcus --check
   mypy marcus
   ```

6. Commit your changes:
   ```bash
   git add .
   git commit -m "feat: add amazing feature"
   ```

7. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

8. Create a Pull Request

### Commit Message Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc)
- `refactor:` Code refactoring
- `test:` Test additions or modifications
- `chore:` Build process or auxiliary tool changes

Examples:
```
feat: add support for custom agent configurations
fix: resolve memory leak in task scheduler
docs: update API reference for v2 endpoints
```

### Code Style

#### Python Code Style

We use:
- [Black](https://black.readthedocs.io/) for code formatting
- [isort](https://pycqa.github.io/isort/) for import sorting
- [Flake8](https://flake8.pycqa.org/) for linting
- [mypy](http://mypy-lang.org/) for type checking

Configuration is in `pyproject.toml` and `.flake8`.

Example:
```python
from typing import List, Optional

from marcus.core import Agent, Task
from marcus.utils import logger


class TaskScheduler:
    """Schedules and manages task execution."""
    
    def __init__(self, agents: List[Agent]) -> None:
        self.agents = agents
        self.queue: List[Task] = []
    
    def schedule_task(self, task: Task) -> Optional[Agent]:
        """Schedule a task to an available agent."""
        available_agent = self._find_available_agent()
        if available_agent:
            available_agent.assign(task)
            logger.info(f"Assigned task {task.id} to agent {available_agent.id}")
            return available_agent
        
        self.queue.append(task)
        return None
    
    def _find_available_agent(self) -> Optional[Agent]:
        """Find an available agent."""
        return next(
            (agent for agent in self.agents if agent.is_available()),
            None
        )
```

#### JavaScript/TypeScript Style

For Seneca dashboard:
- [ESLint](https://eslint.org/) for linting
- [Prettier](https://prettier.io/) for formatting
- TypeScript for type safety

Example:
```typescript
interface Task {
  id: string;
  title: string;
  status: 'pending' | 'in_progress' | 'completed';
  progress: number;
}

export function TaskCard({ task }: { task: Task }) {
  const statusColor = {
    pending: 'gray',
    in_progress: 'blue',
    completed: 'green',
  }[task.status];

  return (
    <Card>
      <CardHeader>
        <Title>{task.title}</Title>
        <Badge color={statusColor}>{task.status}</Badge>
      </CardHeader>
      <CardBody>
        <ProgressBar value={task.progress} />
      </CardBody>
    </Card>
  );
}
```

### Testing

#### Writing Tests

- Write unit tests for all new functionality
- Maintain or improve code coverage
- Use meaningful test names that describe behavior

Example test:
```python
import pytest
from marcus.core import Agent, Task


class TestAgent:
    def test_agent_can_accept_task_when_available(self):
        """Test that an available agent can accept a new task."""
        agent = Agent(name="test_agent")
        task = Task(title="Test task")
        
        assert agent.is_available()
        agent.assign(task)
        
        assert not agent.is_available()
        assert agent.current_task == task
    
    def test_agent_cannot_accept_task_when_busy(self):
        """Test that a busy agent cannot accept a new task."""
        agent = Agent(name="test_agent")
        task1 = Task(title="Task 1")
        task2 = Task(title="Task 2")
        
        agent.assign(task1)
        
        with pytest.raises(AgentBusyError):
            agent.assign(task2)
```

#### Running Tests

```bash
# Run all tests
pytest

# Run specific test file
pytest tests/test_agent.py

# Run with coverage
pytest --cov=marcus --cov-report=html

# Run specific test
pytest tests/test_agent.py::TestAgent::test_agent_can_accept_task_when_available
```

### Documentation

#### Writing Documentation

- Update docstrings for all public APIs
- Add examples for complex functionality
- Update relevant .md files
- Include type hints

Example docstring:
```python
def schedule_tasks(
    tasks: List[Task],
    agents: List[Agent],
    strategy: str = "round_robin"
) -> Dict[str, List[Task]]:
    """
    Schedule multiple tasks across available agents.
    
    Args:
        tasks: List of tasks to schedule
        agents: List of available agents
        strategy: Scheduling strategy. Options:
            - "round_robin": Distribute tasks evenly
            - "priority": Assign based on task priority
            - "capability": Match task requirements to agent capabilities
    
    Returns:
        Dictionary mapping agent IDs to assigned tasks
    
    Raises:
        ValueError: If strategy is not recognized
        InsufficientResourcesError: If not enough agents available
    
    Example:
        >>> tasks = [Task("Task 1"), Task("Task 2")]
        >>> agents = [Agent("Agent 1"), Agent("Agent 2")]
        >>> assignments = schedule_tasks(tasks, agents)
        >>> print(assignments)
        {'agent-1': [Task('Task 1')], 'agent-2': [Task('Task 2')]}
    """
```

### Pull Request Process

1. **Before submitting:**
   - Ensure all tests pass
   - Update documentation
   - Add entry to CHANGELOG.md
   - Rebase on latest main branch

2. **PR description should include:**
   - What changes were made and why
   - Link to related issue(s)
   - Screenshots for UI changes
   - Breaking changes (if any)

3. **Review process:**
   - At least one maintainer approval required
   - CI checks must pass
   - Address review feedback promptly

### Areas for Contribution

#### Good First Issues

Look for issues labeled `good first issue`:
- Documentation improvements
- Test coverage additions
- Small bug fixes
- Code style improvements

#### Feature Development

Current areas of focus:
- Agent capability expansion
- Performance optimizations
- Dashboard visualizations
- Integration plugins

#### Documentation

Always needed:
- Tutorial improvements
- API documentation
- Example projects
- Translation help

### Development Tips

#### Debugging

```python
# Enable debug logging
import logging
logging.basicConfig(level=logging.DEBUG)

# Use debugger
import pdb; pdb.set_trace()

# Or with IPython
from IPython import embed; embed()
```

#### Performance Testing

```python
import cProfile
import pstats

def profile_function():
    profiler = cProfile.Profile()
    profiler.enable()
    
    # Your code here
    
    profiler.disable()
    stats = pstats.Stats(profiler)
    stats.sort_stats('cumulative')
    stats.print_stats(10)
```

### Release Process

1. Version bumps follow [Semantic Versioning](https://semver.org/)
2. Releases are automated via GitHub Actions
3. Changelog is generated from commit messages

### Getting Help

- **Discord**: Join our [Discord server](https://discord.gg/marcus-ai)
- **Discussions**: Use [GitHub Discussions](https://github.com/marcus-ai/marcus/discussions)
- **Email**: dev@marcus-ai.dev

### Recognition

Contributors are recognized in:
- CONTRIBUTORS.md file
- Release notes
- Project website

### License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

## Thank You!

Your contributions make Marcus AI better for everyone. We appreciate your time and effort!