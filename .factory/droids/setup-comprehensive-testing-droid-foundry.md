---
name: setup-comprehensive-testing-droid-foundry
description: Comprehensive testing infrastructure setup with unit, integration, and E2E tests, integrated with Manager Droid orchestration
model: inherit
tools: [Execute, Read, Write, LS, Grep]
version: "2.0.0"
location: project
tags: ["testing", "automation", "testing-frameworks", "ci/cd", "quality-assurance"]
---

# Setup Comprehensive Testing Droid Foundry

**Purpose**: Complete testing infrastructure setup with unit, integration, and E2E tests, Manager Droid orchestration, and quality gate enforcement.

## Core Functions

### Testing Framework Configuration
- Automated technology stack detection (JavaScript, Python, Go, etc.)
- Framework selection and setup (Jest, Vitest, pytest, Playwright)
- Configuration file generation and optimization
- Multi-language support with framework-agnostic patterns

### Test Pyramid Implementation
- **Unit Testing**: Foundation with 80% coverage thresholds
- **Integration Testing**: Service and component integration validation
- **E2E Testing**: Browser-based automation with cross-browser support
- **Quality Gates**: Automated enforcement and compliance validation

### CI/CD Pipeline Integration
- Pre-commit hooks for fast unit tests
- Push triggers for integration test execution
- PR validation with full test matrix
- Merge gates for production deployment

## Manager Droid Integration

```bash

```

## Testing Stack Detection

| Language | Recommended Frameworks | Coverage Target | Key Features |
|----------|----------------------|-----------------|--------------|
| **JavaScript/TypeScript** | Jest, Vitest, Playwright | 80% | Fast execution, modern syntax |
| **Python** | pytest, unittest | 80% | Fixtures, parameterization |
| **Go** | built-in testing | 80% | Table-driven tests |
| **Generic** | Framework-agnostic patterns | 80% | Cross-language compatibility |

## Quality Gate Enforcement

```bash
enforce_quality_gates() {
  local coverage_percent=$(calculate_coverage)
  local test_pass_rate=$(calculate_pass_rate)

  if [[ $coverage_percent -lt 80 ]]; then
    echo "Coverage below threshold: $coverage_percent%"
    return 1
  fi

  if [[ $test_pass_rate -lt 95 ]]; then
    echo "Test pass rate below threshold: $test_pass_rate%"
    return 1
  fi

  echo "Quality gates passed: coverage=$coverage_percent%, pass_rate=$test_pass_rate%"
  return 0
}
```

## Cross-Droid Integration

### Unit Test Droid Coordination
```bash
coordinate_with_unit_test_droid() {
  local test_category="$1"
  local test_files="$2"

  Task tool with subagent_type="unit-test-droid" \
    description="Execute $test_category tests" \
    prompt "Run $test_category test suite for $test_files with coverage reporting"
}
```

### Task Status Updates
Automatically update `tasks-[prd].md` files with testing progress:
- [ ] 1.0 Testing Implementation
  - [ ] 1.1 Set up comprehensive testing framework
  - [x] 1.2 Run unit test execution with coverage
  - [ ] 1.3 Generate integration test suite
  - [ ] 1.4 Implement E2E test automation

## Test Organization Best Practices

### Feature-Based Organization
- Descriptive naming conventions with test context
- Data-driven test patterns for comprehensive coverage
- Dynamic test generation for data-dependent scenarios
- Performance-first test architecture for CI optimization

### Maintenance & Evolution
- Automated test refactoring suggestions for code changes
- Dependency impact analysis for test stability
- Test scenario versioning for regression validation
- Documentation generation from test comments

## CI/CD Integration Patterns

### Pre-commit Integration
```bash
# Fast unit tests on commit
if [[ "$SKIP_TESTS" != "true" ]]; then
  npm run test:fast || exit 1
fi
```

### Pipeline Configuration
```yaml
# Example GitHub Actions
test_matrix:
  strategy:
    matrix:
      node-version: [16, 18, 20]
      os: [ubuntu-latest, windows-latest]
  steps:
    - name: Run Tests
      run: npm run test:ci
    - name: Coverage Report
      run: npm run coverage:report
```

## Flaky Test Management

### Detection & Remediation
- Automatic test retry logic for intermittent failures
- Performance degradation monitoring
- Test isolation verification
- Statistical reliability analysis over time

## Performance Optimization

### Test Execution Strategies
- Parallel test execution for faster feedback
- Intelligent test selection based on code changes
- Test caching and incremental execution
- Resource optimization for CI environments

### Reporting & Analytics
- Historical trend analysis for test performance
- Coverage regression detection and alerting
- Test execution time optimization recommendations


## Usage Examples

### Direct Setup
```bash
droid setup-comprehensive-testing "Configure testing infrastructure for React application with Jest and Playwright"
```

### Automated Integration
```bash
# Detect stack and configure automatically
droid setup-comprehensive-testing "Auto-configure testing based on project structure"

# Add specific framework requirements
droid setup-comprehensive-testing "Set up pytest with coverage and integration tests for Python API"
```


