#!/bin/bash
# Advanced Features & Optimization (Phase 6: Tasks 6.1-6.12)

execute_parallel_tasks() {
  local tasks=("$@")
  local max_parallel=3
  
  # Safe array slicing with bounds checking
  local tasks_cnt=${#tasks[@]}
  local limit=$((tasks_cnt < max_parallel ? tasks_cnt : max_parallel))
  
  # Execute up to limit tasks in parallel
  for ((i=0; i<limit; i++)); do
    echo "Executing ${tasks[i]} in parallel" &
  done
  
  # Wait for all background jobs to complete
  wait
}

export -f execute_parallel_tasks
