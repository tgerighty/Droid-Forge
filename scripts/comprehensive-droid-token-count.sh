#!/bin/bash

# Comprehensive Token Count Script for All Droids
# This script analyzes token usage for all droid files in .factory/droids

echo "=========================================="
echo "COMPREHENSIVE DROID TOKEN COUNT ANALYSIS"
echo "=========================================="
echo "Date: $(date)"
echo "Analyzing all droids in .factory/droids folder"
echo ""

# Initialize counters
TOTAL_FILES=0
TOTAL_TOKENS=0
TOTAL_CHARS=0
TOTAL_WORDS=0
TOTAL_LINES=0

# Create temporary file for detailed results
DETAILED_RESULTS=$(mktemp)
echo "DETAILED TOKEN ANALYSIS REPORT" > "$DETAILED_RESULTS"
echo "Generated on: $(date)" >> "$DETAILED_RESULTS"
echo "==========================================" >> "$DETAILED_RESULTS"
echo "" >> "$DETAILED_RESULTS"

# Function to estimate tokens (rough approximation: ~4 chars = 1 token, ~0.75 words = 1 token)
estimate_tokens() {
    local file="$1"
    local chars=$(wc -c < "$file")
    local words=$(wc -w < "$file")
    local lines=$(wc -l < "$file")

    # Multiple estimation methods
    local char_based=$((chars / 4))
    local word_based=$((words * 4 / 3))
    local line_based=$((lines * 10))

    # Average of methods for better accuracy
    local tokens=$(((char_based + word_based + line_based) / 3))

    echo "$chars,$words,$lines,$tokens"
}

# Process all droid files
echo "Processing droid files..."
for file in .factory/droids/*.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file" .md)

        # Get file metrics
        metrics=$(estimate_tokens "$file")
        chars=$(echo "$metrics" | cut -d',' -f1)
        words=$(echo "$metrics" | cut -d',' -f2)
        lines=$(echo "$metrics" | cut -d',' -f3)
        tokens=$(echo "$metrics" | cut -d',' -f4)

        # Update totals
        TOTAL_FILES=$((TOTAL_FILES + 1))
        TOTAL_CHARS=$((TOTAL_CHARS + chars))
        TOTAL_WORDS=$((TOTAL_WORDS + words))
        TOTAL_LINES=$((TOTAL_LINES + lines))
        TOTAL_TOKENS=$((TOTAL_TOKENS + tokens))

        # Format for display
        printf "%-45s | %8s | %8s | %8s | %8s\n" \
            "$filename" \
            "$lines" \
            "$words" \
            "$chars" \
            "$tokens"

        # Add to detailed report
        echo "File: $filename" >> "$DETAILED_RESULTS"
        echo "  Lines: $lines" >> "$DETAILED_RESULTS"
        echo "  Words: $words" >> "$DETAILED_RESULTS"
        echo "  Characters: $chars" >> "$DETAILED_RESULTS"
        echo "  Estimated Tokens: $tokens" >> "$DETAILED_RESULTS"
        echo "  File Size: $(du -h "$file" | cut -f1)" >> "$DETAILED_RESULTS"
        echo "" >> "$DETAILED_RESULTS"
    fi
done

echo ""
echo "=========================================="
echo "SUMMARY STATISTICS"
echo "=========================================="
printf "%-45s | %8s | %8s | %8s | %8s\n" "METRIC" "FILES" "TOKENS" "CHARS" "WORDS"
echo "-------------------------------------------------------------"
printf "%-45s | %8d | %8d | %8d | %8d\n" \
    "TOTALS" \
    "$TOTAL_FILES" \
    "$TOTAL_TOKENS" \
    "$TOTAL_CHARS" \
    "$TOTAL_WORDS"

echo ""
echo "AVERAGES"
printf "%-45s | %8s | %8s | %8s | %8s\n" "METRIC" "PER FILE" "TOKENS" "CHARS" "WORDS"
echo "-------------------------------------------------------------"
if [ $TOTAL_FILES -gt 0 ]; then
    avg_tokens=$((TOTAL_TOKENS / TOTAL_FILES))
    avg_chars=$((TOTAL_CHARS / TOTAL_FILES))
    avg_words=$((TOTAL_WORDS / TOTAL_FILES))
    avg_lines=$((TOTAL_LINES / TOTAL_FILES))

    printf "%-45s | %8d | %8d | %8d | %8d\n" \
        "AVERAGE" \
        "$avg_lines" \
        "$avg_tokens" \
        "$avg_chars" \
        "$avg_words"
fi

echo ""
echo "CONTEXT WINDOW IMPACT"
echo "=========================================="
echo "Claude 3.5 Sonnet Context Window: 200,000 tokens"
echo "Estimated Usage: $((TOTAL_TOKENS * 100 / 200000))% of context window"
echo ""
echo "Recommended Context Windows:"
echo "- Claude 3.5 Sonnet: 200,000 tokens ✅"
echo "- Claude 3 Opus: 200,000 tokens ✅"
echo "- GPT-4 Turbo: 128,000 tokens ✅"
echo "- GPT-3.5 Turbo: 16,093 tokens ❌ (Too small)"

echo ""
echo "COST ESTIMATES (Input Tokens)"
echo "=========================================="
echo "Claude 3.5 Sonnet: \$3 per 1M tokens"
echo "Estimated cost per droid analysis: \$$(echo "scale=6; $TOTAL_TOKENS / 1000000 * 3" | bc)"
echo ""
echo "GPT-4 Turbo: \$10 per 1M tokens"
echo "Estimated cost per droid analysis: \$$(echo "scale=6; $TOTAL_TOKENS / 1000000 * 10" | bc)"

# Save detailed report
echo ""
echo "=========================================="
echo "DETAILED REPORT SAVED TO: droid-token-analysis-$(date +%Y%m%d_%H%M%S).txt"
echo "=========================================="

# Copy detailed results to timestamped file
cp "$DETAILED_RESULTS" "droid-token-analysis-$(date +%Y%m%d_%H%M%S).txt"

# Clean up
rm "$DETAILED_RESULTS"

echo ""
echo "Analysis complete! 🤖"