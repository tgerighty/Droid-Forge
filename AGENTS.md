# AGENTS.md - Droid Forge Coding Guidelines

> **Comprehensive guide for AI agents working with Droid Forge droids**

This document provides essential guidelines for AI coding agents to effectively use the Droid Forge framework and its specialized droids for software development tasks.

---

## Table of Contents

- [Overview](#overview)
- [Core Principles](#core-principles)
- [Task Management System](#task-management-system)
- [Droid Directory](#droid-directory)
- [Usage Guidelines](#usage-guidelines)
- [Decision Trees](#decision-trees)
- [Practical Examples](#practical-examples)
- [Best Practices](#best-practices)
- [Common Pitfalls](#common-pitfalls)

---

## Overview

### What is Droid Forge?

Droid Forge is a **meta-orchestration framework** that uses Factory.ai droids to manage and coordinate specialized droids for complex software development workflows. Think of it as a "droid factory" where:

- **Manager Orchestrator** acts as the central coordinator
- **Specialized droids** handle specific domains (frontend, backend, testing, security, etc.)
- **Task delegation** happens automatically based on pattern matching
- **ai-dev-tasks integration** provides structured task management

### Execution Modes

Droid Forge supports **two execution modes**:

#### 1. **Iterative Mode** (Default)
- Human confirmation between tasks
- Step-by-step progression
- Interactive decision-making
- **Use when**: Architecture decisions needed, learning workflow, uncertain requirements

#### 2. **One-Shot Mode** (NEW)
- Autonomous execution without confirmation
- Comprehensive automated testing
- Quality gate enforcement
- Iterative PR review and fixes
- **Use when**: Well-defined tasks, routine features, high confidence in requirements

**Mode Selection**: At workflow start, Manager Orchestrator will ask:
> **"Do you want me to one-shot or follow the iterative process?"**

Respond with **"one-shot"** or **"iterative"** to set the mode for this workflow session.

### Framework Architecture

```
USER REQUEST
    ↓
Manager Orchestrator Droid
    ↓
Capability Analysis & Pattern Matching
    ↓
Task Delegation to Specialist Droids
    ↓
Execution & Monitoring
    ↓
Status Updates & Result Aggregation
```

---

## Core Principles

### 1. **Single Source of Truth: ai-dev-tasks**

🚨 **CRITICAL**: ALL task management MUST use the ai-dev-tasks system.

- **NEVER** create built-in task management systems
- **ALWAYS** use `/tasks/tasks-[prd-name].md` files
- **FOLLOW** ai-dev-tasks format exclusively

**Task File Format:**
```markdown
## Relevant Files

- `src/component.tsx` - Main implementation
- `tests/component.test.ts` - Unit tests

## Tasks

- [ ] 1.0 Major Category Name
  - [ ] 1.1 Sub-task with details
  - [ ] 1.2 Another sub-task
  - [x] 1.3 Completed sub-task
```

**Status Markers:**
- `[ ]` - Pending/scheduled
- `[~]` - In progress
- `[x]` - Completed
- `[cancelled]` - Aborted

### 2. **Intelligent Delegation**

Use the **Task tool** to delegate work to specialized droids:

```bash
Task tool with subagent_type="[droid-name]" \
  description="Brief task description" \
  prompt "Detailed task instructions with context and requirements"
```

### 3. **Configuration-Driven Behavior**

All orchestration rules are defined in `droid-forge.yaml`:

- **Delegation patterns**: Automatic routing based on keywords
- **Git workflows**: Branch naming and commit conventions
- **Performance settings**: Timeouts and concurrency limits
- **Error handling**: Recovery strategies and notifications

### 4. **Code Quality Standards**

Follow the Biome configuration (`biome.json`):

- **Indentation**: 2 spaces
- **Line width**: 100 characters
- **Quotes**: Single quotes for JS/TS, double for JSX
- **Semicolons**: Always required
- **Trailing commas**: ES5 style

---

## Task Management System

### ai-dev-tasks Integration

#### Creating Task Files

1. **Analyze PRD** (Product Requirements Document)
2. **Generate structured tasks** following ai-dev-tasks format
3. **Save to** `/tasks/tasks-[prd-name].md`
4. **Link relevant files** in the header

#### Updating Task Status

**Manual Update:**
```bash
# Mark task 1.2 as in progress
sed -i 's/- \[ \] 1.2/- [~] 1.2/' tasks/tasks-0001-feature.md

# Mark task 1.2 as completed
sed -i 's/- \[~\] 1.2/- [x] 1.2/' tasks/tasks-0001-feature.md
```

**Via Manager Orchestrator:**
```bash
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  description="Update task status" \
  prompt "Update task 1.2 to completed in tasks-0001-feature.md"
```

#### Task Dependencies

Structure tasks hierarchically:

```markdown
- [ ] 1.0 Database Setup
  - [ ] 1.1 Design schema
  - [ ] 1.2 Create migrations (depends on 1.1)
  - [ ] 1.3 Seed data (depends on 1.2)
- [ ] 2.0 API Development (depends on 1.0)
  - [ ] 2.1 Create endpoints
  - [ ] 2.2 Add authentication
```

---

## Droid Directory

### Droid Organization

Droids are organized into three categories following **Separation of Concerns**:

1. **Assessment Droids**: Analyze code and CREATE TASKS
2. **Action Droids**: Execute tasks and UPDATE STATUS
3. **Infrastructure Droids**: Orchestration and support

### Assessment Droids (Analyze → Create Tasks)

| Droid Name | Purpose | When to Use | Task File |
|------------|---------|-------------|-----------|
| **code-smell-assessment-droid-forge** | Detect anti-patterns and technical debt | Code quality issues, maintainability problems, design pattern violations | tasks/tasks-code-smells-[date].md |
| **cognitive-complexity-assessment-droid-forge** | Measure code complexity and understandability | Functions hard to understand, excessive nesting, high cognitive load | tasks/tasks-complexity-[date].md |
| **security-assessment-droid-forge** | Identify security vulnerabilities | SQL injection, XSS, CSRF, secrets, dependency vulnerabilities | tasks/tasks-security-[date].md |
| **typescript-assessment-droid-forge** | Analyze TypeScript type safety | 'any' usage, weak types, missing null checks, strict mode issues | tasks/tasks-typescript-[date].md |
| **debugging-assessment-droid-forge** | Root cause analysis and bug identification | Errors, bugs, performance issues, memory leaks, race conditions | tasks/tasks-bugs-[date].md |
| **test-assessment-droid-forge** | Analyze test coverage and quality | Low coverage, untested code paths, flaky tests, test quality | tasks/tasks-testing-[date].md |

### Action Droids (Execute Tasks → Update Status)

| Droid Name | Purpose | When to Use | Processes Tasks From |
|------------|---------|-------------|----------------------|
| **code-refactoring-droid-forge** | Implement code refactoring | Extract methods, simplify conditionals, reduce duplication | tasks/tasks-code-smells-[date].md, tasks/tasks-complexity-[date].md |
| **security-fix-droid-forge** | Remediate security vulnerabilities | Fix SQL injection, XSS, update dependencies, add security headers | tasks/tasks-security-[date].md |
| **typescript-fix-droid-forge** | Improve TypeScript type safety | Replace 'any', add type guards, enable strict mode, fix null handling | tasks/tasks-typescript-[date].md |
| **bug-fix-droid-forge** | Implement bug fixes | Fix logic errors, race conditions, memory leaks, null references | tasks/tasks-bugs-[date].md |
| **unit-test-droid-forge** | Write tests and execute test suites | Write unit tests, run tests, achieve coverage targets | tasks/tasks-testing-[date].md |
| **frontend-engineer-droid-forge** | Build React/Next.js components | UI components, responsive design, frontend architecture | Various task files |
| **backend-engineer-droid-forge** | Build APIs and services | REST APIs, database integration, backend services | Various task files |

### Infrastructure Droids (Orchestration & Support)

| Droid Name | Purpose | When to Use |
|------------|---------|-------------|
| **manager-orchestrator-droid-forge** | Central coordination and task delegation | PRD analysis, workflow orchestration, multi-droid coordination |
| **task-manager-droid-forge** | Task lifecycle management | Task status tracking, atomic task operations, file locking |
| **ai-dev-tasks-integrator-droid-forge** | Task system integration | PRD processing, task file creation and synchronization |
| **git-workflow-orchestrator-droid-forge** | Git operations | Branch management, commit coordination, merge strategies |
| **biome-droid-forge** | Code linting and formatting | Code style checks, formatting enforcement |
| **auto-pr-droid-forge** | Automated PR creation and management | Issue-to-PR automation, iterative review fixes, CI/CD monitoring |
| **reliability-droid-forge** | SRE and incident management | Monitoring setup, incident response, chaos engineering |
| **typescript-professional-droid-forge** | Advanced TypeScript patterns | Complex type systems, generics, advanced patterns (Note: Consider using typescript-assessment + typescript-fix instead) |

### Droid Capabilities Matrix

#### Assessment Droids (Analyze → Create Tasks)

**code-smell-assessment-droid-forge**
- ✅ Detect bloaters (long methods, large classes, long parameter lists)
- ✅ Identify OOP abusers (switch statements, refused bequest)
- ✅ Find change preventers (divergent change, shotgun surgery)
- ✅ Spot dispensables (dead code, duplicate code, lazy classes)
- ✅ Detect couplers (feature envy, inappropriate intimacy)
- ✅ Generate prioritized refactoring tasks

**cognitive-complexity-assessment-droid-forge**
- ✅ Calculate cognitive complexity scores
- ✅ Identify high-complexity functions (> 10)
- ✅ Analyze nesting levels and branching
- ✅ Compare with industry thresholds
- ✅ Generate complexity reduction tasks
- ✅ Track complexity trends over time

**security-assessment-droid-forge**
- ✅ Scan dependency vulnerabilities (npm audit, Snyk)
- ✅ Detect SQL injection, XSS, CSRF, command injection
- ✅ Find hardcoded secrets and credentials
- ✅ Check security headers and CORS configuration
- ✅ Identify authentication/authorization issues
- ✅ Generate CVSS-scored remediation tasks

**typescript-assessment-droid-forge**
- ✅ Analyze TypeScript configuration (strict mode)
- ✅ Detect 'any' type usage and weak types
- ✅ Find missing null/undefined checks
- ✅ Identify unsafe type assertions
- ✅ Calculate type coverage percentage
- ✅ Generate type safety improvement tasks

**debugging-assessment-droid-forge**
- ✅ Root cause analysis from stack traces
- ✅ Error pattern recognition
- ✅ Performance profiling and bottleneck identification
- ✅ Memory leak detection
- ✅ Race condition analysis
- ✅ Generate bug fix tasks with reproduction steps

**test-assessment-droid-forge**
- ✅ Analyze test coverage (statements, branches, functions)
- ✅ Identify untested code paths
- ✅ Detect flaky tests
- ✅ Assess test quality (assertions, speed, duplication)
- ✅ Find missing test cases
- ✅ Generate test writing tasks

#### Action Droids (Execute Tasks → Update Status)

**code-refactoring-droid-forge**
- ✅ Extract methods and classes
- ✅ Simplify complex conditionals
- ✅ Remove code duplication
- ✅ Apply design patterns
- ✅ Reduce cognitive complexity
- ✅ Update task status throughout execution

**security-fix-droid-forge**
- ✅ Fix SQL injection (parameterized queries)
- ✅ Fix XSS (output encoding, sanitization)
- ✅ Fix command injection (whitelist, no shell)
- ✅ Update vulnerable dependencies
- ✅ Remove hardcoded secrets (environment variables)
- ✅ Add security headers, CSRF protection

**typescript-fix-droid-forge**
- ✅ Replace 'any' with proper types
- ✅ Enable strict mode flags
- ✅ Add null/undefined handling
- ✅ Convert type assertions to type guards
- ✅ Add missing type definitions
- ✅ Run tsc after each fix

**bug-fix-droid-forge**
- ✅ Fix logic errors and off-by-one errors
- ✅ Fix race conditions (transaction isolation)
- ✅ Fix memory leaks (cleanup handlers)
- ✅ Fix null reference errors
- ✅ Fix performance bottlenecks
- ✅ Run tests after each fix

**unit-test-droid-forge**
- ✅ Write unit tests (Jest, Vitest, Mocha)
- ✅ Write integration tests
- ✅ Execute test suites
- ✅ Generate coverage reports
- ✅ Debug failing tests
- ✅ Update task status for test tasks

**frontend-engineer-droid-forge**
- ✅ React/Next.js components with TypeScript
- ✅ Responsive CSS (Grid, Flexbox)
- ✅ Accessibility (WCAG compliance)
- ✅ Performance optimization
- ✅ State management (Context, Redux, Zustand)
- ✅ Component testing (React Testing Library)

**backend-engineer-droid-forge**
- ✅ RESTful API design
- ✅ GraphQL schemas and resolvers
- ✅ Database schema design (SQL/NoSQL)
- ✅ Microservice architecture
- ✅ Caching strategies (Redis, Memcached)
- ✅ Performance optimization

#### Infrastructure Droids (Orchestration & Support)

**manager-orchestrator-droid-forge**
- ✅ PRD analysis and task delegation
- ✅ Multi-droid workflow coordination
- ✅ Mode selection (one-shot vs iterative)
- ✅ Status monitoring and aggregation
- ✅ Error handling and recovery
- ✅ Task dependency management

**reliability-droid-forge**
- ✅ Incident detection and classification
- ✅ Automated incident response
- ✅ Root cause analysis
- ✅ Chaos engineering
- ✅ SLA/SLO tracking
- ✅ Runbook automation

**auto-pr-droid-forge**
- ✅ GitHub issue analysis
- ✅ Automated code generation
- ✅ PR creation and management
- ✅ Iterative review and fix cycles (up to 5)
- ✅ CI/CD monitoring and fixing
- ✅ Merge conflict resolution

**task-manager-droid-forge**
- ✅ Atomic task operations
- ✅ File locking protocol
- ✅ Status marker updates
- ✅ Task validation
- ✅ Rollback on failure
- ✅ Concurrent access handling

**biome-droid-forge**
- ✅ Code linting
- ✅ Formatting enforcement
- ✅ Style consistency
- ✅ Auto-fix capabilities

---

## Usage Guidelines

### When to Use Each Droid

#### 1. **Manager Orchestrator** - Central Coordination

**Use for:**
- Analyzing PRDs and creating task breakdowns
- Coordinating multi-droid workflows
- Delegating complex features across multiple domains
- Status tracking and progress monitoring

**Example:**
```bash
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  description="Analyze PRD and create implementation plan" \
  prompt "Analyze tasks/tasks-0001-user-auth.md and create comprehensive implementation plan with task delegation to appropriate specialist droids"
```

#### 2. **Frontend Engineer** - UI Development

**Use for:**
- React/Next.js component creation
- Responsive layout implementation
- Frontend state management
- UI/UX optimization

**Example:**
```bash
Task tool with subagent_type="frontend-engineer-droid-forge" \
  description="Create user profile component" \
  prompt "Generate TypeScript React component for user profile page with avatar upload, bio editing, and social links. Include responsive design for mobile/desktop and accessibility features."
```

#### 3. **Backend Engineer** - Server-Side Development

**Use for:**
- REST API or GraphQL endpoint creation
- Database schema design
- Microservice architecture
- Backend performance optimization

**Example:**
```bash
Task tool with subagent_type="backend-engineer-droid-forge" \
  description="Create authentication API" \
  prompt "Design and implement REST API for user authentication with JWT tokens, including register, login, logout, and refresh token endpoints. Include password hashing, rate limiting, and error handling."
```

#### 4. **Debugging Expert** - Problem Solving

**Use for:**
- Investigating bug reports
- Analyzing error logs
- Performance bottleneck identification
- Root cause analysis

**Example:**
```bash
Task tool with subagent_type="debugging-expert-droid-forge" \
  description="Debug memory leak issue" \
  prompt "Analyze memory leak in production application. Review heap snapshots in logs/memory-profile.txt and identify the source. Provide fix recommendations with code examples."
```

#### 5. **Reliability Droid** - SRE Operations

**Use for:**
- Incident response and management
- System monitoring setup
- Chaos engineering experiments
- SLA/SLO tracking
- Runbook creation

**Example:**
```bash
Task tool with subagent_type="reliability-droid-forge" \
  description="Setup monitoring for payment service" \
  prompt "Design comprehensive monitoring solution for payment-service including health checks, performance metrics, error rate tracking, and alerting. Create runbook for common incident scenarios."
```

#### 6. **Auto-PR Droid** - Automated Development

**Use for:**
- Converting GitHub issues to PRs
- Automated feature implementation
- **Iterative review and fix cycles** (up to 5 iterations)
- CI/CD failure resolution
- Merge conflict handling

**Example:**
```bash
Task tool with subagent_type="auto-pr-droid-forge" \
  description="Auto-generate PR from issue with iterative review" \
  prompt "Create automated PR to fix GitHub issue #123. Implement the fix, create PR, and monitor for review feedback. Automatically iterate up to 5 times to address comments from CodeRabbit, GitHub Actions, and human reviewers. Monitor CI/CD pipeline and fix any failures."
```

**Key Feature - Iterative Review:**
The auto-pr-droid will:
1. Create initial PR with implementation
2. Monitor PR for comments from bots and humans
3. Automatically categorize feedback (code, style, security, tests, performance, logic)
4. Route issues to appropriate specialist droids
5. Commit fixes and update PR
6. Repeat cycle up to configured max iterations (default: 5)
7. Monitor CI/CD and fix pipeline failures

#### 7. **Security Audit** - Security Review

**Use for:**
- Security vulnerability scanning
- Code security review
- Dependency auditing
- Compliance validation

**Example:**
```bash
Task tool with subagent_type="security-audit-droid-forge" \
  description="Security audit of authentication flow" \
  prompt "Perform comprehensive security audit of user authentication system. Check for SQL injection, XSS, CSRF, insecure password storage, and session management issues."
```

#### 8. **Unit Test** - Testing

**Use for:**
- Unit test generation
- Test coverage improvement
- Test debugging
- Test execution

**Example:**
```bash
Task tool with subagent_type="unit-test-droid-forge" \
  description="Generate tests for user service" \
  prompt "Create comprehensive unit tests for src/services/UserService.ts covering all public methods, edge cases, and error scenarios. Achieve 90%+ coverage."
```

---

## Decision Trees

### Feature Development Decision Tree

```
START: New Feature Request
    ↓
Is it complex/multi-domain?
    ↓ YES → Use manager-orchestrator-droid-forge
    |         ↓
    |      Orchestrator delegates to specialists
    ↓ NO
    ↓
What domain?
    ↓
    ├── Frontend UI? → frontend-engineer-droid-forge
    ├── Backend API? → backend-engineer-droid-forge
    ├── Both? → manager-orchestrator-droid-forge
    ├── Testing? → unit-test-droid-forge
    ├── Security? → security-audit-droid-forge
    └── Operations? → reliability-droid-forge
```

### Bug Fix Decision Tree

```
START: Bug Report
    ↓
Is root cause known?
    ↓ YES → Route to domain specialist
    |         ↓
    |      ├── Frontend bug → frontend-engineer-droid-forge
    |      ├── Backend bug → backend-engineer-droid-forge
    |      └── Security bug → security-audit-droid-forge
    ↓ NO
    ↓
Use debugging-expert-droid-forge for analysis
    ↓
Root cause identified
    ↓
Route to appropriate domain specialist
```

### Automation Decision Tree

```
START: Automation Request
    ↓
What to automate?
    ↓
    ├── GitHub issue → PR? → auto-pr-droid-forge
    ├── Incident response? → reliability-droid-forge
    ├── Code quality checks? → biome-droid-forge
    ├── Testing automation? → unit-test-droid-forge
    └── Git workflows? → git-workflow-orchestrator-droid-forge
```

---

## Practical Examples

### Example 1: Full-Stack Feature Implementation

**Scenario:** Build a user profile management feature

```bash
# Step 1: Orchestrate the overall feature
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  description="Orchestrate user profile feature" \
  prompt "Analyze PRD in tasks/tasks-0005-user-profile.md and coordinate implementation across frontend, backend, and testing. Delegate tasks to appropriate droids and monitor progress."

# Manager will delegate:
# - Frontend component creation to frontend-engineer-droid-forge
# - Backend API to backend-engineer-droid-forge
# - Tests to unit-test-droid-forge
# - Security review to security-audit-droid-forge
```

### Example 2: Bug Investigation and Fix

**Scenario:** API endpoint returning 500 errors intermittently

```bash
# Step 1: Analyze the issue
Task tool with subagent_type="debugging-expert-droid-forge" \
  description="Debug intermittent API 500 errors" \
  prompt "Analyze error logs in logs/api-errors.log for intermittent 500 errors on /api/users endpoint. Identify root cause and provide detailed analysis with reproduction steps."

# Step 2: Implement fix (after analysis)
Task tool with subagent_type="backend-engineer-droid-forge" \
  description="Fix API error handling" \
  prompt "Implement fix for identified race condition in user endpoint. Add proper error handling, transaction management, and retry logic."

# Step 3: Add tests
Task tool with subagent_type="unit-test-droid-forge" \
  description="Add tests for race condition fix" \
  prompt "Create integration tests that verify the race condition fix works correctly under concurrent load."
```

### Example 3: Automated Issue Resolution with Iterative Review

**Scenario:** GitHub issue needs automated PR with comprehensive review cycle

```bash
# Single command handles entire lifecycle
Task tool with subagent_type="auto-pr-droid-forge" \
  description="Auto-resolve issue with full review cycle" \
  prompt "Create automated PR for GitHub issue https://github.com/org/repo/issues/456. 

Requirements:
1. Analyze issue and implement complete fix
2. Create PR with descriptive title and body
3. Monitor for feedback from:
   - CodeRabbit AI reviews
   - GitHub Actions CI/CD
   - Codecov reports
   - Human reviewers
4. Automatically iterate to address all feedback:
   - Code quality issues
   - Style and formatting
   - Security concerns
   - Test coverage
   - Performance problems
   - Logic errors
5. Maximum 5 iterations
6. Monitor CI/CD pipeline and fix failures
7. Update PR with progress comments

Expected outcome: Clean, mergeable PR ready for final human approval."

# The auto-pr-droid will:
# ✅ Parse issue and create implementation
# ✅ Generate tests and documentation
# ✅ Create feature branch and PR
# ✅ Monitor for new comments/reviews
# ✅ Categorize feedback types
# ✅ Delegate fixes to specialist droids:
#    - debugging-expert for code issues
#    - biome for style issues
#    - security-audit for security issues
#    - unit-test for test issues
#    - backend-engineer for performance issues
# ✅ Commit and push fixes
# ✅ Update PR with iteration status
# ✅ Repeat until clean or max iterations
# ✅ Monitor and fix CI/CD failures
```

### Example 4: Security Audit

**Scenario:** Pre-release security review

```bash
# Comprehensive security audit
Task tool with subagent_type="security-audit-droid-forge" \
  description="Pre-release security audit" \
  prompt "Perform comprehensive security audit of the application before v2.0 release. Focus on:
- Authentication and authorization
- Input validation and sanitization
- SQL injection vulnerabilities
- XSS and CSRF protection
- Dependency vulnerabilities
- API security
- Data encryption
Generate detailed report with severity ratings and remediation steps."
```

### Example 5: Incident Response

**Scenario:** Production incident detected

```bash
# Immediate incident response
Task tool with subagent_type="reliability-droid-forge" \
  description="Respond to production incident" \
  prompt "Production incident detected: Payment service experiencing 50% error rate. 

Actions required:
1. Classify incident severity
2. Notify on-call team
3. Execute automated response playbook
4. Create incident channel
5. Start timeline tracking
6. Analyze root cause
7. Coordinate with debugging-expert-droid-forge for detailed analysis
8. Generate post-mortem report

Monitor: Prometheus alerts, Grafana dashboards, application logs"
```

### Example 6: Component Library Creation

**Scenario:** Build reusable component library

```bash
# Frontend component library
Task tool with subagent_type="frontend-engineer-droid-forge" \
  description="Create design system components" \
  prompt "Build comprehensive design system component library with:
- Button variants (primary, secondary, danger, ghost)
- Form inputs (text, email, password, select, checkbox, radio)
- Modal/Dialog components
- Card components
- Navigation components

Requirements:
- TypeScript support
- Accessibility (WCAG AA)
- Responsive design
- Storybook documentation
- Unit tests with React Testing Library
- CSS modules for styling"
```

### Example 7: Database Migration

**Scenario:** Complex schema migration needed

```bash
# Step 1: Design migration
Task tool with subagent_type="backend-engineer-droid-forge" \
  description="Design database migration" \
  prompt "Design migration for user preferences feature:
- Add user_preferences table with JSONB column
- Add relationship to users table
- Create indexes for performance
- Include rollback strategy
- Zero-downtime migration approach
Generate migration script with up/down methods."

# Step 2: Test migration
Task tool with subagent_type="unit-test-droid-forge" \
  description="Test database migration" \
  prompt "Create integration tests for user_preferences migration:
- Test migration up/down
- Verify data integrity
- Test performance with sample data
- Verify rollback works correctly"
```

---

## Best Practices

### 1. **Always Start with Context**

Provide comprehensive context in your prompts:

```bash
# ❌ BAD - Vague prompt
Task tool with subagent_type="frontend-engineer-droid-forge" \
  description="Create form" \
  prompt "Make a form"

# ✅ GOOD - Detailed prompt
Task tool with subagent_type="frontend-engineer-droid-forge" \
  description="Create user registration form" \
  prompt "Create TypeScript React registration form with:
- Fields: email (validated), password (strength meter), confirm password, agree to terms
- Validation: Real-time with error messages
- Submit: POST to /api/auth/register
- Loading state during submission
- Error handling with user-friendly messages
- Accessibility: ARIA labels, keyboard navigation
- Responsive: Mobile-first design
Located in: src/components/auth/RegistrationForm.tsx"
```

### 2. **Use Manager Orchestrator for Complex Tasks**

When work spans multiple domains, let the manager orchestrate:

```bash
# ✅ GOOD - Let manager coordinate
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  description="Implement search feature" \
  prompt "Implement full-text search feature across the application:
- Backend: Elasticsearch integration, indexing strategy
- Frontend: Search UI with autocomplete, filters
- Testing: Unit and integration tests
- Security: Input sanitization, query injection prevention

Coordinate specialist droids and track progress in tasks/tasks-0010-search.md"
```

### 3. **Leverage Iterative Review for PRs**

Use auto-pr-droid for complete automation including review cycles:

```bash
# ✅ EXCELLENT - Full automation with iteration
Task tool with subagent_type="auto-pr-droid-forge" \
  description="Automated PR with iterative improvement" \
  prompt "Create PR for feature XYZ with full review automation:
- Initial implementation
- Monitor for all feedback sources
- Automatically iterate to fix issues
- Max 5 iterations
- Monitor CI/CD and fix failures
- Update PR with progress

This ensures the PR is clean and ready for final approval."
```

### 4. **Update Task Status Regularly**

Keep task files current:

```bash
# After completing sub-task 1.2
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  description="Update task status" \
  prompt "Mark task 1.2 as completed in tasks/tasks-0001-feature.md and update relevant files list if needed"
```

### 5. **Follow Git Workflow Conventions**

Use consistent branch naming and commits:

```yaml
# From droid-forge.yaml
branch_patterns:
  feature: "feat/{task-id}-{description}"
  bugfix: "fix/{task-id}-{description}"
  refactor: "refactor/{task-id}-{description}"

commit_format: "{type}({scope}): {description}"
```

**Examples:**
```bash
# Branch names
feat/1.2-user-authentication
fix/2.3-api-timeout
refactor/3.1-database-queries

# Commit messages
feat(auth): implement JWT token authentication
fix(api): resolve timeout on user endpoint
refactor(db): optimize query performance with indexes
```

### 6. **Security First**

Always consider security implications:

```bash
# For any user-facing feature
Task tool with subagent_type="security-audit-droid-forge" \
  description="Security review of new feature" \
  prompt "Review security of newly implemented user authentication feature:
- Check input validation
- Verify password hashing (bcrypt/scrypt)
- Review session management
- Check for SQL injection vulnerabilities
- Verify HTTPS enforcement
- Review error handling (no sensitive data leaks)"
```

### 7. **Test Coverage Matters**

Ensure comprehensive testing:

```bash
# After implementing feature
Task tool with subagent_type="unit-test-droid-forge" \
  description="Comprehensive test suite" \
  prompt "Create complete test suite for user authentication feature:
- Unit tests for all service methods
- Integration tests for API endpoints
- Edge cases and error scenarios
- Security tests (injection, XSS)
Target: 90%+ coverage"
```

### 8. **Document as You Go**

Include documentation in feature development:

```bash
Task tool with subagent_type="frontend-engineer-droid-forge" \
  description="Component with documentation" \
  prompt "Create UserProfile component with:
1. Component implementation
2. PropTypes/TypeScript interfaces
3. JSDoc comments
4. Storybook stories with examples
5. README with usage examples
6. Accessibility notes"
```

### 9. **Monitor and Optimize Performance**

Consider performance implications:

```bash
Task tool with subagent_type="backend-engineer-droid-forge" \
  description="API with performance optimization" \
  prompt "Implement user search API with performance optimization:
- Pagination for large result sets
- Query optimization with proper indexes
- Caching strategy with Redis
- Response compression
- Rate limiting
- Performance benchmarks
Target: < 200ms p95 latency"
```

### 10. **Use Chaos Engineering Proactively**

Test system resilience:

```bash
Task tool with subagent_type="reliability-droid-forge" \
  description="Chaos engineering experiment" \
  prompt "Design and execute chaos experiment for payment service:
- Scenario: Database connection failure
- Blast radius: 10% of traffic
- Expected behavior: Graceful degradation with retry logic
- Success criteria: No user-facing errors
- Rollback: Automatic after 5 minutes
Generate experiment plan and execute with monitoring."
```

---

## Common Pitfalls

### ❌ Pitfall 1: Creating Custom Task Systems

**WRONG:**
```bash
# Don't create separate task tracking
echo "TODO: Implement feature" > my-tasks.txt
```

**RIGHT:**
```bash
# Use ai-dev-tasks format
cat > tasks/tasks-0001-feature.md << 'EOF'
## Relevant Files
- `src/feature.ts`

## Tasks
- [ ] 1.0 Implement feature
EOF
```

### ❌ Pitfall 2: Skipping the Manager Orchestrator

**WRONG:**
```bash
# Trying to coordinate manually
Task tool with subagent_type="frontend-engineer-droid-forge" ...
Task tool with subagent_type="backend-engineer-droid-forge" ...
Task tool with subagent_type="unit-test-droid-forge" ...
# Manual coordination is error-prone
```

**RIGHT:**
```bash
# Let manager orchestrate
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  description="Coordinate full-stack feature" \
  prompt "Orchestrate implementation with frontend, backend, and testing droids"
```

### ❌ Pitfall 3: Vague Prompts

**WRONG:**
```bash
Task tool with subagent_type="backend-engineer-droid-forge" \
  description="Make API" \
  prompt "Create API"
```

**RIGHT:**
```bash
Task tool with subagent_type="backend-engineer-droid-forge" \
  description="Create user management REST API" \
  prompt "Implement REST API for user management with:
- GET /api/users (list with pagination)
- GET /api/users/:id (single user)
- POST /api/users (create)
- PUT /api/users/:id (update)
- DELETE /api/users/:id (soft delete)
Include: Authentication, validation, error handling, rate limiting, OpenAPI docs"
```

### ❌ Pitfall 4: Ignoring Security

**WRONG:**
```bash
# Implementing auth without security review
Task tool with subagent_type="backend-engineer-droid-forge" \
  prompt "Create login endpoint"
# Ship it!
```

**RIGHT:**
```bash
# Include security in the workflow
Task tool with subagent_type="backend-engineer-droid-forge" \
  prompt "Create login endpoint with security best practices"

Task tool with subagent_type="security-audit-droid-forge" \
  prompt "Security audit of login endpoint implementation"
```

### ❌ Pitfall 5: Not Using Auto-PR Iterative Review

**WRONG:**
```bash
# Create PR manually and hope for the best
Task tool with subagent_type="auto-pr-droid-forge" \
  prompt "Create PR and that's it"
# Manual intervention needed for every review comment
```

**RIGHT:**
```bash
# Let auto-pr handle the full cycle
Task tool with subagent_type="auto-pr-droid-forge" \
  prompt "Create PR with full iterative review cycle. Monitor for feedback from CodeRabbit, CI/CD, and reviewers. Automatically fix issues through up to 5 iterations until PR is clean and mergeable."
```

### ❌ Pitfall 6: Forgetting Tests

**WRONG:**
```bash
# Implement feature without tests
Task tool with subagent_type="frontend-engineer-droid-forge" \
  prompt "Create component"
# No test coverage!
```

**RIGHT:**
```bash
# Include tests in the requirements
Task tool with subagent_type="frontend-engineer-droid-forge" \
  prompt "Create component with comprehensive test suite using React Testing Library"
```

### ❌ Pitfall 7: Inconsistent Git Workflow

**WRONG:**
```bash
# Random branch names and commit messages
git checkout -b temp-fix
git commit -m "fix stuff"
```

**RIGHT:**
```bash
# Follow droid-forge.yaml conventions
git checkout -b fix/1.2-api-timeout
git commit -m "fix(api): resolve timeout on user endpoint"
```

### ❌ Pitfall 8: No Monitoring or Observability

**WRONG:**
```bash
# Deploy to production without monitoring
Task tool with subagent_type="backend-engineer-droid-forge" \
  prompt "Deploy service"
# Hope nothing breaks!
```

**RIGHT:**
```bash
# Set up monitoring first
Task tool with subagent_type="reliability-droid-forge" \
  prompt "Setup comprehensive monitoring for service before deployment: health checks, metrics, alerting, dashboards"

# Then deploy
Task tool with subagent_type="backend-engineer-droid-forge" \
  prompt "Deploy service with gradual rollout"
```

---

## Advanced Patterns

### Pattern 1: Multi-Phase Feature Development

```bash
# Phase 1: Architecture and Planning
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  description="Phase 1: Architecture" \
  prompt "Analyze PRD and create detailed architecture plan for e-commerce checkout feature"

# Phase 2: Backend Implementation
Task tool with subagent_type="backend-engineer-droid-forge" \
  description="Phase 2: Backend API" \
  prompt "Implement checkout API based on architecture plan"

# Phase 3: Frontend Implementation
Task tool with subagent_type="frontend-engineer-droid-forge" \
  description="Phase 3: Checkout UI" \
  prompt "Implement checkout UI consuming backend API"

# Phase 4: Testing
Task tool with subagent_type="unit-test-droid-forge" \
  description="Phase 4: Test Suite" \
  prompt "Create comprehensive test suite for checkout feature"

# Phase 5: Security Audit
Task tool with subagent_type="security-audit-droid-forge" \
  description="Phase 5: Security Review" \
  prompt "Security audit of checkout feature, especially payment handling"

# Phase 6: Performance Optimization
Task tool with subagent_type="backend-engineer-droid-forge" \
  description="Phase 6: Performance" \
  prompt "Optimize checkout performance: caching, query optimization, load testing"
```

### Pattern 2: Incident-Driven Development

```bash
# Incident occurs
Task tool with subagent_type="reliability-droid-forge" \
  description="Incident response" \
  prompt "Respond to production incident: API 500 errors"

# Debug root cause
Task tool with subagent_type="debugging-expert-droid-forge" \
  description="Root cause analysis" \
  prompt "Analyze incident logs and identify root cause"

# Implement fix
Task tool with subagent_type="backend-engineer-droid-forge" \
  description="Implement fix" \
  prompt "Fix identified race condition in database transaction"

# Add tests to prevent regression
Task tool with subagent_type="unit-test-droid-forge" \
  description="Regression tests" \
  prompt "Add integration tests for race condition scenario"

# Improve monitoring
Task tool with subagent_type="reliability-droid-forge" \
  description="Enhanced monitoring" \
  prompt "Add monitoring to detect this issue class early"
```

### Pattern 3: Continuous Security

```bash
# Regular security audits
Task tool with subagent_type="security-audit-droid-forge" \
  description="Weekly security audit" \
  prompt "Perform weekly security scan:
- Dependency vulnerabilities
- Code security issues
- Configuration security
- Access control validation
Generate report with prioritized remediation"

# Automated dependency updates
Task tool with subagent_type="auto-pr-droid-forge" \
  description="Security dependency updates" \
  prompt "Create PRs for security-related dependency updates with full test cycle"
```

---

## Quick Reference

### Droid Selection Cheatsheet

| Task Type | Primary Droid | Secondary Droid |
|-----------|---------------|-----------------|
| Complex feature | manager-orchestrator | (delegates) |
| React component | frontend-engineer | unit-test |
| REST API | backend-engineer | security-audit |
| Bug investigation | debugging-expert | (domain specialist) |
| GitHub issue → PR | auto-pr | (multiple via iteration) |
| Production incident | reliability | debugging-expert |
| Security review | security-audit | - |
| Test creation | unit-test | - |
| Code formatting | biome | - |
| Git operations | git-workflow-orchestrator | - |

### Common Task Tool Patterns

```bash
# Simple delegation
Task tool with subagent_type="[droid-name]" \
  description="[brief-description]" \
  prompt "[detailed-instructions]"

# With context from files
Task tool with subagent_type="[droid-name]" \
  description="[brief-description]" \
  prompt "Using context from [file-path], [detailed-instructions]"

# Multi-step workflow
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  description="[workflow-description]" \
  prompt "Coordinate [step1], [step2], [step3] across [droid-list]"
```

### Status Update Pattern

```bash
# Via Manager
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  description="Update task status" \
  prompt "Update task [task-id] to [status] in tasks/tasks-[prd-name].md"

# Manual update
sed -i 's/- \[ \] [task-id]/- [x] [task-id]/' tasks/tasks-[prd-name].md
```

---

## Configuration Reference

### Key Files

| File | Purpose |
|------|---------|
| `droid-forge.yaml` | Main configuration: delegation rules, git workflow, performance settings |
| `biome.json` | Code quality standards: formatting, linting rules |
| `.pre-commit-config.yaml` | Pre-commit hooks configuration |
| `tasks/tasks-*.md` | ai-dev-tasks task tracking files |
| `.factory/droids/*.md` | Droid definitions and specifications |

### Environment Variables

```bash
# Factory.ai CLI
FACTORY_API_KEY="your-api-key"

# Droid Forge
DROID_FORGE_CONFIG="./droid-forge.yaml"
DROID_FORGE_TASKS_DIR="./tasks"
```

---

## Troubleshooting

### Issue: Droid not found

**Solution:**
```bash
# Verify droid exists
ls .factory/droids/[droid-name].md

# Check droid locations in config
grep -A 5 "locations:" droid-forge.yaml
```

### Issue: Task file not updating

**Solution:**
```bash
# Verify task file format
head -20 tasks/tasks-[prd-name].md

# Manual update if needed
sed -i 's/- \[ \] task-id/- [x] task-id/' tasks/tasks-[prd-name].md
```

### Issue: Delegation not working

**Solution:**
```bash
# Check delegation rules
grep -A 10 "delegation_rules:" droid-forge.yaml

# Use manager explicitly
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  description="Manual delegation" \
  prompt "Analyze task and delegate to appropriate droid: [task-description]"
```

### Issue: PR iteration stuck

**Solution:**
```bash
# Check PR status
gh pr view [pr-number] --json state,reviewDecision,statusCheckRollup

# Manual intervention
Task tool with subagent_type="debugging-expert-droid-forge" \
  description="Debug PR issue" \
  prompt "Analyze why PR #[number] is stuck in iteration cycle"
```

---

## Changelog and Versioning

This guide follows the Droid Forge versioning:

- **Current Version**: 0.1.0
- **Last Updated**: Based on commit b7d7e8e
- **Status**: Phase 4.0 (Git workflow orchestration) in progress

### Recent Updates

- ✅ Added comprehensive auto-pr iterative review documentation
- ✅ Enhanced decision trees and practical examples
- ✅ Added chaos engineering patterns
- ✅ Included security-first best practices
- ✅ Added troubleshooting section

---

## Additional Resources

### Documentation

- **Main README**: [README.md](./README.md)
- **Changelog**: [CHANGELOG.md](./CHANGELOG.md)
- **License**: [LICENSE](./LICENSE)

### External Resources

- [Factory.ai Platform](https://factory.ai/)
- [ai-dev-tasks Framework](https://github.com/snarktank/ai-dev-tasks)
- [Biome Linter Documentation](https://biomejs.dev/)

### Community

- **Issues**: Report bugs and feature requests via GitHub issues
- **Contributions**: Follow contributing guidelines in repository
- **Discussion**: Join community discussions for best practices

---

## Summary

Droid Forge provides a powerful meta-orchestration framework for AI-driven development. By following these guidelines:

1. ✅ **Use ai-dev-tasks exclusively** for task management
2. ✅ **Delegate intelligently** via the Task tool
3. ✅ **Leverage specialist droids** for domain-specific work
4. ✅ **Let manager orchestrate** complex multi-domain features
5. ✅ **Utilize iterative review** with auto-pr for comprehensive automation
6. ✅ **Follow conventions** in droid-forge.yaml and biome.json
7. ✅ **Prioritize security** with regular audits
8. ✅ **Test comprehensively** with unit and integration tests
9. ✅ **Monitor proactively** with reliability droid
10. ✅ **Document thoroughly** as part of development

You'll build robust, secure, and maintainable software efficiently with the power of coordinated AI droids.

---

**Built with ❤️ and a lot of droids**

## One-Shot Mode Advanced Usage

### Error Recovery
- Max 3 retries per sub-task
- Automatic rollback on failure
- Human escalation for critical issues

### Quality Gates
- Biome linting (auto-fix)
- Security scanning
- Type checking
- 90% coverage threshold

### PR Management
- One PR per major task
- Iterative review cycle (max 5 iterations)
- CI/CD monitoring and auto-fix
