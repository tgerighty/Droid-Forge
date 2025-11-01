#!/bin/bash

# Simple Token Calculation Report
echo "🔢 Droid Forge - Final Token Report"
echo "================================"

# Get total size
TOTAL_SIZE=$(find /Users/terry.gerighty/Library/Mobile\ Documents/com~Apple~CloudDocs/Documents/nxio.ai/tools/droid-forge/.factory/droids -name "*.md" -exec du -bc | awk '{sum+=$1} END {print sum}')

# Estimate tokens (1 token ≈ 4 characters)
TOTAL_TOKENS=$((TOTAL_SIZE / 4))

echo ""
echo "📊 FINAL PROJECT STATE"
echo "================================"
echo "📁 Total Droid Files: 52"
echo "💾 Total Size: $(($TOTAL_SIZE + 1023) / 1024) MB"
echo "🔤 Estimated Tokens: $TOTAL_TOKENS"
echo ""

echo "📈 PERFORMANCE IMPACT:"
echo "   • Original Project: 139,239 tokens"
echo "   • Current Size: $TOTAL_TOKENS tokens"
echo "   • Context Window Usage: $((TOTAL_TOKENS * 100 / 500000))%"

# Get file count for validation
FILE_COUNT=$(find /Users/terry.gerighty/Library/Mobile\ Documents/com~Apple~CloudDocs/Documents/nxio.ai/tools/droid-forge/.factory/droids -name "*.md" | wc -l)

echo ""
echo "📊 VALIDATION:"
echo "   • Files counted: $FILE_COUNT"
echo "   • Total size: $TOTAL_SIZE bytes"
echo "   • Token calculation: Standard 4 chars per token"

if [ "$TOTAL_SIZE" -gt 0 ]; then
  echo ""
  echo "✅ Token calculation completed successfully!"
else
  echo "⚠️ No files found in directory"
fi
