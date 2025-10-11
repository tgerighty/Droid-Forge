# Assessment and Refactoring Workflow

## Overview

This document describes the complete workflow for code quality assessment and refactoring using the Droid Forge specialist droids with full ai-dev-tasks integration.

## Workflow Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      Manager Orchestrator                        │
│                 (Coordinates entire workflow)                    │
└────────────────────────┬────────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
┌───────────────┐ ┌──────────────┐ ┌──────────────┐
│  Code Smell   │ │  Cognitive   │ │ TypeScript   │
│  Assessment   │ │  Complexity  │ │ Professional │
│     Droid     │ │  Assessment  │ │    Droid     │
└───────┬───────┘ └──────┬───────┘ └──────┬───────┘
        │                │                │
        └────────────────┼────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │    Task Manager Droid          │
        │  Creates tasks in ai-dev-tasks │
        │  tasks/tasks-[type]-[date].md  │
        └────────────────┬───────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  Code Refactoring Droid        │
        │  Executes refactoring tasks    │
        │  Updates task status           │
        └────────────────┬───────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │    Task Manager Droid          │
        │  Marks tasks as completed      │
        └────────────────────────────────┘
```

## Phase 1: Assessment

### 1.1 Code Smell Assessment

**Purpose**: Detect anti-patterns, maintainability issues, and technical debt

**Execution**:
```bash
Task tool with subagent_type="code-smell-assessment-droid-forge" \
  description="Comprehensive code smell assessment" \
  prompt "Analyze entire codebase for code smells, categorize by type (bloaters, OOP abusers, change preventers, dispensables, couplers), generate detailed report, and create tasks in tasks/tasks-code-smells-$(date +%Y%m%d).md for each finding. Prioritize by severity and impact."
```

**Output**:
- Detailed assessment report with findings categorized by:
  - 🔴 Critical (High Impact): God objects, shotgun surgery, duplicate code
  - 🟠 Major (Medium-High Impact): Feature envy, long methods
  - 🟡 Moderate (Medium Impact): Primitive obsession, switch statements
  - 🟢 Minor (Low Impact): Magic numbers, lazy classes

**Task File Created**: `tasks/tasks-code-smells-YYYYMMDD.md`

**Example Task**:
```markdown
- [ ] 1.1 Refactor UserManager.ts God Object - Extract classes (UserRepository, UserAuthService, UserNotificationService, UserAnalyticsService, UserCacheService) - Estimated: 8-12 hours status: scheduled
```

### 1.2 Cognitive Complexity Assessment

**Purpose**: Measure code understandability and mental effort required

**Execution**:
```bash
Task tool with subagent_type="cognitive-complexity-assessment-droid-forge" \
  description="Comprehensive complexity assessment" \
  prompt "Analyze codebase for cognitive complexity, identify functions exceeding thresholds (11+ = complex, 16+ = very complex, 26+ = extremely complex), generate detailed report, and create tasks in tasks/tasks-complexity-$(date +%Y%m%d).md for each high-complexity function. Prioritize by severity (complexity score)."
```

**Output**:
- Complexity report with functions categorized by:
  - 🔴 Extremely Complex (26+): Immediate refactoring required
  - 🟠 Very Complex (16-25): High priority refactoring
  - 🟡 Complex (11-15): Medium priority review

**Task File Created**: `tasks/tasks-complexity-YYYYMMDD.md`

**Example Task**:
```markdown
- [ ] 2.1 Reduce OrderProcessor.processComplexOrder() complexity (OrderProcessor.ts:145) - Current: 28, Target: <10 - Extract order validation, payment processing, inventory update, email notification into separate methods - Reduce nesting with guard clauses - Estimated: 6-8 hours status: scheduled
```

### 1.3 TypeScript Professional Assessment

**Purpose**: TypeScript-specific quality checks (type safety, best practices)

**Execution**:
```bash
Task tool with subagent_type="typescript-professional-droid-forge" \
  description="TypeScript quality assessment" \
  prompt "Analyze TypeScript codebase for type safety issues, missing type definitions, improper use of 'any', weak types, and TypeScript best practices violations. Generate report and create tasks in tasks/tasks-typescript-$(date +%Y%m%d).md"
```

## Phase 2: Task Creation

### Automatic Task Creation

Each assessment droid automatically creates tasks through the **task-manager-droid-forge**:

```bash
create_tasks_for_findings() {
  local task_file="$1"
  local findings_report="$2"
  
  Task tool with subagent_type="task-manager-droid-forge" \
    description="Create refactoring tasks from findings" \
    prompt "Create tasks in $task_file for each finding in $findings_report.
    
    Each task must include:
    - File path and line numbers
    - Issue type and description
    - Recommended refactoring pattern
    - Estimated effort
    - Priority/severity
    
    Status: All tasks start as 'status: scheduled'"
}
```

### Task File Format

```markdown
# Code Quality Improvement Tasks

## Relevant Files
- `src/services/UserManager.ts` - God Object (850 lines, 28 methods)
- `src/payment/PaymentGateway.ts` - Very Complex function (complexity: 24)

## Tasks

- [ ] 1.0 Critical Issues (Priority: High) 🔴
  - [ ] 1.1 Refactor UserManager.ts God Object - Extract 5 classes - 8-12 hours status: scheduled
  - [ ] 1.2 Reduce PaymentGateway.handlePayment() complexity - Break into smaller functions - 5-6 hours status: scheduled
  
- [ ] 2.0 Major Issues (Priority: Medium-High) 🟠
  - [ ] 2.1 Fix Shotgun Surgery in Payment Module - Strategy Pattern - 16-20 hours status: scheduled
```

## Phase 3: Refactoring Execution

### Task-Driven Refactoring

The **code-refactoring-droid-forge** processes tasks and updates status:

```bash
Task tool with subagent_type="code-refactoring-droid-forge" \
  description="Execute refactoring tasks" \
  prompt "Process tasks from tasks/tasks-code-smells-$(date +%Y%m%d).md. 
  
  For each task:
  1. Update status to 'started' ([ ] → [~])
  2. Execute refactoring
  3. Run tests to verify functionality preserved
  4. Update status to 'completed' ([~] → [x]) or 'failed'
  5. Add notes about changes made
  
  Work through tasks in priority order (Critical → Major → Moderate → Minor)"
```

### Status Lifecycle

```
┌─────────────┐
│  scheduled  │  Initial state ([ ])
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   started   │  Work in progress ([~])
└──────┬──────┘
       │
       ├────────┐
       │        │
       ▼        ▼
┌──────────┐ ┌─────────┐
│completed │ │ failed  │
└──────────┘ └─────────┘
   ([x])        ([!])
```

### Refactoring Workflow

```bash
execute_incremental_refactoring() {
  local task_file="$1"
  local task_id="$2"
  
  # 1. Mark as started
  update_task_status "$task_file" "$task_id" "started"
  
  # 2. Perform refactoring
  execute_refactoring_for_task "$task"
  
  # 3. Run tests
  if run_tests_for_refactored_code; then
    # 4a. Success - mark completed
    update_task_status "$task_file" "$task_id" "completed" \
      "Refactoring completed successfully. All tests pass. Complexity reduced from X to Y."
  else
    # 4b. Failure - mark failed
    update_task_status "$task_file" "$task_id" "failed" \
      "Tests failed after refactoring. Rolling back changes."
  fi
}
```

## Phase 4: Verification

### Post-Refactoring Verification

After refactoring, re-run assessments to verify improvements:

```bash
# Verify code smells reduced
Task tool with subagent_type="code-smell-assessment-droid-forge" \
  description="Verify code smell reduction" \
  prompt "Re-analyze refactored files and generate comparison report showing before/after metrics"

# Verify complexity reduced
Task tool with subagent_type="cognitive-complexity-assessment-droid-forge" \
  description="Verify complexity reduction" \
  prompt "Re-analyze refactored functions and verify complexity scores below target thresholds"

# Run full test suite
npm test
# or
pytest tests/
```

## Complete End-to-End Example

### Scenario: Refactor Payment Module

**Step 1: Initial Assessment**

```bash
# Run code smell assessment
Task tool with subagent_type="code-smell-assessment-droid-forge" \
  description="Assess payment module" \
  prompt "Analyze src/payment/ module for code smells and create tasks"
```

**Findings**:
- God Object: `PaymentService.ts` (650 lines, 22 methods)
- Shotgun Surgery: Adding payment method requires changing 8 files
- Duplicate Code: Validation logic duplicated 4 times
- Complex Method: `PaymentGateway.handlePayment()` (complexity: 24)

**Step 2: Tasks Created**

File: `tasks/tasks-code-smells-20250111.md`

```markdown
## Tasks

- [ ] 1.0 Critical Issues 🔴
  - [ ] 1.1 Refactor PaymentService God Object - Extract PaymentProcessor, PaymentValidator, PaymentLogger, PaymentAnalytics - 10-14 hours status: scheduled
  - [ ] 1.2 Fix Shotgun Surgery - Implement Strategy Pattern + Plugin Architecture - 16-20 hours status: scheduled
  
- [ ] 2.0 Major Issues 🟠
  - [ ] 2.1 Reduce PaymentGateway.handlePayment() complexity - Extract validation, processing, error handling methods - 5-6 hours status: scheduled
  - [ ] 2.2 Eliminate duplicate validation code - Extract to shared utility - 2-3 hours status: scheduled
```

**Step 3: Execute Refactoring**

```bash
Task tool with subagent_type="code-refactoring-droid-forge" \
  description="Refactor payment module" \
  prompt "Process tasks from tasks/tasks-code-smells-20250111.md. Start with task 1.1 (God Object)"
```

**Execution**:

1. **Task 1.1 - Started**:
   ```markdown
   - [~] 1.1 Refactor PaymentService God Object status: started
   ```

2. **Refactoring**:
   - Created `PaymentProcessor.ts` (CRUD operations)
   - Created `PaymentValidator.ts` (Validation logic)
   - Created `PaymentLogger.ts` (Logging)
   - Created `PaymentAnalytics.ts` (Analytics tracking)
   - Updated `PaymentService.ts` (Coordinator - 120 lines)
   - Updated imports in dependent files

3. **Testing**:
   ```bash
   npm test src/payment/
   # All tests pass ✓
   ```

4. **Task 1.1 - Completed**:
   ```markdown
   - [x] 1.1 Refactor PaymentService God Object - Extracted 4 classes: PaymentProcessor, PaymentValidator, PaymentLogger, PaymentAnalytics. Reduced from 650 to 120 lines. All tests pass. status: completed
   ```

**Step 4: Verification**

```bash
# Re-run assessment
Task tool with subagent_type="code-smell-assessment-droid-forge" \
  description="Verify improvements" \
  prompt "Re-analyze src/payment/ and compare with original assessment"
```

**Results**:
- ✅ God Object eliminated
- ✅ Class sizes: 120-180 lines (down from 650)
- ✅ Single Responsibility Principle followed
- ✅ Test coverage maintained at 90%+

## Best Practices

### 1. Assessment First, Refactor Second

Never refactor without assessment and planning:
```bash
# ❌ BAD: Refactor without assessment
Task tool with subagent_type="code-refactoring-droid-forge" \
  prompt "Refactor everything"

# ✅ GOOD: Assess, plan, then refactor
1. Assessment droids analyze and create tasks
2. Review task list and prioritize
3. Refactoring droid processes tasks systematically
```

### 2. Task-Driven Approach

Use tasks to track progress and maintain accountability:
- Assessment droids CREATE tasks
- Refactoring droid UPDATES task status
- Manager orchestrator MONITORS progress
- Task history provides audit trail

### 3. Incremental Refactoring

Work in small, testable increments:
```bash
# One task at a time
# Run tests after each task
# Commit after successful refactoring
# Continue to next task
```

### 4. Test Coverage Required

Never refactor code without tests:
```bash
# Before refactoring
if [ ! -f "tests/payment.test.ts" ]; then
  Task tool with subagent_type="unit-test-droid-forge" \
    prompt "Create comprehensive tests for PaymentService before refactoring"
fi
```

### 5. Verification Loop

Always verify improvements:
```bash
# After refactoring
1. Re-run assessment droids
2. Compare before/after metrics
3. Verify all tests pass
4. Check performance benchmarks
```

## Integration with CI/CD

### Pre-Commit Hook

```yaml
# .pre-commit-config.yaml
- id: complexity-check
  name: Check Cognitive Complexity
  entry: ./scripts/check-complexity.sh
  language: bash
  # Fail if any function > 15 complexity
```

### PR Quality Gate

```yaml
# .github/workflows/code-quality.yml
name: Code Quality Assessment

on: [pull_request]

jobs:
  assess:
    runs-on: ubuntu-latest
    steps:
      - name: Run Code Smell Assessment
        run: |
          droid exec code-smell-assessment-droid-forge \
            "Analyze changed files and report findings"
      
      - name: Run Complexity Assessment
        run: |
          droid exec cognitive-complexity-assessment-droid-forge \
            "Check complexity of changed functions"
      
      - name: Fail if Critical Issues
        run: |
          if grep -q "🔴" assessment-report.md; then
            echo "Critical code quality issues found"
            exit 1
          fi
```

## Success Metrics

### Code Smell Reduction
- **Target**: Reduce critical smells by 80% per sprint
- **Measure**: Count of 🔴 critical findings
- **Trend**: Track over time in dashboard

### Complexity Reduction
- **Target**: 90%+ functions under complexity 10
- **Measure**: Average complexity score
- **Trend**: Monthly improvement percentage

### Technical Debt
- **Target**: Reduce estimated refactoring hours by 50% per quarter
- **Measure**: Sum of estimated hours in task files
- **Trend**: Quarterly burn-down chart

## Troubleshooting

### Issue: Assessment finds too many issues

**Solution**: Prioritize and work incrementally
```bash
# Focus on critical issues first
grep "🔴" tasks/tasks-code-smells-*.md > tasks/tasks-critical-only.md
Task tool with subagent_type="code-refactoring-droid-forge" \
  prompt "Focus only on critical issues in tasks-critical-only.md"
```

### Issue: Tests fail after refactoring

**Solution**: Roll back and fix tests first
```bash
git checkout -- .
# Fix or add missing tests
Task tool with subagent_type="unit-test-droid-forge" \
  prompt "Add comprehensive tests for PaymentService before refactoring"
# Retry refactoring
```

### Issue: Task status not updating

**Solution**: Check task-manager-droid-forge integration
```bash
# Verify task file exists
ls -la tasks/tasks-*.md

# Manual status update if needed
Task tool with subagent_type="task-manager-droid-forge" \
  description="Manual task update" \
  prompt "Update task 1.1 in tasks/tasks-code-smells-20250111.md to status: completed"
```

## Summary

The assessment and refactoring workflow provides:

1. ✅ **Systematic Approach**: Assess → Plan → Execute → Verify
2. ✅ **Task Management**: Full ai-dev-tasks integration
3. ✅ **Accountability**: Status tracking and audit trail
4. ✅ **Quality Assurance**: Test-driven refactoring
5. ✅ **Continuous Improvement**: Metrics and trends
6. ✅ **Team Coordination**: Clear task ownership
7. ✅ **Best Practices**: Industry-standard refactoring patterns

Use this workflow to improve code quality systematically while maintaining functionality and test coverage.

---

**Built with ❤️ by the Droid Forge team**
