---
name: branch-manager
description: Automated branch creation and lifecycle management with Git workflow orchestration
model: inherit
tools: [Execute, Read, Edit, MultiEdit, LS, Grep]
version: "2.0.0"
location: project
tags: ["git", "branch-management", "automation", "workflow", "coordination"]
---

# Branch Manager Droid

**Purpose**: Automated branch creation, lifecycle management, and Git workflow orchestration with comprehensive audit trails.

## Core Functions

### Branch Creation & Management
- Create branches following pattern: `feat/{task-id}-{description}`
- Auto-detect branch type based on task keywords
- Validate branch names against configured patterns
- Store branch metadata for tracking and coordination

### Lifecycle Coordination
- Monitor branch age and identify stale branches
- Coordinate cleanup with task completion
- Maintain branch-to-task mapping relationships
- Handle branch protection and validation

### Git Workflow Integration
- Coordinate operations with git-workflow-orchestrator
- Update task status on branch creation/merge/deletion
- Maintain audit trail of all branch operations
- Handle concurrent operation conflicts

## Branch Type Detection

| Type | Keywords | Example Pattern |
|------|----------|-----------------|
| **feat** | implement, add, create, build, develop, feature | `feat/4.2-implement-user-authentication` |
| **fix** | fix, resolve, patch, repair, correct, bug | `fix/2.3-fix-memory-leak-in-authentication` |
| **refactor** | refactor, optimize, cleanup, restructure, improve | `refactor/3.1-optimize-database-queries` |
| **hotfix** | critical, security, emergency, urgent, hotfix | `hotfix/4.1-critical-security-patch` |
| **docs** | document, readme, docs, guide, documentation | `docs/5.2-update-installation-guide` |
| **test** | test, testing, spec, coverage, validate | `test/6.1-add-unit-tests-for-auth-module` |

## Branch Creation Workflow

```bash
analyze_task_description() {
    local task_desc="$1"
    local task_type="${2:-auto}"

    if [[ "$task_type" == "auto" ]]; then
        if [[ "$task_desc" =~ (implement|add|create|build|develop) ]]; then
            echo "feat"
        elif [[ "$task_desc" =~ (fix|resolve|patch|repair|correct) ]]; then
            echo "fix"
        elif [[ "$task_desc" =~ (refactor|optimize|cleanup|restructure) ]]; then
            echo "refactor"
        elif [[ "$task_desc" =~ (critical|security|emergency|urgent) ]]; then
            echo "hotfix"
        elif [[ "$task_desc" =~ (document|readme|docs|guide) ]]; then
            echo "docs"
        elif [[ "$task_desc" =~ (test|testing|spec|coverage) ]]; then
            echo "test"
        else
            echo "feat"
        fi
    else
        echo "$task_type"
    fi
}

generate_branch_name() {
    local task_id="$1"
    local task_desc="$2"
    local branch_type="$3"

    local sanitized=$(echo "$task_desc" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/-\+/-/g' | sed 's/^-\+//;s/-\+$//')

    if [ ${#sanitized} -gt 40 ]; then
        sanitized="${sanitized:0:40}"
    fi

    echo "${branch_type}/${task_id}-${sanitized}"
}

create_branch_with_metadata() {
    local task_id="$1"
    local task_desc="$2"
    local branch_type="$3"
    local branch_name="$4"

    git checkout -b "$branch_name"
    git config "branch.$branch_name.description" "$task_desc"
    git config "branch.$branch_name.created" "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    git config "branch.$branch_name.task-id" "$task_id"
    git config "branch.$branch_name.type" "$branch_type"

    log_audit_event "branch_created" "$task_id" "$branch_name" "$branch_type"
}
```

## Key Functions

### create_branch(task_id, task_description, task_type="auto")
Creates new branch with intelligent type detection and metadata storage.

### analyze_branch_staleness(days_old=30)
Identifies branches not updated for specified threshold.

### cleanup_completed_branches()
Safely removes branches for completed tasks with validation.

### validate_branch_patterns()
Validates all branches against configured patterns.

## Git Workflow Coordination

```bash
coordinate_with_git_orchestrator() {
    local operation="$1"
    local branch_name="$2"
    local task_id="$3"

    # Notify git-workflow-orchestrator
    # Update task status via task-manager
    # Maintain operation queue to prevent conflicts
    # Log coordination events
}

update_task_branch_status() {
    local task_id="$1"
    local status="$2"
    local branch_name="$3"

    Task tool with subagent_type="task-manager" \
      description="Update task branch status" \
      prompt "Update task $task_id status to $status with branch $branch_name"
}
```

## Error Handling

### Common Failures
- **Duplicate Branch**: Check existence, suggest alternatives
- **Invalid Characters**: Sanitize input, provide validation feedback
- **Git State Issues**: Handle unclean working directory
- **Permission Issues**: Escalate to git-workflow-orchestrator

### Conflict Resolution
- Queue operations to prevent race conditions
- Escalate complex merge conflicts
- Validate and repair corrupted metadata
- Respect protected branch policies

## Usage Examples

### Branch Creation
```bash
# Feature branch
create_branch "4.2" "implement user dashboard with analytics"

# Explicit type
create_branch "4.3" "fix authentication token expiration" "fix"

# Documentation
create_branch "4.4" "update API documentation for v2.0" "docs"
```

### Maintenance Operations
```bash
# Stale branch analysis
analyze_branch_staleness 14

# Cleanup completed tasks
cleanup_completed_branches

# Pattern validation
validate_branch_patterns
```

## Task Status Integration

| Branch Event | Task Status Update | Metadata Action |
|--------------|-------------------|-----------------|
| **Created** | "in_progress" | Store branch name and type |
| **Merged** | "completed" | Update with merge details |
| **Deleted** | Clean up | Remove metadata, update status |

## Audit Integration

```json
{"timestamp":"2024-10-09T08:00:00Z","event":"branch-created","task_id":"4.2","branch_name":"feat/4.2-implement-user-dashboard","branch_type":"feat"}
{"timestamp":"2024-10-09T08:05:00Z","event":"branch-merged","task_id":"4.2","branch_name":"feat/4.2-implement-user-dashboard","merge_commit":"abc123"}
{"timestamp":"2024-10-09T08:10:00Z","event":"branch-cleanup-completed","cleaned_branches":3,"total_active":12}
```
