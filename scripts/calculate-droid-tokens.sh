#!/bin/bash

echo "=== DROID TOKEN COUNT ANALYSIS ==="
echo "Analyzing all droids in .factory/droids/"
echo ""

total_droids=0
total_tokens=0

# Create temporary file for sorting
temp_file="/tmp/droid_token_counts.txt"

# Process each droid
for droid in .factory/droids/*.md; do
    if [ -f "$droid" ]; then
        filename=$(basename "$droid" .md)
        # Count characters and estimate tokens (roughly 4 characters per token)
        char_count=$(wc -c < "$droid")
        token_count=$((char_count / 4))

        echo "$filename: $token_count tokens"
        echo "$token_count $filename" >> "$temp_file"

        total_droids=$((total_droids + 1))
        total_tokens=$((total_tokens + token_count))
    fi
done

echo ""
echo "=== SORTED BY TOKEN COUNT (LARGEST FIRST) ==="
sort -nr "$temp_file" | while read -r line; do
    token_count=$(echo "$line" | cut -d' ' -f1)
    filename=$(echo "$line" | cut -d' ' -f2-)
    echo "$token_count tokens - $filename"
done

echo ""
echo "=== SUMMARY ==="
echo "Total droids: $total_droids"
echo "Total estimated tokens: $total_tokens"
echo "Average tokens per droid: $((total_tokens / total_droids))"

# Clean up
rm -f "$temp_file"