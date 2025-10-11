# Tasks: One-Shot Autonomous Execution Mode Implementation

**Based on**: PRD-0001-one-shot-mode.md  
**Status**: Ready for implementation  
**Created**: 2025-10-11

---

## Relevant Files

### Documentation
- `AGENTS.md` - Main agent guidelines (to be updated with mode selection)
- `tasks/prd-0001-one-shot-mode.md` - Product requirements document

### Droid Specifications
- `.factory/droids/manager-orchestrator-droid-forge.md` - Manager orchestrator (to be enhanced)
- `.factory/droids/frontend-engineer-droid-forge.md` - Frontend droid (to be enhanced)
- `.factory/droids/backend-engineer-droid-forge.md` - Backend droid (to be enhanced)
- `.factory/droids/unit-test-droid-forge.md` - Testing droid (to be enhanced)
- `.factory/droids/debugging-expert-droid-forge.md` - Debugging droid (to be enhanced)
- `.factory/droids/auto-pr-droid-forge.md` - PR automation droid (to be enhanced)

### Configuration
- `droid-forge.yaml` - Main configuration (to add one-shot config section)

### Scripts & Utilities
- `tools/one-shot-orchestrator.sh` - New one-shot execution engine (to be created)
- `tools/test-automation.sh` - Testing automation script (to be created)
- `tools/quality-gates.sh` - Quality gate checker script (to be created)

### Logs & Reports
- `.droid-forge/logs/` - Execution logs directory (to be created)
- `.droid-forge/reports/` - Execution reports directory (to be created)

---

## Tasks

- [ ] 1.0 Phase 1: Core Mode Selection & Basic Autonomy
  - [ ] 1.1 Add mode selection to Manager Orchestrator
  - [ ] 1.2 Implement mode detection and storage in execution context
  - [ ] 1.3 Create basic one-shot execution loop (no confirmation between sub-tasks)
  - [ ] 1.4 Implement automatic commit per sub-task
  - [ ] 1.5 Implement immediate push after each commit
  - [ ] 1.6 Add basic execution logging to console
  - [ ] 1.7 Update AGENTS.md with mode selection documentation
  - [ ] 1.8 Test mode selection with simple 3-task example

- [ ] 2.0 Phase 2: Testing Automation
  - [ ] 2.1 Create test-automation.sh script for unit test generation
  - [ ] 2.2 Integrate unit test generation after each sub-task
  - [ ] 2.3 Implement automatic unit test execution
  - [ ] 2.4 Add integration test generation per major task
  - [ ] 2.5 Implement automatic integration test execution
  - [ ] 2.6 Add E2E test generation for complete features
  - [ ] 2.7 Implement automatic E2E test execution
  - [ ] 2.8 Add test failure detection and retry logic (max 3 attempts)
  - [ ] 2.9 Implement test failure rollback mechanism
  - [ ] 2.10 Add code coverage calculation and reporting (90%+ threshold)
  - [ ] 2.11 Block progression on test failures until tests pass
  - [ ] 2.12 Test with failing test scenario to verify retry and rollback

- [ ] 3.0 Phase 3: Quality Gates
  - [ ] 3.1 Create quality-gates.sh script for all quality checks
  - [ ] 3.2 Integrate Biome linting with automatic execution
  - [ ] 3.3 Implement auto-fix for linting errors
  - [ ] 3.4 Add lint failure retry until pass
  - [ ] 3.5 Integrate Biome code formatting with automatic execution
  - [ ] 3.6 Implement security scanning integration (CodeRabbit API)
  - [ ] 3.7 Add critical security issue detection and human escalation
  - [ ] 3.8 Integrate TypeScript type checking
  - [ ] 3.9 Implement type error auto-fix attempts
  - [ ] 3.10 Block commits until all quality gates pass
  - [ ] 3.11 Add quality gate status to execution logs
  - [ ] 3.12 Test with intentional quality violations to verify blocking

- [ ] 4.0 Phase 4: PR Management & Iterative Review
  - [ ] 4.1 Implement PR creation per major task
  - [ ] 4.2 Add PR description generation with summary
  - [ ] 4.3 Implement automated review comment monitoring (CodeRabbit, GitHub Actions)
  - [ ] 4.4 Add feedback categorization (code, style, security, tests, logic)
  - [ ] 4.5 Implement iterative fix cycle for PR feedback
  - [ ] 4.6 Add fix commit and push automation
  - [ ] 4.7 Implement PR iteration counter (max 5 iterations)
  - [ ] 4.8 Add CI/CD pipeline monitoring
  - [ ] 4.9 Implement automatic CI/CD failure fixes
  - [ ] 4.10 Add PR status update comments
  - [ ] 4.11 Implement "PR clean" detection
  - [ ] 4.12 Test PR review cycle with intentional issues

- [ ] 5.0 Phase 5: Error Handling & Recovery
  - [ ] 5.1 Implement test failure retry counter (max 3 per sub-task)
  - [ ] 5.2 Add sub-task commit rollback on test failure
  - [ ] 5.3 Implement human escalation after 3 test failures
  - [ ] 5.4 Add commit failure detection and rollback
  - [ ] 5.5 Implement sub-task restart after commit failure
  - [ ] 5.6 Add commit retry counter (max 3 attempts)
  - [ ] 5.7 Implement quality gate auto-fix loop (no retry limit)
  - [ ] 5.8 Add major task rollback on success criteria failure
  - [ ] 5.9 Implement major task retry counter (max 3 attempts)
  - [ ] 5.10 Add architecture decision detection (keyword matching)
  - [ ] 5.11 Implement human escalation for architecture decisions
  - [ ] 5.12 Add critical security issue human escalation
  - [ ] 5.13 Create error recovery state machine
  - [ ] 5.14 Test all error scenarios and recovery paths

- [ ] 6.0 Phase 6: Advanced Features & Optimization
  - [ ] 6.1 Implement parallel sub-task execution (max 3 concurrent)
  - [ ] 6.2 Add dependency detection for sub-tasks
  - [ ] 6.3 Implement parallel execution coordinator
  - [ ] 6.4 Add parallel execution safety (no conflicts)
  - [ ] 6.5 Implement structured logging to `.droid-forge/logs/`
  - [ ] 6.6 Add real-time action logging (every action)
  - [ ] 6.7 Implement sub-task summary generation
  - [ ] 6.8 Add major task summary generation
  - [ ] 6.9 Create final execution report generator
  - [ ] 6.10 Implement execution metrics collection
  - [ ] 6.11 Add execution report output to `.droid-forge/reports/`
  - [ ] 6.12 Test parallel execution with independent sub-tasks

- [ ] 7.0 Phase 7: Configuration & Integration
  - [ ] 7.1 Add one-shot mode configuration to droid-forge.yaml
  - [ ] 7.2 Implement configuration parser for one-shot settings
  - [ ] 7.3 Add mode-specific behavior to all existing droids
  - [ ] 7.4 Implement execution context sharing across droids
  - [ ] 7.5 Add droid delegation rules for one-shot mode
  - [ ] 7.6 Implement ai-dev-tasks status auto-update
  - [ ] 7.7 Add status marker detection and update logic
  - [ ] 7.8 Implement success criteria validation
  - [ ] 7.9 Add success criteria check at major task completion
  - [ ] 7.10 Implement rollback-and-retry logic for criteria failures
  - [ ] 7.11 Test configuration loading and validation
  - [ ] 7.12 Test integration with all existing droids

- [ ] 8.0 Phase 8: Documentation & Examples
  - [ ] 8.1 Complete AGENTS.md mode selection section
  - [ ] 8.2 Add one-shot mode usage guidelines to AGENTS.md
  - [ ] 8.3 Document when to use one-shot vs iterative
  - [ ] 8.4 Update Manager Orchestrator droid documentation
  - [ ] 8.5 Document one-shot execution flow in detail
  - [ ] 8.6 Add troubleshooting guide for common issues
  - [ ] 8.7 Document configuration options in droid-forge.yaml
  - [ ] 8.8 Create example execution log for reference
  - [ ] 8.9 Add error recovery scenarios documentation
  - [ ] 8.10 Document quality gate requirements
  - [ ] 8.11 Add PR review cycle documentation
  - [ ] 8.12 Review all documentation for completeness

- [ ] 9.0 Phase 9: Testing & Validation
  - [ ] 9.1 Create test suite for mode selection
  - [ ] 9.2 Create test suite for autonomous execution
  - [ ] 9.3 Create test suite for testing automation
  - [ ] 9.4 Create test suite for quality gates
  - [ ] 9.5 Create test suite for PR management
  - [ ] 9.6 Create test suite for error handling
  - [ ] 9.7 Create test suite for parallel execution
  - [ ] 9.8 Create integration test for complete workflow
  - [ ] 9.9 Test with simple 3-task feature
  - [ ] 9.10 Test with complex 10-task feature
  - [ ] 9.11 Test all failure scenarios
  - [ ] 9.12 Validate all success criteria

- [ ] 10.0 Phase 10: Production Readiness & Release
  - [ ] 10.1 Performance optimization for test execution
  - [ ] 10.2 Performance optimization for quality gates
  - [ ] 10.3 Performance optimization for PR review cycle
  - [ ] 10.4 Add monitoring and metrics collection
  - [ ] 10.5 Implement execution analytics
  - [ ] 10.6 Add user feedback mechanism
  - [ ] 10.7 Create release notes
  - [ ] 10.8 Update CHANGELOG.md
  - [ ] 10.9 Create migration guide for users
  - [ ] 10.10 Final security audit
  - [ ] 10.11 Final performance validation
  - [ ] 10.12 Release v1.0.0 with one-shot mode

---

## Success Criteria

### Phase 1 Success Criteria
- [ ] User can select mode at workflow start
- [ ] One-shot mode executes 3 sub-tasks without confirmation
- [ ] Commits created automatically (one per sub-task)
- [ ] Commits pushed immediately after creation

### Phase 2 Success Criteria
- [ ] 100% of new code has unit tests
- [ ] Integration tests created per major task
- [ ] E2E tests created for complete feature
- [ ] Test failures trigger retry (max 3)
- [ ] Test failures rollback sub-task after 3 attempts
- [ ] Code coverage ≥ 90%

### Phase 3 Success Criteria
- [ ] Biome linting runs automatically
- [ ] Linting errors auto-fixed
- [ ] Code formatting applied automatically
- [ ] Security scanning integrated (CodeRabbit)
- [ ] Type checking runs automatically
- [ ] All quality gates block progression until pass

### Phase 4 Success Criteria
- [ ] PR created per major task
- [ ] Automated review comments monitored
- [ ] Feedback categorized correctly
- [ ] Issues fixed iteratively (max 5 iterations)
- [ ] CI/CD failures fixed automatically
- [ ] PR becomes clean without human intervention

### Phase 5 Success Criteria
- [ ] Test failures retry up to 3 times
- [ ] Failed commits rollback and retry
- [ ] Quality gates keep trying until pass
- [ ] Major task failures rollback and retry (max 3)
- [ ] Architecture decisions escalate to human
- [ ] Critical security issues escalate to human

### Phase 6 Success Criteria
- [ ] Max 3 sub-tasks execute in parallel
- [ ] Dependencies detected correctly
- [ ] No conflicts in parallel execution
- [ ] Real-time logging to files
- [ ] Sub-task summaries generated
- [ ] Final execution report comprehensive

### Phase 7 Success Criteria
- [ ] Configuration loads from droid-forge.yaml
- [ ] All droids work in both modes
- [ ] Execution context shared across droids
- [ ] Status updates automatic in ai-dev-tasks file
- [ ] Success criteria validated automatically
- [ ] Rollback and retry working correctly

### Phase 8 Success Criteria
- [ ] AGENTS.md documentation complete
- [ ] Manager Orchestrator docs complete
- [ ] Configuration docs complete
- [ ] Troubleshooting guide helpful
- [ ] Examples clear and accurate

### Phase 9 Success Criteria
- [ ] All test suites passing
- [ ] Simple feature test successful
- [ ] Complex feature test successful
- [ ] All failure scenarios tested
- [ ] Integration tests passing

### Phase 10 Success Criteria
- [ ] Performance targets met
- [ ] Monitoring implemented
- [ ] Release notes complete
- [ ] Security audit passed
- [ ] Ready for production use

---

## Notes

### Estimated Effort
- **Phase 1**: 2 weeks
- **Phase 2**: 2 weeks
- **Phase 3**: 2 weeks
- **Phase 4**: 2 weeks
- **Phase 5**: 2 weeks
- **Phase 6**: 2 weeks
- **Phase 7**: 2 weeks
- **Phase 8**: 2 weeks
- **Phase 9**: 2 weeks
- **Phase 10**: 2 weeks
- **Total**: ~20 weeks (5 months)

### Dependencies
- All phases build sequentially
- Phase 2 depends on Phase 1 completion
- Phase 4 depends on Phase 3 (quality gates needed before PR)
- Phase 5 depends on Phases 2-4 (error handling for all systems)
- Phase 6 can run parallel with Phase 5 after Phase 4
- Phases 8-10 are final polish and can overlap

### Risk Mitigation
- Start with simple examples in each phase
- Test thoroughly before moving to next phase
- Keep iterative mode working throughout (backwards compatibility)
- Human escalation available at all stages
- Rollback mechanisms tested early

---

## Execution Strategy

When implementing in **one-shot mode** (yes, we can use it to build itself!):
1. Manager Orchestrator asks: "Do you want me to one-shot or follow the iterative process?"
2. User responds: "one-shot"
3. Execute Phase 1 tasks autonomously (1.1-1.8)
4. Create PR for Phase 1
5. Fix issues iteratively until clean
6. Move to Phase 2
7. Repeat for all 10 phases

---

**End of Task Breakdown**
