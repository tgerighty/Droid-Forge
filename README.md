# Droid Forge

> A comprehensive droid factory framework designed to host, manage, and orchestrate Factory.ai droids with a BAAS orchestrator.

**Disclaimer: Not affiliated with or endorsed by Factory.ai.**

Droid Forge serves as a centralized hub for developing, deploying, and managing various specialized droids through intelligent orchestration.

## 📖 Methodology & Process

### Conceptual Architecture

Droid Forge operates on a **Factory.ai droid-as-service** model where every component is a self-documenting droid (markdown + YAML). The framework is **meta-orchestral** - using Factory.ai droids to orchestrate other droids.

### Core Principles

- **Declarative Definition**: All droids defined in markdown with embedded functionality
- **Capability Matching**: Intelligent delegation based on tool analysis and pattern matching
- **Audit Trail**: Comprehensive NDJSON logging for all operations
- **ai-dev-tasks Compliance**: Strict adherence to ai-dev-tasks format for task management
- **Parallel Execution**: Multi-droid coordination with synchronization

### Process Flow

#### BAAS Orchestration Cycle
```
USER REQUEST -----> BAAS ORCHESTRATOR -----> DROID DELEGATION -----> EXECUTION -----> MONITOR -----> RESULT
     |                    |                        |                    |                 |
     |           (Analyze & Plan)            (Capability Match)     (Execute)    (Track Status)   (Aggregate)
     |                    |                        |                    |               |
     +--------------------+------------------------+--------------------+---------------+
                              |                                              |
                       TASK SEQUENCING                               AUDIT LOGGING
                             &                                               &
                    SUB-DEPENDENCY RESOLUTION                   COMMIT/PUSH AUTOMATION
```

#### ai-dev-tasks Integration
```
PRD CREATION (Manual/User)
    ↓
AI-DEV-TASKS INTEGRATOR
    ↓ (Validation)
PARENTS + SUB-TASKSbed Generation
    ↓ (Confirmation)
Deferred Task File Creation (tasks-[prd].md)
    ↓
PROCESS-TASK-LIST EXECUTION
    ↓ (Sub-task completion)
COMMITS + STATUS UPDATES
    ↓
WORKFLOW COMPLETION
```

#### Droid Interaction Matrix
```
DROIDS        | DESCRIPT DEBUG | delegation | monitoring | operations | Support
-------------|----------------|--------------|------------|------------|----------
BAAS Orc      | Central Hub    | ✓ Core       | ✓ Status   | Coordination | All
Task Mgr      | Status Control | ✓ Exec       | ✓ Locks    | Serialization| BAAS
Git Workflow  | VCS Management | ✓ Branches   | ✓ History  | Commits/PRs| BAAS
AI-DevTasks   | Process Engine | ✓ Tasks      | ✓ Files    | Format Comp | BAAS
Code Review   | Quality Checks | ✓ Multi-D   | ✓ Progress | Review Mgmt| BAAS
Biome         | Linting/Fmt    | ✓ Quality    | ✗         | Code Style  | PreCommit
Unit Test     | Test Runner    | ✓ Validation | ✓ Coverage | Test Exec   | PreCommit
Changelog     | Doc Mgmt       | ✓ History    | ✓ Runs     | Updates     | All
Branch Mgr    | Branch Ctrl    | ✓ Creation   | ✓ Merge    | Lifecycle   | Git
Merge Resolve | Conflict Fix   | ✓ Conflicts   | ✓ Status   | AutoResolve | Git
CodeRabbit    | AI Review      | ✓ Analysis   | ✓ Metrics  | Suggestions | Code Review
Pre-Commit    | Quality Gate   | ✓ Hooks      | ✓ Check    | Enforcement | Git
```

### ai-dev-tasks Format Compliance

Droid Forge enforces strict compliance with ai-dev-tasks format for task management:

```
## Relevant Files
- `file1.ts` - Component implementation
- `file2.test.ts` - Unit tests

## Tasks

- [ ] 1.0 Major Category Name
  - [ ] 1.1 Sub-task with details
  - [ ] 1.2 Another sub-task
```

### Parallel Execution Safety

- **Locking Mechanisms**: File-based locks for concurrent task operations
- **Status Synchronization**: NDJSON events ensure consistent tracking across droids
- **Rollback Protection**: Backup and restore on failed operations
- **Dependency Resolution**: Sub-task sequencing with hierarchy validation

## 🎯 Overview

Droid Forge is a declarative, droid-based framework that uses Factory.ai's own droid system to create a meta-orchestration layer. All functionality is implemented as Factory.ai droids (markdown with YAML frontmatter) and executed through the Factory.ai CLI.

## 📚 Installation & Usage

### For Framework Users (Installing in Projects)

1. **Clone the Repository**
   ```
   git clone https://github.com/yourusername/droid-forge.git
   cd droid-forge
   ```

2. **Install Factory.ai CLI**
   ```
   # Assuming Factory.ai provides installation
   factory-cli install
   ```

3. **Install Core Droids**
   ```
   factory-cli droid install baas-orchestrator
   factory-cli droid install task-manager
   factory-cli droid install git-workflow-orchestrator
   factory-cli droid install ai-dev-tasks-integrator
   ```

4. **Configure droid-forge.yaml**
   ```yaml
   # Basic configuration
   orchestration:
     debug: false
     audit_dir: ".droid-forge/logs"
     task_timeout: 3600  # 1 hour

   # Droid capabilities
   droids:
     locations:
       - ".factory/droids/"  # Project droids
       - "~/droid-forge/"    # Personal droids

   # Workflow rules
   corellian_rules:
     project_payments: "task-manager"
     git_operations: "git-workflow-orchestrator"
     code_reviews: "code-review-coordinator"
   ```

5. **Start BAAS Orchestrator**
   ```
   factory-cli droid start baas-orchestrator
   ```

### Basic Usage

**Analyze a feature request and create tasks:**
```
factory-cli "Add dark mode toggle to settings page"
```

This triggers:
1. BAAS analysis of the request
2. Delegation to ai-dev-tasks-integrator for PRD processing
3. Task generation with sub-tasks
4. Status tracking through completion

**Monitor task progress:**
```
factory-cli "Show current task status"
```

**View orchestrator logs:**
```
tail -f .droid-forge/logs/events.ndjson
```

## 🔧 Contributing (For Framework Development)

### Adding New Droids

1. Create `.factory/droids/your-droid.md`
2. Include augmentation YAML frontmatter
3. Implement functionality in markdown code blocks
4. Add capability matching rules to orchestration logic
5. Test integration with BAAS delegation

### Example Droid Template

```markdown
---
name: example-coordinator
version: "1.0.0"
model: inherit
tools:
  - Execute
  - Read
description: Example functionality
---

# Example Coordinator Droid

```bash
example_function() {
  echo "Example droid functionality"
}
```
```

### Development Workflow

1. Create feature branch: `git checkout -b feat/new-droid`
2. Implement droid spec in markdown
3. Update BAAS orchestration logic for delegation
4. Add tests for integration
5. Commit with conventional format: `feat: add new coordinator`
6. Create PR for review

### Testing Strategy

- **Unit Tests**: Each droid's bash functions tested individually
- **Integration Tests**: BAAS delegation sequences validated  
- **End-to-End**: Complete workflows from request to completion
- **Performance**: Orchestration efficiency monitored
- **Audit**: All operations logged for traceability

## 📋 Task Management Format

Droid Forge uses ai-dev-tasks format for all task tracking:

### Task File Structure (`tasks/tasks-000X-prd-title.md`)

```markdown
## Relevant Files

- `src/component.tsx` - Main implementation
- `tests/component.test.ts` - Unit tests
- `docs/api.md` - Documentation

## Tasks

- [x] 1.0 Component Implementation
  - [x] 1.1 Create component structure
  - [x] 1.2 Add TypeScript interfaces
  - [x] 1.3 Implement core logic
- [ ] 2.0 Testing Implementation
  - [x] 2.1 Create unit test suite
  - [ ] 2.2 Add integration tests
```

### Status Transitions

- `[ ]` - Scheduled/pending
- `[in_progress]` or logged - In execution
- `[x]` - Completed
- `[cancelled]` - Aborted tasks

### Commit Format

```
feat: implement dark mode toggle
feat: add user authentication system
fix: resolve login validation bug
```

## 🔄 Git Workflow Integration

### Branch Strategy

- `main`: Production branch
- `develop`: Development integration
- `feat/xxx`: Feature branches
- `hotfix/xxx`: Emergency fixes

### Automated Operations

- **Commit Formatting**: Conventional commit enforcement
- **Branch Cleanup**: Automatic merging and deletion
- **Conflict Resolution**: Intelligent merge strategies
- **PR Management**: Automated review coordination

## 📊 Monitoring & Analytics

### Event Logging

All framework operations logged in NDJSON format:

```json
{"timestamp":"2024-10-09T08:00:00Z","event":"task_status_updated","project":"droid-forge","task_id":"1.1","new_status":"completed","run_id":"r-20241009-080000"}
{"timestamp":"2024-10-09T08:15:00Z","event":"droid_delegated","subagent":"unit-test-droid","prompt":"run tests","run_id":"r-20241009-080000"}
```

### Metrics Dashboard

- Task completion rates
- Droid execution success rates
- Error frequency and types
- Performance benchmarks

### Audit Trail

- `.droid-forge/logs/audit.ndjson`: Comprehensive operation history
- `.droid-forge/logs/events.ndjson`: Runtime event stream
- `.droid-forge/branch-metadata/`: Branch-specific tracking data

## 🏗️ Architecture

### Core Components

- **🧠 BAAS Orchestrator** - Broker and Automation System for task management and coordination (BAAS also means "Chief" or "Boss" in Dutch)
- **📋 Task Manager** - Atomic task lifecycle management with file locking
- **🔀 Git Workflow Orchestrator** - Branch management and commit coordination
- **🔗 AI-Dev-Tasks Integrator** - Process file synchronization and PRD integration
- **📊 Changelog Maintainer** - Run tracking and change documentation

### Directory Structure

```
droid-forge/
├── .factory/droids/          # Factory.ai droids (our custom ones)
├── .droid-forge/            # Droid Forge-specific data
│   └── logs/                # NDJSON audit and event logs
├── ai-dev-tasks/            # Process files from https://github.com/snarktank/ai-dev-tasks (linked, not copied)
├── tasks/                   # Generated task lists
├── tools/                   # Analysis utilities
├── droid-forge.yaml         # Configuration file
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
- Interactive HTML dashboard for log visualization

### ⚙️ Configuration-Driven
- All behavior configurable via `droid-forge.yaml`
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

### Installation

1. Clone this repository:
```bash
git clone https://github.com/tgerighty/Droid-Forge.git
cd Droid-Forge
```

2. Copy droids to your Factory.ai personal directory:
```bash
cp .factory/droids/*.md ~/.factory/droids/
```

3. Configure your project in `droid-forge.yaml`:
```yaml
# Customize delegation rules, Git settings, logging etc.
```

### Usage

#### Start Orchestration
```bash
# Use Factory.ai CLI with BAAS Orchestrator
droid baas-orchestrator "Analyze tasks/0001-prd-droid-forge.md and orchestrate implementation"
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
# Open interactive dashboard
open baas-dashboard.html

# View raw logs
cat .droid-forge/logs/audit.ndjson
cat .droid-forge/logs/events.ndjson
```

## 📋 Configuration

The `droid-forge.yaml` file controls all factory behavior:

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
3. Add delegation rules in `droid-forge.yaml`
4. Copy to personal droids directory

### Task Management

Droid Forge integrates with [ai-dev-tasks](https://github.com/snarktank/ai-dev-tasks) for PRD-driven development:

- PRD analysis and task breakdown
- Structured task list generation
- Status tracking with inline markers
- Progress monitoring and reporting

## 📊 Monitoring

### Log Analysis

Comprehensive logging in `.droid-forge/logs/`:
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
- **[ai-dev-tasks](https://github.com/snarktank/ai-dev-tasks)** - For the excellent PRD-driven development framework and process documentation that guides our implementation approach
- **Gemini 2.5 Pro** - For invaluable architecture review and recommendations that shaped the robust design of this system

### Inspiration

The "droid factory" concept is inspired by advanced manufacturing and orchestration systems, where specialized autonomous agents are created and coordinated to accomplish complex missions through intelligent task management.

## 🔗 Related Projects

- [Factory.ai](https://factory.ai/) - AI-powered development platform
- [ai-dev-tasks](https://github.com/snarktank/ai-dev-tasks) - PRD-driven development framework
- [Gemini CLI](https://github.com/google-gemini/gemini-cli) - Command-line AI agent

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ and a lot of droids**
