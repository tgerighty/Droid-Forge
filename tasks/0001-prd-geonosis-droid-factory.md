# Product Requirements Document: Corellian Droid Factory

## Introduction/Overview

Corellian Droid Factory is a comprehensive framework designed to host, manage, and orchestrate Factory.ai droids. This project serves as a centralized hub for developing, deploying, and managing various specialized droids. The centerpiece is the Corellian Master Orchestrator that intelligently delegates tasks to specialized droids based on project requirements and PRD analysis.

## Goals

1. **Create a robust factory framework** that can host and manage multiple Factory.ai droids
2. **Develop the ST-series Kalani master orchestrator droid** that can analyze tasks and delegate them to appropriate specialized droids
3. **Implement comprehensive droid management** including listing, execution, version control, and performance monitoring
4. **Establish CLI-based interaction** for all factory operations
5. **Integrate with ai-dev-tasks workflow** for PRD-driven development
6. **Enable droid discovery via Factory.ai tooling** with optional `.factory/droids` directory support per Factory.ai spec

## User Stories

### As a developer, I want to:
- Easily discover and list all available droids in the factory
- Execute tasks through the Kalani orchestrator that automatically delegates to appropriate droids
- Monitor droid performance and execution status
- Update and manage droid versions across projects
- Use the factory framework droids to plan, assess, improve, document, fix, clean, review etc in new and existing projects
- Create new droids within the factory framework when needed

### As a system architect, I want to:
- Have a centralized system for managing all Factory.ai droids
- Ensure consistent droid specifications and metadata
- Track droid utilization and performance analytics
- Maintain version control and rollback capabilities for droids

### As a project manager, I want to:
- Use PRD-driven development workflows
- Track task breakdown and delegation progress
- Monitor project development through orchestrated droid execution

## Functional Requirements

### 1. Factory Framework Structure
1.1 The system shall provide a standardized structure for hosting Factory.ai droids
1.2 The system shall support both project-level and personal droid repositories
1.3 The system shall use the `.factory/droids` directory convention for droid storage
1.4 The system shall implement proper code formatting and maintain consistency with target project standards
1.5 The system shall be tech-stack agnostic, allowing droids to use whatever technology stack their target projects require

### 2. ST-Series Kalani Master Orchestrator Droid
2.1 The system shall implement a Corellian Master Orchestrator as the master coordinator
2.2 The orchestrator shall analyze PRD documents using rule-based, structured parsing to understand project scope and requirements
2.3 The orchestrator shall automatically break down tasks based on structured PRD analysis (rule-based initially, AI-based as future enhancement)
2.4 The orchestrator shall delegate tasks to appropriate specialized droids based on:
   - Task type (e.g., bug fixing, Docker configuration, security auditing)
   - Droid capabilities and metadata
   - Current project context and requirements
   - Git branch and workflow context
2.5 The orchestrator shall monitor task execution and collect results
2.6 The orchestrator shall handle task dependencies and execution order
2.7 The orchestrator shall coordinate Git workflows between multiple droids working on related tasks
2.8 The orchestrator shall ensure proper Git commit message formatting and content standards

### 3. Droid Specification and Interface
3.1 The system shall follow the official Factory.ai droid specification (manifest and interfaces) and SHALL NOT introduce a custom manifest.
3.2 Each droid shall provide metadata as defined by Factory.ai. For reference within this PRD, droids expose at minimum:
   - **name**: Human-readable droid name
   - **description**: Clear purpose and capabilities description
   - **version**: Semantic versioning
   - **capabilities**: Array of task types the droid can handle
   - **dependencies**: Required tools or runtime environments
   - **interface**: Standardized input/output format
   - **Input**: JSON object via STDIN containing `task_details` and `context`
   - **Output**: JSON object to STDOUT with `status` ('success'/'failure'), `result` (data payload), and `logs` (string array)
   - **Exit Codes**: Standardized exit codes (0=success, 1=general failure, 2=invalid input)
   - **author**: Droid creator information
3.3 The system shall validate droid specifications against the Factory.ai manifest/schema using Factory.ai tooling.
3.4 The system shall support droid versioning and compatibility checking as defined by Factory.ai.

3.5 Custom Droid Definition (Factory.ai)
- Custom droids are defined as Markdown files with YAML frontmatter per Factory.ai. The frontmatter typically includes fields such as `name`, `description`, `model`, and `tools`. The Markdown body contains the droid's instructions/prompt. Refer to the Factory.ai documentation for the authoritative field set and semantics.

Example (illustrative only):

```markdown
---
name: security-sweeper
description: Looks for insecure patterns in recently edited files
model: gpt-5-2025-08-07
tools:
  - Read
  - Grep
  - WebSearch
---

Investigate the files referenced in the prompt for security issues:

- Identify injection, insecure transport, privilege escalation, or secrets exposure.
- Suggest concrete mitigations.
- Link to relevant CWE or internal standards when helpful.
```

### 4. Git Workflow and Version Control
4.1 The orchestrator shall manage Git branching strategies for different types of work
4.2 The orchestrator shall instruct droids on proper Git commit message formatting and content
4.3 The orchestrator shall coordinate Git workflows including staging, committing, and branch management
4.4 The orchestrator shall facilitate code review workflows by coordinating between droids (e.g., code changes → review droid → commit)
4.5 The orchestrator shall maintain audit trails of all Git operations performed by droids
4.6 The orchestrator shall handle branch creation, merging, and cleanup based on task requirements
4.7 The Corellian Master Orchestrator shall maintain a project changelog at `CHANGELOG.md` (created if missing). Only the orchestrator writes to this file. For each orchestrated change, it appends an entry including the date, `run_id`, affected task IDs/titles, and commit SHAs.

Example entry:

```
## 2025-10-08 — Run r-20251008-0955

- Tasks: 1.1 Implement orchestrator bootstrap (completed)
- Commits: abc1234 on feat/orchestrator — feat(orchestrator): bootstrap Kalani runner
```

### 5. Droid Discovery and Management
5.1 The system shall use Factory.ai's droids tooling for discovery and listing of available droids. Optional `.factory/droids` directory support is permitted only as specified by Factory.ai (no custom discovery beyond the spec).
5.2 The system shall not maintain a persistent database or global registry; any in-memory catalog is derived on-demand from Factory.ai tooling.
5.3 The system shall support droid version control and updates via Factory.ai tooling.
5.4 The system shall provide basic, project-scoped execution telemetry captured as append-only JSON events (no database) including:
   - **execution_duration**: Time taken for droid execution
   - **success_status**: Task completion success/failure state
5.5 The system shall support droid execution status tracking via the project task list and JSON event logs.

### 6. CLI Interface
6.1 The CLI interface is exclusively handled by Factory.ai's Droid CLI tool. The orchestrator MUST use this CLI for listing, validating, and executing droids, and SHALL NOT define custom CLI commands.

### 7. Integration with ai-dev-tasks Workflow
7.1 The system shall integrate seamlessly with the ai-dev-tasks PRD-driven development process
7.2 The system shall use PRD documents for project understanding and task breakdown
7.3 The system shall support task list generation and execution tracking
7.4 The system shall maintain audit trails for all PRD-driven development activities
7.5 The Corellian Master Orchestrator shall update the generated task list file (`/tasks/tasks-[prd-file-name].md`) to reflect task states using inline status markers:
   - `status: scheduled` when a task is queued for execution
   - `status: started` when execution begins
   - Check the task's checkbox (`[x]`) when completed and optionally append `status: completed`
   - All updates shall preserve the existing Markdown structure
7.6 The Corellian Master Orchestrator shall ensure the ai-dev-tasks process files are available locally; if missing, it will pull them from a configured GitHub repository (pinned ref/commit recommended) into `ai-dev-tasks/`. Sync operations are captured in the audit log.

Example task status (single line):

```
- [ ] 1.1 Implement orchestrator bootstrap status: started
```

Additional examples:

```
- [ ] 1.1 Implement orchestrator bootstrap status: scheduled
- [x] 1.1 Implement orchestrator bootstrap status: completed
```

Default conventions: Use these task status markers unless the project specifies a different convention; Kalani adapts and preserves the existing Markdown structure.

### 8. Testing and Quality Assurance
8.1 The system shall provide comprehensive unit testing framework for droid development
8.2 The system shall support integration testing for orchestrator workflows
8.3 The system shall provide performance testing and benchmarking tools

## Non-Goals (Out of Scope)

- Web-based dashboard or GUI interface (CLI only for initial version)
- Real-time collaborative features
- Cloud-based droid hosting or SaaS functionality
- Integration with external CI/CD pipelines (initial version)
- Advanced machine learning for task delegation (rule-based initially)
- Multi-tenant or organizational features
- Concurrency management (handled by Factory.ai tooling)
- Centralized database or global droid registry (project-based, file logs only)

## Technical Considerations

### Architecture
- **Modular Design**: Each component should be independently testable and replaceable
- **Plugin System**: Droids should be treated as plugins that can be dynamically loaded
- **Event-Driven**: Use event-driven architecture for orchestrator communication (minimal model; see Audit & Events)
- **Configuration-Driven**: All behavior should be configurable through files
- **Git Integration**: Orchestrator will manage Git workflows, branching strategies, and coordinate code review processes between droids

### Dependencies
- **Factory.ai Specification**: All droids must comply with Factory.ai droid specifications
- **Target Project Integration**: Droids must be able to integrate with their target project's existing technology stack
- **CLI Runtime**: The factory framework shall use Factory.ai's Droid CLI for command execution
- **Storage**: Project-scoped, file-based JSON logs only (no database)
- **Process Files (ai-dev-tasks)**: The Corellian Master Orchestrator ensures required ai-dev-tasks process files are present locally. If missing, it pulls them from a configured GitHub source (pinned ref/commit recommended) into the `ai-dev-tasks/` directory. Failures are recorded to the audit log and do not crash the orchestrator.

## Audit & Events

- **Scope**: Project-based only; no global master lists.
- **Location**: `.factory/logs/` within the project.
- **Format**: One JSON object per line (NDJSON) or small JSON files per run. Fields include at minimum:
  - `timestamp` (ISO 8601), `event_type`, `run_id`, `task_id` (if applicable)
  - `droid_id` (if applicable), `status` (e.g., scheduled|started|completed|failed)
  - `details` (object; optional), `git` (object; optional, e.g., commit SHA)
- **Event Types** (minimal): `task.scheduled`, `task.started`, `task.completed`, `task.failed`, `droid.started`, `droid.completed`, `git.commit`, `audit.recorded`
- **Files**:
  - `.factory/logs/audit.ndjson` for audit trail
  - `.factory/logs/events.ndjson` for runtime events
  - Optionally `.factory/logs/run-<run_id>.ndjson` for per-run events
- **Access**: Orchestrator appends; developers can inspect with standard CLI tools. No database.
- **Creation**: On startup or first write, the Corellian Master Orchestrator ensures `.factory/logs/` exists and creates `events.ndjson` and `audit.ndjson` if missing.
  - When fetching ai-dev-tasks process files, it records an `audit.recorded` entry with `details.action = "process_files_sync"` and the source/ref.

Example event (single-line NDJSON):

```
{"timestamp":"2025-10-08T10:00:05.201Z","event_type":"task.started","run_id":"r-20251008-0955","task_id":"1.1","droid_id":"security-sweeper@1.0.0","status":"started"}
```

Additional examples:

```
{"timestamp":"2025-10-08T09:55:12.345Z","event_type":"task.scheduled","run_id":"r-20251008-0955","task_id":"1.1","status":"scheduled"}
{"timestamp":"2025-10-08T10:15:22.119Z","event_type":"task.completed","run_id":"r-20251008-0955","task_id":"1.1","status":"completed"}
{"timestamp":"2025-10-08T10:07:44.002Z","event_type":"git.commit","run_id":"r-20251008-0955","git":{"sha":"abc1234","branch":"feat/orchestrator"}}
```

Default conventions: Use these event shapes unless the project specifies a different convention; Kalani adapts to project-specific standards.

## Success Metrics

1. **Droid Utilization**: Track usage patterns across different droid types
2. **Task Completion Rate**: Monitor successful task delegation and completion percentages

## Project Phases

### Phase 1: Factory Framework Foundation
- Basic project structure and framework setup
- Droid specification and interface definition
- Git workflow integration foundation
- Basic branch management and commit coordination

### Phase 2: Corellian Master Orchestrator Implementation
- Rule-based task analysis and breakdown system
- Droid capability matching and delegation logic
- Task execution monitoring and result collection
- Integration with ai-dev-tasks workflow
- Error handling and recovery mechanisms
- Advanced Git workflow orchestration
- Multi-droid coordination and code review workflows

### Phase 3: Advanced Features
- Lightweight performance summaries derived from logs (no DB)
- Advanced droid version control and updates (via Factory.ai tooling)
- Comprehensive testing framework integration
