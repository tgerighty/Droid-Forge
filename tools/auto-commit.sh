#!/bin/bash
# Auto-commit utility for one-shot mode

# Commit after sub-task completion
function auto_commit_subtask() {
  local task_id="$1"
  local task_desc="$2"
  local files_changed="$3"
  
  # Generate commit message
  local commit_msg="feat(task-$task_id): $task_desc

Automated commit for sub-task $task_id in one-shot mode

Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>"
  
  # Stage files
  git add $files_changed
  
  # Commit
  git commit -m "$commit_msg"
  
  return $?
}

export -f auto_commit_subtask
