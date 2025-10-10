---
name: biome-droid-forge
description: Biome droid for JavaScript/TypeScript code quality management combining ESLint, Prettier, and TypeScript functionality
version: "2.0.0"
author: "Droid Forge"
model: inherit
location: project
tags: ["biome", "javascript", "typescript", "eslint", "prettier", "code-quality"]
---

# Biome Droid Foundry

**Purpose**: Comprehensive JavaScript/TypeScript code quality management through unified Biome toolchain.

## Capabilities

- **Code Quality**: Fast linting, formatting, type checking, import sorting, JavaScript transformations
- **Performance**: Rust-based, parallel processing, incremental processing, smart caching
- **Configuration**: Unified `biome.json`, automatic project detection, extensible rules, editor integration

## Usage

```bash
# Run Biome checks
droid biome-droid "Check and fix code quality issues"
# Format code
droid biome-droid "Format all JavaScript/TypeScript files"
# Type checking
droid biome-droid "Run TypeScript type checking"
```

## Configuration

`biome.json` in project root:

```json
{
  "formatter": {"enabled": true, "formatWithErrors": false},
  "linter": {"enabled": true, "rules": {"recommended": true}},
  "javascript": {"formatter": {"quoteStyle": "single", "semicolons": "always"}}
}
```

## Integration

- `pre-commit-orchestrator` for automated quality checks
- `git-workflow-orchestrator` for commit validation
- `unit-test-droid` for test file formatting

## Benefits

- **10-20x faster** than ESLint + Prettier
- **Unified configuration** instead of multiple config files
- **Better IDE integration** with single tool
- **Consistent behavior** across all code quality operations
