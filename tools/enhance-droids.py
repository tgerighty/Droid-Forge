#!/usr/bin/env python3
"""
enhance-droids.py - Add tool usage guidelines and task file I/O to all droids
More reliable than bash for complex text manipulation
"""

import os
import re
from pathlib import Path

DROID_DIR = Path(".factory/droids")

# Assessment droid tool guidelines template
ASSESSMENT_TOOLS = """---

## Tool Usage Guidelines

### Execute Tool
**Purpose**: Run validation and analysis commands only - never modify code

#### Allowed Commands
**Testing & Validation**:
- `npm test`, `npm run test:coverage` - Run test suites and coverage
- `pytest`, `jest --coverage`, `vitest run` - Test frameworks
- `biome check`, `eslint .` - Linting and code quality
- `tsc --noEmit` - TypeScript type checking

**Analysis & Inspection**:
- `git status`, `git log`, `git diff` - Repository inspection
- `ls -la`, `tree -L 2` - Directory structure
- `cat`, `head`, `tail`, `grep` - File reading and searching

#### Prohibited Commands
**Never Execute**:
- `rm`, `mv`, `git push`, `npm publish` - Destructive operations
- `npm install`, `pip install` - Installation commands
- `sudo`, `chmod`, `chown` - System modifications

**Security**: Factory.ai CLI prompts for user confirmation before executing commands.

---

### Create Tool
**Purpose**: Generate task files and reports - never modify source code

#### Allowed Paths
- `/tasks/tasks-*.md` - Task files for action droid handoff
- `/reports/*.md` - Assessment reports
- `/docs/assessments/*.md` - Documentation

#### Prohibited Paths
**Never Create In**:
- `/src/**` - Source code directories
- Configuration files: `package.json`, `tsconfig.json`, `.env`
- `.git/**` - Git metadata

**Security Principle**: Assessment droids analyze and document - they NEVER modify source code.

---
"""

# Action droid tool guidelines template
ACTION_TOOLS = """---

## Tool Usage Guidelines

### Execute Tool
**Purpose**: Full execution rights for validation, testing, building, and git operations

#### Allowed Commands
**All assessment commands plus**:
- `npm run build`, `npm run dev` - Build and development
- `npm install`, `pnpm install` - Dependency management
- `git add`, `git commit`, `git checkout` - Git operations
- Build tools, compilers, and package managers

#### Caution Commands (Ask User First)
- `git push` - Push to remote repository
- `npm publish` - Publish to package registry
- `docker push` - Push to container registry

---

### Edit & MultiEdit Tools
**Purpose**: Modify source code to implement fixes and features

**Best Practices**:
1. **Read before editing** - Always read files first to understand context
2. **Preserve formatting** - Match existing code style
3. **Atomic changes** - Each edit should be a complete, working change
4. **Test after editing** - Run tests to verify changes work

---

### Create Tool
**Purpose**: Generate new files including source code

#### Allowed Paths (Full Access)
- `/src/**` - All source code directories
- `/tests/**` - Test files
- `/docs/**` - Documentation

#### Prohibited Paths
- `.env` - Actual secrets (only `.env.example`)
- `.git/**` - Git internals (use git commands)

**Security**: Action droids have full modification rights to implement fixes and features.

---
"""

# Assessment task I/O template
ASSESSMENT_TASK_IO = """## Task File Integration

### Output Format
**Creates**: `/tasks/tasks-[prd-id]-[domain].md`

**Structure**:
```markdown
# [Domain] Assessment - [Brief Description]

**Assessment Date**: YYYY-MM-DD
**Priority**: P0 (Critical) | P1 (High) | P2 (Medium) | P3 (Low)

## Relevant Files
- `path/to/file.ts` - [Purpose/Issue]

## Tasks
- [ ] 1.1 [Task description]
  - **File**: `path/to/file.ts`
  - **Priority**: P0
  - **Issue**: [Problem description]
  - **Suggested Fix**: [Recommended approach]
```

**Priority Levels**:
- **P0**: Critical security/system-breaking bugs
- **P1**: Major bugs, significant issues
- **P2**: Minor bugs, code quality
- **P3**: Nice-to-have improvements

---
"""

# Action task I/O template
ACTION_TASK_IO = """## Task File Integration

### Input Format
**Reads**: `/tasks/tasks-[prd-id]-[domain].md` from assessment droid

### Output Format
**Updates**: Same file with status markers

**Status Markers**:
- `[ ]` - Pending
- `[~]` - In Progress
- `[x]` - Completed
- `[!]` - Blocked

**Example Update**:
```markdown
- [x] 1.1 Fix authentication bug
  - **Status**: ✅ Completed
  - **Completed**: 2025-01-12 11:45
  - **Changes**: Added input validation, error handling
  - **Tests**: ✅ All tests passing (12/12)
```

---
"""

# Orchestration task I/O template
ORCHESTRATION_TASK_IO = """## Task File Integration

### Input Format
**Reads**: Multiple task files across domains
- `/tasks/tasks-[prd]-frontend.md`
- `/tasks/tasks-[prd]-backend.md`
- `/tasks/tasks-[prd]-security.md`

### Output Format
**Creates**: `/tasks/tasks-[prd]-orchestration.md`

Coordinates delegation and tracks overall progress across all task files.

---
"""


def has_section(content, section_title):
    """Check if content already has a specific section"""
    pattern = re.compile(rf'^##\s+{re.escape(section_title)}', re.MULTILINE)
    return bool(pattern.search(content))


def find_insertion_point(content):
    """Find the best insertion point for tool guidelines"""
    # Try to insert before common end sections
    for section in ["## Integration", "## Manager Droid", "## Best Practices", 
                    "## Usage Guidelines", "## Success Criteria", "## Metrics"]:
        pattern = re.compile(rf'^({section})', re.MULTILINE)
        match = pattern.search(content)
        if match:
            return match.start()
    
    # If no good insertion point, append at end (before final --- if present)
    if content.rstrip().endswith("---"):
        return len(content.rstrip()) - 3
    return len(content)


def enhance_droid(filepath, droid_type):
    """Enhance a single droid file"""
    print(f"Enhancing: {filepath.name}")
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Check if already enhanced
    if has_section(content, "Tool Usage Guidelines"):
        print(f"  ✓ Already has tool guidelines, skipping")
        return False
    
    # Find insertion point
    insert_pos = find_insertion_point(content)
    
    # Build enhancement content
    if droid_type == "assessment":
        enhancement = ASSESSMENT_TOOLS + ASSESSMENT_TASK_IO
    elif droid_type == "action":
        enhancement = ACTION_TOOLS + ACTION_TASK_IO
    elif droid_type == "orchestration":
        enhancement = "\n---\n\n" + ORCHESTRATION_TASK_IO
    else:
        # Integration droids - treat as action droids
        enhancement = ACTION_TOOLS + ACTION_TASK_IO
    
    # Insert enhancement
    new_content = content[:insert_pos] + "\n" + enhancement + "\n" + content[insert_pos:]
    
    # Write back
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print(f"  ✓ Enhanced successfully")
    return True


def main():
    print("=" * 60)
    print("Droid Enhancement Script (Python)")
    print("=" * 60)
    print()
    
    # Classification
    assessment_droids = [
        "caching-assessment", "code-smell-assessment", "cognitive-complexity-assessment",
        "database-performance-assessment", "debugging-assessment", "drizzle-assessment",
        "nextjs15-assessment", "security-assessment", "security-audit", "test-assessment",
        "trpc-assessment", "typescript-assessment", "typescript-integration-assessment",
        "bug-hunter", "impact-analyzer", "plan-review"
    ]
    
    action_droids = [
        "bug-fix", "code-refactoring", "security-fix", "typescript-fix",
        "unit-test", "frontend-engineer", "backend-engineer",
        "database-performance", "drizzle-orm-specialist",
        "nextjs15-specialist", "typescript-professional"
    ]
    
    orchestration_droids = [
        "manager-orchestrator", "auto-pr", "reliability",
        "task-manager", "ai-dev-tasks-integrator",
        "git-workflow-orchestrator", "biome"
    ]
    
    integration_droids = [
        "better-auth-integration", "trpc-tanstack-integration",
        "typescript-integration", "valkey-caching-strategist"
    ]
    
    enhanced_count = 0
    
    # Process all markdown files in droid directory
    for md_file in sorted(DROID_DIR.glob("*.md")):
        stem = md_file.stem.replace("-droid-forge", "")
        
        if any(stem.startswith(a) for a in assessment_droids):
            if enhance_droid(md_file, "assessment"):
                enhanced_count += 1
        elif any(stem.startswith(a) for a in action_droids):
            if enhance_droid(md_file, "action"):
                enhanced_count += 1
        elif any(stem.startswith(o) for o in orchestration_droids):
            if enhance_droid(md_file, "orchestration"):
                enhanced_count += 1
        elif any(stem.startswith(i) for i in integration_droids):
            if enhance_droid(md_file, "integration"):
                enhanced_count += 1
    
    print()
    print("=" * 60)
    print(f"✓ Enhancement complete! Enhanced {enhanced_count} droids")
    print("=" * 60)
    print()
    print("Next steps:")
    print("  1. Review changes: git diff")
    print("  2. Test a few droids")
    print("  3. Commit: git add . && git commit -m 'feat: add tool guidelines and task I/O docs'")


if __name__ == "__main__":
    main()
