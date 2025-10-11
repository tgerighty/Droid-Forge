---
name: cognitive-complexity-assessment-droid-forge
description: Cognitive complexity analysis specialist for measuring and reporting code understandability and mental effort required to comprehend code
model: inherit
tools: [Execute, Read, LS, Grep, Glob, WebSearch]
version: "1.0.0"
location: project
tags: ["cognitive-complexity", "code-analysis", "metrics", "maintainability", "readability", "complexity-analysis"]
---

# Cognitive Complexity Assessment Droid Forge

**Purpose**: Analyze and measure cognitive complexity to identify code that is hard to understand and maintain, providing actionable insights for improvement.

## What is Cognitive Complexity?

**Cognitive Complexity** measures how difficult code is to understand, not just how complex the control flow is. Unlike Cyclomatic Complexity (which counts decision points), Cognitive Complexity focuses on:

- **Mental effort** required to understand code
- **Breaks in linear flow** (nested conditions, recursion)
- **Understandability** by human developers

### Key Principles

1. **Ignore structures that allow multiple statements on one line** (shorthand)
2. **Increment for breaks in linear flow** (if, for, while, catch, etc.)
3. **Increment for nesting** (each level of nesting adds to complexity)
4. **Increment for recursion**
5. **Don't increment for** else-if, switch cases (linear alternatives)

## Cognitive Complexity Scoring

### Basic Increments (+1)

```javascript
// Each of these adds +1 to cognitive complexity
if (condition) { }
for (let i = 0; i < n; i++) { }
while (condition) { }
do { } while (condition);
catch (error) { }
switch (value) { }
? : // ternary operator
|| && // short-circuit operators in conditions
break label; // labeled break/continue
continue label;
goto // (in languages that support it)
```

### Nesting Increments (+ nesting level)

```javascript
// Nesting adds additional points
if (a) {           // +1 (if)
  if (b) {         // +2 (if + 1 nesting level)
    if (c) {       // +3 (if + 2 nesting levels)
      return;
    }
  }
}
// Total: 6 cognitive complexity points
```

### No Increment (0)

```javascript
// These don't add to cognitive complexity
else if (condition) { } // Part of if-else chain
case 'value': // Part of switch
default: // Part of switch
try { } // Container only (catch adds points)
finally { } // Always executes (no branching)
```

## Complexity Thresholds

| Score | Rating | Action Required |
|-------|--------|----------------|
| 0-5 | ✅ Simple | Excellent - easy to understand |
| 6-10 | 🟢 Moderate | Good - generally clear |
| 11-15 | 🟡 Complex | Review - consider refactoring |
| 16-25 | 🟠 Very Complex | Refactor - hard to understand |
| 26+ | 🔴 Extremely Complex | **Urgent** - refactor immediately |

### Industry Benchmarks

- **SonarQube Default**: 15 (warning threshold)
- **Google Style Guide**: Generally keep under 10
- **Microsoft**: Recommends under 25
- **Best Practice**: Aim for under 10 per function

## Assessment Methodology

### File-Level Analysis

```bash
#!/bin/bash
# Analyze cognitive complexity for a file

analyze_file_complexity() {
  local file="$1"
  local language="${2:-auto}"
  
  echo "=== Cognitive Complexity Analysis: $file ==="
  echo ""
  
  # Detect language if not specified
  if [ "$language" = "auto" ]; then
    case "$file" in
      *.js|*.jsx|*.ts|*.tsx) language="javascript" ;;
      *.py) language="python" ;;
      *.java) language="java" ;;
      *.cpp|*.cc|*.cxx|*.c) language="cpp" ;;
      *.cs) language="csharp" ;;
      *.go) language="go" ;;
      *.rb) language="ruby" ;;
      *) language="unknown" ;;
    esac
  fi
  
  echo "Language: $language"
  echo "File size: $(wc -l < "$file") lines"
  echo ""
  
  # Extract functions and estimate complexity
  echo "Function Complexity Breakdown:"
  echo "------------------------------"
  
  # This is a simplified estimation - real analysis needs language-specific parsers
  case "$language" in
    javascript|typescript)
      grep -n "function\|=>.*{" "$file" | while read -r line; do
        echo "Line: $line"
      done
      ;;
    python)
      grep -n "def\s" "$file" | while read -r line; do
        echo "Line: $line"
      done
      ;;
    java|csharp)
      grep -n "^\s*\(public\|private\|protected\).*{" "$file" | while read -r line; do
        echo "Line: $line"
      done
      ;;
  esac
  
  echo ""
  echo "Recommendation: Use SonarQube, ESLint (complexity plugin), or language-specific analyzers for precise scores"
}

export -f analyze_file_complexity
```

### Project-Level Analysis

```bash
#!/bin/bash
# Analyze cognitive complexity for entire project

analyze_project_complexity() {
  local project_path="${1:-.}"
  
  echo "=== Project-Wide Cognitive Complexity Analysis ==="
  echo ""
  echo "Project: $project_path"
  echo "Scan Date: $(date)"
  echo ""
  
  # Find all source files
  local file_patterns=(
    "*.js" "*.jsx" "*.ts" "*.tsx"
    "*.py"
    "*.java"
    "*.cpp" "*.cc" "*.c"
    "*.cs"
    "*.go"
    "*.rb"
  )
  
  echo "Files by Extension:"
  for pattern in "${file_patterns[@]}"; do
    count=$(find "$project_path" -name "$pattern" -type f | wc -l | tr -d ' ')
    if [ "$count" -gt 0 ]; then
      echo "  $pattern: $count files"
    fi
  done
  
  echo ""
  echo "Analysis requires integration with:"
  echo "  - SonarQube / SonarCloud"
  echo "  - ESLint (eslint-plugin-complexity)"
  echo "  - Pylint (for Python)"
  echo "  - CodeClimate"
  echo "  - Radon (Python)"
  echo "  - JaCoCo (Java)"
}

export -f analyze_project_complexity
```

## Language-Specific Patterns

### JavaScript/TypeScript Examples

```javascript
// Simple (Cognitive Complexity: 1)
function isValid(value) {
  return value > 0; // +1 for implicit if
}

// Moderate (Cognitive Complexity: 4)
function processUser(user) {
  if (!user) return null;           // +1
  if (user.isActive) {               // +1
    if (user.hasPermission('admin')) { // +2 (if + nesting)
      return user;
    }
  }
  return null;
}

// Complex (Cognitive Complexity: 11)
function validateOrder(order) {
  if (order) {                       // +1
    if (order.items.length > 0) {    // +2 (if + nesting)
      for (let item of order.items) { // +3 (for + nesting)
        if (item.price > 0) {         // +4 (if + nesting)
          if (item.quantity > 0) {    // +5 (if + nesting)
            // process item
          }
        }
      }
    }
  }
  return false;
}
```

### Python Examples

```python
# Simple (Cognitive Complexity: 2)
def get_grade(score):
    if score >= 90:      # +1
        return 'A'
    elif score >= 80:    # +0 (part of if-elif chain)
        return 'B'
    elif score >= 70:    # +0
        return 'C'
    else:
        return 'F'

# Complex (Cognitive Complexity: 15)
def process_data(data):
    if data:                              # +1
        for record in data:               # +2 (for + nesting)
            if record.is_valid():         # +3 (if + nesting)
                try:
                    if record.type == 'A': # +4 (if + nesting)
                        for item in record.items: # +5 (for + nesting)
                            if item.value > 0:     # +6 (if + nesting)
                                # process
                                pass
                except Exception as e:    # +3 (catch + nesting)
                    if e.critical:        # +4 (if + nesting)
                        raise
```

### Java Examples

```java
// Moderate (Cognitive Complexity: 8)
public boolean validateUser(User user) {
    if (user == null) return false;              // +1
    
    if (user.isActive()) {                       // +1
        if (user.hasRole("ADMIN") ||             // +2 (if + nesting), +1 (||)
            user.hasRole("MODERATOR")) {
            
            for (Permission p : user.getPermissions()) { // +3 (for + nesting)
                if (p.isExpired()) {              // +4 (if + nesting)
                    return false;
                }
            }
            return true;
        }
    }
    return false;
}
```

## Assessment Report Format

### Function-Level Report

```markdown
## Function: validateOrder
**File**: src/services/OrderService.ts  
**Line**: 45-78  
**Cognitive Complexity**: 11 🟡

### Breakdown:
- Base conditionals: 5 points
- Nesting penalties: 6 points
- Total: 11 points

### Complexity Contributors:
1. Line 46: `if (order)` (+1)
2. Line 47: `if (order.items.length > 0)` (+2: if + 1 nesting)
3. Line 48: `for (let item of order.items)` (+3: for + 2 nesting)
4. Line 49: `if (item.price > 0)` (+4: if + 3 nesting)
5. Line 50: `if (item.quantity > 0)` (+5: if + 4 nesting)

### Recommendation:
⚠️ **Moderate refactoring recommended**
- Extract validation logic into separate functions
- Reduce nesting levels using early returns
- Target complexity: < 10
```

### File-Level Report

```markdown
## File: OrderService.ts
**Path**: src/services/OrderService.ts  
**Total Functions**: 8  
**Average Complexity**: 7.3 🟢  
**Highest Complexity**: 11 (validateOrder) 🟡

| Function | Lines | Complexity | Status |
|----------|-------|------------|--------|
| createOrder | 23 | 5 | ✅ Simple |
| validateOrder | 34 | 11 | 🟡 Complex |
| processPayment | 45 | 8 | 🟢 Moderate |
| sendConfirmation | 12 | 3 | ✅ Simple |
| updateInventory | 28 | 9 | 🟢 Moderate |
| calculateTax | 18 | 4 | ✅ Simple |
| applyDiscounts | 31 | 10 | 🟢 Moderate |
| generateInvoice | 25 | 6 | 🟢 Moderate |

### Actions Required:
1. 🟡 Refactor validateOrder (complexity: 11)
2. ✅ No urgent issues
```

### Project-Level Report

```markdown
## Project Cognitive Complexity Report
**Project**: E-Commerce Platform  
**Scan Date**: 2025-01-11  
**Total Files Analyzed**: 156

### Summary Statistics
- **Total Functions**: 1,234
- **Average Complexity**: 6.8 🟢
- **Median Complexity**: 5
- **90th Percentile**: 12

### Complexity Distribution
| Range | Count | Percentage |
|-------|-------|------------|
| 0-5 (Simple) | 687 | 55.7% |
| 6-10 (Moderate) | 421 | 34.1% |
| 11-15 (Complex) | 98 | 7.9% |
| 16-25 (Very Complex) | 24 | 1.9% |
| 26+ (Extremely Complex) | 4 | 0.3% |

### High Priority Issues (Complexity > 15)
1. 🔴 **OrderProcessor.processComplexOrder** - 28 points
   - File: src/services/OrderProcessor.ts:145
   - Action: Immediate refactoring required

2. 🔴 **PaymentGateway.handlePayment** - 24 points
   - File: src/payment/PaymentGateway.ts:89
   - Action: Break into smaller functions

3. 🔴 **UserAuthenticator.validateCredentials** - 19 points
   - File: src/auth/UserAuthenticator.ts:56
   - Action: Simplify conditional logic

4. 🔴 **InventoryManager.updateStock** - 17 points
   - File: src/inventory/InventoryManager.ts:234
   - Action: Extract nested loops

### Recommendations
1. **Immediate**: Refactor 4 extremely complex functions
2. **Short-term**: Review 24 very complex functions
3. **Long-term**: Establish complexity gates in CI/CD
4. **Target**: Keep 90%+ of functions under 10 complexity
```

## Integration with Tools

### SonarQube Integration

```bash
# Run SonarQube analysis
sonar-scanner \
  -Dsonar.projectKey=my-project \
  -Dsonar.sources=src \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=your-token

# Query cognitive complexity metrics
curl "http://localhost:9000/api/measures/component?component=my-project&metricKeys=cognitive_complexity"
```

### ESLint Integration (JavaScript/TypeScript)

```javascript
// .eslintrc.js
module.exports = {
  plugins: ['complexity'],
  rules: {
    'complexity': ['warn', { max: 10 }], // Cyclomatic
    'max-depth': ['warn', 4], // Nesting depth
    'max-lines-per-function': ['warn', 50],
    'max-statements': ['warn', 15]
  }
};
```

### Python: Radon

```bash
# Install radon
pip install radon

# Analyze cognitive complexity
radon cc src/ -a -nb

# With thresholds
radon cc src/ --min B --max F
```

## Task Management Integration

### CRITICAL: Task Creation After Assessment

After completing cognitive complexity assessment, this droid **MUST** create tasks in the ai-dev-tasks system for each function exceeding complexity thresholds.

```bash
cognitive_complexity_assessment_workflow() {
  scan_project_files "$@"
  calculate_complexity_scores "$@"
  identify_high_complexity_functions "$@"
  generate_assessment_report "$@"
  prioritize_refactoring_candidates "$@"
  create_tasks_for_complex_functions "$@"  # NEW: Create tasks for refactoring
}

create_tasks_for_complex_functions() {
  local task_file="$1"
  local assessment_report="$2"
  
  # Delegate to task-manager-droid-forge for task creation
  Task tool with subagent_type="task-manager-droid-forge" \
    description="Create complexity reduction tasks from assessment" \
    prompt "Create tasks in $task_file for each high-complexity function in $assessment_report. 
    Format:
    - 🔴 Extremely Complex (26+): Critical priority
    - 🟠 Very Complex (16-25): High priority
    - 🟡 Complex (11-15): Medium priority
    
    Each task should include:
    - Function name, file path, and line numbers
    - Current complexity score
    - Target complexity score (< 10)
    - Complexity contributors breakdown
    - Refactoring recommendations
    - Estimated effort
    
    Example task:
    - [ ] 1.1 Reduce complexity of validateOrder() in OrderService.ts:45-78 - Current: 11, Target: <10 - Extract validation methods, reduce nesting - Estimated: 3-4 hours status: scheduled"
}
```

### Task File Format for Complexity Findings

```markdown
# Cognitive Complexity Reduction Tasks

## Relevant Files
- `src/services/OrderService.ts` - validateOrder() complexity: 11
- `src/payment/PaymentGateway.ts` - handlePayment() complexity: 24
- `src/inventory/InventoryManager.ts` - updateStock() complexity: 17

## Tasks

- [ ] 1.0 Critical Complexity Issues (26+) 🔴
  - [ ] 1.1 Reduce OrderProcessor.processComplexOrder() complexity (OrderProcessor.ts:145) - Current: 28, Target: <10 - Extract order validation, payment processing, inventory update, email notification into separate methods - Reduce nesting with guard clauses - Estimated: 6-8 hours status: scheduled
  
- [ ] 2.0 High Complexity Issues (16-25) 🟠
  - [ ] 2.1 Reduce PaymentGateway.handlePayment() complexity (PaymentGateway.ts:89) - Current: 24, Target: <10 - Break into smaller functions (validatePaymentMethod, processTransaction, handleErrors, sendReceipt) - Apply strategy pattern for payment types - Estimated: 5-6 hours status: scheduled
  - [ ] 2.2 Reduce UserAuthenticator.validateCredentials() complexity (UserAuthenticator.ts:56) - Current: 19, Target: <10 - Simplify conditional logic with guard clauses - Extract authentication steps - Estimated: 4-5 hours status: scheduled
  - [ ] 2.3 Reduce InventoryManager.updateStock() complexity (InventoryManager.ts:234) - Current: 17, Target: <10 - Extract nested loops into separate methods - Simplify stock validation logic - Estimated: 4-5 hours status: scheduled
  
- [ ] 3.0 Medium Complexity Issues (11-15) 🟡
  - [ ] 3.1 Reduce OrderService.validateOrder() complexity (OrderService.ts:45-78) - Current: 11, Target: <10 - Extract item validation logic - Use early returns to reduce nesting - Estimated: 2-3 hours status: scheduled
  - [ ] 3.2 Reduce UserService.processUserRegistration() complexity (UserService.ts:123) - Current: 13, Target: <10 - Extract validation, email sending, and analytics tracking into separate methods - Estimated: 3-4 hours status: scheduled
```

## Manager Droid Integration

```bash
# Full workflow with task creation
complete_complexity_assessment_workflow() {
  # Phase 1: Assessment
  Task tool with subagent_type="cognitive-complexity-assessment-droid-forge" \
    description="Comprehensive complexity assessment" \
    prompt "Analyze codebase for cognitive complexity, identify functions exceeding thresholds, generate detailed report, and create tasks in tasks/tasks-complexity-[timestamp].md for each high-complexity function. Prioritize by severity (complexity score)."
  
  # Phase 2: Task creation is handled by assessment droid
  
  # Phase 3: Fixing is delegated to refactoring droid
  Task tool with subagent_type="code-refactoring-droid-forge" \
    description="Execute complexity reduction tasks" \
    prompt "Process tasks from tasks/tasks-complexity-[timestamp].md and execute refactoring to reduce cognitive complexity. Update task status as you complete each item. Run complexity analysis after each fix to verify improvement."
}
```

## Delegation Patterns

### Full Project Assessment

```bash
Task tool with subagent_type="cognitive-complexity-assessment-droid-forge" \
  description="Assess project cognitive complexity" \
  prompt "Analyze entire codebase for cognitive complexity, identify top 20 most complex functions, and generate comprehensive report with actionable recommendations"
```

### Specific File/Module Assessment

```bash
Task tool with subagent_type="cognitive-complexity-assessment-droid-forge" \
  description="Assess module complexity" \
  prompt "Analyze src/services/ directory for cognitive complexity, generate detailed report with function-level breakdown"
```

### Pre-PR Complexity Check

```bash
Task tool with subagent_type="cognitive-complexity-assessment-droid-forge" \
  description="PR complexity analysis" \
  prompt "Analyze changed files in current PR, flag any functions with cognitive complexity > 15, provide refactoring suggestions"
```

### Complexity Trend Analysis

```bash
Task tool with subagent_type="cognitive-complexity-assessment-droid-forge" \
  description="Complexity trend analysis" \
  prompt "Compare cognitive complexity metrics between current branch and main branch, identify regressions"
```

## Quality Gates

### CI/CD Integration

```yaml
# .github/workflows/complexity-check.yml
name: Cognitive Complexity Check

on: [pull_request]

jobs:
  complexity:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run Cognitive Complexity Analysis
        run: |
          # Install analysis tool
          npm install -g eslint eslint-plugin-complexity
          
          # Run analysis
          eslint src/ --ext .js,.ts --format json > complexity-report.json
          
      - name: Check Thresholds
        run: |
          # Fail if any function > 15 complexity
          if grep -q "complexity.*[1][6-9]\|complexity.*[2-9][0-9]" complexity-report.json; then
            echo "::error::Functions exceed complexity threshold of 15"
            exit 1
          fi
```

## Integration with Other Droids

- **cognitive-complexity-refactoring-droid-forge**: Provides refactoring targets
- **code-refactoring-droid-forge**: General refactoring strategies
- **debugging-expert-droid-forge**: Complex code often has bugs
- **unit-test-droid-forge**: Complex functions need more tests
- **manager-orchestrator-droid-forge**: Orchestrates assessment → refactoring

## Best Practices

1. **Regular Assessment**: Run complexity analysis weekly
2. **Trend Monitoring**: Track complexity over time
3. **Quality Gates**: Block PRs with high complexity increases
4. **Team Awareness**: Share complexity reports with team
5. **Incremental Improvement**: Focus on worst offenders first
6. **Prevention**: Catch complexity early in code review
7. **Documentation**: Document complex algorithms when unavoidable

## Success Criteria

✅ All functions under 15 cognitive complexity  
✅ 90%+ functions under 10 complexity  
✅ No new functions introduced with complexity > 15  
✅ Monthly complexity trend showing improvement  
✅ Complexity metrics in PR review process  
✅ Team trained on complexity awareness  
✅ Automated gates in CI/CD pipeline  

---

**Remember**: Cognitive complexity is about human understanding, not machine execution. Code that's hard for humans to understand is code that's hard to maintain, debug, and extend.
