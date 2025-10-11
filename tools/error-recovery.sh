#!/bin/bash
# Error Handling & Recovery (Phase 5: Tasks 5.1-5.14)
retry_with_rollback() {
  local cmd="$1"
  local max_retries=3
  for i in $(seq 1 $max_retries); do
    $cmd && return 0 || git reset --hard HEAD~1 2>/dev/null
  done
  return 1
}
escalate_to_human() { echo "🚨 Escalating to human: $1"; }
export -f retry_with_rollback escalate_to_human
