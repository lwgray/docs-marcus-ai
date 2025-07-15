# Marcus AI Documentation

Unified documentation for the Marcus AI ecosystem, combining documentation from:
- **Marcus**: AI agent orchestration platform
- **Seneca**: Real-time visualization dashboard
- **Zeno**: (Future projects)

Visit the live documentation at [docs.marcus-ai.dev](https://docs.marcus-ai.dev).

## Repository Structure

```
docs-marcus-ai/
├── docs/                     # Documentation content
│   ├── index.md             # Homepage
│   ├── marcus/              # Marcus documentation (synced)
│   ├── seneca/              # Seneca documentation (synced)
│   └── guides/              # Cross-product guides
├── mkdocs.yml               # MkDocs configuration
├── scripts/                 # Sync and build scripts
└── .github/workflows/       # Automated workflows
```

## Local Development

### Prerequisites
- Python 3.9+
- Git

### Setup

1. Clone this repository:
```bash
git clone https://github.com/lwgray/docs-marcus-ai.git
cd docs-marcus-ai
```

2. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Sync documentation from source repositories:
```bash
./scripts/sync-docs.sh
```

5. Run the development server:
```bash
mkdocs serve
```

Visit http://localhost:8000 to see the documentation.

## Building for Production

```bash
mkdocs build
```

The built site will be in the `site/` directory.

## Automated Deployment

This repository automatically deploys to [docs.marcus-ai.dev](https://docs.marcus-ai.dev) when changes are pushed to the main branch.

Documentation is also automatically synced from the source repositories when they update their docs.

## Contributing

1. For Marcus documentation: Contribute to [marcus/docs](https://github.com/lwgray/marcus)
2. For Seneca documentation: Contribute to [seneca/docs](https://github.com/lwgray/seneca)
3. For cross-product guides: Submit PRs to this repository

## License

MIT License - see individual projects for specific licensing.