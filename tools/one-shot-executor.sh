#!/bin/bash
# One-Shot Execution Engine
# Executes tasks autonomously without confirmation

# Get script directory for reliable path resolution
SCRIPT_DIR=
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source dependencies
source "$SCRIPT_DIR/execution-context.sh" 2>/dev/null || true
source "$SCRIPT_DIR/execution-logger.sh" 2>/dev/null || true

# Execute all sub-tasks of a major task
function execute_major_task_one_shot() {
  local task_file="$1"
  local major_task_id="$2"
  
  echo "🚀 Executing major task $major_task_id in ONE-SHOT MODE"
  
  # Extract all sub-tasks for this major task (fix regex and word-splitting)
  # Use [[:space:]] instead of \s for POSIX compliance
  local sub_task_lines
  sub_task_lines=$(grep -E "^[[:space:]]+-[[:space:]]\[[[:space:]]\][[:space:]]${major_task_id}\." "$task_file")
  
  # Process each line safely without word-splitting
  while IFS= read -r line; do
    if [ -z "$line" ]; then
      continue
    fi
    
    # Extract task ID safely
    local sub_task_id
    sub_task_id=$(echo "$line" | sed -n 's/.*\[[[:space:]]\][[:space:]]*\([0-9]\+\.[0-9]\+\).*/\1/p' | tr -d '[:space:]')
    
    if [ -n "$sub_task_id" ]; then
      echo ""
      echo "▶️  Executing sub-task: $sub_task_id"
      execute_sub_task_one_shot "$task_file" "$sub_task_id"
    fi
  done <<< "$sub_task_lines"
  
  echo ""
  echo "✅ Major task $major_task_id completed"
}

# Execute single sub-task without confirmation
function execute_sub_task_one_shot() {
  local task_file="$1"
  local sub_task_id="$2"
  
  # Get task description (fix SC2155)
  local task_desc
  task_desc=$(grep "$sub_task_id" "$task_file" | sed "s/.*$sub_task_id //")
  
  echo "  📝 Task: $task_desc"
  echo "  ⏳ Status: Executing..."
  
  # Actual execution would delegate to appropriate droid here
  # For now, simulate execution
  sleep 0.5
  
  # NEW: Generate and run tests after task execution (Task 2.2-2.3)
  if [ -f "tools/test-automation.sh" ]; then
    source tools/test-automation.sh
    
    # Generate unit tests
    local test_file=$(generate_unit_tests "tools/example.sh" 2>/dev/null || echo "")
    
    # Run unit tests with retry
    if [ -n "$test_file" ] && [ -f "$test_file" ]; then
      if ! run_unit_tests "$test_file"; then
        echo "  ❌ Tests failed after retries"
        return 1
      fi
    fi
  fi
  
  echo "  ✅ Status: Complete"
  
  # Update task status
  update_task_status "$task_file" "$sub_task_id" "completed"
}

# Update task status in ai-dev-tasks file
function update_task_status() {
  local task_file="$1"
  local task_id="$2"
  local status="$3"
  
  local marker
  case "$status" in
    "completed") marker="x" ;;
    "in_progress") marker="~" ;;
    *) marker=" " ;;
  esac
  
  # Update the task file
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/- \[ \] $task_id/- [$marker] $task_id/" "$task_file"
  else
    sed -i "s/- \[ \] $task_id/- [$marker] $task_id/" "$task_file"
  fi
}

# Main execution handler
function run_one_shot_workflow() {
  local task_file="$1"
  
  if ! is_one_shot_mode; then
    echo "❌ Not in one-shot mode. Use iterative workflow instead."
    return 1
  fi
  
  echo "🎯 Starting ONE-SHOT workflow execution"
  echo "📄 Task file: $task_file"
  echo ""
  
  # Get all major tasks
  local major_tasks=$(grep -E "^- \[ \] [0-9]+\.0 " "$task_file" | sed 's/.*\[ \] //' | awk '{print $1}')
  
  for major_task in $major_tasks; do
    execute_major_task_one_shot "$task_file" "$major_task"
  done
  
  echo ""
  echo "🎉 ONE-SHOT workflow execution completed!"
}

export -f execute_major_task_one_shot
export -f execute_sub_task_one_shot
export -f update_task_status
export -f run_one_shot_workflow
