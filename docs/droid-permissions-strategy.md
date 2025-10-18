# Droid Permissions Strategy

**Version**: 1.0.0  
**Date**: 2025-01-12  
**Source**: Factory.ai Custom Droids Documentation

## Available Tools & Categories

### Tool Categories (from Factory.ai)

| Category | Tools Included | Use Case |
|----------|----------------|----------|
| `read-only` | Read, Grep, Glob, LS | Analysis, assessment, investigation |
| `edit` | Edit, MultiEdit, Create | File modification, code changes |
| `execution` | Execute | Running commands, tests, scripts |
| `web` | WebSearch, FetchUrl | Research, documentation lookup |
| `mcp` | MCP tools | Model Context Protocol integrations |
| `all` | All tools | Full permissions (use sparingly) |

### Individual Tools

| Tool | Purpose | Risk Level |
|------|---------|------------|
| **Read** | Read file contents | Low |
| **LS** | List directory contents | Low |
| **Grep** | Search file contents | Low |
| **Glob** | Pattern-based file search | Low |
| **Edit** | Modify existing files | Medium |
| **MultiEdit** | Multiple edits in one file | Medium |
| **Create** | Create new files | Medium |
| **Execute** | Run shell commands | High |
| **WebSearch** | Search the web | Low |
| **FetchUrl** | Fetch URL content | Low |
| **Task** | Spawn sub-agents | Medium |
| **TodoWrite** | Update task tracking | Low |
| **GenerateDroid** | Generate new droids | Medium |

## Permission Strategy by Droid Type

### 1. Assessment Droids (Read + Create for Task Files)

**Philosophy**: Assessment droids analyze code and **create task files** with findings. They need:
- **Read access** to analyze code
- **Create access** to generate task files
- **NO Edit/MultiEdit** - they should not modify existing code

**Recommended Tools**: `[Execute, Read, LS, Grep, Glob, Create, WebSearch, FetchUrl]`

**Rationale**:
- `Execute` - Run analysis commands (npm audit, tsc, linting)
- `Read, LS, Grep, Glob` - Analyze codebase
- `Create` - Generate task files in `/tasks/` directory
- `WebSearch, FetchUrl` - Research best practices, CVEs, documentation
- **Exclude Edit/MultiEdit** - Assessment droids should not modify code

**Assessment Droids**:
1. ✅ bug-hunter-droid-forge
2. ✅ code-smell-assessment-droid-forge
3. ✅ cognitive-complexity-assessment-droid-forge
4. ✅ debugging-assessment-droid-forge
5. ✅ impact-analyzer-droid-forge
6. ✅ plan-review-droid-forge
7. ✅ security-assessment-droid-forge
8. ✅ security-audit-droid-forge
9. ✅ test-assessment-droid-forge
10. ✅ typescript-assessment-droid-forge
11. ❌ auth-assessment-droid-forge (currently has Edit/MultiEdit)
12. ❌ caching-assessment-droid-forge (currently has Edit/MultiEdit)
13. ❌ database-performance-assessment-droid-forge (currently has Edit/MultiEdit)
14. ❌ drizzle-assessment-droid-forge (currently has Edit/MultiEdit)
15. ❌ nextjs15-assessment-droid-forge (currently has Edit/MultiEdit)
16. ❌ trpc-assessment-droid-forge (currently has Edit/MultiEdit)
17. ❌ typescript-integration-assessment-droid-forge (currently has Edit/MultiEdit)

### 2. Action Droids (Full Edit + Create)

**Philosophy**: Action droids implement fixes and features. They need full modification permissions.

**Recommended Tools**: `[Execute, Read, LS, Edit, MultiEdit, Create, Grep, Glob, WebSearch, FetchUrl]`

**Rationale**:
- `Execute` - Run tests, commands, build tools
- `Read, LS, Grep, Glob` - Understand codebase context
- `Edit, MultiEdit` - Modify existing files
- `Create` - Create new files (components, tests, etc.)
- `WebSearch, FetchUrl` - Research solutions, APIs, documentation

**Action Droids**:
1. ✅ bug-fix-droid-forge (now has Create)
2. ✅ code-refactoring-droid-forge (now has Create)
3. ✅ security-fix-droid-forge (now has Create)
4. ✅ typescript-fix-droid-forge (now has Create)
5. ✅ unit-test-droid-forge (now has Create)
6. ✅ frontend-engineer-droid-forge (now has Create)
7. ✅ backend-engineer-droid-forge (already had Create)

### 3. Specialist/Integration Droids (Full Permissions)

**Philosophy**: Specialist droids implement features in specific domains. They need full permissions.

**Recommended Tools**: `[Execute, Read, LS, Edit, MultiEdit, Create, Grep, Glob, WebSearch, FetchUrl]`

**Specialist Droids**:
1. better-auth-integration-droid-forge
2. drizzle-orm-specialist-droid-forge
3. nextjs15-specialist-droid-forge
4. trpc-tanstack-integration-droid-forge
5. typescript-integration-droid-forge
6. typescript-professional-droid-forge
7. caching-specialist-droid-forge
8. database-performance-droid-forge

### 4. Infrastructure Droids (Specialized Permissions)

**Philosophy**: Infrastructure droids orchestrate workflows and manage processes. Permissions vary by function.

| Droid | Tools | Rationale |
|-------|-------|-----------|
| **manager-orchestrator** | all + Task + TodoWrite + GenerateDroid | Central coordinator needs full access to delegate and track |
| **auto-pr** | Read, Grep, Glob, LS, Task, Execute, Edit, MultiEdit, Create, WebSearch, FetchUrl, TodoWrite | PR automation needs code changes + delegation |
| **reliability** | Read, Grep, Glob, LS, Task, Execute, Edit, MultiEdit, Create, WebSearch, FetchUrl, TodoWrite | Incident response needs full access |
| **task-manager** | Read, Edit, MultiEdit, LS, Create, Grep | Task file management only |
| **ai-dev-tasks-integrator** | FetchUrl, WebSearch, Read, Create, Edit, LS, Execute | PRD → task conversion |
| **git-workflow-orchestrator** | Execute, Read, Edit, MultiEdit, LS, Grep | Git operations + task updates |
| **biome** | Execute, Read, Edit, MultiEdit, LS | Linting and formatting |

## Updated Permission Assignments

### Assessment Droids - Add Create, Remove Edit/MultiEdit

```yaml
tools: [Execute, Read, LS, Grep, Glob, Create, WebSearch, FetchUrl]
```

**Apply to**:
- auth-assessment-droid-forge
- caching-assessment-droid-forge
- database-performance-assessment-droid-forge
- drizzle-assessment-droid-forge
- nextjs15-assessment-droid-forge
- trpc-assessment-droid-forge
- typescript-integration-assessment-droid-forge

**Already correct**:
- bug-hunter-droid-forge
- code-smell-assessment-droid-forge
- cognitive-complexity-assessment-droid-forge
- debugging-assessment-droid-forge
- impact-analyzer-droid-forge
- plan-review-droid-forge
- security-assessment-droid-forge
- security-audit-droid-forge
- test-assessment-droid-forge
- typescript-assessment-droid-forge

### Action Droids - Already Updated ✅

All action droids now have Create permission.

### Specialist Droids - Add Create

```yaml
tools: [Execute, Read, LS, Edit, MultiEdit, Create, Grep, Glob, WebSearch, FetchUrl]
```

**Apply to**:
- better-auth-integration-droid-forge
- drizzle-orm-specialist-droid-forge
- nextjs15-specialist-droid-forge
- trpc-tanstack-integration-droid-forge
- typescript-integration-droid-forge
- typescript-professional-droid-forge
- caching-specialist-droid-forge
- database-performance-droid-forge

## Best Practices

### 1. Principle of Least Privilege
- Give droids only the tools they need for their specific function
- Use tool categories (`read-only`, `edit`) when possible
- Avoid `all` unless truly necessary (manager-orchestrator only)

### 2. Assessment vs. Action Separation
- **Assessment droids**: Analyze + Create task files (NO code modification)
- **Action droids**: Implement fixes + Create new files (full modification)
- This separation prevents accidental code changes during analysis

### 3. Create Permission for Task Files
- Assessment droids NEED `Create` to generate `/tasks/tasks-*.md` files
- This is their primary output mechanism
- Without `Create`, they can only report findings verbally

### 4. WebSearch & FetchUrl
- Essential for research-oriented droids
- Helps find documentation, CVEs, best practices
- Low risk, high value

### 5. Execute Permission
- All droids that run analysis commands need it
- Examples: `npm audit`, `tsc --noEmit`, `biome check`
- Medium risk - be cautious with destructive commands

## Migration Checklist

- [x] Remove Edit/MultiEdit from 7 assessment droids that had them incorrectly
- [x] Add Create to all 7 action droids
- [x] Add Create to assessment droids (need to verify they don't already have it)
- [ ] Add Create to all 8 specialist droids
- [ ] Verify infrastructure droids have appropriate permissions
- [ ] Update AGENTS.md with permission guidelines
- [ ] Test a few droids to verify permissions work correctly

## Testing Strategy

After permission updates:
1. Test an assessment droid (e.g., bug-hunter) - should create task file successfully
2. Test an action droid (e.g., bug-fix) - should modify code and create files
3. Test manager-orchestrator - should be able to delegate to sub-agents
4. Verify no droids have unnecessary permissions

## Summary

**Key Insight**: Assessment droids need `Create` permission to generate task files, but should NOT have `Edit`/`MultiEdit` to prevent accidental code modification during analysis.

**Permission Tiers**:
1. **Read-Only + Create**: Assessment droids (`[Execute, Read, LS, Grep, Glob, Create, WebSearch, FetchUrl]`)
2. **Full Edit + Create**: Action droids (`[Execute, Read, LS, Edit, MultiEdit, Create, Grep, Glob, WebSearch, FetchUrl]`)
3. **Specialized**: Infrastructure droids (varies by function)
4. **All Tools**: Manager-orchestrator only
