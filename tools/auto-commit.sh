#!/bin/bash
set -euo pipefail

# Auto-commit utility for one-shot mode

# Commit after sub-task completion
function auto_commit_subtask() {
  local task_id="$1"
  local task_desc="$2"
  shift 2
  local files_changed=("$@")
  
  # Generate commit message with separate title and body
  local title="feat(task-$task_id): $task_desc"
  local body="Automated commit for sub-task $task_id in one-shot mode

Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>"
  
  # Stage files safely (handle spaces and special characters)
  if [ ${#files_changed[@]} -eq 0 ]; then
    echo "⚠️  Warning: No files specified for commit"
    git add -A
  else
    for file in "${files_changed[@]}"; do
      git add "$file"
    done
  fi
  
  # Commit with structured message
  git commit -m "$title" -m "$body"
  
  return $?
}

export -f auto_commit_subtask
