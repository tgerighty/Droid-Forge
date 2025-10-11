# PRD: One-Shot Autonomous Execution Mode

**Document ID**: PRD-0001  
**Version**: 1.0.0  
**Status**: Draft - Awaiting Approval  
**Created**: 2025-10-11  
**Author**: Droid Forge Team  
**Target Release**: Q4 2025

---

## Executive Summary

This PRD defines the requirements for adding a **one-shot autonomous execution mode** to the Droid Forge framework. This mode enables AI agents to execute entire task lists end-to-end without human confirmation between tasks, while maintaining quality through comprehensive automated testing, quality gates, and iterative PR review.

**Key Innovation**: A mode flag in AGENTS.md that lets users choose between **iterative** (current) or **one-shot** (new) execution patterns at the start of each workflow.

---

## 1. Introduction

### 1.1 Problem Statement

Current AGENTS.md workflow requires human confirmation at multiple decision points:
- Between each sub-task execution
- Before commits
- Before progression to next major task
- During error recovery

This creates bottlenecks and limits development velocity for routine, well-defined tasks.

### 1.2 Proposed Solution

Add a **mode selection mechanism** where Manager Orchestrator asks:
> "Do you want me to one-shot or follow the iterative process?"

Based on the answer:
- **Iterative Mode**: Continue with current human-in-the-loop workflow
- **One-Shot Mode**: Execute autonomously with comprehensive automation

### 1.3 Scope

**In Scope**:
- Mode selection at workflow start
- Autonomous execution for all task types
- Comprehensive testing automation (Unit + Integration + E2E)
- Quality gate enforcement (linting, formatting, security, type checking)
- Automatic commit and PR management
- Iterative PR review and fix cycles
- Error recovery with automatic retry
- Development environment only

**Out of Scope**:
- Production deployments (requires human approval)
- Performance testing (dev environment focus)
- Accessibility testing (not required for this phase)
- Architecture decision-making (requires human input)

---

## 2. User Stories

### Primary User Story

**As a Developer**, I want to assign an entire feature to an AI agent in one-shot mode so that:
- The agent executes all sub-tasks autonomously
- All code is tested comprehensively (unit, integration, E2E)
- Quality gates are enforced automatically
- PRs are created per major task with iterative fixes
- I only review final PRs instead of intermediate steps

### Detailed Scenarios

#### Scenario 1: Feature Implementation in One-Shot Mode

```
Given: User provides PRD with 3 major tasks (8 sub-tasks total)
When: User chooses "one-shot mode"
Then:
  - Agent executes all 8 sub-tasks autonomously
  - Creates 1 commit per sub-task (8 commits)
  - Pushes commits immediately for safety
  - Creates 3 PRs (one per major task)
  - Waits for automated reviews on each PR
  - Fixes issues iteratively until PRs are clean
  - Human reviews only final approved PRs
```

#### Scenario 2: Test Failure Handling

```
Given: Sub-task 2.3 has failing tests
When: Tests fail on first attempt
Then:
  - Agent analyzes failure
  - Fixes code and re-runs tests
  - If test fails again, repeats fix attempt
  - After 3 failures on same test: Stop and ask human
  - Does NOT continue to sub-task 2.4 until tests pass
```

#### Scenario 3: Quality Gate Failure

```
Given: Code has linting errors after sub-task 1.2
When: Linting check runs
Then:
  - Agent automatically fixes linting errors
  - Re-runs linting check
  - Does NOT commit until linting passes
  - Does NOT continue to sub-task 1.3 until quality gates pass
```

---

## 3. Requirements

### 3.1 Functional Requirements

#### FR-1: Mode Selection

**FR-1.1**: Manager Orchestrator MUST ask mode preference at workflow start
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Question: "Do you want me to one-shot or follow the iterative process?"
  - Accept responses: "one-shot", "iterative", "one shot", "yes" (one-shot), "no" (iterative)
  - Default to iterative if unclear response

**FR-1.2**: Agent MUST adapt behavior based on selected mode
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Iterative mode: Use current AGENTS.md workflow
  - One-shot mode: Use autonomous execution workflow
  - Mode persists for entire workflow session

#### FR-2: Autonomous Task Execution (One-Shot Mode Only)

**FR-2.1**: Agent MUST execute all sub-tasks of a major task without human confirmation
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Sub-tasks execute sequentially (1.1 → 1.2 → 1.3)
  - No confirmation prompts between sub-tasks
  - Progression blocked only by failures or quality gates

**FR-2.2**: Agent MUST support parallel execution of independent sub-tasks (max 3 concurrent)
- **Priority**: P1 (High)
- **Acceptance Criteria**:
  - Detect independent sub-tasks automatically
  - Execute up to 3 in parallel
  - Wait for all to complete before dependent tasks
  - Sequential execution for dependent tasks

**FR-2.3**: Agent MUST stop and ask human for core architecture decisions
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Detect architecture decision points (e.g., task description contains "design", "architecture", "choose pattern")
  - Present options to human with recommendations
  - Wait for human decision before continuing
  - Log decision for future reference

#### FR-3: Comprehensive Testing (One-Shot Mode Only)

**FR-3.1**: Unit test MUST be created for 100% of new code
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Every implementation file has corresponding test file
  - Tests created before marking sub-task complete
  - Tests cover happy path, edge cases, and error scenarios

**FR-3.2**: Integration tests MUST be created after each major task
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Tests verify sub-tasks work together
  - Cover cross-component interactions
  - Test data flow between components

**FR-3.3**: End-to-end tests MUST be created for complete features
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Tests cover critical user journeys
  - Validate entire feature functionality
  - Run in isolated test environment

**FR-3.4**: All tests MUST pass with 90%+ coverage before progression
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Coverage threshold: 90% minimum (100% preferred)
  - All tests must pass (100% pass rate)
  - Coverage includes all new code
  - Agent does NOT continue to next sub-task until tests pass

**FR-3.5**: Failed tests MUST block progression with automatic retry
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Test failure detected → Analyze and fix
  - Re-run tests after fix
  - Maximum 3 retry attempts per sub-task
  - After 3 failures: Rollback commit, stop, ask human
  - No progression to next sub-task until tests pass

#### FR-4: Commit Management (One-Shot Mode Only)

**FR-4.1**: Code MUST be committed after each sub-task completion
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - One commit per sub-task (granular commits)
  - Commit includes: implementation + tests + documentation
  - Commit message follows conventional format: `type(scope): description`
  - Commit is atomic and revertible

**FR-4.2**: Commits MUST be pushed immediately after creation
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Push to remote after each commit (safety measure)
  - No batching of commits
  - Handle push failures with retry logic

**FR-4.3**: Failed commits MUST trigger rollback and retry
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Commit failure detected → Rollback changes
  - Retry sub-task from beginning
  - Maximum 3 retry attempts per sub-task
  - After 3 failures: Stop and ask human
  - Log all retry attempts

#### FR-5: Pull Request Management (One-Shot Mode Only)

**FR-5.1**: Agent MUST create one PR per major task
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - PR created after major task 1.0 completes
  - PR created after major task 2.0 completes
  - Etc. for all major tasks
  - Each PR contains all commits for that major task

**FR-5.2**: Agent MUST wait for automated review comments on each PR
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Monitor PR for comments from CodeRabbit, GitHub Actions, etc.
  - Detect new comments automatically
  - Categorize feedback (code, style, security, tests, performance, logic)

**FR-5.3**: Agent MUST fix issues iteratively until PR is clean (like auto-pr-droid)
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Analyze feedback and implement fixes
  - Commit fixes with descriptive messages
  - Push updates to PR branch
  - Wait for new review cycle
  - Repeat until no more issues (max 5 iterations)
  - Update PR with iteration status comments

**FR-5.4**: Agent MUST monitor CI/CD pipeline and fix failures
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Watch for pipeline failures
  - Analyze failure logs
  - Implement fixes for test, build, lint, security failures
  - Push fixes and re-run pipeline
  - Repeat until pipeline passes

#### FR-6: Quality Gates (One-Shot Mode Only)

**FR-6.1**: Biome linting MUST pass before commit
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Run biome lint after code generation
  - Auto-fix linting errors if possible
  - Block commit if errors remain
  - Keep fixing until lint passes

**FR-6.2**: Code formatting MUST be applied before commit
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Run biome format before commit
  - All code formatted per biome.json
  - No format-related diffs in commits

**FR-6.3**: Security scanning MUST pass before commit
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Run security scan (CodeRabbit) after code generation
  - Block commit on critical security issues
  - Stop and ask human if critical issues found
  - Continue with warnings for non-critical issues

**FR-6.4**: Type checking MUST pass before commit
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Run TypeScript/type checker before commit
  - Block commit on type errors
  - Auto-fix type errors if possible
  - Keep fixing until types pass

**FR-6.5**: Quality gate failures MUST block progression
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Agent does NOT commit until all quality gates pass
  - Agent does NOT continue to next sub-task until current quality gates pass
  - Agent keeps working to fix all issues
  - No skipping or bypassing quality gates

#### FR-7: Status and Logging (One-Shot Mode Only)

**FR-7.1**: Agent MUST log every single action in real-time
- **Priority**: P1 (High)
- **Acceptance Criteria**:
  - Log level: INFO for actions, WARN for issues, ERROR for failures
  - Timestamp for every log entry
  - Structured logging format (JSON or key-value)
  - Logs written to `.droid-forge/logs/execution-{timestamp}.log`

**FR-7.2**: Agent MUST provide summary after each sub-task (minimum requirement)
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Summary includes: sub-task ID, status, duration, tests run, coverage
  - Summary written to console and log file
  - Summary includes any warnings or issues encountered

**FR-7.3**: Agent MUST generate comprehensive execution report at completion
- **Priority**: P1 (High)
- **Acceptance Criteria**:
  - Report includes: all tasks performed/created
  - All tests performed and success rates
  - Code coverage statistics
  - All commits created with messages
  - All PRs created with status
  - Any errors or warnings encountered
  - Total execution time
  - Report written to `.droid-forge/reports/execution-{timestamp}.md`

#### FR-8: Integration with Existing System

**FR-8.1**: Agent MUST reuse all existing droids with hybrid approach
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Reuse: frontend-engineer-droid-forge, backend-engineer-droid-forge, etc.
  - Create new droids only if needed for one-shot specific functionality
  - Existing droids work in both iterative and one-shot modes

**FR-8.2**: Agent MUST use exact same delegation rules from droid-forge.yaml
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Pattern matching rules unchanged
  - Delegation logic unchanged
  - Droid selection criteria unchanged

**FR-8.3**: Agent MUST maintain ai-dev-tasks format compliance
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Task files follow ai-dev-tasks format
  - Status markers: `[ ]`, `[~]`, `[x]`
  - Status updates automatic in one-shot mode
  - File format preserved

#### FR-9: Error Handling and Recovery

**FR-9.1**: Test failures MUST trigger automatic retry (max 3 attempts per sub-task)
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Failure detected → Analyze root cause
  - Implement fix → Re-run tests
  - Retry #2 if still failing
  - Retry #3 if still failing
  - After 3 failures: Rollback sub-task commit, stop, ask human

**FR-9.2**: Quality gate failures MUST trigger automatic fix attempts
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Linting errors → Auto-fix and re-run
  - Type errors → Fix types and re-run
  - Security issues (non-critical) → Fix and re-run
  - Security issues (critical) → Stop and ask human
  - Keep attempting fixes until quality gates pass

**FR-9.3**: Commit failures MUST trigger rollback and retry
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - Commit failure → Rollback changes (git reset)
  - Restart sub-task from beginning
  - Maximum 3 retry attempts
  - After 3 failures: Stop and ask human

**FR-9.4**: No execution time limit (run until finished)
- **Priority**: P1 (High)
- **Acceptance Criteria**:
  - No timeout on overall execution
  - Agent runs until all tasks complete or failure
  - User can manually interrupt if needed

#### FR-10: Success Criteria

**FR-10.1**: Success MUST be defined as: All tasks completed + All tests passing
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - All sub-tasks marked `[x]` in ai-dev-tasks file
  - All unit tests passing (100% pass rate)
  - All integration tests passing (100% pass rate)
  - All E2E tests passing (100% pass rate)
  - Code coverage ≥ 90%
  - All quality gates passing
  - All PRs created and clean

**FR-10.2**: Failure to meet success criteria MUST trigger rollback and restart
- **Priority**: P0 (Critical)
- **Acceptance Criteria**:
  - If any major requirement not met at end: Rollback
  - Rollback strategy: Revert all commits for current major task
  - Ask human: "Success criteria not met. Rollback and retry, or stop?"
  - If retry: Start current major task from beginning
  - Maximum 3 retry attempts for entire major task
  - After 3 major task failures: Stop and ask human for direction

### 3.2 Non-Functional Requirements

#### NFR-1: Performance

- **NFR-1.1**: Support up to 3 parallel sub-tasks for independent work
- **NFR-1.2**: Test execution time should be minimized (use parallel test runners)
- **NFR-1.3**: Log writing should not impact execution performance

#### NFR-2: Reliability

- **NFR-2.1**: 95%+ success rate for one-shot executions on well-defined tasks
- **NFR-2.2**: Automatic recovery from 95% of transient failures
- **NFR-2.3**: Zero data loss on failures (commits pushed immediately)
- **NFR-2.4**: State recovery after network interruptions

#### NFR-3: Maintainability

- **NFR-3.1**: All logs structured and queryable
- **NFR-3.2**: Execution state fully recoverable from logs
- **NFR-3.3**: Configuration changes without code modifications

#### NFR-4: Security

- **NFR-4.1**: All commits signed automatically
- **NFR-4.2**: Secrets never logged or committed
- **NFR-4.3**: Audit trail for all autonomous decisions

#### NFR-5: Usability

- **NFR-5.1**: Mode selection question clear and unambiguous
- **NFR-5.2**: Status updates easy to read and understand
- **NFR-5.3**: Error messages actionable with clear next steps

---

## 4. Workflow Architecture

### 4.1 Mode Selection Flow

```
User starts workflow
    ↓
Manager Orchestrator: "Do you want me to one-shot or follow the iterative process?"
    ↓
User responds: "one-shot" OR "iterative"
    ↓
    ├─ ITERATIVE → Use current AGENTS.md workflow
    │
    └─ ONE-SHOT → Enter autonomous execution mode
         ↓
       [One-Shot Workflow Below]
```

### 4.2 One-Shot Execution Flow

```
Parse ai-dev-tasks file
    ↓
FOR EACH Major Task (1.0, 2.0, 3.0...):
    │
    ├─ FOR EACH Sub-task (1.1, 1.2, 1.3...):
    │   │
    │   ├─ Detect architecture decision needed? → Stop and ask human
    │   │
    │   ├─ Execute sub-task (delegate to appropriate droid)
    │   │
    │   ├─ Generate unit tests (100% of new code)
    │   │
    │   ├─ Run unit tests
    │   │   └─ FAIL? → Fix and retry (max 3 attempts)
    │   │       └─ 3 failures? → Rollback commit, stop, ask human
    │   │
    │   ├─ Run quality gates:
    │   │   ├─ Biome linting → Fix if fail, retry until pass
    │   │   ├─ Code formatting → Apply automatically
    │   │   ├─ Security scan → Stop if critical, fix if warning
    │   │   └─ Type checking → Fix if fail, retry until pass
    │   │
    │   ├─ Commit (one commit per sub-task)
    │   │   └─ FAIL? → Rollback, retry sub-task (max 3 attempts)
    │   │
    │   ├─ Push immediately (safety)
    │   │
    │   └─ Update status [x] in ai-dev-tasks file
    │
    ├─ Generate integration tests for major task
    │
    ├─ Run integration tests
    │   └─ FAIL? → Fix and retry (max 3 attempts)
    │
    ├─ Create PR for major task
    │
    ├─ Wait for automated review comments (CodeRabbit, GitHub Actions)
    │
    ├─ Iterative PR fix cycle (like auto-pr-droid):
    │   ├─ Categorize feedback (code, style, security, tests, logic)
    │   ├─ Fix issues
    │   ├─ Commit and push fixes
    │   ├─ Wait for new review cycle
    │   └─ Repeat until PR clean (max 5 iterations)
    │
    └─ Next major task
    │
    ↓
Generate end-to-end tests for entire feature
    ↓
Run E2E tests
    ↓
Verify success criteria:
  ✓ All tasks completed [x]
  ✓ All tests passing (100%)
  ✓ Coverage ≥ 90%
  ✓ All PRs clean
    ↓
Success? → DONE
    ↓
Failure? → Rollback major task, retry (max 3), or ask human
```

### 4.3 Error Recovery Flow

```
Error/Failure Detected
    ↓
Classify Error Type
    ↓
    ├─ Test Failure
    │   ↓
    │  Analyze root cause
    │   ↓
    │  Fix implementation or test
    │   ↓
    │  Re-run tests
    │   ↓
    │  Retry count < 3? → YES → Continue fixing
    │                     ↓ NO
    │                   Rollback sub-task commit
    │                     ↓
    │                   Stop and ask human
    │
    ├─ Quality Gate Failure (lint, format, type, security-warning)
    │   ↓
    │  Auto-fix if possible
    │   ↓
    │  Re-run quality gate
    │   ↓
    │  Keep fixing until pass (no retry limit for quality)
    │
    ├─ Critical Security Issue
    │   ↓
    │  Stop immediately
    │   ↓
    │  Notify human with details
    │   ↓
    │  Wait for human decision
    │
    └─ Commit/Push Failure
        ↓
       Rollback changes (git reset)
        ↓
       Retry sub-task from beginning
        ↓
       Retry count < 3? → YES → Start sub-task again
                          ↓ NO
                        Stop and ask human
```

---

## 5. Integration Points

### 5.1 AGENTS.md Modifications

**Current AGENTS.md** workflow stays intact for iterative mode.

**Add to AGENTS.md** at the beginning:

```markdown
## Execution Modes

Droid Forge supports two execution modes:

### 1. Iterative Mode (Default)
- Human confirmation between tasks
- Step-by-step progression
- Interactive decision-making
- Use when: Architecture decisions needed, learning workflow, uncertain requirements

### 2. One-Shot Mode
- Autonomous execution without confirmation
- Comprehensive automated testing
- Quality gate enforcement
- Iterative PR review and fixes
- Use when: Well-defined tasks, routine features, high confidence in requirements

**Mode Selection**: Manager Orchestrator will ask at workflow start:
> "Do you want me to one-shot or follow the iterative process?"

Respond with "one-shot" or "iterative" to set the mode for this workflow.
```

### 5.2 Manager Orchestrator Droid Enhancement

**Add to manager-orchestrator-droid-forge.md**:

```markdown
## Mode Selection Handler

At workflow start, ask user:
> "Do you want me to one-shot or follow the iterative process?"

Parse response:
- "one-shot", "one shot", "oneshot", "yes" → ONE_SHOT_MODE=true
- "iterative", "iterate", "no", "step-by-step" → ONE_SHOT_MODE=false
- Unclear → Default to iterative, ask for clarification

Store mode in execution context for all droids to access.

## One-Shot Execution Logic

If ONE_SHOT_MODE=true:
  - Enable autonomous execution
  - Disable confirmation prompts
  - Enable comprehensive testing automation
  - Enable quality gate enforcement
  - Enable automatic commit/push
  - Enable PR creation per major task
  - Enable iterative PR review cycle
```

### 5.3 Droid-forge.yaml Configuration

**Add new section**:

```yaml
# One-Shot Mode Configuration
one_shot_mode:
  enabled: true
  
  # Execution settings
  execution:
    max_parallel_subtasks: 3
    no_time_limit: true
    
  # Testing requirements
  testing:
    unit_tests_required: true
    integration_tests_required: true
    e2e_tests_required: true
    min_coverage: 90
    preferred_coverage: 100
    block_on_test_failure: true
    max_retry_attempts: 3
    
  # Quality gates (all block progression)
  quality_gates:
    biome_linting: true
    code_formatting: true
    security_scanning: true
    type_checking: true
    performance_validation: false
    accessibility_checks: false
    
  # Commit strategy
  commits:
    one_per_subtask: true
    push_immediately: true
    conventional_format: true
    sign_commits: true
    max_retry_attempts: 3
    
  # PR strategy
  pull_requests:
    one_per_major_task: true
    wait_for_automated_reviews: true
    iterative_fix_cycle: true
    max_iterations: 5
    
  # Error handling
  errors:
    rollback_on_failure: true
    max_subtask_retries: 3
    max_major_task_retries: 3
    stop_on_critical_security: true
    stop_on_architecture_decision: true
    
  # Logging
  logging:
    level: INFO
    log_every_action: true
    minimum_subtask_summary: true
    final_execution_report: true
    log_dir: ".droid-forge/logs"
    report_dir: ".droid-forge/reports"
    
  # Success criteria
  success:
    all_tasks_completed: true
    all_tests_passing: true
    min_coverage: 90
    all_quality_gates_passing: true
```

### 5.4 AI-Dev-Tasks File Format

**No changes required** - format stays the same:

```markdown
## Relevant Files
- `file1.ts`

## Tasks
- [ ] 1.0 Major Task
  - [ ] 1.1 Sub-task
  - [ ] 1.2 Sub-task
```

Status updates happen automatically in one-shot mode.

---

## 6. Success Metrics

### 6.1 Key Performance Indicators

| Metric | Target | Measurement |
|--------|--------|-------------|
| Mode selection clarity | 100% users understand | User feedback survey |
| One-shot execution success rate | 95%+ | Completed vs failed executions |
| Test coverage in one-shot | 90%+ average | Coverage reports |
| Quality gate pass rate | 95%+ | Quality check results |
| Time to feature completion | <60 min for standard | Execution logs |
| PR iteration cycles | 2-3 average | PR comment analysis |
| Human interventions in one-shot | <2 per feature | Interaction logs |

### 6.2 Acceptance Criteria for Release

- [ ] Mode selection implemented in Manager Orchestrator
- [ ] One-shot mode executes all sub-tasks without confirmation
- [ ] Comprehensive testing automation (unit + integration + E2E)
- [ ] Quality gates enforced (linting, formatting, security, types)
- [ ] Automatic commit per sub-task with immediate push
- [ ] PR creation per major task
- [ ] Iterative PR review and fix cycle working
- [ ] Error handling with retry and rollback working
- [ ] Success criteria validation working
- [ ] Logging and reporting comprehensive
- [ ] Documentation updated in AGENTS.md
- [ ] All tests passing with 90%+ coverage

---

## 7. Implementation Phases

### Phase 1: Core Mode Selection & Basic Autonomy (Week 1-2)

**Deliverables**:
- [ ] Mode selection in Manager Orchestrator
- [ ] Basic one-shot execution (no confirmation between sub-tasks)
- [ ] Simple commit automation (one per sub-task)
- [ ] Immediate push after commit
- [ ] Basic logging

**Success Criteria**:
- User can select mode
- Agent executes 3-5 sub-tasks autonomously
- Commits created and pushed automatically

### Phase 2: Testing Automation (Week 3-4)

**Deliverables**:
- [ ] Unit test generation for all new code
- [ ] Integration test generation per major task
- [ ] E2E test generation for features
- [ ] Test execution automation
- [ ] Test failure handling with retry (max 3)
- [ ] Coverage reporting (90%+ threshold)

**Success Criteria**:
- 100% of new code has tests
- Tests run automatically and block on failure
- Retry logic working correctly

### Phase 3: Quality Gates (Week 5-6)

**Deliverables**:
- [ ] Biome linting integration with auto-fix
- [ ] Code formatting automation
- [ ] Security scanning integration (CodeRabbit)
- [ ] Type checking integration
- [ ] Quality gate enforcement (block on failure)

**Success Criteria**:
- All quality gates enforced
- Auto-fix working for linting and formatting
- Critical security issues stop execution

### Phase 4: PR Management & Iterative Review (Week 7-8)

**Deliverables**:
- [ ] PR creation per major task
- [ ] Automated review comment monitoring
- [ ] Feedback categorization
- [ ] Iterative fix cycle (like auto-pr-droid)
- [ ] CI/CD pipeline monitoring and fixing
- [ ] Max 5 iteration cycles

**Success Criteria**:
- PRs created automatically
- Agent fixes issues iteratively
- PRs become clean without human intervention

### Phase 5: Error Handling & Recovery (Week 9-10)

**Deliverables**:
- [ ] Test failure retry logic (max 3)
- [ ] Commit failure rollback and retry
- [ ] Quality gate failure auto-fix
- [ ] Major task rollback on success criteria failure
- [ ] Architecture decision detection and human escalation

**Success Criteria**:
- Retry logic working correctly
- Rollback working correctly
- Human escalation working for critical cases

### Phase 6: Documentation & Polish (Week 11-12)

**Deliverables**:
- [ ] AGENTS.md updated with mode selection docs
- [ ] Manager Orchestrator docs updated
- [ ] droid-forge.yaml configuration documented
- [ ] Logging and reporting polished
- [ ] Final execution report format finalized

**Success Criteria**:
- Documentation complete and clear
- All logs and reports useful
- User can understand how to use one-shot mode

---

## 8. Risk Assessment

### High Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Autonomous agent makes incorrect assumptions | Medium | High | Comprehensive testing at each step, quality gates, human escalation for critical decisions |
| Test failures cascade causing workflow stalls | Medium | High | Max 3 retry limit, rollback and restart, human escalation |
| Security vulnerabilities introduced | Low | Critical | Automatic security scans, block on critical issues, human review on PRs |
| Quality suffers without human review | Low | Medium | Enforce all quality gates, comprehensive testing, human review final PRs |

### Medium Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Mode selection ambiguous to users | Medium | Medium | Clear question, examples in docs, fallback to iterative |
| Parallel execution causes conflicts | Low | Medium | Limit to 3 parallel, careful dependency detection |
| PR iteration cycles take too long | Medium | Low | Max 5 iterations, intelligent fixes, parallel processing |

### Low Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Excessive commits clutter history | High | Low | One per sub-task is reasonable, squash on merge option |
| Logs too verbose | Medium | Low | Configurable log levels, structured logging |

---

## 9. Open Questions

None - all clarified with user.

---

## 10. Appendix

### A. Comparison: Iterative vs One-Shot Mode

| Aspect | Iterative Mode | One-Shot Mode |
|--------|---------------|---------------|
| **Confirmations** | Every sub-task | None (except critical decisions) |
| **Testing** | Manual test runs | Automatic unit+integration+E2E |
| **Quality Gates** | Manual checks | Automatic enforcement |
| **Commits** | Ask before commit | Automatic per sub-task |
| **PRs** | Manual creation | Automatic per major task |
| **PR Fixes** | Manual fixes | Iterative auto-fix (max 5) |
| **Error Handling** | Ask human | Auto-retry (max 3) then ask |
| **Execution Time** | Variable (waiting) | Continuous (no waiting) |
| **Best For** | Architecture work, learning | Routine features, well-defined tasks |

### B. Example One-Shot Execution Scenario

**Input**: Feature with 2 major tasks, 6 sub-tasks total

```
1.0 User Authentication
  1.1 Create user model
  1.2 Add password hashing
  1.3 Create login endpoint
  
2.0 Authorization
  2.1 Create auth middleware
  2.2 Add role-based access
  2.3 Protect routes
```

**One-Shot Execution**:

```
[00:00] Manager: "Do you want me to one-shot or follow the iterative process?"
[00:00] User: "one-shot"
[00:00] Manager: "Entering one-shot mode. I'll execute all tasks autonomously."

[00:01] Executing 1.1: Create user model
[00:05] Generated: models/User.ts
[00:06] Generated: tests/User.test.ts
[00:07] Running unit tests... ✓ 8/8 passed
[00:08] Quality gates: ✓ Lint ✓ Format ✓ Types ✓ Security
[00:09] Committed: feat(auth): create user model with validation
[00:09] Pushed commit successfully
[00:09] Updated status: 1.1 [x]

[00:10] Executing 1.2: Add password hashing
[00:14] Generated: utils/password.ts
[00:15] Generated: tests/password.test.ts
[00:16] Running unit tests... ✓ 6/6 passed
[00:17] Quality gates: ✓ Lint ✓ Format ✓ Types ✓ Security
[00:18] Committed: feat(auth): implement bcrypt password hashing
[00:18] Pushed commit successfully
[00:18] Updated status: 1.2 [x]

[00:19] Executing 1.3: Create login endpoint
[00:25] Generated: routes/auth.ts
[00:26] Generated: tests/auth.test.ts
[00:27] Running unit tests... ✓ 12/12 passed
[00:28] Quality gates: ✓ Lint ✓ Format ✓ Types ✓ Security
[00:29] Committed: feat(auth): add login endpoint with JWT
[00:29] Pushed commit successfully
[00:29] Updated status: 1.3 [x]

[00:30] Generating integration tests for major task 1.0
[00:32] Generated: tests/auth.integration.test.ts
[00:33] Running integration tests... ✓ 10/10 passed

[00:34] Creating PR for major task 1.0: User Authentication
[00:35] PR #10 created: https://github.com/org/repo/pull/10
[00:35] Waiting for automated reviews...

[00:40] CodeRabbit comment received: 3 suggestions
[00:41] Categorizing feedback: 2 style, 1 logic
[00:42] Implementing fixes...
[00:45] Committed: fix(auth): address CodeRabbit review comments
[00:45] Pushed fixes to PR #10
[00:50] CodeRabbit: ✓ All issues resolved
[00:51] PR #10 ready for human review

[00:52] Executing 2.1: Create auth middleware
[00:58] Generated: middleware/auth.ts
[00:59] Generated: tests/middleware-auth.test.ts
[01:00] Running unit tests... ✓ 15/15 passed
[01:01] Quality gates: ✓ Lint ✓ Format ✓ Types ✓ Security
[01:02] Committed: feat(auth): create authentication middleware
[01:02] Pushed commit successfully
[01:02] Updated status: 2.1 [x]

[... continues for 2.2, 2.3 ...]

[01:30] Generating E2E tests for complete authentication feature
[01:35] Running E2E tests... ✓ 12/12 passed

[01:36] Execution Summary:
  ✓ Tasks completed: 6/6
  ✓ Tests passed: 63/63 (100%)
  ✓ Code coverage: 94.2%
  ✓ Commits: 6
  ✓ PRs created: 2
  ✓ Duration: 96 minutes

[01:36] Manager: "One-shot execution complete! All tasks done, all tests passing. PRs ready for your review."
```

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2025-10-11 | Droid Forge Team | Initial PRD based on user requirements |

**Approval Status**: Draft - Awaiting User Approval

**Next Steps**:
1. User reviews and approves PRD
2. Create detailed task breakdown in ai-dev-tasks format
3. User confirms task breakdown
4. Begin implementation

---

**End of PRD**
