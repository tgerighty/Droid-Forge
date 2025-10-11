# Separation of Concerns Plan

## Overview

This document outlines the plan to separate **assessment droids** (which analyze and report) from **action droids** (which fix and implement), following the established pattern from code-smell-assessment and code-refactoring droids.

## Core Principle

> **Assessment droids ANALYZE and CREATE TASKS**  
> **Action droids EXECUTE and UPDATE TASK STATUS**

This ensures:
- ✅ Clear responsibility boundaries
- ✅ Reports can be reviewed before action
- ✅ Prioritization based on findings
- ✅ Audit trail of issues and fixes
- ✅ Task-driven workflow with ai-dev-tasks integration

## Current Droids Analysis

### ✅ Already Properly Separated

| Droid | Type | Notes |
|-------|------|-------|
| code-smell-assessment-droid-forge | Assessment | Creates tasks for code smells |
| cognitive-complexity-assessment-droid-forge | Assessment | Creates tasks for high complexity |
| code-refactoring-droid-forge | Action | Executes refactoring, updates tasks |
| manager-orchestrator-droid-forge | Orchestration | Coordinates workflows |
| task-manager-droid-forge | Infrastructure | Manages task files |
| ai-dev-tasks-integrator-droid-forge | Infrastructure | PRD processing |
| git-workflow-orchestrator-droid-forge | Infrastructure | Git operations |
| biome-droid-forge | Action | Formatting only (no assessment) |
| auto-pr-droid-forge | Action | PR automation |

### 🔴 Need Separation

#### 1. **security-audit-droid-forge**

**Current State**: Mixed concerns - does both assessment AND fixing

**Issues**:
- Assesses vulnerabilities
- Also fixes them immediately
- No task tracking
- No prioritization workflow

**Separation Plan**:

##### A. **security-assessment-droid-forge** (NEW)
```markdown
**Purpose**: Security vulnerability detection and risk assessment

**Responsibilities**:
- Scan dependencies for known vulnerabilities (npm audit, Snyk)
- Analyze code for security issues (SQL injection, XSS, CSRF)
- Review authentication/authorization patterns
- Check secrets management and configuration
- Generate risk-prioritized report
- **CREATE TASKS** in tasks/tasks-security-[date].md

**Output**:
- Detailed security assessment report
- Categorized findings:
  - 🔴 Critical: Remote code execution, auth bypass
  - 🟠 High: SQL injection, XSS vulnerabilities
  - 🟡 Medium: Weak crypto, missing security headers
  - 🟢 Low: Outdated dependencies (non-critical)

**Example Task**:
- [ ] 1.1 Fix SQL injection in UserController.authenticate() - Use parameterized queries - Estimated: 2-3 hours status: scheduled
```

##### B. **security-fix-droid-forge** (NEW)
```markdown
**Purpose**: Execute security fixes from assessment findings

**Responsibilities**:
- Process security tasks from tasks/tasks-security-[date].md
- Update task status (scheduled → started → completed)
- Implement security fixes:
  - Parameterized queries for SQL injection
  - Input sanitization for XSS
  - CSRF token implementation
  - Update vulnerable dependencies
  - Add security headers
- Run security tests after each fix
- **UPDATE TASKS** with completion status

**Workflow**:
1. Read task from tasks/tasks-security-[date].md
2. Mark task as started
3. Implement fix
4. Run security tests
5. Mark task as completed (or failed)
```

---

#### 2. **typescript-professional-droid-forge**

**Current State**: Mixed concerns - both assesses type safety AND implements fixes

**Issues**:
- Analyzes type safety issues
- Also fixes them
- No task tracking
- Assessment and fixing mixed together

**Separation Plan**:

##### A. **typescript-assessment-droid-forge** (NEW)
```markdown
**Purpose**: TypeScript type safety and quality assessment

**Responsibilities**:
- Analyze TypeScript configuration (strict mode compliance)
- Detect 'any' usage and weak types
- Find missing type definitions
- Identify improper type assertions
- Check null/undefined handling
- Review type coverage percentage
- Generate type safety report
- **CREATE TASKS** in tasks/tasks-typescript-[date].md

**Output**:
- Type safety assessment report
- Categorized findings:
  - 🔴 Critical: 'any' in public APIs, unsafe type assertions
  - 🟠 High: Missing null checks, weak types
  - 🟡 Medium: Type assertion abuse, implicit any
  - 🟢 Low: Type inference opportunities

**Example Task**:
- [ ] 1.1 Replace 'any' with proper types in UserService.ts - Define User interface, use generics - Estimated: 3-4 hours status: scheduled
- [ ] 1.2 Add null checks in PaymentGateway.processPayment() - Use optional chaining and nullish coalescing - Estimated: 1-2 hours status: scheduled
```

##### B. **typescript-fix-droid-forge** (NEW)
```markdown
**Purpose**: Execute TypeScript type safety improvements

**Responsibilities**:
- Process TypeScript tasks from tasks/tasks-typescript-[date].md
- Update task status (scheduled → started → completed)
- Implement type fixes:
  - Replace 'any' with proper types
  - Add missing type definitions
  - Fix type assertions
  - Add null/undefined checks
  - Implement strict mode compliance
- Run type checker after each fix
- **UPDATE TASKS** with completion status

**Workflow**:
1. Read task from tasks/tasks-typescript-[date].md
2. Mark task as started
3. Implement type safety fix
4. Run tsc --noEmit to verify
5. Mark task as completed (or failed)
```

---

#### 3. **debugging-expert-droid-forge**

**Current State**: Mixed concerns - analyzes bugs AND fixes them

**Issues**:
- Root cause analysis
- Also implements fixes
- No task tracking
- Debugging and fixing mixed

**Separation Plan**:

##### A. **debugging-assessment-droid-forge** (NEW - rename existing)
```markdown
**Purpose**: Bug analysis and root cause identification

**Responsibilities**:
- Analyze error messages and stack traces
- Perform root cause analysis
- Identify patterns in failures
- Analyze performance bottlenecks
- Review concurrency issues
- Generate debugging report with findings
- **CREATE TASKS** in tasks/tasks-bugs-[date].md

**Output**:
- Root cause analysis report
- Categorized findings:
  - 🔴 Critical: Data loss, security issues, crashes
  - 🟠 High: Functional bugs, performance issues
  - 🟡 Medium: UI bugs, edge cases
  - 🟢 Low: Minor issues, cosmetic bugs

**Example Task**:
- [ ] 1.1 Fix race condition in OrderProcessor.processOrder() - Add transaction isolation - Estimated: 4-5 hours status: scheduled
- [ ] 1.2 Fix memory leak in UserSession.cleanup() - Clear event listeners properly - Estimated: 2-3 hours status: scheduled
```

##### B. **bug-fix-droid-forge** (NEW)
```markdown
**Purpose**: Execute bug fixes from debugging analysis

**Responsibilities**:
- Process bug tasks from tasks/tasks-bugs-[date].md
- Update task status (scheduled → started → completed)
- Implement bug fixes:
  - Fix logic errors
  - Resolve race conditions
  - Fix memory leaks
  - Performance optimizations
  - Error handling improvements
- Run tests after each fix
- **UPDATE TASKS** with completion status

**Workflow**:
1. Read task from tasks/tasks-bugs-[date].md
2. Mark task as started
3. Implement bug fix
4. Run tests to verify fix
5. Mark task as completed (or failed)
```

---

#### 4. **unit-test-droid-forge**

**Current State**: Mostly action-focused, but could have assessment component

**Issues**:
- Runs tests (action)
- Could also assess test coverage and quality
- No separate assessment phase

**Separation Plan**:

##### A. **test-assessment-droid-forge** (NEW)
```markdown
**Purpose**: Test coverage and quality assessment

**Responsibilities**:
- Analyze test coverage percentages
- Identify untested code paths
- Review test quality (meaningful assertions)
- Detect flaky tests
- Check test performance
- Generate test quality report
- **CREATE TASKS** in tasks/tasks-testing-[date].md

**Output**:
- Test coverage report
- Categorized findings:
  - 🔴 Critical: Zero coverage on critical paths
  - 🟠 High: < 50% coverage on important modules
  - 🟡 Medium: < 80% coverage overall
  - 🟢 Low: Missing edge case tests

**Example Task**:
- [ ] 1.1 Add tests for UserService.createUser() - Currently 0% coverage - Add unit tests with success/failure cases - Estimated: 3-4 hours status: scheduled
```

##### B. **unit-test-droid-forge** (UPDATE - keep as action)
```markdown
**Purpose**: Execute test tasks and run test suites

**Responsibilities**:
- Process test tasks from tasks/tasks-testing-[date].md
- Update task status (scheduled → started → completed)
- Generate test files
- Run test suites
- Report test results
- **UPDATE TASKS** with completion status

**Note**: Keep existing functionality, add task management
```

---

### ✅ Already Properly Focused (No Change Needed)

#### **frontend-engineer-droid-forge**
- **Type**: Action (implementation)
- **Focus**: Build React components, create layouts
- **Status**: ✅ Good - pure implementation, no assessment mixed in

#### **backend-engineer-droid-forge**
- **Type**: Action (implementation)
- **Focus**: Build APIs, design schemas
- **Status**: ✅ Good - pure implementation, no assessment mixed in

#### **reliability-droid-forge**
- **Type**: Mixed (operational)
- **Focus**: Incident response and monitoring
- **Status**: ✅ OK - operational nature requires both detection and response
- **Note**: This is different - incidents require immediate action, not task creation

## Workflow Pattern

### Standard Assessment → Action Workflow

```
┌─────────────────────┐
│  Assessment Droid   │
│                     │
│ 1. Analyze code     │
│ 2. Detect issues    │
│ 3. Generate report  │
│ 4. CREATE TASKS     │
└──────────┬──────────┘
           │
           │ tasks/tasks-[type]-[date].md
           │
           ▼
┌─────────────────────┐
│  Task Manager Droid │
│                     │
│ Manages task file   │
└──────────┬──────────┘
           │
           │
           ▼
┌─────────────────────┐
│   Action Droid      │
│                     │
│ 1. Read task        │
│ 2. Mark started     │
│ 3. Execute fix      │
│ 4. Run tests        │
│ 5. Mark completed   │
└─────────────────────┘
```

## Implementation Priority

### Phase 1: Security (High Priority)
1. ✅ Create security-assessment-droid-forge
2. ✅ Create security-fix-droid-forge
3. ✅ Update documentation

### Phase 2: TypeScript (High Priority)
1. ✅ Create typescript-assessment-droid-forge
2. ✅ Create typescript-fix-droid-forge
3. ✅ Update documentation

### Phase 3: Debugging (Medium Priority)
1. ✅ Rename debugging-expert to debugging-assessment-droid-forge
2. ✅ Create bug-fix-droid-forge
3. ✅ Update documentation

### Phase 4: Testing (Lower Priority)
1. ✅ Create test-assessment-droid-forge
2. ✅ Update unit-test-droid-forge with task management
3. ✅ Update documentation

## Benefits of Separation

### 1. **Clear Responsibilities**
- Assessment droids focus on analysis
- Action droids focus on execution
- No confusion about what each droid does

### 2. **Review Before Action**
- Findings can be reviewed by humans
- Priorities can be adjusted
- Not all issues need immediate fixing

### 3. **Task-Driven Workflow**
- All work tracked in ai-dev-tasks
- Progress visible and auditable
- Clear accountability

### 4. **Parallel Execution**
- Multiple assessment droids can run simultaneously
- All findings aggregated
- Action droids process tasks in priority order

### 5. **Better Quality**
- Assessment is thorough (not rushed to fix)
- Fixes are deliberate (following assessment guidance)
- Tests verify each fix before marking complete

## Example: Security Workflow

### Before (Mixed):
```bash
# security-audit-droid finds and fixes immediately
Task tool with subagent_type="security-audit-droid-forge" \
  prompt "Audit and fix security issues"
# Result: Issues fixed without review, no task tracking
```

### After (Separated):
```bash
# Phase 1: Assessment
Task tool with subagent_type="security-assessment-droid-forge" \
  prompt "Assess security vulnerabilities and create tasks"

# Output: tasks/tasks-security-20250111.md
# - [ ] 1.1 Fix SQL injection in UserController - Critical
# - [ ] 1.2 Update vulnerable dependencies - High
# - [ ] 2.1 Add security headers - Medium

# Review tasks, adjust priorities...

# Phase 2: Fixing
Task tool with subagent_type="security-fix-droid-forge" \
  prompt "Process security tasks starting with critical issues"

# Result: Tasks marked as completed with audit trail
```

## Migration Strategy

### For Each Droid to Split:

1. **Create Assessment Droid**
   - Extract analysis/detection logic
   - Add task creation with task-manager-droid-forge
   - Generate reports with categorized findings
   - Include examples of task format

2. **Create/Update Action Droid**
   - Extract fix/implementation logic
   - Add task status updates
   - Include test verification
   - Handle success/failure states

3. **Update Documentation**
   - Add to AGENTS.md
   - Update delegation patterns
   - Include workflow examples
   - Document integration points

4. **Test Workflow**
   - Run assessment → creates tasks
   - Run action → updates tasks
   - Verify task file integrity
   - Confirm audit trail

## Success Criteria

✅ All assessment droids create tasks in ai-dev-tasks format  
✅ All action droids update task status as they work  
✅ No mixed-concern droids remain (except operational)  
✅ Clear documentation for each droid's purpose  
✅ Workflow examples show proper delegation  
✅ Task files provide complete audit trail  
✅ AGENTS.md updated with new droids  

---

**Next Steps**: Implement Phase 1 (Security droids) as proof of concept, then proceed with remaining phases.
