#!/bin/bash
# Execution Context Manager
# Manages execution mode and context sharing across droids

CONTEXT_DIR=".droid-forge/context"
MODE_FILE="$CONTEXT_DIR/execution-mode.env"

# Initialize context directory
function init_context() {
  mkdir -p "$CONTEXT_DIR"
}

# Get current execution mode
function get_execution_mode() {
  if [ -f "$MODE_FILE" ]; then
    # Parse safely without executing arbitrary code
    local mode_value
    mode_value=$(grep '^ONE_SHOT_MODE=' "$MODE_FILE" | cut -d'=' -f2 | tr -d '"\047')
    echo "${mode_value:-false}"
  else
    echo "false"  # Default to iterative
  fi
}

# Set execution mode
function set_execution_mode() {
  local mode="$1"
  init_context
  echo "ONE_SHOT_MODE=$mode" > "$MODE_FILE"
  export ONE_SHOT_MODE="$mode"
}

# Check if in one-shot mode
function is_one_shot_mode() {
  local mode
  mode=$(get_execution_mode)
  [ "$mode" = "true" ]
}

# Load execution context for droids
function load_execution_context() {
  if [ -f "$MODE_FILE" ]; then
    # Parse safely without executing arbitrary code
    local mode_value
    mode_value=$(grep '^ONE_SHOT_MODE=' "$MODE_FILE" | cut -d'=' -f2 | tr -d '"\047')
    export ONE_SHOT_MODE="${mode_value:-false}"
  else
    export ONE_SHOT_MODE=false
  fi
}

# Clear execution context
function clear_execution_context() {
  rm -f "$MODE_FILE"
}

# Export functions for use by other scripts
export -f init_context
export -f get_execution_mode
export -f set_execution_mode
export -f is_one_shot_mode
export -f load_execution_context
export -f clear_execution_context
