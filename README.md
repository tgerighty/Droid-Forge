# Droid Forge

> A comprehensive droid factory framework designed to host, manage, and orchestrate Factory.ai droids with intelligent task delegation and specialized expertise.

**Disclaimer: Not affiliated with or endorsed by Factory.ai.**

Droid Forge serves as a centralized hub for developing, deploying, and managing 35+ specialized droids through intelligent orchestration, achieving **10.1% token optimization** while maintaining full functionality.

## 📖 Methodology & Process

### Conceptual Architecture

Droid Forge operates on a **Factory.ai droid-as-service** model where every component is a self-documenting droid (markdown + YAML). The framework is **meta-orchestral** - using Factory.ai droids to orchestrate other droids.

### Core Principles

- **Declarative Definition**: All droids defined in markdown with embedded functionality
- **Capability Matching**: Intelligent delegation based on tool analysis and pattern matching
- **Task Tracking**: Comprehensive task status tracking for all operations
- **ai-dev-tasks Compliance**: Strict adherence to ai-dev-tasks format for task management
- **Parallel Execution**: Multi-droid coordination with synchronization

### Process Flow

#### Manager Droid Orchestration Cycle
```
USER REQUEST -----> Manager Droid ORCHESTRATOR -----> DROID DELEGATION -----> EXECUTION -----> MONITOR -----> RESULT
     |                    |                        |                    |                 |
     |           (Analyze & Plan)            (Capability Match)     (Execute)    (Track Status)   (Aggregate)
     |                    |                        |                    |               |
     +--------------------+------------------------+--------------------+---------------+
                              |                                              |
                       TASK SEQUENCING                               STATUS TRACKING
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
Manager Droid Orc      | Central Hub    | ✓ Core       | ✓ Status   | Coordination | All
Task Mgr      | Status Control | ✓ Exec       | ✓ Locks    | Serialization| Manager Droid
Git Workflow  | VCS Management | ✓ Branches   | ✓ History  | Commits/PRs| Manager Droid
AI-DevTasks   | Process Engine | ✓ Tasks      | ✓ Files    | Format Comp | Manager Droid
Code Review   | Quality Checks | ✓ Multi-D   | ✓ Progress | Review Mgmt| Manager Droid
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
- **Status Synchronization**: Task state ensures consistent tracking across droids
- **Rollback Protection**: Backup and restore on failed operations
- **Dependency Resolution**: Sub-task sequencing with hierarchy validation

## 🎯 Overview

Droid Forge is a declarative, droid-based framework that uses Factory.ai's own droid system to create a meta-orchestration layer. All functionality is implemented as Factory.ai droids (markdown with YAML frontmatter) and executed through the Factory.ai CLI.

## 🚀 Key Optimizations

- **10.1% Total Token Reduction**: Reduced from 112,694 to 101,268 tokens
- **Cost Savings**: $0.04 per analysis, $36.20/month for 1,000 analyses
- **Performance**: 6% more context window availability
- **Zero Functionality Loss**: All capabilities preserved while improving efficiency
- **35+ Specialized Droids**: Complete ecosystem of domain-specific experts

## 📚 Installation & Usage

### For Framework Users (Installing in Projects)

1. **Clone the Repository**
   ```
   git clone https://github.com/yourusername/droid-forge.git
   cd droid-forge
   ```

2. **Install Factory.ai CLI**
   
   If you don't have the Factory.ai CLI installed, follow the quickstart guide:
   https://docs.factory.ai/cli/getting-started/quickstart

3. **Install Core Droids**
   ```
   # Option 1: Use the installation script to choose location
   ./install.sh
   
   # Option 2: Manual installation (default to project directory)
   mkdir -p .factory/droids
   cp .factory/droids/*.md .factory/droids/
   ```

4. **Configure droid-forge.yaml**
   ```yaml
   # Basic configuration
   orchestration:
     debug: false
     task_timeout: 3600  # 1 hour

   # Droid capabilities
   droids:
     locations:
       - ".factory/droids"          # Project-specific droids
       - "~/.factory/droids"        # Personal/global droids

   # Workflow rules
   corellian_rules:
     project_payments: "task-manager"
     git_operations: "git-workflow-orchestrator"
     code_reviews: "code-review-coordinator"
   ```

5. **Start using Droid Forge**
   
   Simply invoke the droid CLI and ask the manager orchestrator to perform tasks.

### Uninstallation (When needed)

To completely remove Droid Forge from your system:
```bash
# Interactive mode with safety options
./uninstall.sh

# Or use specific options
./uninstall.sh --project-only  # Remove from current project
./uninstall.sh --user-only     # Remove from personal directory
./uninstall.sh --dry-run       # Preview what would be removed
```

### Basic Usage

**Analyze a feature request and create tasks:**
```
droid
> Ask manager-orchestrator-droid-forge to add dark mode toggle to settings page
```

This triggers:
1. Manager Droid analysis of the request
2. Delegation to ai-dev-tasks-integrator for PRD processing
3. Task generation with sub-tasks
4. Status tracking through completion

**Use specialized droids directly:**
```
droid
> Ask frontend-engineer-droid-forge to create responsive user profile component

droid
> Ask database-specialist-droid-forge to optimize query performance

droid
> Ask comprehensive-testing-droid-forge to implement E2E test suite

droid
> Ask typescript-specialist-droid-forge to improve type safety
```

**Monitor task progress:**
```
droid
> Ask manager-orchestrator-droid-forge to show current task status
```

### Uninstallation

**Remove Droid Forge completely:**
```bash
# Interactive mode with options
./uninstall.sh

# Remove from current project only
./uninstall.sh --project-only

# Remove from personal directory only
./uninstall.sh --user-only

# Remove from both locations
./uninstall.sh --both

# Preview what would be removed (dry run)
./uninstall.sh --dry-run

# Show detailed output
./uninstall.sh --verbose
```

The uninstaller safely removes:
- All droids from `.factory/droids/` (project)
- All droids from `~/.factory/droids/` (personal)
- Configuration files (`droid-forge.yaml`, `AGENTS.md`)
- Tools, tests, and working directories
- `.gitignore` entries related to Droid Forge

**Safety features:**
- Dry run mode to preview changes
- Interactive confirmation required
- Verbose output for detailed tracking
- Graceful error handling and reporting

## 🔧 Contributing (For Framework Development)

### Adding New Droids

1. Create `.factory/droids/your-droid.md`
2. Include augmentation YAML frontmatter
3. Implement functionality in markdown code blocks
4. Add capability matching rules to orchestration logic
5. Test integration with Manager Droid delegation

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
3. Update Manager Droid orchestration logic for delegation
4. Add tests for integration
5. Commit with conventional format: `feat: add new coordinator`
6. Create PR for review

### Testing Strategy

- **Unit Tests**: Each droid's bash functions tested individually
- **Integration Tests**: Manager Droid delegation sequences validated  
- **End-to-End**: Complete workflows from request to completion
- **Performance**: Orchestration efficiency monitored
- **Tracking**: All operations tracked for traceability

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
- `[in_progress]` - In execution
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

## 🏗️ Architecture

## 🤖 Available Droids

### Orchestration & Management
- **🧠 Manager Orchestrator** - Central coordination, PRD analysis, task delegation, workflow management
- **🔀 Git Workflow Orchestrator** - Branch management, commit coordination, merge strategies
- **📋 AI-Dev-Tasks Integrator** - Process file synchronization and PRD integration
- **📊 Plan Review** - Pre-implementation plan validation with GREEN/YELLOW/RED decisions

### Development & Engineering
- **⚛️ Frontend Engineer** - React/Next.js components, responsive design, accessibility
- **🔧 Backend Security Specialist** - API design, database integration, security assessment
- **🗄️ Database Specialist** - PostgreSQL 18, Drizzle ORM, performance optimization
- **🔷 TypeScript Specialist** - Comprehensive TypeScript integration, advanced patterns, type safety
- **⚡ Next.js Specialist** - Next.js 15, App Router, Server Components, performance
- **🔗 tRPC Specialist** - API architecture, TanStack Query integration, type safety

### Code Quality & Testing
- **🔍 Code Reviewer** - Senior engineer code review, security, performance, correctness
- **🧪 Comprehensive Testing** - Unit, E2E, performance, accessibility, WCAG compliance
- **🔧 Code Tools Specialist** - Bug analysis, code quality assessment, unified patches
- **🛠️ Biome** - JavaScript/TypeScript code quality (ESLint, Prettier, TypeScript)
- **📝 Code Refactoring** - Code quality improvement, maintainability, performance

### DevOps & Infrastructure
- **🚀 DevOps Automation** - CI/CD pipelines, automated workflows, deployment automation
- **💾 Caching Specialist** - Valkey/Redis caching strategies, performance optimization
- **🔐 Better Auth** - OAuth, sessions, tRPC context, Next.js middleware
- **🖥️ Replit Assessment** - Platform optimization, infrastructure elimination

### Specialized Services
- **🔍 Change Auditor** - Change verification, security scans, PASS/FAIL reporting
- **🐛 Debugging Assessment** - Root cause analysis, bug identification, fix tasks
- **📊 Code Analysis** - Context analysis, impact assessment, file mapping
- **📝 Template** - Standardized structure and patterns for all droids

### Project & Workflow
- **🔄 Git Workflow Orchestrator** - Coordinated commit handling, branch management
- **📋 AI-Dev-Tasks Integrator** - Workflow synchronization, PRD processing

### Directory Structure

```
droid-forge/
├── .factory/droids/          # Factory.ai droids (our custom ones)
├── .droid-forge/            # Droid Forge-specific data
│   └── metadata/            # Branch and task metadata
├── ai-dev-tasks/            # Process files from https://github.com/tgerighty/ai-dev-tasks (linked, not copied)
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

### 📊 Comprehensive Tracking
- Task status monitoring
- Complete execution history with timestamps
- Performance metrics and execution tracking
- Progress visualization and reporting

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

- [Factory.ai CLI](https://docs.factory.ai/cli/getting-started/quickstart) installed
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
# Customize delegation rules, Git settings, task tracking etc.
```

### Usage

#### Start Orchestration
```bash
droid
> Ask manager-orchestrator-droid-forge to analyze tasks/0001-prd-droid-forge.md and orchestrate implementation
```

#### Individual Droid Operations
```bash
droid
> Ask manager-orchestrator-droid-forge to update task 1.1 status to started

droid
> Ask git-workflow-orchestrator-droid-forge to create feature branch for task 1.2

droid
> Ask ai-dev-tasks-integrator-droid-forge to sync latest process files

droid
> Ask code-reviewer-droid-forge to review pull request #123

droid
> Ask change-auditor-droid-forge to audit implementation changes

droid
> Ask plan-review-droid-forge to validate implementation plan
```

#### Monitor Progress
```bash
droid
> Ask manager-orchestrator-droid-forge to show current task status

droid
> Ask manager-orchestrator-droid-forge to show project overview
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

Droid Forge integrates with [ai-dev-tasks](https://github.com/tgerighty/ai-dev-tasks) for PRD-driven development:

- PRD analysis and task breakdown
- Structured task list generation
- Status tracking with inline markers
- Progress monitoring and reporting

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
- **[ai-dev-tasks](https://github.com/tgerighty/ai-dev-tasks)** - For the excellent PRD-driven development framework and process documentation that guides our implementation approach
- **Gemini 2.5 Pro** - For invaluable architecture review and recommendations that shaped the robust design of this system

### Inspiration

The "droid factory" concept is inspired by advanced manufacturing and orchestration systems, where specialized autonomous agents are created and coordinated to accomplish complex missions through intelligent task management.

## 🔗 Related Projects

- [Factory.ai](https://factory.ai/) - AI-powered development platform
- [ai-dev-tasks](https://github.com/tgerighty/ai-dev-tasks) - PRD-driven development framework
- [Factory.ai CLI](https://docs.factory.ai/cli/getting-started/quickstart) - Command-line AI agent

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ and a lot of droids**
