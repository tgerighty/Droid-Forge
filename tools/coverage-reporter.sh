#!/bin/bash
# Code coverage reporting (Tasks 2.10-2.11)

# Get script directory for reliable sourcing
SCRIPT_DIR=
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source dependencies
source "$SCRIPT_DIR/test-automation.sh" 2>/dev/null || true

function generate_coverage_report() {
  # Split declare/assign to avoid SC2155
  local coverage
  coverage=$(calculate_coverage "tools")
  
  echo "========================================" 
  echo "Code Coverage Report"
  echo "========================================"
  echo "Coverage: ${coverage}%"
  echo "Threshold: ${COVERAGE_THRESHOLD}%"
  
  if check_coverage_threshold "$coverage"; then
    echo "Status: ✅ PASS"
    return 0
  else
    echo "Status: ❌ FAIL - Below threshold"
    return 1
  fi
}

export -f generate_coverage_report
