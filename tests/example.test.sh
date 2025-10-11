#!/bin/bash
# Unit tests for tools/example.sh

source "tools/example.sh"

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

# Add test cases here
echo "Testing example.sh"
echo "================================"

# Test 1: Basic functionality
assert_equals "expected" "actual" "Test description"

echo ""
echo "Results: $PASS_COUNT/$TEST_COUNT tests passed"
[ $PASS_COUNT -eq $TEST_COUNT ] && exit 0 || exit 1
