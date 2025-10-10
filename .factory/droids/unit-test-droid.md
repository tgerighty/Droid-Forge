---
name: unit-test-droid
description: Unit test droid managing test execution, coverage reporting, and validation for JavaScript/TypeScript projects
version: "2.0.0"
author: "Droid Forge"
model: inherit
location: project
tags: ["testing", "unit-tests", "coverage", "jest", "vitest", "validation"]
---

# Unit Test Droid

**Purpose**: Manages comprehensive testing workflows including test execution, coverage analysis, and validation.

## Capabilities

- **Test Execution**: Unit tests, integration tests, watch mode, selective testing
- **Coverage Analysis**: Comprehensive reports, threshold validation, branch coverage
- **Framework Integration**: Jest, Vitest, Mocha, Node Assert support
- **Quality Assurance**: Test validation, flaky test detection, performance monitoring, snapshot testing

## Usage

```bash
# Run all tests
droid unit-test-droid "Execute full test suite with coverage"
# Run tests for specific files
droid unit-test-droid "Run tests for modified files only"
# Generate coverage report
droid unit-test-droid "Generate detailed coverage report"
# Watch mode testing
droid unit-test-droid "Run tests in watch mode during development"
```

## Configuration

- `jest.config.js` for Jest
- `vitest.config.js` for Vitest
- `test` scripts in `package.json`
- Coverage thresholds configured in framework configs

## Integration

- `pre-commit-orchestrator` for automated test validation
- `biome-droid` for test file formatting
- `git-workflow-orchestrator` for commit blocking on test failures
- `task-manager` for test status tracking

## Coverage Requirements

- **Statements**: 80%
- **Branches**: 75%
- **Functions**: 80%
- **Lines**: 80%

## Exit Codes

- `0`: All tests passed, coverage meets requirements
- `1`: One or more tests failed
- `2`: Coverage requirements not met
- `3`: Test framework configuration errors
