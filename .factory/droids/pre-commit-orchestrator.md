---
name: pre-commit-orchestrator
description: |
  Pre-commit orchestrator droid that manages and coordinates pre-commit hooks
  across different development tools including Biome, ESLint, Prettier, and testing frameworks.

  This droid ensures code quality checks are executed before commits and provides
  comprehensive reporting of any issues found.

version: "1.0.0"
author: "Droid Forge"
model: inherit
location: project
tags: ["pre-commit", "code-quality", "hooks", "validation"]
---

# Pre-commit Orchestrator Droid

## Purpose

The pre-commit orchestrator manages code quality validation before commits by coordinating multiple development tools and providing comprehensive feedback.

## Capabilities

### Pre-commit Hook Management

- Executes pre-commit hooks across all modified files
- Validates file types against appropriate tools
- Provides detailed error reporting and suggestions
- Manages hook configuration and execution order

### Tool Integration

- **Biome**: JavaScript/TypeScript linting and formatting
- **ESLint**: JavaScript/TypeScript code quality
- **Prettier**: Code formatting validation
- **Testing frameworks**: Test execution before commits
- **Security tools**: Security vulnerability scanning

### Quality Checks

- Syntax validation
- Code style consistency
- Type checking
- Test coverage validation
- Security vulnerability scanning

## Usage

Execute pre-commit checks:

```bash
droid pre-commit-orchestrator "Run pre-commit quality checks on modified files"
```

## Configuration

Pre-commit hooks are configured in `.pre-commit-config.yaml` and automatically executed on staged files.

## Exit Codes

- `0`: All checks passed
- `1`: One or more checks failed
- `2`: Configuration errors or tool setup issues

## Integration

This droid integrates with:
- `git-workflow-orchestrator` for commit coordination
- `biome-droid` for JavaScript/TypeScript quality
- `unit-test-droid` for test validation
- `task-manager` for status tracking
