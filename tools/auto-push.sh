#!/bin/bash
set -euo pipefail

# Auto-push utility for one-shot mode

# Push immediately after commit
# Usage: auto_push [remote] [refspec]
# If no args provided, pushes to default remote/branch
function auto_push() {
  local remote="${1:-}"
  local refspec="${2:-}"
  
  if [ -n "$remote" ] && [ -n "$refspec" ]; then
    git push "$remote" "$refspec"
  elif [ -n "$remote" ]; then
    git push "$remote"
  else
    git push
  fi
  
  return $?
}

export -f auto_push
