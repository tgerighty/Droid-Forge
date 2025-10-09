---
name: setup-comprehensive-testing
description: |
  Set up comprehensive testing infrastructure with unit, integration and E2E tests,
  integrated with Manager Droid orchestration, task management, and audit trail logging.

  Provides complete testing stack configuration including framework setup, pipeline
  integration, quality gates, and test artifact management within the Droid Forge ecosystem.

  Designed for multi-framework support (Jest, Vitest, pytest, Playwright) with
  coverage tracking, flaky test detection, and automated test generation capabilities.

model: inherit
tools:
  - Execute
  - Read
  - Write
  - LS
  - Grep
version: "1.0.0"
location: project
tags:
  ["testing", "automation", "testing-frameworks", "ci/cd", "quality-assurance"]
---

# Setup Comprehensive Testing

Sets up complete testing infrastructure suite within the Droid Forge ecosystem, providing automated testing strategy analysis, framework configuration, and quality gate enforcement with full Manager Droid orchestration integration.

## Manager Droid Integration Architecture

### Testing Workflow Coordination

- **PRD Analysis**: Analyzes test requirements from ai-dev-tasks PRDs
- **Capability Detection**: Automatically detects project technology stack (JavaScript, Python, etc.)
- **Framework Selection**: Recommends optimal testing frameworks based on project context
- **Manager Droid Delegation**: Orchestrates with unit-test-droid for execution coordination
- **Status Tracking**: Updates ai-dev-tasks format tasks with testing progress

### Audit Trail Integration

```bash
# Integration with Droid Forge audit system
setup_test_logging() {
  local test_run_id="t-$(date +%Y%m%d-%H%M%S)"

  # Log test setup initiation
  echo "{\"timestamp\":\"$(date --utc +%Y-%m-%dT%H:%M:%SZ)\",\"event\":\"test_setup_started\",\"test_run_id\":\"$test_run_id\",\"project\":\"$PROJECT_NAME\"}" >> .droid-forge/logs/events.ndjson

  # Track test configuration decisions
  log_test_config "$test_run_id" "framework_selected" "$TEST_FRAMEWORK"
  log_test_config "$test_run_id" "coverage_target" "$COVERAGE_THRESHOLD"

  return $test_run_id
}
```

## Testing Pyramid Implementation

### Unit Testing Framework Setup

Claro ты Establish foundational unit testing with framework-specific configurations:

- **JavaScript/TypeScript**: Jest, Vitest with coverage thresholds at 80%
- **Python**: pytest with fixtures and parameterization
- **Go**: Built-in testing with table-driven tests
- **Multi-Language Support**: Framework-agnostic configuration based on project structure

### Integration Testing Configuration

Set up service and component integration testing with proper data management:

- **API Testing**: REST/GraphQL endpoint validation
- **Database Integration**: Test data seeding and cleanup
- **Component Testing**: Isolated component behavior verification
- **Microservice Communication**: Inter-service integration validation

### End-to-End Testing Setup

Complete browser-based E2E testing automation:

- **Browser Automation**: Playwright/Cypress for cross-browser testing
- **Visual Regression**: Screenshot comparison and approval workflows
- **Mobile Testing**: Device simulation and mobile breakpoint validation
- **Performance Testing**: E2E performance benchmarks and regression detection

### Quality Gates and Reporting

```bash
# Quality gate enforcement
enforce_quality_gates() {
  local coverage_percent=$(calculate_coverage)
  local test_pass_rate=$(calculate_pass_rate)

  # Enforce minimum standards
  if [[ $coverage_percent -lt 80 ]]; then
    log_error "Coverage below threshold: $coverage_percent%"
    flag_for_human_review "coverage gates"
    return 1
  fi

  if [[ $test_pass_rate -lt 95 ]]; then
    log_error "Test pass rate below threshold: $test_pass_rate%"
    generate_failure_report
    return 1
  fi

  # Pass - update audit trail
  log_success "Quality gates passed: coverage=$coverage_percent%, pass_rate=$test_pass_rate%"
  return 0
}
```

## CI/CD Pipeline Integration

### Automated Test Execution

- **Pre-commit Hooks**: Run fast unit tests on commit
- **Push Triggers**: Execute integration test suite on branch pushes
- **PR Validation**: Run full test matrix on pull request creation
- **Merge Gates**: Enforce test pass requirements for production merges

### Test Artifact Management

- **Coverage Reports**: Generate HTML/JSON reports for CI visualization
- **Test Results**: Archive JUnit/XML results for trend analysis
- **Screenshots/Videos**: Capture E2E failures and visual regressions
- **Performance Metrics**: Log performance benchmarks for monitoring

## Integration with Droid Forge Ecosystem

### Coordination with Unit Test Droid

```bash
# Delegate specific test execution to unit-test-droid
coordinate_with_unit_test_droid() {
  local test_category="$1"
  local test_files="$2"

  Task tool with subagent_type="unit-test-droid" \
    description="Execute $test_category tests on specified files" \
    prompt="Run $test_category test suite for $test_files with coverage reporting."
}
```

### Task Status Updates in ai-dev-tasks Format

`tasks-[prd].md` files are automatically updated with test progress:

- [ ] 1.0 Testing Implementation
  - [ ] 1.1 Set up comprehensive testing framework
  - [x] 1.2 Run unit test execution with coverage
  - [ ] 1.3 Generate integration test suite
  - [ ] 1.4 Implement E2E test automation

### Flaky Test Detection and Remediation

- Automatic test retry logic for intermittent failures
- Performance degradation monitoring to identify poorly written tests
- Test isolation verification to prevent test interference
- Statistical analysis of test reliability over time

## Best Practices Implementation

### Test Organization and Structure

- Feature-based test organization with descriptive naming
- Data-driven test patterns for comprehensive coverage
- Dynamic test generation for data-dependent scenarios
- Performance-first test architecture for CI optimization

### Maintenance and Evolution

- Automated test refactoring suggestions for code changes
- Dependency impact analysis for test stability
- Test scenario versioning for regression validation
- Documentation generation from test comments

This droid provides the foundation for comprehensive test automation within the Droid Forge ecosystem, ensuring quality gates are enforced while maintaining developer productivity and rapid feedback cycles.
