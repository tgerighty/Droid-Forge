#!/bin/bash

echo "🔢 Droid Forge Token Count"
echo "============================="

# Count files and total size
FILE_COUNT=$(find /Users/terry.gerighty/Library/Mobile\ Documents/com~Apple~CloudDocs/Documents/nxio.ai/tools/droid-forge/.factory/droids -name "*.md" | wc -l)
TOTAL_SIZE=$(find /Users/terry.gerighty/Library/Mobile\ Documents/com~Apple~CloudDocs/Documents/nxio.ai/tools/droid-forge/.factory/droids -name "*.md" -exec du -bc | awk '{sum+=$1} END {print sum}')

# Estimate tokens (1 token ≈ 4 characters)
TOTAL_TOKENS=$((TOTAL_SIZE / 4))

echo ""
echo "📊 RESULTS"
echo "============================"
echo "📁 Total Droids: $FILE_COUNT"
echo "💾 Total Size: $(($TOTAL_SIZE + 1023) / 1024) MB"
echo "🔤 Total Tokens: $TOTAL_TOKENS"
echo ""

echo "📈 PROJECT ANALYSIS"
echo "============================"
if [ "$FILE_COUNT" -eq 52 ]; then
  echo "✅ All 52 droids accounted for"
else
  echo "⚠️ Expected 52 files, found $FILE_COUNT"
fi

echo ""
echo "📈 PERFORMANCE METRICS"
echo "============================"
echo "🚀 Context Window Efficiency:"
ORIGINAL_TOKENS=139239
CURRENT_TOKENS=$TOTAL_TOKENS
echo "• Before: $ORIGINAL_TOKENS tokens (28% of 500K context window)"
echo "• After: $CURRENT_TOKENS tokens ($(($CURRENT_TOKENS * 100 / 500000))% of context window)"

if [ "$CURRENT_TOKENS" -gt 0 ]; then
  SAVINGS=$((ORIGINAL_TOKENS - CURRENT_TOKENS))
  REDUCTION=$((SAVINGS * 100 / ORIGINAL_TOKENS))
  
  echo "💾 Tokens Saved: $SAVINGS tokens"
  echo "📈 Reduction: $REDUCTION%"
else
  echo "⚠️ Error: Token calculation failed"
fi
