# AGENTS.md - Droid Forge Coding Guidelines

> **Comprehensive guide for AI agents working with Droid Forge droids (v2.1 - Token Optimized)**

AI coding agents: Use this guide to effectively leverage the Droid Forge framework and specialized droids for software development.

---

## Table of Contents

- [Overview](#overview)
- [Core Principles](#core-principles)
- [Task Management](#task-management)
- [Droid Directory](#droid-directory)
- [Usage Guidelines](#usage-guidelines)
- [Decision Trees](#decision-trees)
- [Examples](#examples)
- [Best Practices](#best-practices)
- [Common Pitfalls](#common-pitfalls)
- [Quick Reference](#quick-reference)

---

## Overview

### What is Droid Forge?

**Meta-orchestration framework** using Factory.ai droids to coordinate specialized droids for complex software workflows.

**Components:**
- **Manager Orchestrator**: Central coordinator
- **Specialized droids**: Domain-specific handlers (frontend, backend, testing, security)
- **Task delegation**: Automatic pattern matching
- **ai-dev-tasks**: Structured task management

### Execution Modes

**1. Iterative Mode (Default)**
- Human confirmation between tasks
- Use when: Architecture decisions needed, uncertain requirements

**2. One-Shot Mode**
- Autonomous execution, no confirmation
- Automated testing + quality gates
- Iterative PR review (max 5 cycles)
- Use when: Well-defined tasks, routine features

**Mode Selection**: Manager asks at start: *"Do you want me to one-shot or follow the iterative process?"*

### Architecture

```
USER REQUEST → Manager Orchestrator → Pattern Matching → Delegate to Specialists → Execute → Monitor → Results
```

---

## Core Principles

### 1. Single Source of Truth: ai-dev-tasks

**CRITICAL**: ALL task management uses ai-dev-tasks system.

- NEVER create custom task systems
- ALWAYS use `/tasks/tasks-[prd-name].md`
- FOLLOW ai-dev-tasks format exclusively

**Format:**
```markdown
## Relevant Files
- `src/component.tsx` - Main implementation

## Tasks
- [ ] 1.0 Major Category
  - [ ] 1.1 Sub-task details
  - [x] 1.2 Completed sub-task
```

**Status**: `[ ]` pending | `[~]` in progress | `[x]` completed | `[cancelled]` aborted

### 2. Intelligent Delegation

Use Task tool to delegate:
```bash
Task tool with subagent_type="[droid-name]" \
  description="Brief task" \
  prompt "Detailed instructions with context"
```

### 3. Configuration-Driven

All rules in `droid-forge.yaml`: delegation patterns, git workflows, timeouts, error handling.

### 4. Code Quality Standards

Biome config (`biome.json`): 2-space indent, 100-char lines, single quotes, semicolons, ES5 commas.

---

## Task Management

### Creating Tasks

1. Analyze PRD
2. Generate structured tasks (ai-dev-tasks format)
3. Save to `/tasks/tasks-[prd-name].md`
4. Link relevant files

### Updating Status

**Manual:**
```bash
sed -i 's/- \[ \] 1.2/- [~] 1.2/' tasks/tasks-0001-feature.md  # In progress
sed -i 's/- \[~\] 1.2/- [x] 1.2/' tasks/tasks-0001-feature.md  # Completed
```

**Via Manager:**
```bash
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  description="Update task status" \
  prompt "Mark task 1.2 completed in tasks-0001-feature.md"
```

### Dependencies

Structure hierarchically:
```markdown
- [ ] 1.0 Database Setup
  - [ ] 1.1 Design schema
  - [ ] 1.2 Migrations (depends on 1.1)
- [ ] 2.0 API Development (depends on 1.0)
```

---

## Droid Directory

### Organization

**Assessment Droids**: Analyze code → CREATE TASKS  
**Action Droids**: Execute tasks → UPDATE STATUS  
**Infrastructure Droids**: Orchestration & support

### Assessment Droids (Analyze → Create Tasks)

| Droid | Purpose | Creates Tasks For |
|-------|---------|-------------------|
| code-smell-assessment | Detect anti-patterns, tech debt | Bloaters, OOP abusers, change preventers, dispensables, couplers |
| cognitive-complexity-assessment | Measure complexity | High-complexity functions, excessive nesting |
| security-assessment | Identify vulnerabilities | SQL injection, XSS, CSRF, secrets, dependencies |
| typescript-assessment | Analyze type safety | 'any' usage, weak types, missing null checks |
| debugging-assessment | Root cause analysis | Bugs, performance issues, memory leaks, race conditions |
| test-assessment | Analyze test quality | Low coverage, flaky tests, missing test cases |

### Action Droids (Execute → Update Status)

| Droid | Purpose | Processes Tasks From |
|-------|---------|----------------------|
| code-refactoring | Implement refactoring | Code smells, complexity tasks |
| security-fix | Remediate vulnerabilities | Security tasks |
| typescript-fix | Improve type safety | TypeScript tasks |
| bug-fix | Fix bugs | Bug tasks |
| unit-test | Write/run tests | Test tasks |
| frontend-engineer | Build React/Next.js components | Frontend tasks |
| backend-engineer | Build APIs/services | Backend tasks |

### Infrastructure Droids

| Droid | Purpose |
|-------|---------|
| manager-orchestrator | Central coordination, task delegation, mode selection |
| auto-pr | PR creation, iterative review (max 5 cycles), CI/CD monitoring |
| task-manager | Task lifecycle, atomic operations, file locking |
| ai-dev-tasks-integrator | PRD processing, task file creation |
| git-workflow-orchestrator | Branch management, commits, merge strategies |
| biome | Linting, formatting |
| reliability | SRE, incident management, chaos engineering |
| typescript-professional | Advanced TypeScript patterns (prefer assessment + fix) |

### Capabilities Summary

**Assessment Droids:**
- code-smell: Detect bloaters, OOP abuse, change preventers, dispensables, couplers → tasks
- cognitive-complexity: Calculate scores, identify high complexity (>10), analyze nesting → tasks
- security: Scan dependencies, detect injections, find secrets, check headers → tasks
- typescript: Analyze config, detect 'any', find missing null checks, calculate coverage → tasks
- debugging: Root cause analysis, error patterns, profiling, memory leaks → tasks
- test: Analyze coverage, identify untested paths, detect flaky tests → tasks

**Action Droids:**
- code-refactoring: Extract methods/classes, simplify conditionals, remove duplication
- security-fix: Fix injections, update dependencies, remove secrets, add headers
- typescript-fix: Replace 'any', enable strict mode, add null handling, type guards
- bug-fix: Fix logic errors, race conditions, memory leaks, null references
- unit-test: Write unit/integration tests, execute suites, generate coverage
- frontend-engineer: React/Next.js, responsive CSS, accessibility, state management
- backend-engineer: REST/GraphQL APIs, database design, microservices, caching

**Infrastructure Droids:**
- manager-orchestrator: PRD analysis, multi-droid coordination, monitoring, error handling
- reliability: Incident detection, automated response, chaos engineering, SLA tracking
- auto-pr: Issue analysis, code generation, PR management, iterative review, CI/CD fixes
- task-manager: Atomic operations, file locking, status updates, validation, rollback

---

## Usage Guidelines

### When to Use Each Droid

| Task Type | Use Droid | Example Prompt |
|-----------|-----------|----------------|
| PRD analysis | manager-orchestrator | "Analyze tasks/tasks-0001.md and create plan with delegation" |
| React component | frontend-engineer | "Create TypeScript user profile component with avatar upload, responsive" |
| REST API | backend-engineer | "Implement auth API with JWT: register, login, logout, refresh" |
| Bug investigation | debugging-assessment | "Analyze memory leak in logs/profile.txt, identify source" |
| GitHub issue → PR | auto-pr | "Create PR for issue #123, monitor reviews, iterate 5x, fix CI/CD" |
| Production incident | reliability | "Respond to incident: 50% error rate, classify, notify, execute playbook" |
| Security audit | security-assessment | "Scan for SQL injection, XSS, CSRF, secrets, dependencies" |
| Test creation | unit-test | "Write unit tests for UserService.ts, 90%+ coverage, edge cases" |

**Auto-PR Iterative Review:**
1. Create initial PR
2. Monitor for bot/human comments
3. Categorize feedback (code, style, security, tests, performance)
4. Route to specialist droids
5. Commit fixes, update PR
6. Repeat (max 5 iterations)
7. Monitor/fix CI/CD

---

## Decision Trees

### Feature Development

```
START → Complex/multi-domain? 
  YES → manager-orchestrator → delegates
  NO → What domain?
    Frontend UI → frontend-engineer
    Backend API → backend-engineer
    Both → manager-orchestrator
    Testing → unit-test
    Security → security-assessment
    Operations → reliability
```

### Bug Fix

```
START → Root cause known?
  YES → Domain specialist (frontend/backend/security)
  NO → debugging-assessment → identify → domain specialist
```

### Automation

```
START → What to automate?
  GitHub issue → PR → auto-pr
  Incident response → reliability
  Code quality → biome
  Testing → unit-test
  Git workflows → git-workflow-orchestrator
```

---

## Examples

### Full-Stack Feature

```bash
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  description="Orchestrate user profile" \
  prompt "Analyze tasks/tasks-0005-user-profile.md, coordinate frontend/backend/testing"
# Manager delegates to frontend-engineer, backend-engineer, unit-test, security-audit
```

### Bug Investigation

```bash
# Step 1: Analyze
Task tool with subagent_type="debugging-assessment-droid-forge" \
  description="Debug API 500 errors" \
  prompt "Analyze logs/api-errors.log for /api/users 500s, identify root cause"

# Step 2: Fix
Task tool with subagent_type="backend-engineer-droid-forge" \
  description="Fix race condition" \
  prompt "Fix race condition with transaction management, retry logic"

# Step 3: Test
Task tool with subagent_type="unit-test-droid-forge" \
  description="Test fix" \
  prompt "Integration tests for race condition under concurrent load"
```

### Automated PR with Review

```bash
Task tool with subagent_type="auto-pr-droid-forge" \
  description="Auto-resolve with review" \
  prompt "Create PR for github.com/org/repo/issues/456. Implement fix, monitor feedback from CodeRabbit/CI/CD/humans, iterate 5x to address all comments, fix CI/CD failures"
```

### Security Audit

```bash
Task tool with subagent_type="security-assessment-droid-forge" \
  description="Pre-release audit" \
  prompt "Audit v2.0: auth, input validation, SQL injection, XSS, CSRF, dependencies, API security, encryption. Generate report with severity + remediation"
```

### Incident Response

```bash
Task tool with subagent_type="reliability-droid-forge" \
  description="Production incident" \
  prompt "Payment service 50% error rate. Classify severity, notify team, execute playbook, create channel, track timeline, coordinate with debugging-assessment, generate post-mortem"
```

---

## Best Practices

### 1. Context Required

```bash
# ❌ BAD
prompt "Make a form"

# ✅ GOOD
prompt "Create TypeScript React registration form: email (validated), password (strength), confirm, terms. Real-time validation, POST /api/auth/register, loading state, error handling, ARIA labels, responsive mobile-first. Located: src/components/auth/RegistrationForm.tsx"
```

### 2. Manager for Complex

```bash
# ✅ Let manager coordinate multi-domain work
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  description="Search feature" \
  prompt "Implement search: backend (Elasticsearch, indexing), frontend (UI, autocomplete, filters), testing (unit/integration), security (input sanitization, injection prevention). Track in tasks/tasks-0010-search.md"
```

### 3. Auto-PR for Full Cycle

```bash
# ✅ Full automation with iteration
prompt "Create PR for feature XYZ with full review automation: initial implementation, monitor feedback sources, iterate 5x to fix issues, monitor CI/CD, update PR with progress"
```

### 4. Update Status

```bash
# After completing 1.2
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  prompt "Mark task 1.2 completed in tasks/tasks-0001-feature.md"
```

### 5. Git Conventions

**Branches:** `feat/1.2-description` | `fix/2.3-description` | `refactor/3.1-description`  
**Commits:** `feat(auth): implement JWT` | `fix(api): resolve timeout` | `refactor(db): optimize queries`

### 6. Security First

```bash
# Always audit user-facing features
Task tool with subagent_type="security-assessment-droid-forge" \
  prompt "Review auth: input validation, password hashing (bcrypt/scrypt), session management, SQL injection, HTTPS, error handling (no sensitive leaks)"
```

### 7. Test Coverage

```bash
# After feature implementation
Task tool with subagent_type="unit-test-droid-forge" \
  prompt "Complete test suite for auth: unit tests (all service methods), integration (API endpoints), edge cases, security tests (injection, XSS). Target: 90%+ coverage"
```

### 8. Document

Include documentation in prompts: "Component with PropTypes, JSDoc, Storybook stories, README usage examples, accessibility notes"

### 9. Performance

Consider in prompts: "API with pagination, query optimization + indexes, Redis caching, compression, rate limiting, benchmarks. Target: <200ms p95"

### 10. Chaos Engineering

```bash
Task tool with subagent_type="reliability-droid-forge" \
  prompt "Chaos experiment for payment: database connection failure, 10% traffic, expect graceful degradation + retry, no user errors, auto-rollback 5min"
```

---

## Common Pitfalls

### ❌ 1. Custom Task Systems

**WRONG:** `echo "TODO: feature" > my-tasks.txt`  
**RIGHT:** Use ai-dev-tasks format in `tasks/tasks-0001.md`

### ❌ 2. Skip Manager

**WRONG:** Manual multi-droid coordination  
**RIGHT:** `manager-orchestrator-droid-forge` to coordinate

### ❌ 3. Vague Prompts

**WRONG:** "Create API"  
**RIGHT:** "REST API for users: GET /api/users (paginated), GET /api/users/:id, POST (create), PUT/:id (update), DELETE/:id (soft delete). Auth, validation, error handling, rate limiting, OpenAPI docs"

### ❌ 4. Ignore Security

**WRONG:** Ship without review  
**RIGHT:** Include `security-assessment-droid-forge` in workflow

### ❌ 5. Skip Auto-PR Iteration

**WRONG:** Manual PR, manual review responses  
**RIGHT:** `auto-pr-droid-forge` with full iteration: "Monitor feedback, iterate 5x until clean and mergeable"

### ❌ 6. No Tests

**WRONG:** Feature without tests  
**RIGHT:** Include in prompt: "with comprehensive test suite using React Testing Library"

### ❌ 7. Inconsistent Git

**WRONG:** Random branch/commit names  
**RIGHT:** Follow conventions: `fix/1.2-api-timeout`, `fix(api): resolve timeout`

### ❌ 8. No Monitoring

**WRONG:** Deploy without monitoring  
**RIGHT:** Setup first: "Comprehensive monitoring: health checks, metrics, alerting, dashboards"

---

## Quick Reference

### Droid Selection

| Task | Primary | Secondary |
|------|---------|-----------|
| Complex feature | manager-orchestrator | (delegates) |
| React component | frontend-engineer | unit-test |
| REST API | backend-engineer | security-assessment |
| Bug investigation | debugging-assessment | domain specialist |
| GitHub issue → PR | auto-pr | multiple via iteration |
| Production incident | reliability | debugging-assessment |
| Security review | security-assessment | - |
| Test creation | unit-test | - |
| Code formatting | biome | - |
| Git operations | git-workflow-orchestrator | - |

### Task Tool Pattern

```bash
Task tool with subagent_type="[droid-name]" \
  description="[brief]" \
  prompt "[detailed instructions]"
```

### Status Update

```bash
# Via Manager
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  prompt "Update task [id] to [status] in tasks/tasks-[prd].md"

# Manual
sed -i 's/- \[ \] [id]/- [x] [id]/' tasks/tasks-[prd].md
```

### Key Files

| File | Purpose |
|------|---------|
| `droid-forge.yaml` | Delegation rules, git workflow, performance |
| `biome.json` | Code quality standards |
| `.pre-commit-config.yaml` | Pre-commit hooks |
| `tasks/tasks-*.md` | ai-dev-tasks tracking |
| `.factory/droids/*.md` | Droid definitions |

### Environment

```bash
FACTORY_API_KEY="your-api-key"
DROID_FORGE_CONFIG="./droid-forge.yaml"
DROID_FORGE_TASKS_DIR="./tasks"
```

---

## Troubleshooting

**Droid not found:** `ls .factory/droids/[droid-name].md` | `grep -A 5 "locations:" droid-forge.yaml`

**Task file not updating:** `head -20 tasks/tasks-[prd].md` | Manual: `sed -i 's/- \[ \] id/- [x] id/' tasks/...`

**Delegation not working:** `grep -A 10 "delegation_rules:" droid-forge.yaml` | Use manager explicitly

**PR iteration stuck:** `gh pr view [num] --json state,reviewDecision,statusCheckRollup` | Debug with debugging-assessment

---

## Advanced Patterns

### Multi-Phase Development

```bash
# Phase 1: Architecture
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  prompt "Analyze PRD, create architecture for e-commerce checkout"

# Phase 2-6: Backend, Frontend, Testing, Security, Performance
# (Delegate each phase to appropriate specialists)
```

### Incident-Driven

```bash
# 1. Respond: reliability-droid-forge
# 2. Debug: debugging-assessment-droid-forge  
# 3. Fix: domain specialist (backend/frontend)
# 4. Test: unit-test-droid-forge
# 5. Monitor: reliability-droid-forge
```

### Continuous Security

```bash
# Weekly: security-assessment-droid-forge
# Automated updates: auto-pr-droid-forge for security dependencies
```

---

## Changelog

**Current**: v2.1.0  
**Status**: Phase 4.0 (Git workflow orchestration) in progress

**Recent:**
- Token optimization (v2.1): 50% reduction in AGENTS.md
- Comprehensive auto-pr iterative review
- Enhanced decision trees
- Chaos engineering patterns
- Security-first practices

---

## Resources

**Docs:** [README.md](./README.md) | [CHANGELOG.md](./CHANGELOG.md) | [LICENSE](./LICENSE)  
**External:** [Factory.ai](https://factory.ai/) | [ai-dev-tasks](https://github.com/snarktank/ai-dev-tasks) | [Biome](https://biomejs.dev/)  
**Community:** GitHub issues for bugs/features

---

## Summary

Droid Forge provides systematic AI-driven development:

1. Use ai-dev-tasks exclusively
2. Delegate intelligently via Task tool
3. Leverage specialist droids
4. Manager orchestrates complex work
5. Auto-PR for full automation + iteration
6. Follow droid-forge.yaml conventions
7. Prioritize security (regular audits)
8. Test comprehensively (unit + integration)
9. Monitor proactively (reliability droid)
10. Document thoroughly (part of development)

**Status**: Production-ready, team adoption enabled 🚀

---

**Built with ❤️ and optimized droids**
