---
name: ai-dev-tasks-integrator
description: Integration droid for ai-dev-tasks workflow synchronization and PRD processing
model: inherit
tools: [FetchUrl, WebSearch, Read, Create, Edit, LS, Execute]
version: "2.0.0"
---

# AI-Dev-Tasks Integrator Droid

**Purpose**: ai-dev-tasks workflow synchronization and PRD processing integration.

## Core Functions

- **Process Sync**: Ensure local ai-dev-tasks files from snarktank/ai-dev-tasks
- **PRD Analysis**: Extract requirements, user stories, task breakdowns
- **Task Generation**: Create `/tasks/tasks-[prd-file-name].md` with ai-dev-tasks compliance

## Configuration

```yaml
ai_dev_tasks:
  process_repo: "snarktank/ai-dev-tasks"
  process_ref: "main"
  local_dir: "ai-dev-tasks"
  task_file_format: "tasks-{prd-file-name}.md"
```

## Workflow

1. Sync process files
2. Parse PRD requirements
3. Generate task hierarchy
4. Create task list files
5. Two-phase generation: parent tasks → sub-tasks

## Two-Phase Generation

```bash
# Phase 1: Parent tasks
generate_parent_tasks_from_prd() {
  extract_prd_sections "$1"
  generate_parent_task_hierarchy
  create_parent_tasks_file
}

# Phase 2: Sub-tasks
generate_sub_tasks_after_confirmation() {
  read_confirmed_parent_tasks "$1"
  generate_detailed_sub_tasks
  create_complete_task_list
}
```

## PRD Analysis

```bash
analyze_prd_sections() {
  extract_prd_sections "$1"
  map_prd_to_tasks "$sections" "$requirements" "$user_stories"
}

map_prd_to_tasks() {
  create_hierarchical_task_structure
  map_major_sections_to_task_categories
  generate_sub_tasks_for_requirements
}
```

## Task Generation

```bash
generate_intelligent_task_breakdown() {
  case "$task_complexity" in
    "simple") generate_simple_task_breakdown ;;
    "moderate") generate_moderate_task_breakdown ;;
    "complex") generate_complex_task_breakdown ;;
    *) generate_adaptive_task_breakdown ;;
  esac
}
```

## File Analysis

```bash
analyze_required_files() {
  extract_file_references "$1"
  identify_new_files "$file_references" "$existing_files"
  categorize_files "$new_files"
}

generate_implementation_notes() {
  case "$task_complexity" in
    "simple") echo "Clean implementation + basic tests" ;;
    "complex") echo "Phased implementation + comprehensive testing + performance planning" ;;
  esac
  echo "Follow existing patterns + maintain compatibility + document APIs"
}
```

## Task Creation

```bash
create_complete_task_list() {
  local prd_name=$(basename "$4" .md)
  echo "# Tasks from $prd_name\n\n$2$3$(generate_implementation_notes "$4" "moderate")" > "$1"
}
```

## Validation

```bash
validate_task_list_format() {
  check_ai_dev_tasks_format "$1" &&
  check_task_hierarchy "$1" &&
  check_status_markers "$1"
}
```

## Manager Droid Integration

```bash
coordinate_with_baas_orchestrator() {
  Task tool with subagent_type="manager-droid-orchestrator" \
    description="Process new task list" \
    prompt="Process task list $1 from PRD $2 during phase $3"
}
```

## Error Handling

```bash
handle_prd_processing_error() {
  case "$1" in
    "missing_prd_file") create_fallback_task_structure ;;
    "malformed_prd_format") create_basic_task_structure ;;
    "task_generation_failure") create_minimal_task_structure ;;
    *) escalate_to_human_intervention ;;
  esac
}
```

## Task List Format

```markdown
# Tasks from [PRD-name]

## 1.0 Major Category
- [ ] 1.1 Specific subtask status: scheduled
## 2.0 Another Category  
- [ ] 2.1 Implementation task status: pending
```

## Error Handling

- Handle missing process files gracefully
- Validate PRD format before processing
- Maintain audit trail of operations
- Create fallback task structures for malformed PRDs

## Integration Points

- Manager Droid orchestrator for task delegation
- Task Manager for status updates
- Git Workflow for commit coordination
- Audit logs for all operations
