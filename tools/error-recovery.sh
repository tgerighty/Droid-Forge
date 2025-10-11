#!/bin/bash
# Error Handling & Recovery (Phase 5: Tasks 5.1-5.14)

retry_with_rollback() {
  local max_retries=3
  local attempt=1
  
  # Validate we're in a git repository before attempting rollback
  if [ ! -d .git ]; then
    echo "❌ ERROR: Not in a git repository, cannot rollback"
    return 1
  fi
  
  while [ $attempt -le $max_retries ]; do
    # Execute command with all arguments properly quoted
    if "$@"; then
      return 0
    else
      echo "⚠️  Attempt $attempt failed, rolling back..."
      
      # Only rollback if there are uncommitted changes or recent commit
      if [ -n "$(git status --porcelain)" ] || [ -n "$(git log -1 --pretty=format:%H 2>/dev/null)" ]; then
        git reset --hard HEAD~1 2>/dev/null || true
      fi
      
      attempt=$((attempt + 1))
      sleep 2  # Brief pause between retries
    fi
  done
  
  echo "❌ Failed after $max_retries attempts"
  return 1
}

escalate_to_human() { 
  echo "🚨 Escalating to human: $1"
  # In the future, this could trigger notifications
}

export -f retry_with_rollback escalate_to_human
