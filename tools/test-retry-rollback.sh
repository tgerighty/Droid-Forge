#!/bin/bash
# Test retry and rollback mechanism (Tasks 2.8-2.9)

MAX_RETRIES=3

function execute_with_retry_rollback() {
  local task_id="$1"
  local attempt=1
  
  while [ $attempt -le $MAX_RETRIES ]; do
    if execute_task "$task_id"; then
      return 0
    fi
    
    echo "Attempt $attempt failed, rolling back..."
    git reset --hard HEAD~1 2>/dev/null
    attempt=$((attempt + 1))
  done
  
  echo "Failed after $MAX_RETRIES attempts"
  return 1
}

export -f execute_with_retry_rollback
