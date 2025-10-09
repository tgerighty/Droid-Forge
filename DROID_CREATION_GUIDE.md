# Droid Forge Droid Creation Guide v1.0

## Overview

This guide provides comprehensive instructions for creating new droids within the Droid Forge framework. It codifies all established patterns, best practices, configuration standards, logging requirements, and orchestration rules developed through v1.0-v1.1 framework evolution.

## Table of Contents

1. [Fundamental Principles](#fundamental-principles)
2. [Droid Template Structure](#droid-template-structure)
3. [YAML Frontmatter Specifications](#yaml-frontmatter-specifications)
4. [BAAS Integration Patterns](#baas-integration-patterns)
5. [Audit Trail and Logging Standards](#audit-trail-and-logging-standards)
6. [Task Status Management](#task-status-management)
7. [Cross-Droid Coordination](#cross-droid-coordination)
8. [Error Handling Patterns](#error-handling-patterns)
9. [Factory.ai Template Compliance](#factoryai-template-compliance)
10. [Testing and Validation](#testing-and-validation)
11. [Deployment and Registration](#deployment-and-registration)

## Fundamental Principles

### Core Philosophy

Droid Forge droids are **self-documenting, declarative agents** that extend Factory.ai CLI capabilities through markdown specifications and shell scripting. They provide specialized functionality while maintaining consistent interface patterns.

### Key Requirements

- **Factory.ai Template Compliance**: Strict adherence to YAML frontmatter specifications
- **BAAS Orchestration Compatibility**: All droids must be delegatable via BAAS system
- **Audit Trail Integration**: Every operation must log to .droid-forge/logs/events.ndjson
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

## BAAS Integration Examples
How to invoke through BAAS delegation.

## Audit Trail Recording
What events are logged.
```

### File Naming Convention

`.factory/droids/{droid-name}-droid-forge.md`

- Uses lowercase
- Hyphen-separated words
- Always ends with `-droid-forge.md`
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

- **tags**: Array of 3-5 strings for BAAS capability matching

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

## BAAS Integration Patterns

### Basic Delegation Structure

```bash
function main_delegation_handler() {
  validate_orchestration_requirements "$@"
  initialize_audit_session "$@"
  execute_core_functionality "$@"
  finalize_audit_session "$@"
}
```

### Capability Declaration

All droids must declare capabilities for BAAS pattern matching:

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

Droids must provide BAAS-compatible status responses:

```bash
return_baas_status() {
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

## Audit Trail and Logging Standards

### Event Structure

All droid operations must emit NDJSON events:

```json
{"timestamp":"2024-10-09T08:00:00Z","event":"droid.operation.started","project":"my-project","task_id":"1.1","droid":"my-droid-name","session_id":"sess-123"}
{"timestamp":"2024-10-09T08:01:00Z","event":"droid.operation.completed","project":"my-project","success":true,"output_summary":"analysis complete","session_id":"sess-123"}
```

### Standard Event Types

```bash
emit_droid_start() {
  emit_event "droid.operation.started" '{"phase":"initialization","request_id":"'$REQUEST_ID'"}'
}

emit_droid_progress() {
  emit_event "droid.operation.progress" '{"progress_percent":'$PROGRESS',"current_task":"'$CURRENT_TASK'"}'
}

emit_droid_completion() {
  emit_event "droid.operation.completed" '{"success":'$SUCCESS',"results_count":'$RESULTS_COUNT'}'
}

emit_droid_error() {
  emit_event "droid.operation.error" '{"error_type":"'$ERROR_TYPE'","error_message":"'$ERROR_MESSAGE'"}'
}
```

### Utility Functions

```bash
emit_event() {
  local event_type="$1"
  local event_data="$2"
  local session_id="${3:-${REQUEST_ID:-default}}"

  cat << EVENT_EOF >> .droid-forge/logs/events.ndjson
{"timestamp":"$(date --utc +%Y-%m-%dT%H:%M:%SZ)","event":"$event_type","project":"${PROJECT:-unknown}","session_id":"$session_id",${event_data:+$event_data}}
EVENT_EOF
}
```

## Task Status Management

### Integration with ai-dev-tasks

Droids must support ai-dev-tasks format updates:

```bash
update_task_status() {
  local task_file="$1"
  local task_key="$2"  # e.g., "1.1"
  local new_status="${3:-completed}"  # pending, started, completed

  # Safely update status marker in markdown
  sed -i.tmp "s|\- \[.\] \+$task_key|- [$new_status] $task_key|g" "$task_file"

  # Log task status change
  emit_event "task.status.updated" "\"task_key\":\"$task_key\",\"new_status\":\"$new_status\",\"task_file\":\"$task_file\""
}
```

### Status Marker Standards

- `[ ]` - Task pending/scheduled
- `[~]` or `[ ]` - Task in progress
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

  emit_event "droid.coordination.completed" "\"target_droid\":\"$target_droid\",\"result_code\":$result"

  return $result
}
```

### Service Discovery

Droids can query available capabilities:

```bash
discover_available_droids() {
  local capability_pattern="$1"

  # Query BAAS for matching droids
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

  # Check frontmatter delimiters
  grep -q "^---$" "$droid_file" || error "Missing frontmatter start delimiter"
  grep -q "^---$" "$droid_file" || error "Missing frontmatter end delimiter"

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

# Integration testing with BAAS
test_baas_delegation() {
  local test_droid="$1"
  local test_prompt="$2"

  # Test delegation path
  if Task tool with subagent_type="$test_droid" description="Test invocation" prompt="$test_prompt"; then
    echo "PASS: BAAS delegation to $test_droid"
  else
    echo "FAIL: BAAS delegation failed for $test_droid"
  fi
}
```

### Validation Checklist

- [ ] Frontmatter fields complete and compliant
- [ ] Markdown structure follows template
- [ ] BAAS delegation syntax correct
- [ ] Audit trail events properly formatted
- [ ] Error handling patterns implemented
- [ ] Cross-droid coordination capabilities included
- [ ] Task status management integrated
- [ ] Testing hooks available for validation

## Deployment and Registration

### Adding New Droid to Framework

1. **Create Droid File**

   ```bash
   .factory/droids/new-droid-name-droid-forge.md
   ```

2. **Register Capabilities in Config**

   ```yaml
   # droid-forge.yaml
   rules:
     - pattern: "your|capability|matches"
       capabilities: ["your-capability"]
       droid_types: ["new-droid-name-droid-forge"]
       priority: 9
   ```

3. **Validate Integration**

   ```bash
   # Test BAAS delegation
   factory-cli "test delegation to new droid"

   # Check audit trail
   tail -f .droid-forge/logs/events.ndjson | grep "new-droid"
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
- [ ] Proper auditing implementation
- [ ] Cross-droid coordination patterns
- [ ] Error handling and recovery
- [ ] Testing hooks included

### Common Patterns

- **Event logging**: Always use NDJSON format with timestamp
- **Status updates**: Use ai-dev-tasks markdown markers consistently
- **Error conditions**: Implement retry/fallback mechanisms
- **BAAS delegation**: Use Task tool syntax exactly
- **File paths**: Use relative paths from project root

This guide ensures all Droid Forge droids maintain high quality, consistent interfaces, and reliable orchestration within the ecosystem.
