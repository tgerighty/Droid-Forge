# Geonosis - The Droid Factory

> A comprehensive droid factory framework designed to host, manage, and orchestrate Factory.ai droids with an ST-series Super Tactical Droid "Kalani" orchestrator.

**Disclaimer: Not affiliated with or endorsed by Lucasfilm/Disney.**

Named after the planet where the Separatist Alliance created their droid armies, Geonosis serves as a centralized hub for developing, deploying, and managing various specialized droids through intelligent orchestration. The Star Wars-themed naming is used purely as a metaphor for automated, specialized task execution.

## 🎯 Overview

Geonosis is a declarative, droid-based framework that uses Factory.ai's own droid system to create a meta-orchestration layer. All functionality is implemented as Factory.ai droids (markdown with YAML frontmatter) and executed through the Factory.ai CLI.

## 🏗️ Architecture

### Core Components

- **🧠 Kalani Orchestrator** - ST-series Super Tactical Droid master orchestrator
- **📋 Task Manager** - Atomic task lifecycle management with file locking
- **🔀 Git Workflow Orchestrator** - Branch management and commit coordination  
- **🔗 AI-Dev-Tasks Integrator** - Process file synchronization and PRD integration
- **📊 Changelog Maintainer** - Run tracking and change documentation

### Directory Structure

```
geonosis/
├── .factory/droids/          # Factory.ai droids (our custom ones)
├── .geonosis/               # Geonosis-specific data
│   └── logs/                # NDJSON audit and event logs
├── ai-dev-tasks/            # Process files (linked, not copied)
├── tasks/                   # Generated task lists
├── tools/                   # Analysis utilities
├── geonosis.yaml            # Configuration file
└── README.md
```

## ✨ Key Features

### 🔒 Concurrency Control
- File-based locking mechanism prevents race conditions
- Atomic write operations (temp file → rename)
- Backup and rollback capabilities

### 📊 Comprehensive Auditing
- NDJSON structured logging
- Complete audit trails with timestamps
- Performance metrics and execution tracking
- Python analysis tools for log inspection

### ⚙️ Configuration-Driven
- All behavior configurable via `geonosis.yaml`
- Delegation rules with pattern matching
- Git workflow settings and conventions
- Error handling and recovery options

### 🤖 Droid-Based Architecture
- Everything implemented as Factory.ai droids
- No custom Python code for core functionality
- Leverages Factory.ai's droid discovery and execution
- Composable and extensible system

## 🚀 Getting Started

### Prerequisites

- [Factory.ai CLI](https://github.com/google-gemini/gemini-cli) installed
- Git repository initialized
- Python 3.9+ (for analysis tools only)

### Installation

1. Clone this repository:
```bash
git clone https://github.com/your-org/geonosis.git
cd geonosis
```

2. Copy droids to your Factory.ai personal directory:
```bash
cp .factory/droids/*.md ~/.factory/droids/
```

3. Configure your project in `geonosis.yaml`:
```yaml
# Customize delegation rules, Git settings, logging etc.
```

### Usage

#### Start Orchestration
```bash
# Use Factory.ai CLI with Kalani orchestrator
droid kalani-orchestrator "Analyze tasks/0001-prd-geonosis-droid-factory.md and orchestrate implementation"
```

#### Individual Droid Operations
```bash
# Update task status
droid task-manager "Update task 1.1 status to started"

# Git workflow management
droid git-workflow-orchestrator "Create feature branch for task 1.2"

# Sync process files
droid ai-dev-tasks-integrator "Sync latest process files"
```

#### Analyze Logs
```bash
# Analyze audit logs
python tools/analyze-audit.py --all

# Check performance metrics
python tools/analyze-audit.py --events
```

## 📋 Configuration

The `geonosis.yaml` file controls all factory behavior:

### Delegation Rules
Pattern-based task routing to appropriate droids:
```yaml
delegation_rules:
  rules:
    - pattern: "security|audit|vulnerability"
      droid_types: ["security-audit", "security-review"]
      priority: 3
    - pattern: "test|coverage|testing"
      droid_types: ["setup-comprehensive-testing"]
      priority: 2
```

### Git Workflows
Configurable branch naming and commit formats:
```yaml
git:
  branch_patterns:
    feature: "feat/{task-id}-{description}"
    bugfix: "fix/{task-id}-{description}"
  commit_format: "{type}({scope}): {description}"
```

### Concurrency Control
File locking and atomic operations:
```yaml
concurrency:
  file_locking:
    enabled: true
    lock_timeout: 300
    max_lock_attempts: 60
```

## 🔧 Development

### Adding New Droids

1. Create droid specification in `.factory/droids/`
2. Follow Factory.ai droid format (YAML frontmatter + markdown)
3. Add delegation rules in `geonosis.yaml`
4. Copy to personal droids directory

### Task Management

Geonosis integrates with [ai-dev-tasks](https://github.com/factory-ai/ai-dev-tasks) for PRD-driven development:

- PRD analysis and task breakdown
- Structured task list generation
- Status tracking with inline markers
- Progress monitoring and reporting

## 📊 Monitoring

### Log Analysis

Comprehensive logging in `.geonosis/logs/`:
- `audit.ndjson` - High-level audit trail
- `events.ndjson` - Detailed execution events

Use the built-in analysis tool:
```bash
python tools/analyze-audit.py --project-dir . --all
```

### Performance Metrics

Track droid utilization, completion rates, and execution duration through structured logs.

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'feat: add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

### Special Thanks

- **[Factory.ai](https://factory.ai/)** - For providing the incredible droid platform and CLI tools that make this meta-orchestration possible
- **[ai-dev-tasks](https://github.com/factory-ai/ai-dev-tasks)** - For the excellent PRD-driven development framework and process documentation that guides our implementation approach
- **Gemini 2.5 Pro** - For invaluable architecture review and recommendations that shaped the robust design of this system

### Inspiration

The "droid factory" concept is inspired by the strategic manufacturing capabilities shown in the Star Wars universe, where specialized droids are created and orchestrated to accomplish complex missions through intelligent coordination.

## 🔗 Related Projects

- [Factory.ai](https://factory.ai/) - AI-powered development platform
- [ai-dev-tasks](https://github.com/factory-ai/ai-dev-tasks) - PRD-driven development framework
- [Gemini CLI](https://github.com/google-gemini/gemini-cli) - Command-line AI agent

---

**Built with ❤️ and a lot of droids**
