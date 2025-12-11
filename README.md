# Droid Forge

> A comprehensive droid factory framework for Factory.ai CLI - host, manage, and orchestrate 40+ specialized droids with intelligent task delegation and SonarQube-level code analysis.

**Disclaimer: Not affiliated with or endorsed by Factory.ai.**

Droid Forge provides a complete ecosystem of specialized AI droids that work with the [Factory.ai CLI](https://docs.factory.ai/cli/getting-started/quickstart) to automate code reviews, security analysis, performance optimization, and development workflows.

## 🚀 Quick Start

### Prerequisites

1. **Install Factory.ai CLI**
   ```bash
   # Follow the quickstart guide:
   # https://docs.factory.ai/cli/getting-started/quickstart
   
   # Verify installation
   droid --version
   ```

2. **Clone Droid Forge**
   ```bash
   git clone https://github.com/tgerighty/Droid-Forge.git
   cd Droid-Forge
   ```

3. **Install Droids**
   ```bash
   ./install.sh
   # Choose: Project (.factory/droids) or Personal (~/.factory/droids)
   ```

4. **Start Using Droids**
   ```bash
   droid
   > Ask pr-review-droid-forge to review my changes against main branch
   ```

## 🎯 What's New: PR Review System

Droid Forge now includes a **SonarQube-level PR Review System** with 10 specialized analysis droids coordinated by a central orchestrator:

### PR Review Orchestrator

The `pr-review-droid-forge` coordinates comprehensive pull request reviews:

```bash
droid
> Ask pr-review-droid-forge to review all changes against main branch
```

This triggers **10 parallel analyses**:

| Analysis | Droid | Focus |
|----------|-------|-------|
| 🔐 Security | `security-vulnerability-droid-forge` | OWASP Top 10, CWE patterns, secrets |
| 🐛 Bugs | `bug-detection-droid-forge` | Race conditions, null safety, async |
| 🏗️ Architecture | `architecture-analysis-droid-forge` | SOLID, design patterns, coupling |
| 🧪 Code Smells | `code-smells-droid-forge` | Cognitive complexity, SonarQube rules |
| 📋 Duplication | `duplicate-code-droid-forge` | Copy-paste, DRY violations |
| ⚡ Performance | `performance-analysis-droid-forge` | N+1 queries, re-renders, O(n²) |
| 🧪 Test Quality | `test-quality-droid-forge` | Coverage gaps, flaky tests |
| 📦 Dep Recommendations | `dependency-recommendations-droid-forge` | Library suggestions |
| 🔄 Dep Updates | `dependency-updates-droid-forge` | Vulnerabilities, outdated |
| 💀 Dead Code | `dead-code-hunter-droid-forge` | Unused exports, unreachable |

## 📖 Usage Guide

### Using the Factory.ai CLI

All droids are invoked through the Factory.ai CLI using natural language:

```bash
# Start the droid CLI
droid

# Then ask any droid to perform tasks:
> Ask [droid-name] to [task description]
```

### PR Review Examples

**Full Comprehensive Review:**
```bash
droid
> Ask pr-review-droid-forge to perform a comprehensive review of my PR against main
```

**Security-Focused Review:**
```bash
droid
> Ask security-vulnerability-droid-forge to scan my changes for OWASP vulnerabilities
```

**Performance Analysis:**
```bash
droid
> Ask performance-analysis-droid-forge to check for N+1 queries and React re-render issues
```

**Code Quality Review:**
```bash
droid
> Ask code-smells-droid-forge to analyze cognitive complexity and find nested ternaries
```

**Bug Detection:**
```bash
droid
> Ask bug-detection-droid-forge to find race conditions and null safety issues
```

### Development Workflow Examples

**Create a New Feature:**
```bash
droid
> Ask manager-orchestrator-droid-forge to help me implement user authentication
```

**Code Review:**
```bash
droid
> Ask code-reviewer-droid-forge to review my implementation for security and performance
```

**Database Optimization:**
```bash
droid
> Ask database-specialist-droid-forge to optimize my PostgreSQL queries
```

**Frontend Development:**
```bash
droid
> Ask frontend-engineer-droid-forge to create a responsive dashboard component
```

**TypeScript Improvements:**
```bash
droid
> Ask typescript-specialist-droid-forge to improve type safety in my API layer
```

**Run Tests:**
```bash
droid
> Ask comprehensive-testing-droid-forge to create E2E tests for the checkout flow
```

## 🤖 Complete Droid Catalog (40+)

### PR Review & Analysis Droids (NEW)

| Droid | Description | Key Capabilities |
|-------|-------------|------------------|
| `pr-review-droid-forge` | **Orchestrator** - Coordinates all analysis droids | Parallel execution, result aggregation, severity classification |
| `security-vulnerability-droid-forge` | Security scanning | OWASP Top 10, CWE patterns, injection flaws, secrets detection |
| `bug-detection-droid-forge` | Bug hunting | Race conditions, null safety, async issues, control flow bugs |
| `architecture-analysis-droid-forge` | Architecture review | SOLID principles, design patterns, coupling, complexity |
| `code-smells-droid-forge` | Code quality | Cognitive complexity, nested ternaries, SonarQube rules |
| `duplicate-code-droid-forge` | DRY enforcement | Copy-paste detection, structural clones, refactoring suggestions |
| `performance-analysis-droid-forge` | Performance optimization | N+1 queries, React re-renders, algorithm complexity |
| `test-quality-droid-forge` | Test improvement | Coverage gaps, flaky tests, weak assertions |
| `dependency-recommendations-droid-forge` | Library suggestions | Reduce complexity with battle-tested packages |
| `dependency-updates-droid-forge` | Dependency management | Security vulnerabilities, outdated packages, migration guides |
| `dead-code-hunter-droid-forge` | Code cleanup | Unused exports, unreachable code, stale imports |

### Orchestration & Management

| Droid | Description |
|-------|-------------|
| `manager-orchestrator-droid-forge` | Central coordination, PRD analysis, task delegation |
| `git-workflow-orchestrator-droid-forge` | Branch management, commit coordination |
| `ai-dev-tasks-integrator-droid-forge` | PRD processing, task synchronization |
| `plan-review-droid-forge` | Pre-implementation validation (GREEN/YELLOW/RED) |

### Development Specialists

| Droid | Description |
|-------|-------------|
| `frontend-engineer-droid-forge` | React/Next.js, responsive design, accessibility |
| `backend-security-specialist-droid-forge` | API design, database integration, security |
| `database-specialist-droid-forge` | PostgreSQL 18, Drizzle ORM, query optimization |
| `typescript-specialist-droid-forge` | Type safety, advanced patterns, integration |
| `nextjs-specialist-droid-forge` | Next.js 15, App Router, Server Components |
| `trpc-specialist-droid-forge` | tRPC, TanStack Query, end-to-end type safety |

### Quality & Testing

| Droid | Description |
|-------|-------------|
| `code-reviewer-droid-forge` | Senior-level code review, security, performance |
| `comprehensive-testing-droid-forge` | Unit, E2E, performance, accessibility testing |
| `biome-droid-forge` | ESLint, Prettier, TypeScript linting |
| `ultracite-droid-forge` | Strict TypeScript linting and auto-fix |
| `code-refactoring-droid-forge` | Code quality improvement, maintainability |

### DevOps & Infrastructure

| Droid | Description |
|-------|-------------|
| `devops-automation-droid-forge` | CI/CD pipelines, deployment automation |
| `change-auditor-droid-forge` | Change verification, security scans |
| `caching-specialist-droid-forge` | Valkey/Redis strategies, performance |
| `better-auth-integration-droid-forge` | OAuth, sessions, authentication flows |
| `pre-commit-droid-forge` | Pre-commit hooks and quality gates |

### Analysis & Debugging

| Droid | Description |
|-------|-------------|
| `debugging-assessment-droid-forge` | Root cause analysis, bug identification |
| `code-analysis-droid-forge` | Context analysis, impact assessment |
| `code-tools-specialist-droid-forge` | Bug analysis, unified patches |

## 🔧 Installation

### Quick Install

```bash
# Clone the repository
git clone https://github.com/tgerighty/Droid-Forge.git
cd Droid-Forge

# Run the installer
./install.sh
```

The installer will:
1. Check for Factory.ai CLI
2. Ask where to install (project or personal directory)
3. Let you select a model (or use 'inherit' for default)
4. Copy all droids to the selected location
5. Verify key droids are installed

### Manual Install

```bash
# For project-specific droids
mkdir -p .factory/droids
cp .factory/droids/*.md .factory/droids/

# For personal/global droids
mkdir -p ~/.factory/droids
cp .factory/droids/*.md ~/.factory/droids/
```

### Install to Another Project

```bash
./install-to-project.sh /path/to/your/project
```

### Uninstall

```bash
./uninstall.sh
# Options: --project-only, --user-only, --dry-run
```

## 📊 PR Review Output Format

The PR Review system outputs findings in a structured format:

### Summary Report
```markdown
## PR Review Summary

**Total Issues**: 42
**Decision**: request_changes

### By Severity
- ❌ Errors: 3
- ⚠️ Warnings: 15
- ℹ️ Info: 24

### By Category
- 🔐 Security: 2 (1 critical, 1 high)
- 🐛 Bugs: 5 (2 errors, 3 warnings)
- 🏗️ Architecture: 8 (all warnings)
- 🧪 Code Smells: 12
- ⚡ Performance: 3
```

### Individual Issue Format
```json
{
  "path": "src/api/users.ts",
  "line": 42,
  "severity": "error",
  "category": "security",
  "body": "[Security] SQL Injection: Template literal with user input. Fix: Use parameterized queries.",
  "cwe": "CWE-89"
}
```

## ⚙️ Configuration

### droid-forge.yaml

```yaml
# Orchestration settings
orchestration:
  debug: false
  task_timeout: 3600

# Droid locations
droids:
  locations:
    - ".factory/droids"      # Project droids
    - "~/.factory/droids"    # Personal droids

# Delegation rules
delegation_rules:
  rules:
    - pattern: "security|vulnerability|owasp"
      droid_types: ["security-vulnerability-droid-forge"]
      priority: 1
    - pattern: "bug|error|crash"
      droid_types: ["bug-detection-droid-forge"]
      priority: 1
    - pattern: "performance|slow|optimize"
      droid_types: ["performance-analysis-droid-forge"]
      priority: 2

# Git workflow
git:
  branch_patterns:
    feature: "feat/{task-id}-{description}"
    bugfix: "fix/{task-id}-{description}"
  commit_format: "{type}({scope}): {description}"
```

## 📁 Directory Structure

```
droid-forge/
├── .factory/droids/           # All droid definitions (40+)
│   ├── pr-review-droid-forge.md
│   ├── security-vulnerability-droid-forge.md
│   ├── bug-detection-droid-forge.md
│   ├── ... (more droids)
├── tools/                     # Utility scripts
├── docs/                      # Documentation
├── install.sh                 # Main installer
├── install-to-project.sh      # Project installer
├── uninstall.sh              # Uninstaller
├── local-sonar-droid.sh      # SonarQube-style analysis script
├── droid-forge.yaml          # Configuration
├── AGENTS.md                 # Coding guidelines for AI agents
└── README.md
```

## 🔄 How It Works

### Droid Discovery

Factory.ai CLI automatically discovers droids from:
1. `.factory/droids/` in current project
2. `~/.factory/droids/` in your home directory

### Droid Invocation

When you ask a droid to perform a task:
1. Factory.ai CLI finds the matching droid
2. Loads the droid's capabilities and instructions
3. Executes the task using the specified model
4. Returns results to you

### PR Review Workflow

```
User Request
    ↓
pr-review-droid-forge (Orchestrator)
    ↓
┌───────────────────────────────────────────────────┐
│  Parallel Analysis (5 concurrent)                 │
│  ├── security-vulnerability-droid-forge           │
│  ├── bug-detection-droid-forge                    │
│  ├── architecture-analysis-droid-forge            │
│  ├── code-smells-droid-forge                      │
│  ├── duplicate-code-droid-forge                   │
│  ├── performance-analysis-droid-forge             │
│  ├── test-quality-droid-forge                     │
│  ├── dependency-recommendations-droid-forge       │
│  ├── dependency-updates-droid-forge               │
│  └── dead-code-hunter-droid-forge                 │
└───────────────────────────────────────────────────┘
    ↓
Result Aggregation & Deduplication
    ↓
Unified Report with Severity Classification
```

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Adding a New Droid

1. Create `.factory/droids/your-droid-forge.md`
2. Add YAML frontmatter with name, description, model, tools
3. Document capabilities in markdown
4. Update `install.sh` key droids list if it's essential
5. Submit a PR

### Droid Template

```markdown
---
name: your-droid-forge
description: Brief description of what this droid does
model: inherit
tools: ["Read", "Grep", "Glob", "Execute", "Edit", "Create"]
version: "1.0.0"
location: project
tags: ["category1", "category2"]
---

# Your Droid Name

**Purpose**: What this droid does.

## Core Capabilities
- ✅ Capability 1
- ✅ Capability 2

## Detection Patterns
...

## Tool Usage Guidelines
...

## Output Format
...
```

## 📄 License

Apache License 2.0 - see [LICENSE](LICENSE)

## 🙏 Acknowledgments

- **[Factory.ai](https://factory.ai/)** - The incredible droid platform and CLI
- **[ai-dev-tasks](https://github.com/tgerighty/ai-dev-tasks)** - PRD-driven development framework
- Inspired by SonarQube for the comprehensive PR review analysis system

---

**Built with ❤️ and 40+ droids**
