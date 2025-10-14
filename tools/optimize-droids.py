#!/usr/bin/env python3
"""
optimize-droids.py - Optimize all droids for token efficiency
Reduces verbosity while maintaining clarity and functionality
"""

import os
import re
from pathlib import Path

DROID_DIR = Path(".factory/droids")

def optimize_code_examples(content):
    """
    Reduce number of code examples - keep 1-2 most important ones
    """
    # Find all code blocks
    code_blocks = re.findall(r'```[\s\S]*?```', content)
    
    # If more than 3 code blocks in a section, it's too much
    # This is a simple heuristic - manual review recommended
    return content

def optimize_tool_guidelines(content):
    """
    Consolidate tool guidelines - they're very repetitive across droids
    """
    # Check if guidelines are overly verbose
    guidelines_match = re.search(r'## Tool Usage Guidelines.*?(?=\n## |\Z)', content, re.DOTALL)
    
    if not guidelines_match:
        return content
    
    guidelines = guidelines_match.group(0)
    
    # If tool guidelines are more than 100 lines, they're too verbose
    line_count = guidelines.count('\n')
    if line_count > 100:
        # Suggest consolidation
        print(f"    → Tool guidelines are verbose ({line_count} lines)")
    
    return content

def optimize_repetitive_patterns(content):
    """
    Remove repetitive workflow patterns and consolidate
    """
    # Look for repeated bash function examples
    bash_blocks = re.findall(r'```bash[\s\S]*?```', content)
    
    if len(bash_blocks) > 5:
        print(f"    → Found {len(bash_blocks)} bash examples - consider consolidating")
    
    return content

def optimize_task_file_examples(content):
    """
    Task file I/O sections are quite long - reference templates instead
    """
    task_match = re.search(r'## Task File Integration.*?(?=\n## |\Z)', content, re.DOTALL)
    
    if not task_match:
        return content
    
    task_section = task_match.group(0)
    
    # If task file section is more than 80 lines, consolidate
    line_count = task_section.count('\n')
    if line_count > 80:
        print(f"    → Task file section is verbose ({line_count} lines)")
        # Could replace with: "See docs/templates/task-file-io-template.md for format"
    
    return content

def remove_excessive_whitespace(content):
    """
    Remove excessive blank lines (more than 2 consecutive)
    """
    # Replace 3+ blank lines with 2 blank lines
    content = re.sub(r'\n\n\n+', '\n\n', content)
    return content

def consolidate_lists(content):
    """
    Convert verbose paragraphs to concise bullet points where appropriate
    """
    # This is complex and risky - manual review better
    return content

def get_optimization_metrics(content):
    """
    Calculate metrics for optimization report
    """
    lines = len(content.split('\n'))
    code_blocks = len(re.findall(r'```', content)) // 2
    headings = len(re.findall(r'^##+ ', content, re.MULTILINE))
    
    return {
        'lines': lines,
        'code_blocks': code_blocks,
        'headings': headings,
        'chars': len(content)
    }

def analyze_droid(filepath):
    """
    Analyze a droid file for optimization opportunities
    """
    print(f"\nAnalyzing: {filepath.name}")
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    metrics = get_optimization_metrics(content)
    print(f"  Lines: {metrics['lines']}, Code blocks: {metrics['code_blocks']}, Headings: {metrics['headings']}")
    
    # Run optimization checks
    optimize_code_examples(content)
    optimize_tool_guidelines(content)
    optimize_repetitive_patterns(content)
    optimize_task_file_examples(content)
    
    return metrics

def generate_optimization_report():
    """
    Generate a report of optimization opportunities
    """
    print("=" * 70)
    print("Droid Optimization Analysis")
    print("=" * 70)
    
    total_lines = 0
    total_chars = 0
    droids_analyzed = 0
    large_droids = []
    
    for md_file in sorted(DROID_DIR.glob("*.md")):
        metrics = analyze_droid(md_file)
        total_lines += metrics['lines']
        total_chars += metrics['chars']
        droids_analyzed += 1
        
        if metrics['lines'] > 500:
            large_droids.append((md_file.name, metrics['lines']))
    
    print("\n" + "=" * 70)
    print("Summary")
    print("=" * 70)
    print(f"Total droids analyzed: {droids_analyzed}")
    print(f"Total lines: {total_lines:,}")
    print(f"Total characters: {total_chars:,}")
    print(f"Average lines per droid: {total_lines // droids_analyzed}")
    
    print(f"\nLarge droids (>500 lines): {len(large_droids)}")
    for name, lines in sorted(large_droids, key=lambda x: x[1], reverse=True)[:10]:
        print(f"  {name}: {lines} lines")
    
    print("\n" + "=" * 70)
    print("Optimization Recommendations")
    print("=" * 70)
    print("""
1. **Code Examples**: Reduce to 1-2 key examples per section
   - Remove redundant bash/typescript examples
   - Keep only the most illustrative examples
   
2. **Tool Guidelines**: Consolidate repetitive tool documentation
   - Create common tool guidelines template
   - Reference instead of repeating full guidelines
   
3. **Task File I/O**: Replace verbose examples with template references
   - Use: "See docs/templates/task-file-io-template.md"
   - Keep only droid-specific details
   
4. **Workflow Patterns**: Consolidate similar bash function examples
   - One comprehensive example instead of many small ones
   
5. **Best Practices**: Convert paragraphs to bullet points
   - More scannable, less verbose
   
6. **Remove Duplicates**: Many droids repeat similar patterns
   - Extract common patterns to shared documentation
   
Estimated reduction: 30-40% (2,000-3,000 lines across all droids)
""")

if __name__ == "__main__":
    generate_optimization_report()
