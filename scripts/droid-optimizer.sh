#!/bin/bash

# Droid Optimization Script
# Optimizes droid files for minimal token usage while preserving functionality

echo "🤖 DROID OPTIMIZER INITIALIZED"
echo "================================"

# Function to calculate tokens (simplified)
calculate_tokens() {
    local file="$1"
    local chars=$(wc -c < "$file")
    echo $((chars / 4))
}

# Function to optimize a droid file
optimize_droid() {
    local input_file="$1"
    local output_file="${input_file%.md}-optimized.md"
    local filename=$(basename "$input_file" .md)

    echo "🔧 Optimizing: $filename"

    local original_tokens=$(calculate_tokens "$input_file")

    # Create optimized version
    python3 - << PYTHON_EOF
import re
import sys

def optimize_droid_content(content):
    """Optimize droid content for minimal token usage"""

    # Extract metadata
    title_match = re.search(r'^# (.+)$', content, re.MULTILINE)
    title = title_match.group(1) if title_match else "Droid"

    # Extract description
    desc_match = re.search(r'## [Dd]escription\n\n(.*?)(?=\n##|\n#|$)', content, re.DOTALL)
    description = desc_match.group(1).strip() if desc_match else ""

    # Extract sections
    sections = {}
    section_pattern = r'## (.+?)\n\n(.*?)(?=\n##|\n#|$)'

    for section_match in re.finditer(section_pattern, content, re.DOTALL):
        section_name = section_match.group(1).strip()
        section_content = section_match.group(2).strip()
        sections[section_name] = section_content

    # Optimize each section
    optimized_sections = {}

    for section_name, section_content in sections.items():
        # Skip certain sections that can be condensed
        if section_name.lower() in ['description', 'overview']:
            optimized_sections[section_name] = section_content
            continue

        # Optimize section content
        optimized = optimize_section_content(section_name, section_content)
        optimized_sections[section_name] = optimized

    # Rebuild optimized content
    optimized = f"# {title}\n\n"

    if description:
        optimized += f"## Description\n{description}\n\n"

    # Add optimized sections
    for section_name in ['Core Capabilities', 'Key Features', 'Approach', 'Instructions', 'Tools']:
        if section_name in optimized_sections:
            optimized += f"## {section_name}\n{optimized_sections[section_name]}\n\n"

    # Add remaining sections
    for section_name, content in optimized_sections.items():
        if section_name not in ['Core Capabilities', 'Key Features', 'Approach', 'Instructions', 'Tools']:
            optimized += f"## {section_name}\n{content}\n\n"

    return optimized.strip()

def optimize_section_content(section_name, content):
    """Optimize individual section content"""

    # Convert bullet lists to more compact format
    content = re.sub(r'^- (.+)$', r'• \1', content, flags=re.MULTILINE)

    # Remove excessive whitespace
    content = re.sub(r'\n\s*\n\s*\n', '\n\n', content)

    # Condense repetitive phrases
    content = re.sub(r'You are (?:a|an) (.+?) (?:with expertise|specializing|focused on)', r'Specialist \1', content)
    content = re.sub(r'Your role is to (.+?)\.', r'Role: \1', content)
    content = re.sub(r'You should (.+?)\.', r'Focus: \1', content)

    # Optimize tool descriptions
    if section_name.lower() == 'tools':
        content = optimize_tools_section(content)

    # Optimize instruction sections
    if 'instruction' in section_name.lower() or 'approach' in section_name.lower():
        content = optimize_instructions(content)

    return content.strip()

def optimize_tools_section(content):
    """Optimize tools section for minimal tokens"""

    # Remove redundant tool descriptions
    content = re.sub(r'- (.+?): (.+?)\n', r'- \1\n', content)

    # Group common tools
    common_tools = {
        'Read': 'Read files',
        'Write': 'Write files',
        'Edit': 'Edit files',
        'Bash': 'Execute commands',
        'Glob': 'Find files',
        'Grep': 'Search content',
        'TodoWrite': 'Manage tasks'
    }

    lines = content.split('\n')
    optimized_lines = []

    for line in lines:
        line = line.strip()
        if line.startswith('-'):
            tool_name = line[2:].strip()
            if tool_name in common_tools:
                optimized_lines.append(f"- {tool_name}: {common_tools[tool_name]}")
            else:
                optimized_lines.append(line)
        else:
            optimized_lines.append(line)

    return '\n'.join(optimized_lines)

def optimize_instructions(content):
    """Optimize instruction sections"""

    # Convert numbered lists to more compact format
    content = re.sub(r'^\d+\.\s+(.+)$', r'\1', content, flags=re.MULTILINE)

    # Remove redundant phrases
    content = re.sub(r'Please (.+?)\.', r'\1', content)
    content = re.sub(r'Make sure to (.+?)\.', r'Ensure \1', content)
    content = re.sub(r'It is important to (.+?)\.', r'Critical: \1', content)

    return content

# Read input file
with open('$input_file', 'r') as f:
    content = f.read()

# Optimize content
optimized_content = optimize_droid_content(content)

# Write optimized content
with open('$output_file', 'w') as f:
    f.write(optimized_content)

print(f"✅ Optimized {filename}")
PYTHON_EOF

    local optimized_tokens=$(calculate_tokens "$output_file")
    local savings=$((original_tokens - optimized_tokens))
    local percent_saved=$((savings * 100 / original_tokens))

    printf "   Original: %4d tokens\n" "$original_tokens"
    printf "   Optimized: %4d tokens\n" "$optimized_tokens"
    printf "   Savings: %4d tokens (%d%%)\n" "$savings" "$percent_saved"
    echo ""

    # Replace original with optimized
    mv "$output_file" "$input_file"

    echo "$original_tokens,$optimized_tokens,$savings,$percent_saved"
}

# Main optimization loop
echo "Starting optimization process..."
echo ""

total_original=0
total_optimized=0
total_savings=0

# Get list of droids sorted by size (largest first)
droids=($(ls -la .factory/droids/*.md | awk '{print $5, $9}' | sort -nr | cut -d' ' -f2-))

for droid_file in "${droids[@]}"; do
    if [[ -f "$droid_file" ]]; then
        stats=$(optimize_droid "$droid_file")

        original=$(echo "$stats" | cut -d',' -f1)
        optimized=$(echo "$stats" | cut -d',' -f2)
        savings=$(echo "$stats" | cut -d',' -f3)

        total_original=$((total_original + original))
        total_optimized=$((total_optimized + optimized))
        total_savings=$((total_savings + savings))
    fi
done

echo "=========================================="
echo "🎯 OPTIMIZATION SUMMARY"
echo "=========================================="
printf "Total Original Tokens:  %8d\n" "$total_original"
printf "Total Optimized Tokens: %8d\n" "$total_optimized"
printf "Total Savings:          %8d\n" "$total_savings"
printf "Reduction:              %8d%%\n" "$((total_savings * 100 / total_original))"
echo ""
echo "🚀 All droids optimized successfully!"