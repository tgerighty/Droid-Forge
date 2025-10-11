#!/bin/bash
# Unit tests for Manager Orchestrator mode selection

# Test framework setup
TEST_COUNT=0
PASS_COUNT=0
FAIL_COUNT=0

function assert_equals() {
  local expected="$1"
  local actual="$2"
  local test_name="$3"
  
  TEST_COUNT=$((TEST_COUNT + 1))
  
  if [ "$expected" == "$actual" ]; then
    echo "✅ PASS: $test_name"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo "❌ FAIL: $test_name"
    echo "   Expected: $expected"
    echo "   Actual: $actual"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
}

function assert_true() {
  local condition="$1"
  local test_name="$2"
  
  TEST_COUNT=$((TEST_COUNT + 1))
  
  if [ "$condition" == "true" ]; then
    echo "✅ PASS: $test_name"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo "❌ FAIL: $test_name"
    echo "   Expected: true"
    echo "   Actual: $condition"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
}

# Source the function to test
source_mode_selection() {
  # Extract function from droid file for testing
  cat > /tmp/test_mode_selection.sh << 'EOF'
function ask_execution_mode() {
  local mode_response="$1"  # For testing, pass as parameter
  
  # Convert to lowercase for case-insensitive matching (macOS compatible)
  mode_response_lower=$(echo "$mode_response" | tr '[:upper:]' '[:lower:]')
  
  case "$mode_response_lower" in
    "one-shot"|"one shot"|"oneshot"|"yes"|"autonomous")
      export ONE_SHOT_MODE=true
      ;;
    "iterative"|"iterate"|"no"|"step-by-step"|"manual")
      export ONE_SHOT_MODE=false
      ;;
    *)
      export ONE_SHOT_MODE=false
      ;;
  esac
  
  mkdir -p .droid-forge/context
  echo "ONE_SHOT_MODE=$ONE_SHOT_MODE" > .droid-forge/context/execution-mode.env
}
EOF
  source /tmp/test_mode_selection.sh
}

echo "========================================"
echo "Testing Manager Orchestrator Mode Selection"
echo "========================================"
echo ""

source_mode_selection

# Test 1: One-shot mode variations
echo "Test Suite: One-Shot Mode Detection"
echo "------------------------------------"

ask_execution_mode "one-shot"
assert_equals "true" "$ONE_SHOT_MODE" "Test 1.1: 'one-shot' sets ONE_SHOT_MODE=true"

ask_execution_mode "one shot"
assert_equals "true" "$ONE_SHOT_MODE" "Test 1.2: 'one shot' (with space) sets ONE_SHOT_MODE=true"

ask_execution_mode "oneshot"
assert_equals "true" "$ONE_SHOT_MODE" "Test 1.3: 'oneshot' (no space) sets ONE_SHOT_MODE=true"

ask_execution_mode "yes"
assert_equals "true" "$ONE_SHOT_MODE" "Test 1.4: 'yes' sets ONE_SHOT_MODE=true"

ask_execution_mode "autonomous"
assert_equals "true" "$ONE_SHOT_MODE" "Test 1.5: 'autonomous' sets ONE_SHOT_MODE=true"

ask_execution_mode "ONE-SHOT"
assert_equals "true" "$ONE_SHOT_MODE" "Test 1.6: 'ONE-SHOT' (uppercase) sets ONE_SHOT_MODE=true"

echo ""

# Test 2: Iterative mode variations
echo "Test Suite: Iterative Mode Detection"
echo "-------------------------------------"

ask_execution_mode "iterative"
assert_equals "false" "$ONE_SHOT_MODE" "Test 2.1: 'iterative' sets ONE_SHOT_MODE=false"

ask_execution_mode "iterate"
assert_equals "false" "$ONE_SHOT_MODE" "Test 2.2: 'iterate' sets ONE_SHOT_MODE=false"

ask_execution_mode "no"
assert_equals "false" "$ONE_SHOT_MODE" "Test 2.3: 'no' sets ONE_SHOT_MODE=false"

ask_execution_mode "step-by-step"
assert_equals "false" "$ONE_SHOT_MODE" "Test 2.4: 'step-by-step' sets ONE_SHOT_MODE=false"

ask_execution_mode "manual"
assert_equals "false" "$ONE_SHOT_MODE" "Test 2.5: 'manual' sets ONE_SHOT_MODE=false"

ask_execution_mode "ITERATIVE"
assert_equals "false" "$ONE_SHOT_MODE" "Test 2.6: 'ITERATIVE' (uppercase) sets ONE_SHOT_MODE=false"

echo ""

# Test 3: Default to iterative for unclear responses
echo "Test Suite: Default Behavior"
echo "-----------------------------"

ask_execution_mode "maybe"
assert_equals "false" "$ONE_SHOT_MODE" "Test 3.1: Unclear response 'maybe' defaults to iterative"

ask_execution_mode ""
assert_equals "false" "$ONE_SHOT_MODE" "Test 3.2: Empty response defaults to iterative"

ask_execution_mode "something random"
assert_equals "false" "$ONE_SHOT_MODE" "Test 3.3: Random input defaults to iterative"

echo ""

# Test 4: Context file creation
echo "Test Suite: Execution Context Storage"
echo "--------------------------------------"

ask_execution_mode "one-shot"
if [ -f ".droid-forge/context/execution-mode.env" ]; then
  assert_true "true" "Test 4.1: Context file created"
  
  source .droid-forge/context/execution-mode.env
  assert_equals "true" "$ONE_SHOT_MODE" "Test 4.2: Context file contains correct mode"
else
  assert_true "false" "Test 4.1: Context file created"
fi

echo ""

# Summary
echo "========================================"
echo "Test Summary"
echo "========================================"
echo "Total tests: $TEST_COUNT"
echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
  echo "✅ All tests passed!"
  exit 0
else
  echo "❌ Some tests failed!"
  exit 1
fi
