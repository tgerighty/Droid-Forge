# Shared Guidelines for All Droids

This document provides standardized guidelines that should be referenced by all droids to maintain consistency across the Droid Forge ecosystem.

## Common Tool Guidelines

### Execute Tool
**Purpose**: Running commands, testing, validation, and system operations

#### Standard Allowed Commands
**Testing & Validation**:
- `npm test`, `npm run test:coverage` - Test suites and coverage
- `pytest`, `jest --coverage`, `vitest run` - Framework-specific testing
- `biome check`, `eslint .` - Code quality and linting
- `tsc --noEmit` - TypeScript type checking
- `docker build` - Container operations

**Analysis & Inspection**:
- `rg` - Fast grep for code analysis (preferred over `grep`)
- `find` - File system operations
- `cat`, `head`, `tail` - File content inspection
- `stat` - File metadata and properties

**Database Operations**:
- Database client commands (psql, mysql, mongosh)
- Migration commands (when safe)
- Connection testing and validation

#### Caution Commands (Ask User First)
**Production Changes**:
- Database migrations in production
- Service restarts in production
- Configuration changes affecting live systems

**Destructive Operations**:
- `rm -rf` - Recursive deletion
- Database DROP statements
- Force pushes (git push --force)

**System Changes**:
- System package installs (unless specified)
- Configuration file changes in system directories

### Edit & MultiEdit Tools
**Purpose**: Code modification, refactoring, and file creation

#### Best Practices
1. **Read First**: Always understand context before editing
2. **Backup Strategy**: Consider creating backups before major changes
3. **Test After Changes**: Verify edits work correctly
4. **Follow Project Standards**: Maintain code style and patterns

#### Allowed Operations
- Code refactoring and optimization
- Configuration updates
- Test file creation and modification
- Documentation updates

### Create Tool
**Purpose**: Generating new files, templates, and documentation

#### Allowed Paths
- **Project Source**: `/src/**` - Source code files
- **Tests**: `/tests/**` - Test files
- **Documentation**: `/docs/**` - Documentation
- **Configuration**: Config files (as appropriate for project)
- **Tasks**: `/tasks/**` - Task management files

#### Security Considerations
- Never create files with hardcoded secrets
- Use environment variables for sensitive data
- Follow project security standards

## Versioning Standards

### Semantic Versioning
**Format**: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes, API changes
- **MINOR**: New features, backward-compatible changes
- **PATCH**: Bug fixes, security patches

### Implementation Guidelines
- Update `version` field in YAML frontmatter
- Update `updatedAt` field to current date
- Include changelog in droid documentation
- Follow semantic versioning principles

## Error Handling Patterns

### Standard Error Handling
```typescript
// Consistent error handling pattern
async function operation() {
  try {
    const result = await riskyOperation();
    return { success: true, data: result };
  } catch (error) {
    console.error('Operation failed:', error);
    return { 
      success: false, 
      error: error instanceof Error ? error.message : 'Unknown error' 
    };
  }
}
```

### Error Recovery Strategies
1. **Graceful Degradation**: Provide fallback behavior when possible
2. **Clear Error Messages**: Include actionable error descriptions
3. **Logging**: Log errors with appropriate severity levels
4. **User Communication**: Provide clear feedback to users

## Task File Integration Standards

### Status Markers
- `[ ]` - Pending task
- `[~]` - Task in progress
- `[x]` - Completed task
- `[!]` - Blocked task

### File Naming Convention
- Format: `tasks/tasks-[domain]-[purpose].md`
- Examples:
  - `tasks/typescript-analysis.md`
  - `tasks/security-assessment.md`
  - `tasks/frontend-implementation.md`

### Task Structure Template
```markdown
## Relevant Files
- `src/example.ts` - Description
- `tests/example.test.ts` - Description

## Tasks
- [ ] 1.0 Category Name
  - [ ] 1.1 Specific task description
  - [ ] 1.2 Another task
```

## Security Standards

### Secret Management
- Never hardcode passwords, API keys, or tokens
- Use environment variables for sensitive data
- Reference configuration through `.env` files or secure storage
- Follow principle of least privilege

### Input Validation
- Validate all user inputs and parameters
- Sanitize data before processing
- Use appropriate TypeScript types for validation
- Implement proper error handling for invalid inputs

### Permission Boundaries
- **Assessment Droids**: Read-only operations, no destructive changes
- **Action Droids**: Read-write operations within defined boundaries
- **Infrastructure Droids**: System-level operations with explicit authorization

## Documentation Standards

### Markdown Format
- Use consistent heading hierarchy (##, ###, ####)
- Include code blocks with appropriate language tags
- Use bullet points for lists and examples
- Add proper table formatting when needed

### Code Examples
- **Language Tags**: Specify language in code blocks (```typescript, ```bash, ```sql)
- **Conciseness**: Keep examples focused on key concepts
- **Comments**: Add brief explanations for complex logic
- **Formatting**: Follow language-specific formatting standards

### Accessibility
- Use descriptive alt text for images and diagrams
- Ensure color contrast meets accessibility standards
- Use semantic HTML structure where applicable
- Provide keyboard navigation alternatives

## Quality Assurance

### Testing Standards
- Include unit tests for core functionality
- Provide integration examples where applicable
- Document expected behavior and edge cases
- Include error handling test scenarios

### Review Process
- Peer review for new droid implementations
- Consistency checks against this template
- Validation of tool usage guidelines
- Testing of task file integration patterns

---

**Purpose**: Shared guidelines for droid consistency and quality
**Maintainer**: Droid Forge Team
**Updated**: 2025-10-14
**Version**: 1.0.0
