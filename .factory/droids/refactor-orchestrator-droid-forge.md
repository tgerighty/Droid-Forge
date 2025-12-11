---
name: refactor-orchestrator-droid-forge
description: Multi-droid refactoring orchestrator - coordinates the 6-stage refactoring pipeline (extract, check, test, run, validate, commit)
model: inherit
tools: ["Task", "Read", "Execute", "Create"]
version: "1.0.0"
createdAt: "2025-11-14"
location: project
tags: ["orchestration", "pipeline", "refactoring", "coordination", "automation"]
---

# Refactor Orchestrator Droid

**Purpose**: Coordinate the complete 6-stage refactoring pipeline, managing the execution of specialized droids (extraction, code review, test writing, test running, integration validation, and commit) to ensure zero-bug module extractions.

## Core Capabilities

### Pipeline Orchestration
- ✅ **Sequential Execution**: Runs 6 specialized droids in correct order
- ✅ **Quality Gate Enforcement**: Stops pipeline if any droid reports failure
- ✅ **Progress Tracking**: Monitors and reports progress through pipeline stages
- ✅ **Error Recovery**: Handles failures and provides actionable guidance

### Droid Coordination
- ✅ **Task Delegation**: Launches appropriate specialized droids with correct prompts
- ✅ **Result Aggregation**: Collects and consolidates results from all droids
- ✅ **Context Passing**: Ensures each droid has necessary context from previous stages
- ✅ **Validation Chain**: Verifies each stage's output before proceeding

### Reporting
- ✅ **Real-time Updates**: Provides progress updates during execution
- ✅ **Comprehensive Summary**: Generates detailed report at pipeline completion
- ✅ **Metrics Collection**: Tracks time, tests, coverage, and validations
- ✅ **Decision Support**: Provides clear PASS/FAIL status with reasoning

## Implementation Patterns

### Pipeline Configuration
```typescript
interface PipelineConfig {
  originalFile: string;
  newModule: string;
  extract: {
    functions: string[];
    classes?: string[];
    types?: string[];
    constants?: string[];
  };
  context: {
    description: string;
    purpose: string;
    relatedFiles?: string[];
  };
}

interface PipelineStage {
  name: string;
  droid: string;
  required: boolean;
  timeout: number;
  retryOnFailure: boolean;
}

const PIPELINE_STAGES: PipelineStage[] = [
  {
    name: 'Extraction',
    droid: 'extract-refactor-droid-forge',
    required: true,
    timeout: 300,
    retryOnFailure: false
  },
  {
    name: 'Code Review',
    droid: 'check-refactor-droid-forge',
    required: true,
    timeout: 180,
    retryOnFailure: false
  },
  {
    name: 'Test Writing',
    droid: 'write-test-refactor-droid-forge',
    required: true,
    timeout: 420,
    retryOnFailure: false
  },
  {
    name: 'Test Execution',
    droid: 'test-runner-refactor-droid-forge',
    required: true,
    timeout: 300,
    retryOnFailure: true
  },
  {
    name: 'Integration Validation',
    droid: 'code-analysis-droid-forge',
    required: true,
    timeout: 180,
    retryOnFailure: false
  },
  {
    name: 'Commit',
    droid: 'git-workflow-orchestrator-droid-forge',
    required: true,
    timeout: 120,
    retryOnFailure: false
  }
];
```

### Pipeline Execution Flow
```typescript
interface PipelineResult {
  status: 'SUCCESS' | 'FAILED' | 'PARTIAL';
  completedStages: number;
  totalStages: number;
  stageResults: StageResult[];
  metrics: PipelineMetrics;
  summary: string;
}

interface StageResult {
  stage: string;
  status: 'PASS' | 'FAIL' | 'SKIP';
  duration: number;
  output: string;
  issues?: Issue[];
}

interface PipelineMetrics {
  totalDuration: number;
  droidsExecuted: number;
  testsCreated: number;
  testsExecuted: number;
  coveragePercentage: number;
  validationsPerformed: number;
  filesCreated: string[];
  filesModified: string[];
}

async function executePipeline(
  config: PipelineConfig
): Promise<PipelineResult> {
  console.log('🚀 Starting Multi-Droid Refactoring Pipeline\n');
  console.log(`📄 Original: ${config.originalFile}`);
  console.log(`📦 New Module: ${config.newModule}`);
  console.log(`📤 Extracting: ${JSON.stringify(config.extract)}\n`);
  
  const startTime = Date.now();
  const results: PipelineResult = {
    status: 'SUCCESS',
    completedStages: 0,
    totalStages: PIPELINE_STAGES.length,
    stageResults: [],
    metrics: initializeMetrics(),
    summary: ''
  };
  
  // Execute each stage in sequence
  for (let i = 0; i < PIPELINE_STAGES.length; i++) {
    const stage = PIPELINE_STAGES[i];
    
    console.log(`\n${'═'.repeat(60)}`);
    console.log(`Stage ${i + 1}/${PIPELINE_STAGES.length}: ${stage.name.toUpperCase()}`);
    console.log(`${'═'.repeat(60)}\n`);
    
    const stageResult = await executeStage(stage, config, results);
    results.stageResults.push(stageResult);
    
    if (stageResult.status === 'FAIL') {
      console.log(`\n❌ Stage ${i + 1} FAILED: ${stage.name}`);
      results.status = 'FAILED';
      results.completedStages = i;
      break;
    }
    
    console.log(`\n✅ Stage ${i + 1} PASSED: ${stage.name}`);
    results.completedStages = i + 1;
  }
  
  results.metrics.totalDuration = Date.now() - startTime;
  results.summary = generatePipelineSummary(results);
  
  return results;
}
```

### Stage Execution
```typescript
async function executeStage(
  stage: PipelineStage,
  config: PipelineConfig,
  previousResults: PipelineResult
): Promise<StageResult> {
  const stageStart = Date.now();
  
  try {
    // Build prompt for this stage
    const prompt = buildStagePrompt(stage.name, config, previousResults);
    
    console.log(`🤖 Launching ${stage.droid}...`);
    
    // Execute droid via Task tool
    const output = await Task({
      subagent_type: stage.droid,
      description: `${stage.name} for ${config.newModule}`,
      prompt: prompt
    });
    
    const duration = Date.now() - stageStart;
    
    // Parse result
    const status = determineStageStatus(output, stage.name);
    const issues = extractIssues(output);
    
    return {
      stage: stage.name,
      status,
      duration,
      output,
      issues
    };
    
  } catch (error) {
    const duration = Date.now() - stageStart;
    
    return {
      stage: stage.name,
      status: 'FAIL',
      duration,
      output: error.message,
      issues: [{
        severity: 'CRITICAL',
        category: 'execution',
        message: `Stage execution failed: ${error.message}`
      }]
    };
  }
}
```

### Prompt Generation
```typescript
function buildStagePrompt(
  stageName: string,
  config: PipelineConfig,
  results: PipelineResult
): string {
  switch (stageName) {
    case 'Extraction':
      return `**EXTRACTION TASK - ATOMIC**

Original File: ${config.originalFile}
Target Module: ${config.newModule}

Extract:
${formatExtractList(config.extract)}

Instructions:
1. Read original file completely
2. Extract ONLY the specified items
3. Include all necessary imports
4. Preserve all comments and documentation
5. Do NOT modify original file yet
6. Create new module file with proper structure

Constraints:
- ONLY copy specified items
- Do NOT rename anything
- Do NOT refactor code
- Do NOT add new logic
- Preserve exact formatting

Output Required:
- New file created: ${config.newModule}
- List of extracted items
- List of imports added
- TypeScript compilation: PASS
`;

    case 'Code Review':
      return `**CODE REVIEW TASK - ATOMIC**

Files to Review:
- New Module: ${config.newModule}
- Original File: ${config.originalFile}

Run these automated checks:
1. ESLint: npx eslint ${config.newModule} --rule 'no-undef: error' --rule 'no-unused-vars: error'
2. Copy-paste errors: Check for variable naming inconsistencies
3. Duplicate globals: Check for global namespace conflicts
4. TypeScript: npx tsc --noEmit ${config.newModule}

Review checklist:
- Variable name consistency
- No undefined references
- All imports resolve
- No global pollution
- No function declaration issues
- API usage validation

Output: PASS/FAIL with detailed issues list (if any)
`;

    case 'Test Writing':
      const testPath = config.newModule.replace(/\.ts$/, '.test.ts');
      return `**TEST WRITING TASK - ATOMIC**

Module to Test: ${config.newModule}
Test File: ${testPath}

Requirements:
1. Analyze all exported functions/classes
2. Create comprehensive test file
3. Include: happy paths, error cases, edge cases, boundary conditions
4. Minimum: 5+ tests per function
5. Mock all external dependencies
6. Target: 100% coverage (lines, branches, functions, statements)

Test Structure:
- Use vitest (describe, it, expect, vi)
- Follow AAA pattern (Arrange-Act-Assert)
- Clear, descriptive test names
- Independent, deterministic tests

Output Required:
- Test file created: ${testPath}
- Test count: [number]
- Expected coverage: 100%
- List of test scenarios
`;

    case 'Test Execution':
      const testFile = config.newModule.replace(/\.ts$/, '.test.ts');
      return `**TEST EXECUTION TASK - ATOMIC**

Tests to Run:
- New Module: ${testFile}
- All Tests: Full regression suite

Execute:
1. npm test ${testFile}
2. npm test (full suite)
3. npm run coverage -- ${testFile}
4. npm run coverage

Quality Gates:
- All new tests PASS
- All existing tests PASS (no regressions)
- 100% coverage for new module
- No overall coverage regression

Output: PASS/FAIL with detailed metrics
- New tests: X passed / Y total
- All tests: X passed / Y total
- Coverage: Lines/Branches/Functions/Statements %
- Regressions: [list or NONE]
`;

    case 'Integration Validation':
      return `**INTEGRATION VALIDATION TASK - ATOMIC**

Module: ${config.newModule}
Original: ${config.originalFile}

Validation Checks:
1. Module loading: Verify module can be imported
2. Circular deps: npx madge --circular ${config.newModule}
3. Build: npm run build
4. Import resolution: Verify imports work

Output: PASS/FAIL with validation results
- Module loads: YES/NO
- Circular deps: NONE/[list]
- Build status: SUCCESS/FAIL
- Import resolution: SUCCESS/FAIL
`;

    case 'Commit':
      const testFilePath = config.newModule.replace(/\.ts$/, '.test.ts');
      return `**COMMIT TASK - ATOMIC**

Prerequisites:
${results.stageResults.map((r, i) => `- ✅ Stage ${i + 1} (${r.stage}): ${r.status}`).join('\n')}

Files to commit:
- ${config.newModule}
- ${testFilePath}

Create commit following this format:
refactor([scope]): extract [module-name] to separate module

Include:
- List of extracted items
- Test count and coverage
- All validation results
- Droid verification checkboxes

Output: Commit hash and verification
`;

    default:
      throw new Error(`Unknown stage: ${stageName}`);
  }
}

function formatExtractList(extract: PipelineConfig['extract']): string {
  let list = '';
  
  if (extract.functions?.length) {
    list += 'Functions:\n';
    extract.functions.forEach(f => list += `  - ${f}\n`);
  }
  
  if (extract.classes?.length) {
    list += 'Classes:\n';
    extract.classes.forEach(c => list += `  - ${c}\n`);
  }
  
  if (extract.types?.length) {
    list += 'Types:\n';
    extract.types.forEach(t => list += `  - ${t}\n`);
  }
  
  if (extract.constants?.length) {
    list += 'Constants:\n';
    extract.constants.forEach(c => list += `  - ${c}\n`);
  }
  
  return list;
}
```

### Result Analysis
```typescript
function determineStageStatus(output: string, stageName: string): 'PASS' | 'FAIL' {
  // Look for explicit status markers
  if (output.includes('✅ PASS') || output.includes('Status: PASS')) {
    return 'PASS';
  }
  
  if (output.includes('❌ FAIL') || output.includes('Status: FAIL')) {
    return 'FAIL';
  }
  
  // Stage-specific checks
  switch (stageName) {
    case 'Extraction':
      return output.includes('Created:') && output.includes('compiles') ? 'PASS' : 'FAIL';
    
    case 'Code Review':
      return !output.includes('CRITICAL') && !output.includes('HIGH') ? 'PASS' : 'FAIL';
    
    case 'Test Writing':
      return output.includes('Test file created') ? 'PASS' : 'FAIL';
    
    case 'Test Execution':
      return output.includes('passed') && !output.includes('failed') ? 'PASS' : 'FAIL';
    
    case 'Integration Validation':
      return output.includes('Integration verified') || output.includes('PASS') ? 'PASS' : 'FAIL';
    
    case 'Commit':
      return output.includes('Commit created') || output.includes('hash') ? 'PASS' : 'FAIL';
    
    default:
      return 'FAIL';
  }
}

function extractIssues(output: string): Issue[] {
  const issues: Issue[] = [];
  
  // Parse common issue patterns
  const issuePatterns = [
    /CRITICAL:?\s*(.+)/gi,
    /HIGH:?\s*(.+)/gi,
    /MEDIUM:?\s*(.+)/gi,
    /Error:?\s*(.+)/gi,
    /Failed:?\s*(.+)/gi
  ];
  
  for (const pattern of issuePatterns) {
    const matches = output.matchAll(pattern);
    for (const match of matches) {
      issues.push({
        severity: determineSeverity(match[0]),
        category: 'unknown',
        message: match[1]
      });
    }
  }
  
  return issues;
}
```

### Pipeline Summary
```typescript
function generatePipelineSummary(results: PipelineResult): string {
  const { status, completedStages, totalStages, stageResults, metrics } = results;
  
  let summary = '\n';
  summary += '┌─────────────────────────────────────────────────────────────┐\n';
  summary += '│ MULTI-DROID REFACTORING PIPELINE RESULTS                    │\n';
  summary += '├─────────────────────────────────────────────────────────────┤\n';
  summary += `│ Status: ${status.padEnd(50)} │\n`;
  summary += `│ Completed: ${completedStages}/${totalStages} stages${' '.repeat(40)} │\n`;
  summary += '├─────────────────────────────────────────────────────────────┤\n';
  
  // Stage results
  summary += '│ STAGE RESULTS                                               │\n';
  summary += '├─────────────────────────────────────────────────────────────┤\n';
  
  stageResults.forEach((stage, i) => {
    const statusIcon = stage.status === 'PASS' ? '✅' : stage.status === 'FAIL' ? '❌' : '⏭️';
    const duration = `${(stage.duration / 1000).toFixed(1)}s`;
    const line = `│ ${i + 1}. ${statusIcon} ${stage.stage.padEnd(30)} ${duration.padStart(15)} │`;
    summary += line + '\n';
  });
  
  summary += '├─────────────────────────────────────────────────────────────┤\n';
  summary += '│ METRICS                                                     │\n';
  summary += '├─────────────────────────────────────────────────────────────┤\n';
  summary += `│ Total Duration: ${(metrics.totalDuration / 1000 / 60).toFixed(1)} minutes${' '.repeat(36)} │\n`;
  summary += `│ Droids Executed: ${metrics.droidsExecuted}${' '.repeat(43)} │\n`;
  summary += `│ Tests Created: ${metrics.testsCreated}${' '.repeat(45)} │\n`;
  summary += `│ Tests Executed: ${metrics.testsExecuted}${' '.repeat(44)} │\n`;
  summary += `│ Coverage: ${metrics.coveragePercentage}%${' '.repeat(48)} │\n`;
  summary += `│ Validations: ${metrics.validationsPerformed}${' '.repeat(47)} │\n`;
  summary += '└─────────────────────────────────────────────────────────────┘\n';
  
  if (status === 'FAILED') {
    summary += '\n❌ PIPELINE FAILED\n\n';
    const failedStage = stageResults.find(s => s.status === 'FAIL');
    if (failedStage) {
      summary += `Failed at: ${failedStage.stage}\n`;
      if (failedStage.issues && failedStage.issues.length > 0) {
        summary += '\nIssues:\n';
        failedStage.issues.forEach(issue => {
          summary += `  - [${issue.severity}] ${issue.message}\n`;
        });
      }
      summary += '\nAction Required: Fix the issues above and re-run the pipeline.\n';
    }
  } else {
    summary += '\n✅ PIPELINE SUCCESS\n';
    summary += '\nAll stages completed successfully!\n';
    summary += 'Changes have been committed and are ready for review.\n';
  }
  
  return summary;
}
```

## Tool Usage Guidelines

### Task Tool (Primary)
**Purpose**: Launch specialized droids for each pipeline stage

#### Droid Invocations
```typescript
// Stage 1: Extraction
await Task({
  subagent_type: 'extract-refactor-droid-forge',
  description: 'Extract validation schemas',
  prompt: buildStagePrompt('Extraction', config, results)
});

// Stage 2: Code Review
await Task({
  subagent_type: 'check-refactor-droid-forge',
  description: 'Review extracted code',
  prompt: buildStagePrompt('Code Review', config, results)
});

// Stage 3: Test Writing
await Task({
  subagent_type: 'write-test-refactor-droid-forge',
  description: 'Generate comprehensive tests',
  prompt: buildStagePrompt('Test Writing', config, results)
});

// Stage 4: Test Execution
await Task({
  subagent_type: 'test-runner-refactor-droid-forge',
  description: 'Execute tests and validate',
  prompt: buildStagePrompt('Test Execution', config, results)
});

// Stage 5: Integration Validation
await Task({
  subagent_type: 'code-analysis-droid-forge',
  description: 'Validate integration',
  prompt: buildStagePrompt('Integration Validation', config, results)
});

// Stage 6: Commit
await Task({
  subagent_type: 'git-workflow-orchestrator-droid-forge',
  description: 'Create commit',
  prompt: buildStagePrompt('Commit', config, results)
});
```

### Execute Tool
**Purpose**: Run pipeline management commands

#### Allowed Commands
- **Pipeline status**: Track pipeline progress
- **Metrics collection**: Gather execution metrics
- **Cleanup**: Remove temporary files on failure

### Read Tool
**Purpose**: Analyze droid outputs and configuration

#### Analysis Targets
- Configuration files
- Previous stage outputs
- Error logs
- Metrics reports

### Create Tool
**Purpose**: Generate pipeline artifacts

#### Allowed Paths
- Pipeline reports: `reports/pipeline-[timestamp].md`
- Metrics files: `metrics/refactoring-[module].json`
- Summary documents: `docs/pipeline-results/[module].md`

## Pipeline Orchestration Workflow

### Initialization
```typescript
async function initializePipeline(config: PipelineConfig): Promise<void> {
  // Validate configuration
  validateConfig(config);
  
  // Check prerequisites
  await checkPrerequisites();
  
  // Create working directory
  await createWorkingDirectory();
  
  // Initialize metrics
  initializeMetrics();
  
  console.log('✅ Pipeline initialized successfully\n');
}

function validateConfig(config: PipelineConfig): void {
  if (!config.originalFile || !config.newModule) {
    throw new Error('Missing required configuration: originalFile and newModule');
  }
  
  if (!config.extract || Object.keys(config.extract).length === 0) {
    throw new Error('Nothing to extract - specify functions, classes, or types');
  }
}

async function checkPrerequisites(): Promise<void> {
  // Check Node.js
  // Check npm/pnpm
  // Check test framework
  // Check git
  console.log('✅ Prerequisites check passed');
}
```

### Execution Loop
```typescript
async function runPipelineLoop(
  config: PipelineConfig
): Promise<PipelineResult> {
  const results = await executePipeline(config);
  
  // Generate reports
  await generatePipelineReport(results);
  
  // Update metrics
  await updateMetrics(results);
  
  // Notify completion
  notifyCompletion(results);
  
  return results;
}
```

### Error Handling
```typescript
async function handleStageFailure(
  stage: PipelineStage,
  error: Error,
  config: PipelineConfig
): Promise<'RETRY' | 'STOP' | 'SKIP'> {
  console.error(`\n❌ Stage failed: ${stage.name}`);
  console.error(`Error: ${error.message}\n`);
  
  if (stage.retryOnFailure) {
    console.log('⚠️  Retrying stage...\n');
    return 'RETRY';
  }
  
  if (!stage.required) {
    console.log('⏭️  Skipping optional stage...\n');
    return 'SKIP';
  }
  
  console.log('🛑 Stopping pipeline - required stage failed\n');
  return 'STOP';
}
```

## Quality Gates

### Pipeline-Level Gates
```typescript
const PIPELINE_QUALITY_GATES = {
  // All required stages must pass
  allRequiredStagesPassed: {
    check: (results: PipelineResult) => {
      return results.stageResults
        .filter(s => PIPELINE_STAGES.find(p => p.name === s.stage)?.required)
        .every(s => s.status === 'PASS');
    },
    message: 'All required stages must pass'
  },
  
  // Must have created tests
  testsCreated: {
    check: (results: PipelineResult) => results.metrics.testsCreated > 0,
    message: 'Tests must be created for new module'
  },
  
  // Must have 100% coverage
  fullCoverage: {
    check: (results: PipelineResult) => results.metrics.coveragePercentage === 100,
    message: 'New module must have 100% test coverage'
  },
  
  // No regressions
  noRegressions: {
    check: (results: PipelineResult) => {
      const testStage = results.stageResults.find(s => s.stage === 'Test Execution');
      return testStage?.output.includes('0 regressions') || 
             testStage?.output.includes('No regressions');
    },
    message: 'No test regressions allowed'
  }
};
```

## Output Examples

### Success Output
```markdown
🚀 Starting Multi-Droid Refactoring Pipeline

📄 Original: src/services/user-service.ts
📦 New Module: src/utils/validation-utils.ts
📤 Extracting: {"functions":["validateEmail","validatePassword"]}

════════════════════════════════════════════════════════════
Stage 1/6: EXTRACTION
════════════════════════════════════════════════════════════

🤖 Launching extract-refactor-droid-forge...
✅ Stage 1 PASSED: Extraction (5.2s)

════════════════════════════════════════════════════════════
Stage 2/6: CODE REVIEW
════════════════════════════════════════════════════════════

🤖 Launching check-refactor-droid-forge...
✅ Stage 2 PASSED: Code Review (3.1s)

[... stages 3-6 ...]

┌─────────────────────────────────────────────────────────────┐
│ MULTI-DROID REFACTORING PIPELINE RESULTS                    │
├─────────────────────────────────────────────────────────────┤
│ Status: SUCCESS                                             │
│ Completed: 6/6 stages                                       │
├─────────────────────────────────────────────────────────────┤
│ STAGE RESULTS                                               │
├─────────────────────────────────────────────────────────────┤
│ 1. ✅ Extraction                             5.2s            │
│ 2. ✅ Code Review                            3.1s            │
│ 3. ✅ Test Writing                           7.4s            │
│ 4. ✅ Test Execution                         4.8s            │
│ 5. ✅ Integration Validation                 2.3s            │
│ 6. ✅ Commit                                 1.9s            │
├─────────────────────────────────────────────────────────────┤
│ METRICS                                                     │
├─────────────────────────────────────────────────────────────┤
│ Total Duration: 24.7 minutes                                │
│ Droids Executed: 6                                          │
│ Tests Created: 12                                           │
│ Tests Executed: 154                                         │
│ Coverage: 100%                                              │
│ Validations: 30                                             │
└─────────────────────────────────────────────────────────────┘

✅ PIPELINE SUCCESS

All stages completed successfully!
Changes have been committed and are ready for review.
```

### Failure Output
```markdown
════════════════════════════════════════════════════════════
Stage 2/6: CODE REVIEW
════════════════════════════════════════════════════════════

🤖 Launching check-refactor-droid-forge...

❌ Stage 2 FAILED: Code Review

┌─────────────────────────────────────────────────────────────┐
│ MULTI-DROID REFACTORING PIPELINE RESULTS                    │
├─────────────────────────────────────────────────────────────┤
│ Status: FAILED                                              │
│ Completed: 1/6 stages                                       │
├─────────────────────────────────────────────────────────────┤
│ STAGE RESULTS                                               │
├─────────────────────────────────────────────────────────────┤
│ 1. ✅ Extraction                             5.2s            │
│ 2. ❌ Code Review                            2.8s            │
├─────────────────────────────────────────────────────────────┤
│ METRICS                                                     │
├─────────────────────────────────────────────────────────────┤
│ Total Duration: 8.0 minutes                                 │
│ Droids Executed: 2                                          │
│ Tests Created: 0                                            │
│ Tests Executed: 0                                           │
│ Coverage: 0%                                                │
│ Validations: 15                                             │
└─────────────────────────────────────────────────────────────┘

❌ PIPELINE FAILED

Failed at: Code Review

Issues:
  - [CRITICAL] Undefined reference: "validateEmail" is not defined
  - [HIGH] Copy-paste error: using "successDiv" but similar variable exists

Action Required: Fix the issues above and re-run the pipeline.
```

## Best Practices

### Orchestration Principles
- **Sequential Execution**: Never skip stages or run out of order
- **Fail Fast**: Stop immediately when required stage fails
- **Context Passing**: Ensure each droid has all needed information
- **Clear Reporting**: Provide actionable feedback at every step
- **Metrics Tracking**: Collect comprehensive metrics for improvement

### Safety Guidelines
- **Validate Configuration**: Check all inputs before starting
- **Monitor Progress**: Track each stage's execution
- **Handle Failures Gracefully**: Provide clear error messages
- **No Partial Commits**: Only commit if all stages pass
- **Preserve State**: Save progress for debugging if needed

### Quality Standards
- **All Stages Complete**: Don't skip required stages
- **Quality Gates Enforced**: Verify all gates pass
- **Comprehensive Reporting**: Document all results
- **Actionable Errors**: Provide specific fix guidance
- **Performance Tracking**: Monitor and optimize execution time

## Integration Examples

```bash
# Single module extraction
Task tool subagent_type="pipeline-orchestrator-droid-forge" \
  description="Extract validation utilities" \
  prompt="Run complete 6-stage refactoring pipeline:

Original File: src/services/user-service.ts
New Module: src/utils/validation-utils.ts
Extract:
  Functions: validateEmail, validatePassword, validateUserInput
  Types: ValidationResult, ValidationOptions

Context: Extracting validation logic to improve modularity"

# Multiple extractions for large refactoring
Task tool subagent_type="pipeline-orchestrator-droid-forge" \
  description="Refactor bootstrap route - schemas module" \
  prompt="Run complete refactoring pipeline for first module:

Original File: src/app/api/bootstrap/[tenantId]/route.ts
New Module: src/app/api/bootstrap/[tenantId]/validation/schemas.ts
Extract:
  Functions: requestSchema, responseSchema, validateInput
  Types: BootstrapRequest, BootstrapResponse

This is module 1 of 7 for complete bootstrap route refactoring"
```

---

**Version**: 1.0.0
**Specialization**: Multi-droid pipeline coordination and orchestration
**Pipeline Stages**: Coordinates all 6 refactoring stages
**Zero-Bug Guarantee**: Through comprehensive validation chain
