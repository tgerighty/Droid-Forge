#!/bin/bash

# Final Token Calculation for Droid Forge Project
echo "🔢 Droid Forge Final Token Analysis"
echo "======================================"

# Count all markdown files
echo "📊 Counting droid files..."
FILE_COUNT=$(find /Users/terry.gerighty/Library/Mobile\ Documents/com~Apple~CloudDocs/Documents/nxio.ai/tools/droid-forge/.factory/droids -name "*.md" | wc -l)
echo "Found $FILE_COUNT droid files"

# Calculate total size
TOTAL_BYTES=$(find /Users/terry.gerighty/Library/Mobile\ Documents/com~Apple~CloudDocs/Documents/nxio.ai/tools/droid-forge/.factory/droids -name "*.md" -exec du -bc | awk '{sum+=$1} END {print sum}')
TOTAL_TOKENS=$((TOTAL_BYTES / 4))

echo ""
echo "======================================"
echo "📊 FINAL PROJECT ANALYSIS"
echo "======================================"
echo "📁 Total Droid Files: $FILE_COUNT"
echo "💾 Total Size: $TOTAL_BYTES bytes ($(($TOTAL_BYTES + 1023) / 1024)) MB"
echo "🔤 Estimated Tokens: $TOTAL_TOKENS"
echo ""

# Calculate original vs current
ORIGINAL_TOKENS=139239
SAVINGS=$((ORIGINAL_TOKENS - TOTAL_TOKENS))
REDUCTION=$((SAVINGS * 100 / ORIGINAL_TOKENS))

echo "📈 PERFORMANCE COMPARISON:"
echo "   • Original Project: $ORIGINAL_TOKENS tokens"
echo "   • Current Optimized: $TOTAL_TOKENS tokens"
echo "   • Tokens Saved: $SAVINGS tokens"
echo "   • Reduction: $REDUCTION%"
echo ""

# Context window analysis
CONTEXT_PERCENTAGE=$((TOTAL_TOKENS * 100 / 500000))
echo "📈 Context Window Analysis:"
echo "   • 500K token context window = 100%"
echo "   • Current usage: $CONTEXT_PERCENTAGE%"
echo "   • Available space: $((500000 - TOTAL_TOKENS) * 100 / 500000))%"

echo ""
echo "🎯 OPTIMIZATION SUCCESS:"
if [ $REDUCTION -ge 60 ]; then
  echo "   🚀️ EXCELLENT: Over 60% token reduction achieved!"
elif [ $REDUCTION -ge 50 ]; then
  echo "   ✅ EXCELLENT: Over 50% token reduction achieved!"
elif [ $REDUCTION -ge 40 ]; then
  echo "   ✅ GOOD: 40%+ token reduction achieved!"
elif [ $REDUCTION -ge 30 ]; then
  echo "   ✅ SOLID: 30%+ token reduction achieved!"
else
  echo "   ⚠️ MODERATE: Further optimization possible"
fi

echo ""
echo "📊 Largest Files (Top 10):"
find /Users/terry.gerighty/Library/Mobile\ Documents/com~Apple~CloudDocs/Documents/nxio.ai/tools/droid-forge/.factory/droids -name "*.md" -exec ls -la {} + | sort -k5 -nr | head -10 | while read -r size name; do
  SIZE_KB=$((size + 1023) / 1024))
  TOKENS_EST=$((SIZE_KB * 256))
  echo "   📄 $name: ${SIZE_KB}KB (~$TOKENS_EST tokens)"
done

echo ""
echo "🚀 NEXT STEPS:"
echo "   • 35 additional droids remain to optimize"
echo "   • Potential additional savings: 35-45,000 tokens"
echo "   • Final target: 40-50,000 total tokens (~65-70% reduction)"

echo ""
echo "✅ Token calculation complete!"
