#!/bin/bash
# Integration and E2E test execution (Tasks 2.4-2.7)
source tools/test-automation.sh

function run_major_task_tests() {
  local major_task_id="$1"
  
  # Generate and run integration tests
  local int_test=$(generate_integration_tests "$major_task_id")
  run_integration_tests "$int_test" || return 1
  
  # Generate and run E2E tests
  local e2e_test=$(generate_e2e_tests "task-$major_task_id")
  run_e2e_tests "$e2e_test" || return 1
  
  return 0
}

export -f run_major_task_tests
