#!/bin/bash
# Tests for one-shot executor

source tools/execution-context.sh
source tools/one-shot-executor.sh

# Create test task file
cat > /tmp/test-tasks.md << 'EOF'
## Tasks

- [ ] 1.0 Test Major Task
  - [ ] 1.1 First sub-task
  - [ ] 1.2 Second sub-task
  - [ ] 1.3 Third sub-task
EOF

echo "Testing One-Shot Executor"
echo "========================="

# Test 1: Reject execution if not in one-shot mode
set_execution_mode "false"
if run_one_shot_workflow "/tmp/test-tasks.md" 2>&1 | grep -q "Not in one-shot mode"; then
  echo "✅ PASS: Rejects execution in iterative mode"
else
  echo "❌ FAIL: Should reject execution in iterative mode"
fi

# Test 2: Update task status
update_task_status "/tmp/test-tasks.md" "1.1" "completed"
if grep -q "\[x\] 1.1" "/tmp/test-tasks.md"; then
  echo "✅ PASS: Task status updated to completed"
else
  echo "❌ FAIL: Task status not updated"
fi

# Test 3: Execute sub-task
execute_sub_task_one_shot "/tmp/test-tasks.md" "1.2" > /dev/null
if grep -q "\[x\] 1.2" "/tmp/test-tasks.md"; then
  echo "✅ PASS: Sub-task executed and marked complete"
else
  echo "❌ FAIL: Sub-task not executed properly"
fi

echo ""
echo "Tests completed"
