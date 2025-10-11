#!/bin/bash
# Auto-push utility for one-shot mode

# Push immediately after commit
function auto_push() {
  git push
  return $?
}

export -f auto_push
