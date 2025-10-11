#!/bin/bash
# Code coverage reporting (Tasks 2.10-2.11)
source tools/test-automation.sh

function generate_coverage_report() {
  local coverage=$(calculate_coverage "tools")
  
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
