#!/usr/bin/env python3
"""
aggressive-optimize.py - Aggressive token optimization for AI consumption
Reduces verbosity while maintaining functionality for AI understanding
"""

import re
from pathlib import Path
import sys

def optimize_for_ai(content: str) -> str:
    """Aggressively optimize content for AI token efficiency"""
    
    # 1. Consolidate capability lists - convert verbose bullets to compact format
    content = re.sub(
        r'(### .+)\n((?:- ✅ \*\*.+?\*\*:.+\n)+)',
        lambda m: convert_capabilities_to_compact(m.group(1), m.group(2)),
        content
    )
    
    # 2. Remove redundant code examples - keep only 1-2 key examples
    code_blocks = re.findall(r'```[\s\S]*?```', content)
    if len(code_blocks) > 4:
        # Keep first 2 substantive examples, remove rest
        for i, block in enumerate(code_blocks[2:], start=2):
            if len(block) > 500:  # Large code blocks
                content = content.replace(block, '', 1)
    
    # 3. Simplify tool guidelines - reference template
    content = re.sub(
        r'## Tool Usage Guidelines\n\n### Execute Tool.*?(?=\n---\n\n)',
        '## Tool Usage\n**Execute**: Database ops, psql, migrations, testing\n**Edit**: Database code, configs, migrations\n**Create**: Services, schemas, docs\nSee templates for details.\n',
        content,
        flags=re.DOTALL
    )
    
    # 4. Consolidate task file I/O - make ultra-compact
    content = re.sub(
        r'## Task File Integration.*?(?=\n---\n\n)',
        '## Task Files\n**Input**: `/tasks/tasks-[prd]-[domain].md`\n**Output**: Update with `[~]` in-progress, `[x]` completed, metrics\n**Format**: Status + before/after metrics + changes\n',
        content,
        flags=re.DOTALL
    )
    
    # 5. Remove excessive whitespace
    content = re.sub(r'\n\n\n+', '\n\n', content)
    
    # 6. Compact "Best Practices" - bullets only
    content = re.sub(
        r'### (.+?) Best Practices.*?\n\n',
        '',
        content,
        flags=re.DOTALL
    )
    
    return content

def convert_capabilities_to_compact(header: str, bullets: str) -> str:
    """Convert verbose capability bullets to compact format"""
    items = re.findall(r'\*\*(.+?)\*\*', bullets)
    compact = f"{header}\n**Handles**: {', '.join(items)}\n\n"
    return compact

def optimize_file(filepath: Path) -> tuple[int, int]:
    """Optimize a single file, return (old_lines, new_lines)"""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    old_lines = len(content.split('\n'))
    optimized = optimize_for_ai(content)
    new_lines = len(optimized.split('\n'))
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(optimized)
    
    return (old_lines, new_lines)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 aggressive-optimize.py <droid-file.md>")
        sys.exit(1)
    
    filepath = Path(sys.argv[1])
    if not filepath.exists():
        print(f"Error: {filepath} not found")
        sys.exit(1)
    
    old, new = optimize_file(filepath)
    reduction = ((old - new) / old) * 100
    print(f"✅ Optimized: {old} → {new} lines ({reduction:.1f}% reduction)")
