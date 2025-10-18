#!/usr/bin/env bash
# enhance-droids.sh - Add tool usage guidelines, task file I/O, and timestamps to all droids

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DROID_DIR=".factory/droids"
TEMPLATES_DIR="docs/templates"
TIMESTAMP=$(date +%Y-%m-%d)

# Arrays to track droid types
ASSESSMENT_DROIDS=(
  "auth-assessment-droid-forge.md"
  "bug-hunter-droid-forge.md"
  "caching-assessment-droid-forge.md"
  "code-smell-assessment-droid-forge.md"
  "cognitive-complexity-assessment-droid-forge.md"
  "database-performance-assessment-droid-forge.md"
  "debugging-assessment-droid-forge.md"
  "drizzle-assessment-droid-forge.md"
  "impact-analyzer-droid-forge.md"
  "nextjs15-assessment-droid-forge.md"
  "plan-review-droid-forge.md"
  "security-assessment-droid-forge.md"
  "security-audit-droid-forge.md"
  "test-assessment-droid-forge.md"
  "trpc-assessment-droid-forge.md"
  "typescript-assessment-droid-forge.md"
  "typescript-integration-assessment-droid-forge.md"
)

ACTION_DROIDS=(
  "bug-fix-droid-forge.md"
  "code-refactoring-droid-forge.md"
  "security-fix-droid-forge.md"
  "typescript-fix-droid-forge.md"
  "unit-test-droid-forge.md"
  "frontend-engineer-droid-forge.md"
  "backend-engineer-droid-forge.md"
  "database-performance-droid-forge.md"
  "drizzle-orm-specialist-droid-forge.md"
  "nextjs15-specialist-droid-forge.md"
  "typescript-professional-droid-forge.md"
)

ORCHESTRATION_DROIDS=(
  "manager-orchestrator-droid-forge.md"
  "auto-pr-droid-forge.md"
  "reliability-droid-forge.md"
  "task-manager-droid-forge.md"
  "ai-dev-tasks-integrator-droid-forge.md"
  "git-workflow-orchestrator-droid-forge.md"
  "biome-droid-forge.md"
)

INTEGRATION_DROIDS=(
  "better-auth-integration-droid-forge.md"
  "trpc-tanstack-integration-droid-forge.md"
  "typescript-integration-droid-forge.md"
  "caching-specialist-droid-forge.md"
)

# Function to add timestamps to YAML frontmatter
add_timestamps() {
  local file="$1"
  echo -e "${BLUE}Adding timestamps to: ${file}${NC}"
  
  # Check if timestamps already exist
  if grep -q "createdAt:" "$file"; then
    echo -e "${YELLOW}  Timestamps already exist, skipping${NC}"
    return
  fi
  
  # Add timestamps after version field
  sed -i.bak "/^version:/a\\
createdAt: \"$TIMESTAMP\"\\
updatedAt: \"$TIMESTAMP\"
" "$file"
  
  rm "${file}.bak"
  echo -e "${GREEN}  ✓ Timestamps added${NC}"
}

# Function to add tool usage guidelines to assessment droids
add_assessment_tool_guidelines() {
  local file="$1"
  echo -e "${BLUE}Adding assessment tool guidelines to: ${file}${NC}"
  
  # Check if guidelines already exist
  if grep -q "## Tool Usage Guidelines" "$file"; then
    echo -e "${YELLOW}  Tool guidelines already exist, skipping${NC}"
    return
  fi
  
  # Find the line number after "## Assessment Capabilities" or similar section
  # We'll add it before "## Assessment Patterns" or at the end
  local insert_line=$(grep -n "^## Assessment Patterns" "$file" | head -1 | cut -d: -f1)
  
  if [ -z "$insert_line" ]; then
    # If no Assessment Patterns section, add before "## Best Practices"
    insert_line=$(grep -n "^## Best Practices" "$file" | head -1 | cut -d: -f1)
  fi
  
  if [ -z "$insert_line" ]; then
    # If still not found, append at end
    cat >> "$file" << 'EOF'

---

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

EOF
  else
    # Insert before the found line
    {
      head -n $((insert_line - 1)) "$file"
      cat << 'EOF'

---

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

EOF
      tail -n +$insert_line "$file"
    } > "${file}.tmp"
    mv "${file}.tmp" "$file"
  fi
  
  echo -e "${GREEN}  ✓ Tool guidelines added${NC}"
}

# Function to add tool usage guidelines to action droids
add_action_tool_guidelines() {
  local file="$1"
  echo -e "${BLUE}Adding action tool guidelines to: ${file}${NC}"
  
  # Check if guidelines already exist
  if grep -q "## Tool Usage Guidelines" "$file"; then
    echo -e "${YELLOW}  Tool guidelines already exist, skipping${NC}"
    return
  fi
  
  # Add before "## Best Practices" or at the end
  local insert_line=$(grep -n "^## Best Practices" "$file" | head -1 | cut -d: -f1)
  
  if [ -z "$insert_line" ]; then
    cat >> "$file" << 'EOF'

---

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
1. Read files before editing to understand context
2. Preserve existing code style and formatting
3. Make atomic changes that work together
4. Run tests after editing to verify changes

---

### Create Tool
**Purpose**: Generate new files including source code

#### Allowed Paths (Full Access)
- `/src/**` - All source code directories
- `/tests/**` - Test files
- `/docs/**` - Documentation
- Configuration files (with caution)

#### Prohibited Paths
- `.env` - Actual secrets (only `.env.example`)
- `.git/**` - Git internals (use git commands)

**Security**: Action droids have full modification rights to implement fixes and features.

EOF
  else
    {
      head -n $((insert_line - 1)) "$file"
      cat << 'EOF'

---

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
1. Read files before editing to understand context
2. Preserve existing code style and formatting
3. Make atomic changes that work together
4. Run tests after editing to verify changes

---

### Create Tool
**Purpose**: Generate new files including source code

#### Allowed Paths (Full Access)
- `/src/**` - All source code directories
- `/tests/**` - Test files
- `/docs/**` - Documentation
- Configuration files (with caution)

#### Prohibited Paths
- `.env` - Actual secrets (only `.env.example`)
- `.git/**` - Git internals (use git commands)

**Security**: Action droids have full modification rights to implement fixes and features.

EOF
      tail -n +$insert_line "$file"
    } > "${file}.tmp"
    mv "${file}.tmp" "$file"
  fi
  
  echo -e "${GREEN}  ✓ Tool guidelines added${NC}"
}

# Function to add task file I/O documentation
add_task_file_io() {
  local file="$1"
  local droid_type="$2"  # assessment, action, or orchestration
  
  echo -e "${BLUE}Adding task file I/O to: ${file}${NC}"
  
  # Check if task file I/O already exists
  if grep -q "## Task File Integration" "$file"; then
    echo -e "${YELLOW}  Task file I/O already exists, skipping${NC}"
    return
  fi
  
  # Add after tool usage guidelines or before best practices
  local insert_line=$(grep -n "^## Best Practices" "$file" | head -1 | cut -d: -f1)
  
  if [ "$droid_type" == "assessment" ]; then
    local content='

---

## Task File Integration

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
'
  elif [ "$droid_type" == "action" ]; then
    local content='

---

## Task File Integration

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
'
  else
    local content='

---

## Task File Integration

### Input Format
**Reads**: Multiple task files across domains
- `/tasks/tasks-[prd]-frontend.md`
- `/tasks/tasks-[prd]-backend.md`
- `/tasks/tasks-[prd]-security.md`

### Output Format
**Creates**: `/tasks/tasks-[prd]-orchestration.md`

Coordinates delegation and tracks overall progress across all task files.
'
  fi
  
  if [ -z "$insert_line" ]; then
    echo "$content" >> "$file"
  else
    {
      head -n $((insert_line - 1)) "$file"
      echo "$content"
      tail -n +$insert_line "$file"
    } > "${file}.tmp"
    mv "${file}.tmp" "$file"
  fi
  
  echo -e "${GREEN}  ✓ Task file I/O added${NC}"
}

# Main execution
main() {
  echo -e "${GREEN}========================================${NC}"
  echo -e "${GREEN}Droid Enhancement Script${NC}"
  echo -e "${GREEN}========================================${NC}"
  echo ""
  
  # Change to project root
  cd "$(dirname "$0")/.."
  
  echo -e "${BLUE}Step 1: Adding timestamps to all droids${NC}"
  echo ""
  
  for file in "$DROID_DIR"/*.md; do
    if [ -f "$file" ]; then
      add_timestamps "$file"
    fi
  done
  
  echo ""
  echo -e "${BLUE}Step 2: Adding tool guidelines to assessment droids${NC}"
  echo ""
  
  for droid in "${ASSESSMENT_DROIDS[@]}"; do
    if [ -f "$DROID_DIR/$droid" ]; then
      add_assessment_tool_guidelines "$DROID_DIR/$droid"
      add_task_file_io "$DROID_DIR/$droid" "assessment"
    fi
  done
  
  echo ""
  echo -e "${BLUE}Step 3: Adding tool guidelines to action droids${NC}"
  echo ""
  
  for droid in "${ACTION_DROIDS[@]}"; do
    if [ -f "$DROID_DIR/$droid" ]; then
      add_action_tool_guidelines "$DROID_DIR/$droid"
      add_task_file_io "$DROID_DIR/$droid" "action"
    fi
  done
  
  echo ""
  echo -e "${BLUE}Step 4: Adding task file I/O to orchestration droids${NC}"
  echo ""
  
  for droid in "${ORCHESTRATION_DROIDS[@]}"; do
    if [ -f "$DROID_DIR/$droid" ]; then
      add_timestamps "$DROID_DIR/$droid"
      add_task_file_io "$DROID_DIR/$droid" "orchestration"
    fi
  done
  
  echo ""
  echo -e "${BLUE}Step 5: Adding task file I/O to integration droids${NC}"
  echo ""
  
  for droid in "${INTEGRATION_DROIDS[@]}"; do
    if [ -f "$DROID_DIR/$droid" ]; then
      add_timestamps "$DROID_DIR/$droid"
      add_task_file_io "$DROID_DIR/$droid" "action"
    fi
  done
  
  echo ""
  echo -e "${GREEN}========================================${NC}"
  echo -e "${GREEN}✓ All enhancements complete!${NC}"
  echo -e "${GREEN}========================================${NC}"
  echo ""
  echo -e "${YELLOW}Summary:${NC}"
  echo -e "  • Timestamps added to all droids"
  echo -e "  • Tool usage guidelines added to assessment and action droids"
  echo -e "  • Task file I/O documentation added to all droids"
  echo ""
  echo -e "${YELLOW}Next steps:${NC}"
  echo -e "  1. Review the changes: ${BLUE}git diff${NC}"
  echo -e "  2. Test with a few droids to ensure formatting is correct"
  echo -e "  3. Commit the enhancements: ${BLUE}git add . && git commit -m 'feat: add tool guidelines and task I/O docs to all droids'${NC}"
}

main "$@"
