# Droid Forge Droid Creation Guide v1.0

## Overview

This guide provides comprehensive instructions for creating new droids within the Droid Forge framework. It codifies all established patterns, best practices, configuration standards, and orchestration rules developed through v1.0-v1.1 framework evolution.

## Table of Contents

1. [Fundamental Principles](#fundamental-principles)
2. [Droid Template Structure](#droid-template-structure)
3. [YAML Frontmatter Specifications](#yaml-frontmatter-specifications)
4. [Manager Droid Integration Patterns](#manager-droid-integration-patterns)
5. [Task Status Management](#task-status-management)
6. [Cross-Droid Coordination](#cross-droid-coordination)
7. [Error Handling Patterns](#error-handling-patterns)
8. [Factory.ai Template Compliance](#factoryai-template-compliance)
9. [Testing and Validation](#testing-and-validation)
10. [Deployment and Registration](#deployment-and-registration)

## Fundamental Principles

### Core Philosophy

Droid Forge droids are **self-documenting, declarative agents** that extend Factory.ai CLI capabilities through markdown specifications and shell scripting. They provide specialized functionality while maintaining consistent interface patterns.

### Key Requirements

- **Factory.ai Template Compliance**: Strict adherence to YAML frontmatter specifications
- **Manager Droid Orchestration Compatibility**: All droids must be delegatable via Manager Droid system
- **ai-dev-tasks Support**: Compatible with task generation and status tracking workflows
- **Error Resilience**: Robust failure handling with recovery mechanisms
- **Self-Contained**: Portable functionality without external dependencies

## Droid Template Structure

```
---
name: your-droid-name
description: |
  Multi-line description of droid functionality with
  use cases, capabilities, and scope limitations
model: inherit
tools: [Execute, Read, LS, Write, Grep]  # Specific tools array
version: "1.0.0"
location: project
tags: ["category", "subcategory", "capability"]  # Maximum 5 tags
---

# Main Documentation (Markdown)

## Purpose
What the droid does and why it exists.

## Capabilities
Detailed list of functions and features.

## Manager Droid Integration Examples
How to invoke through Manager Droid delegation.
```

### File Naming Convention

`.factory/droids/{droid-name}-droid-foundry.md`

- Uses lowercase
- Hyphen-separated words
- Always ends with `-droid-foundry.md`
- Maintains consistency across all extensions

## YAML Frontmatter Specifications

### Required Fields

- **name**: `your-droid-name` (kebab-case, no special characters except hyphens)
- **description**: Block-scoped multi-line description using | pipe symbol
- **model**: Always `inherit` for Factory.ai compatibility
- **tools**: Array of specific tools required (not generic "all")
- **version**: Semantic version starting at "1.0.0"
- **location**: Always `project`

### Optional but Recommended Fields

- **tags**: Array of 3-5 strings for Manager Droid capability matching

### Best Practices

```yaml
# ✅ Good Example
---
name: code-quality-analyzer
description: |
  Advanced code quality assessment tool that analyzes
  codebases for potential issues, performance bottlenecks,
  and security vulnerabilities using static analysis.
model: inherit
tools: [Execute, Read, LS, Grep, Write]
version: "1.0.1"
location: project
tags: ["quality", "analysis", "security", "performance", "code"]
---
# ❌ Avoid
---
name: UndefinedName
description: Single line description doesn't explain much.
model: random
tools: all
version: v1
location: anywhere
---
```

## Manager Droid Integration Patterns

### Basic Delegation Structure

```bash
function main_delegation_handler() {
  validate_orchestration_requirements "$@"
  execute_core_functionality "$@"
}
```

### Capability Declaration

All droids must declare capabilities for Manager Droid pattern matching:

```bash
# In droid document
## Capabilities
- pattern: "code analysis|code review|code quality"
  matcher: "code-quality-pattern"
  priority: 2

# Matching rules in droid-forge.yaml
rules:
  - pattern: "code.*quality|review.*code"
    capabilities: ["code-quality-pattern"]
    droid_types: ["code-quality-analyzer"]
    priority: high
```

### Orchestration Response Formats

Droids must provide Manager Droid-compatible status responses:

```bash
return_status() {
  local status="$1"
  local details="$2"
  local next_action="$3"

  echo "{\"status\":\"$status\",\"details\":\"$details\",\"next_action\":\"$next_action\"}"

  case "$status" in
    "success") return 0 ;;
    "error") return 1 ;;
    "partial") return 2 ;;
  esac
}
```


## Task Status Management

### Integration with ai-dev-tasks

Droids must support ai-dev-tasks format updates:

```bash
update_task_status() {
  local task_file="$1"
  local task_key="$2"  # e.g., "1.1"
  local new_status="${3:-completed}"  # pending, in_progress, completed

  # Create backup and update atomically
  local temp_file="${task_file}.tmp.$$"
  cp "$task_file" "$temp_file" || {
    rm -f "$temp_file"
    error "Failed to create backup of $task_file"
  }

  # Escape task key for regex (handle dots and special chars)
  local escaped_key
  escaped_key="$(printf '%s\n' "$task_key" | sed 's/[.[\*^$()+?{|]/\\&/g')"

  # Update status marker while preserving task description
  sed "s|^\(- \)\[\([^]]*\)\] \+\($escaped_key\b.*\)$|\1[$new_status] \3|g" "$temp_file" > "${task_file}.new" || {
    rm -f "$temp_file" "${task_file}.new"
    error "Failed to update task status in $task_file"
  }

  # Atomic move
  mv "${task_file}.new" "$task_file" || {
    mv "$temp_file" "$task_file"  # Restore backup
    error "Failed to atomically replace $task_file"
  }
  
  # Cleanup
  rm -f "$temp_file"
}
```

### Status Marker Standards

- `[ ]` - Task pending/scheduled
- `[in_progress]` - Task in progress  
- `[x]` - Task completed
- `[cancelled]` - Task aborted

## Cross-Droid Coordination

### Delegation Patterns

```bash
delegate_to_peer_droid() {
  local target_droid="$1"
  local task_parameters="$2"

  Task tool with subagent_type="$target_droid" \
    description="Coordinated operation from $(basename "$0")" \
    prompt="Execute delegated task with parameters: $task_parameters"

  local result=$?

  return $result
}
```

### Service Discovery

Droids can query available capabilities:

```bash
discover_available_droids() {
  local capability_pattern="$1"

  # Query Manager Droid for matching droids
  find_droids_by_capability "$capability_pattern"
}

find_droids_by_capability() {
  local pattern="$1"

  # Parse droid-forge.yaml for matching rules
  grep -A 5 "capabilities:\s*$pattern" droid-forge.yaml | grep "droid_types:" | cut -d: -f2 | tr -d ' '
}
```

## Error Handling Patterns

### Standardized Error Classification

```bash
classify_error_and_handle() {
  local error_context="$1"
  local error_code="$2"

  case "$error_code" in
    1)  # Invalid input
        log_user_error "Invalid input provided: $error_context"
        suggest_input_correction "$error_context"
        ;;
    2)  # Resource unavailable
        log_system_error "Required resource unavailable: $error_context"
        initiate_retry_mechanism "$error_context"
        ;;
    3)  # Permission denied
        log_security_error "Insufficient permissions: $error_context"
        escalate_permission_request "$error_context"
        ;;
    *)  # Unknown error
        log_generic_error "Unknown error ($error_code): $error_context"
        create_error_diagnostic_report "$error_context"
        ;;
  esac

  return $error_code
}
```

### Recovery Mechanisms

```bash
implement_error_recovery() {
  local recovery_strategy="$1"

  case "$recovery_strategy" in
    "retry")
        implement_exponential_backoff_retry
        ;;
    "fallback")
        switch_to_backup_execution_path
        ;;
    "rollback")
        reverse_partial_changes
        ;;
    "partial_success")
        preserve_completed_work_save_failure_state
        ;;
  esac
}
```

## Factory.ai Template Compliance

### Frontmatter Validation

```bash
validate_frontmatter_compliance() {
  local droid_file="$1"

  # Extract frontmatter
  local frontmatter=$(sed -n '/^---$/,/^---$/p' "$droid_file" | head -n -1 | tail -n +2)

  # Validate required fields
  check_required_field "name" "$frontmatter"
  check_required_field "description" "$frontmatter"
  check_required_field "model" "$frontmatter"
  check_required_field "tools" "$frontmatter"
  check_required_field "version" "$frontmatter"
  check_required_field "location" "$frontmatter"

  # Validate field values
  validate_name_format "$(extract_field_value "name" "$frontmatter")"
  validate_model_value "$(extract_field_value "model" "$frontmatter")"
  validate_tools_array "$(extract_field_value "tools" "$frontmatter")"
}
```

### Structure Validation

```bash
validate_droid_structure() {
  local droid_file="$1"

  # Check file extension
  [[ "$droid_file" == *.md ]] || error "Must use .md extension"

  # Check frontmatter delimiters (start and end)
  local delim_count
  delim_count="$(grep -n '^---$' "$droid_file" | wc -l | tr -d ' ')"
  [ "$delim_count" -ge 2 ] || error "Missing frontmatter delimiters"

  # Validate markdown structure
  has_main_heading "$droid_file"
  has_purpose_section "$droid_file"
  has_capabilities_section "$droid_file"
}
```

## Testing and Validation

### Unit Testing Framework Integration

```bash
# Unit tests for droid internals (if script functions exist)
test_droid_functions() {
  local test_function="$1"

  # Execute function with test parameters
  local result
  result="$($test_function "test_input")"

  # Validate return code and output
  [[ $? -eq 0 ]] && echo "PASS: $test_function" || echo "FAIL: $test_function - $result"
}

# Integration testing with Manager Droid
test_manager_droid_delegation() {
  local test_droid="$1"
  local test_prompt="$2"

  # Test delegation path
  if Task tool with subagent_type="$test_droid" description="Test invocation" prompt="$test_prompt"; then
    echo "PASS: Manager Droid delegation to $test_droid"
  else
    echo "FAIL: Manager Droid delegation failed for $test_droid"
  fi
}
```

### Validation Checklist

- [ ] Frontmatter fields complete and compliant
- [ ] Markdown structure follows template
- [ ] Manager Droid delegation syntax correct
- [ ] Error handling patterns implemented
- [ ] Cross-droid coordination capabilities included
- [ ] Task status management integrated
- [ ] Testing hooks available for validation

## Deployment and Registration

### Adding New Droid to Framework

1. **Create Droid File**

   ```bash
   .factory/droids/new-droid-name-droid-foundry.md
   ```

2. **Register Capabilities in Config**

   ```yaml
   # droid-forge.yaml
   rules:
     - pattern: "your|capability|matches"
       capabilities: ["your-capability"]
       droid_types: ["new-droid-name-droid-foundry"]
       priority: 9
   ```

3. **Validate Integration**

   ```bash
   # Test Manager Droid delegation
   factory-cli "test delegation to new droid"
   ```

4. **Update Documentation**
   - Add to README.md droid portfolio
   - Update usage examples
   - Register in capability matrix

5. **Version and Release**

   ```bash
   # Update version
   git tag v1.1.x -m "Add new droid capabilities"

   # Push changes
   git push origin main --tags
   ```

## Quick Reference

### Template Checklist

- [ ] YAML frontmatter complete and valid
- [ ] Description uses block format (|)
- [ ] Tools array specific (not generic "all")
- [ ] Cross-droid coordination patterns
- [ ] Error handling and recovery
- [ ] Testing hooks included

### Common Patterns

- **Status updates**: Use ai-dev-tasks markdown markers consistently
- **Error conditions**: Implement retry/fallback mechanisms
- **Manager Droid delegation**: Use Task tool syntax exactly
- **File paths**: Use relative paths from project root

This guide ensures all Droid Forge droids maintain high quality, consistent interfaces, and reliable orchestration within the ecosystem.
