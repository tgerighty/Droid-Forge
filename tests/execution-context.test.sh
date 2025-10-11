#!/bin/bash
# Unit tests for execution context management

source tools/execution-context.sh

TEST_COUNT=0
PASS_COUNT=0

assert_equals() {
  TEST_COUNT=$((TEST_COUNT + 1))
  if [ "$1" == "$2" ]; then
    echo "✅ PASS: $3"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo "❌ FAIL: $3 (expected: $1, got: $2)"
  fi
}

echo "Testing Execution Context Management"
echo "====================================="

# Clean start
clear_execution_context

# Test 1: Default mode
result=$(get_execution_mode)
assert_equals "false" "$result" "Default mode is iterative"

# Test 2: Set one-shot mode
set_execution_mode "true"
result=$(get_execution_mode)
assert_equals "true" "$result" "Set one-shot mode"

# Test 3: Set iterative mode
set_execution_mode "false"
result=$(get_execution_mode)
assert_equals "false" "$result" "Set iterative mode"

# Test 4: is_one_shot_mode check
set_execution_mode "true"
if is_one_shot_mode; then
  assert_equals "true" "true" "is_one_shot_mode returns true"
else
  assert_equals "true" "false" "is_one_shot_mode returns true"
fi

# Test 5: Context file creation
set_execution_mode "true"
if [ -f ".droid-forge/context/execution-mode.env" ]; then
  assert_equals "true" "true" "Context file created"
else
  assert_equals "true" "false" "Context file created"
fi

# Test 6: Load context
set_execution_mode "true"
unset ONE_SHOT_MODE
load_execution_context
assert_equals "true" "$ONE_SHOT_MODE" "Load context sets environment variable"

echo ""
echo "Results: $PASS_COUNT/$TEST_COUNT tests passed"
[ $PASS_COUNT -eq $TEST_COUNT ] && exit 0 || exit 1
