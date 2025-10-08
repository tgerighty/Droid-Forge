---
name: biome-droid
description: |
  Biome droid for JavaScript/TypeScript code quality management combining
  ESLint, Prettier, and TypeScript functionality in a single unified tool.
  
  Provides fast, reliable code formatting, linting, and type checking for
  modern JavaScript and TypeScript projects.

version: "1.0.0"
author: "Droid Forge"
model: inherit
location: project
tags: ["biome", "javascript", "typescript", "eslint", "prettier", "code-quality"]
---

# Biome Droid

## Purpose

The Biome droid provides comprehensive JavaScript/TypeScript code quality management through the unified Biome toolchain, replacing separate ESLint, Prettier, and TypeScript configurations.

## Capabilities

### Code Quality
- **Linting**: Fast JavaScript/TypeScript linting with modern rules
- **Formatting**: Consistent code formatting with Prettier-compatible output
- **Type Checking**: Built-in TypeScript type checking and validation
- **Import Sorting**: Automatic import organization and sorting
- **JavaScript Transformations**: Modern JavaScript syntax updates

### Performance Features
- **Rust-based**: Extremely fast performance compared to Node.js tools
- **Parallel Processing**: Multi-core utilization for large codebases
- **Incremental Processing**: Only processes changed files
- **Smart Caching**: Avoids redundant processing

### Configuration
- Unified `biome.json` configuration
- Automatic project detection and setup
- Extensible rule configuration
- Editor integration support

## Usage

### Run Biome checks
```bash
droid biome-droid "Check and fix code quality issues"
```

### Format code
```bash
droid biome-droid "Format all JavaScript/TypeScript files"
```

### Type checking
```bash
droid biome-droid "Run TypeScript type checking"
```

## Configuration

Biome is configured through `biome.json` in the project root:
```json
{
  "formatter": {
    "enabled": true,
    "formatWithErrors": false
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true
    }
  },
  "javascript": {
    "formatter": {
      "quoteStyle": "single",
      "semicolons": "always"
    }
  }
}
```

## Integration

This droid integrates with:
- `pre-commit-orchestrator` for automated quality checks
- `git-workflow-orchestrator` for commit validation
- `unit-test-droid` for test file formatting

## Benefits

- **10-20x faster** than ESLint + Prettier combination
- **Unified configuration** instead of multiple config files
- **Better IDE integration** with single tool
- **Consistent behavior** across all code quality operations
