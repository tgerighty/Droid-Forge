#!/bin/bash
# Execution logger for one-shot mode

LOG_DIR=".droid-forge/logs"
LOG_FILE="$LOG_DIR/execution-$(date +%Y%m%d-%H%M%S).log"

# Initialize logging
function init_logging() {
  mkdir -p "$LOG_DIR"
  touch "$LOG_FILE"
}

# Log message
function log_message() {
  local level="$1"
  local message="$2"
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  
  echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# Log info
function log_info() {
  log_message "INFO" "$1"
}

# Log error
function log_error() {
  log_message "ERROR" "$1"
}

# Log warning
function log_warn() {
  log_message "WARN" "$1"
}

export -f init_logging
export -f log_message
export -f log_info
export -f log_error
export -f log_warn
