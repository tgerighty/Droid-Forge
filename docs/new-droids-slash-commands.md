# New Droids from Slash Commands Analysis

## Overview

Created 2 new droids based on analysis of [regenrek/slash-commands](https://github.com/regenrek/slash-commands) repository, focusing on non-overlapping capabilities with existing Droid Forge droids.

**Created**: January 12, 2025  
**Source Inspiration**: regenrek/slash-commands  
**Droid Forge Version**: v2.1.0

---

## Slash Commands Analysis

### Original Slash Commands Reviewed

| Command | Purpose | Overlap with Droid Forge |
|---------|---------|--------------------------|
| **plan-review** | Pre-implementation plan validation, go/no-go decision | ~40% overlap with manager-orchestrator |
| **code-review-low** | Fast code review (smells, security, performance) | ~60% overlap with assessment droids |
| **code-review-high** | Thorough code review | ~70% overlap with multiple assessments |
| **problem-analyzer** | Bug analysis, file mapping, root cause | ~80% overlap with debugging-assessment |
| **refactor-code** | Refactoring with commit isolation | ~90% overlap with code-refactoring |

### Gap Analysis

**Unique Capabilities Not in Droid Forge**:
1. ✅ **Pre-implementation go/no-go decision** with codebase alignment scoring
2. ✅ **Comprehensive file impact mapping** with propagation tracing
3. ❌ Fast combined review (duplicates existing assessment specialization)
4. ❌ Deep comprehensive review (covered by multiple specialists)
5. ❌ Refactoring isolation (already in code-refactoring-droid-forge)

---

## New Droids Created

### 1. plan-review-droid-forge

**File**: `.factory/droids/plan-review-droid-forge.md`

**Purpose**: Validate implementation plans **before** development begins. Provides GREEN/YELLOW/RED LIGHT decisions with confidence scores.

**Unique Value**:
- Pre-implementation validation (catches issues before code is written)
- Codebase pattern alignment check
- Go/no-go decision with confidence percentage
- Scope completeness verification
- No feature flags or fallbacks validation

**When to Use**:
```bash
# Before starting implementation
Task tool with subagent_type="plan-review-droid-forge" \
  description="Review implementation plan" \
  prompt "Review plan at tasks/plan-auth-feature.md. Check alignment with existing patterns, assess risks, provide go/no-go decision with confidence score."
```

**Decision Criteria**:
- **GREEN LIGHT (>90%)**: Plan is solid, low risk, aligned with codebase
- **YELLOW LIGHT (70-90%)**: Plan needs minor adjustments
- **RED LIGHT (<70%)**: Plan has major issues, requires rework

**Workflow Position**:
```
PRD → plan-review → GREEN → manager-orchestrator → Implementation
              ↓
          RED/YELLOW → Revise Plan → Re-review
```

**Outputs**:
- Decision report with confidence score
- Codebase alignment assessment
- Scope analysis (in/out of scope)
- Risk assessment (performance, security, privacy)
- Code smell and caveat identification
- Required changes for GREEN LIGHT
- No task file creation (pre-implementation)

**Complements**:
- **manager-orchestrator**: Validates plans before orchestration
- **code-smell-assessment**: Pre-validates to avoid introducing smells
- **security-assessment**: Catches security issues at planning stage

**Example Output**:
```markdown
# Plan Review: User Authentication Feature

## Decision: YELLOW LIGHT
**Confidence**: 75%

## Executive Summary
Plan follows Next.js patterns but diverges from Better Auth conventions.
Security and scope are solid, but auth implementation needs alignment.

## Codebase Alignment
- ✅ Matches Next.js 15 App Router structure
- ✅ Follows tRPC procedure patterns
- ⚠️ Diverges from Better Auth patterns in lib/auth/
- ❌ Missing test strategy

## Required Changes Before GREEN LIGHT
- [ ] Align with Better Auth middleware pattern
- [ ] Add comprehensive test strategy
- [ ] Define error handling approach
```

**Integration with Existing Droids**:
- Runs **before** manager-orchestrator delegation
- Provides validation that **prevents** work on misaligned plans
- Saves time by catching architectural conflicts early

---

### 2. impact-analyzer-droid-forge

**File**: `.factory/droids/impact-analyzer-droid-forge.md`

**Purpose**: Analyze bug impact across entire codebase. Map all affected files, trace propagation, identify root causes, propose minimal safe fixes.

**Unique Value**:
- **Comprehensive file impact mapping** (not just stack trace)
- Propagation path tracing (entry point → error)
- Identifies indirect and cascading impacts
- Documentation gap identification
- Test file mapping
- Configuration impact analysis

**When to Use**:
```bash
# After bug discovered, before implementing fix
Task tool with subagent_type="impact-analyzer-droid-forge" \
  description="Analyze API error impact" \
  prompt "Analyze 500 errors on /api/users. Map all affected files (direct + indirect), trace propagation, identify root cause, propose minimal fix. Check for doc gaps."
```

**Impact Mapping**:
- **Direct**: Files in stack trace
- **Indirect**: Files that import affected modules
- **Cascading**: Files dependent on indirect files
- **Test Files**: Tests for all affected files
- **Config Files**: Configs influencing behavior

**Workflow Position**:
```
Bug Reported → impact-analyzer → File Map + Root Cause → bug-fix → Implementation
```

**Outputs**:
- Comprehensive impact report
- Affected files list with reasons
- Root cause explanation with propagation path
- Minimal safe fix proposal with side effects
- Test requirements (add/update)
- Documentation gaps (outdated/missing)
- Rollback strategy
- No automatic code changes (assessment only)

**Complements**:
- **debugging-assessment**: Provides deeper analysis before this droid
- **bug-fix-droid-forge**: Implements fixes proposed by this droid
- **unit-test-droid-forge**: Writes tests identified by this droid

**Example Output**:
```markdown
# Bug Impact Analysis: Null Reference Error

## Affected Files

### Direct Impact
- `src/services/user.service.ts:123` - Error in getUserData()
- `src/api/users/route.ts:456` - Calls without null check

### Indirect Impact
- `src/components/UserProfile.tsx` - Uses affected API
- `src/lib/auth/session.ts` - Similar pattern, potential same bug

### Test Files Affected
- `tests/user.service.test.ts` - Needs update for null handling

## Root Cause
getUserData() changed to return null (PR #123, commit abc123)
Propagation: null return → property access → TypeError → 500

## Proposed Fix
**Option 1**: Add null check at call site (Recommended)
- Minimal change
- Explicit error handling
- Tests: Add NotFoundError test case

## Documentation Gaps
1. `docs/api/users.md` - States function always returns object
2. Missing: `docs/troubleshooting/user-errors.md` (CREATE)
```

**Integration with Existing Droids**:
- Runs **between** debugging-assessment and bug-fix
- Provides comprehensive **file mapping** not in debugging-assessment
- Feeds **test requirements** to unit-test-droid-forge

---

## Configuration Updates

### droid-forge.yaml

Added delegation rules with high priority:

```yaml
delegation_rules:
  rules:
    - pattern: "plan-review|plan-validation|pre-implementation|go-no-go|implementation-plan|architecture-review"
      capabilities: ["plan-review", "pre-implementation", "validation", "architecture-alignment"]
      droid_types: ["plan-review-droid-forge"]
      priority: 1

    - pattern: "impact-analysis|bug-impact|affected-files|file-mapping|bug-propagation|root-cause-files"
      capabilities: ["impact-analysis", "file-mapping", "bug-tracking", "propagation-analysis"]
      droid_types: ["impact-analyzer-droid-forge"]
      priority: 2
```

**Keywords Trigger**:
- **plan-review-droid-forge**: plan-review, plan-validation, pre-implementation, go-no-go, implementation-plan, architecture-review
- **impact-analyzer-droid-forge**: impact-analysis, bug-impact, affected-files, file-mapping, bug-propagation, root-cause-files

---

## Usage Workflows

### Workflow 1: Feature Development with Plan Review

```bash
# Step 1: Create PRD
# Step 2: Review plan BEFORE coding
Task tool with subagent_type="plan-review-droid-forge" \
  prompt "Review implementation plan at tasks/plan-user-search.md"

# Step 3: If GREEN LIGHT, proceed with manager orchestration
Task tool with subagent_type="manager-orchestrator-droid-forge" \
  prompt "Orchestrate user search feature implementation"

# Step 4: Implementation via specialists
```

**Benefit**: Catches architectural conflicts before writing code

### Workflow 2: Bug Fix with Impact Analysis

```bash
# Step 1: Bug reported
# Step 2: Deep debugging
Task tool with subagent_type="debugging-assessment-droid-forge" \
  prompt "Analyze error logs for API timeout issue"

# Step 3: Comprehensive impact mapping
Task tool with subagent_type="impact-analyzer-droid-forge" \
  prompt "Map all files affected by timeout, trace propagation, propose minimal fix"

# Step 4: Implement fix
Task tool with subagent_type="bug-fix-droid-forge" \
  prompt "Implement minimal fix from impact analysis report"

# Step 5: Add tests
Task tool with subagent_type="unit-test-droid-forge" \
  prompt "Add tests identified in impact analysis"
```

**Benefit**: Complete file context prevents missing affected areas

### Workflow 3: Refactoring with Pre-validation

```bash
# Step 1: Create refactoring plan
# Step 2: Validate plan
Task tool with subagent_type="plan-review-droid-forge" \
  prompt "Review refactoring plan for API layer. Ensure no fallbacks or feature flags, verify scope completeness."

# Step 3: If GREEN, execute refactoring
Task tool with subagent_type="code-refactoring-droid-forge" \
  prompt "Execute refactoring per approved plan"
```

**Benefit**: Ensures refactoring is complete and aligned

---

## Comparison with Existing Droids

### plan-review-droid-forge vs. manager-orchestrator-droid-forge

| Aspect | plan-review | manager-orchestrator |
|--------|-------------|----------------------|
| **When** | Pre-implementation | During implementation |
| **Purpose** | Validate plan | Coordinate execution |
| **Output** | Go/no-go decision | Task delegation |
| **Creates Tasks** | No | Yes |
| **Code Changes** | No | Via delegates |
| **Confidence Score** | Yes (percentage) | No |

**Relationship**: plan-review validates **before** manager-orchestrator coordinates

### impact-analyzer-droid-forge vs. debugging-assessment-droid-forge

| Aspect | impact-analyzer | debugging-assessment |
|--------|-----------------|----------------------|
| **Focus** | File mapping | Root cause |
| **Output** | Comprehensive file list | Cause analysis |
| **Propagation** | Full trace | Focused |
| **Tests** | Lists all needed | General recommendations |
| **Docs** | Identifies gaps | Not covered |
| **Fix Proposal** | Minimal with side effects | General approach |

**Relationship**: debugging-assessment finds cause, impact-analyzer maps scope

---

## Success Metrics

### plan-review-droid-forge

**Goal**: Prevent implementation of misaligned plans

**Metrics**:
- Plans reviewed vs. issues caught during implementation
- Time saved by catching conflicts early
- % of RED/YELLOW plans that become GREEN after revision
- Reduction in architecture debates during implementation

### impact-analyzer-droid-forge

**Goal**: Complete bug context before fixing

**Metrics**:
- % of bugs with complete file mapping
- Time to identify all affected files
- Accuracy of fix proposals (do they work?)
- Documentation gaps found and fixed
- Cascading bugs prevented

---

## Integration Summary

### New Workflow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    FEATURE DEVELOPMENT                       │
└─────────────────────────────────────────────────────────────┘
                             ↓
                  PRD / Implementation Plan
                             ↓
              ┌──────────────────────────┐
              │  plan-review-droid       │ ← NEW
              │  (Pre-validation)        │
              └──────────────────────────┘
                      ↓          ↓
                   GREEN      RED/YELLOW
                      ↓          ↓
         ┌────────────────┐  Revise Plan
         │ manager-orch   │     ↓
         │ (Coordinate)   │  Re-review
         └────────────────┘
                ↓
         Delegate to Specialists

┌─────────────────────────────────────────────────────────────┐
│                      BUG FIXING                              │
└─────────────────────────────────────────────────────────────┘
                             ↓
                    Bug Reported + Logs
                             ↓
              ┌──────────────────────────┐
              │  debugging-assessment    │
              │  (Root cause analysis)   │
              └──────────────────────────┘
                             ↓
              ┌──────────────────────────┐
              │  impact-analyzer-droid   │ ← NEW
              │  (File mapping)          │
              └──────────────────────────┘
                             ↓
                    Complete File Map
                    + Fix Proposal
                    + Test Requirements
                             ↓
              ┌──────────────────────────┐
              │  bug-fix-droid           │
              │  (Implement fix)         │
              └──────────────────────────┘
                             ↓
              ┌──────────────────────────┐
              │  unit-test-droid         │
              │  (Add tests)             │
              └──────────────────────────┘
```

---

## Files Created

1. **`.factory/droids/plan-review-droid-forge.md`** (8.5KB)
   - Full droid specification
   - Decision criteria and examples
   - Output format templates

2. **`.factory/droids/impact-analyzer-droid-forge.md`** (11KB)
   - Full droid specification
   - Impact mapping patterns
   - Output format templates

3. **`droid-forge.yaml`** (updated)
   - Added delegation rules for both droids
   - Priority 1 and 2 (high priority)

4. **`docs/new-droids-slash-commands.md`** (this file)
   - Comprehensive documentation
   - Usage workflows
   - Integration guide

---

## Next Steps

### Immediate
1. ✅ Create droid specifications
2. ✅ Update droid-forge.yaml
3. ⏳ Update AGENTS.md with new droids
4. ⏳ Commit changes with detailed message

### Short-term (1 week)
1. Test plan-review-droid with real PRDs
2. Test impact-analyzer-droid with real bugs
3. Gather feedback on decision criteria
4. Refine output formats based on usage

### Medium-term (1 month)
1. Track metrics for both droids
2. Optimize delegation patterns
3. Create example output library
4. Add to team workflow documentation

---

## Credits

**Inspired by**: [regenrek/slash-commands](https://github.com/regenrek/slash-commands)  
**Author**: @regenrek (Kevin Kern)  
**Adapted for**: Droid Forge v2.1.0  
**Created**: January 12, 2025  
**License**: MIT (Droid Forge), Original slash-commands license applies to inspiration

---

**Built with ❤️ for proactive planning and comprehensive bug analysis**
