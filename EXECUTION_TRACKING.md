# Execution Tracking System

Comprehensive execution tracking and result collection system for the BAAS Orchestrator in Droid Forge.

## 🎯 Overview

The execution tracking system provides complete visibility into droid task execution through an event-driven architecture that relies on droid self-reporting rather than intrusive monitoring. This practical approach works with Factory.ai's execution model while providing comprehensive audit trails and performance metrics.

## 🏗️ Architecture

### Core Components

1. **Enhanced Audit Logger** (`src/baas/audit.py`)
   - Thread-safe execution lifecycle tracking
   - Performance metrics collection
   - Result validation and storage
   - NDJSON structured logging

2. **Droid Self-Reporting Interface** (`src/baas/droid_interface.py`)
   - Standardized droid status reporting
   - Progress tracking capabilities
   - Context manager for automated tracking
   - Resource usage monitoring

3. **Performance Analysis Tool** (`tools/analyze-execution.py`)
   - Comprehensive performance reports
   - Execution pattern analysis
   - Droid utilization metrics
   - Issue detection and recommendations

4. **Integration Layer**
   - BAAS Orchestrator integration
   - Audit trail consistency
   - Configuration-driven behavior

## 📊 Execution Lifecycle

### Event Flow

```
Task Delegation → Execution Started → Self-Reporting → Completion → Result Collection → Audit Trail
```

### Key Events

| Event Type | Description | Source |
|------------|-------------|--------|
| `task.execution.started` | Task execution begins | BAAS Orchestrator |
| `droid.self_report` | Droid reports status/progress | Droid Interface |
| `task.execution.completed` | Task execution finishes | BAAS Orchestrator |
| `task.execution.abandoned` | Task timeout/crash detected | Audit Tracker |
| `task.result` | Raw execution result | BAAS Orchestrator |
| `task.result.validated` | Validated & categorized result | Audit Tracker |
| `performance.metrics` | Performance summary | Audit Tracker |

## 🤖 Droid Self-Reporting

### Status Values

- `initializing` - Droid setting up
- `ready` - Droid prepared to work
- `executing` - Actively working on task
- `waiting` - Paused for resources/input
- `completed` - Task finished successfully
- `failed` - Task encountered error
- `abandoned` - Task timed out/crashed
- `timeout` - Execution time exceeded

### Implementation Methods

#### Method 1: Direct Function Calls

```python
from src.baas.droid_interface import (
    report_task_start, 
    report_task_progress, 
    report_task_completion
)

# Start task
report_task_start("1.1", "Implement user authentication")

# Report progress
report_task_progress("1.1", 0.5, "Setting up database models")

# Complete task
report_task_completion("1.1", {"files_created": ["auth.py"]}, success=True)
```

#### Method 2: Context Manager (Recommended)

```python
from src.baas.droid_interface import TaskExecution

with TaskExecution("1.2", "Create API endpoints") as task:
    # Work automatically tracked
    files_created = ["api/auth.py", "api/users.py"]
    task.result = {"files_created": files_created}
    # Completion automatically logged on exit
```

#### Method 3: Advanced Interface

```python
from src.baas.droid_interface import DroidExecutionInterface

interface = DroidExecutionInterface()
interface.report_status("executing", {"progress": 0.3})
interface.report_resource_usage(cpu_percent=45.2, memory_mb=256)
```

## 📈 Performance Metrics

### Tracked Metrics

- **Execution Duration** - Start to completion time
- **Success/Failure Rates** - Per droid and overall
- **Abandonment Rate** - Timeout/crash frequency
- **Droid Utilization** - Who's doing what work
- **Result Categories** - Types of outputs produced
- **Resource Usage** - CPU/Memory consumption (when reported)

### Metric Categories

```json
{
  "file_operations": {"files_created": [...], "files_modified": [...]},
  "git_operations": {"commits": [...], "branches": [...]},
  "testing": {"tests_run": 10, "coverage": 85},
  "error": {"error_type": "...", "stack_trace": "..."},
  "unknown": {"raw_result": "..."}
}
```

## 🗂️ Log Files

### NDJSON Structure

All log files use NDJSON (Newline-Delimited JSON) format for easy parsing and analysis.

#### File Types

| File | Purpose | Key Events |
|------|---------|------------|
| `audit.ndjson` | High-level audit trail | `audit.recorded` |
| `events.ndjson` | Detailed execution events | All task/droid events |
| `results.ndjson` | Raw and validated results | `task.result.*` |
| `performance.ndjson` | Performance metrics | `performance.metrics` |
| `droid_status.ndjson` | Droid self-reports | `droid.self_report` |

#### Event Structure

```json
{
  "timestamp": "2025-10-08T16:21:54.536702+00:00",
  "event_type": "task.execution.started", 
  "run_id": "r-20251008-1621",
  "task_id": "1.1",
  "droid_id": "setup-comprehensive-testing",
  "execution_id": "exec-1759940510-1.1",
  "status": "executing",
  "details": {"description": "Test infrastructure setup"}
}
```

## 🔧 Configuration

### droid-forge.yaml Settings

```yaml
performance:
  execution_tracking:
    default_timeout: 3600        # 1 hour task timeout
    cleanup_interval: 300        # 5 minute cleanup cycle
    metrics_interval: 600        # 10 minute metrics collection
    enable_result_validation: true
    enable_self_reporting: true

logging:
  events:
    - task.execution.started
    - task.execution.completed  
    - task.execution.abandoned
    - droid.self_report
    - performance.metrics
    - task.result
    - task.result.validated
```

## 📊 Analysis and Reporting

### Performance Reports

```bash
# Generate comprehensive report
python tools/analyze-execution.py

# Specific analyses
python tools/analyze-execution.py --events
python tools/analyze-execution.py --droids  
python tools/analyze-execution.py --issues
python tools/analyze-execution.py --json
```

### Report Sections

1. **Data Summary** - Log file statistics
2. **Execution Patterns** - Completion rates, durations, abandonment
3. **Droid Performance** - Individual droid metrics and success rates
4. **Result Patterns** - Output categorization and validation
5. **Performance Issues** - Automated detection and recommendations
6. **Recent Activity** - Last 24 hours of execution events

### Issue Detection

The system automatically detects:

- High abandonment rates (>10%)
- Poor droid performance (<50% success rate)
- Stuck executions (started but never completed)
- Resource utilization anomalies
- Pattern deviations from historical baselines

## 🧪 Testing

### Test Suite

```bash
# Run comprehensive tests
python tools/test-execution-tracking.py

# Test without cleanup (for inspection)
python tools/test-execution-tracking.py --no-cleanup

# Clean up test data only
python tools/test-execution-tracking.py --cleanup
```

### Test Coverage

- ✅ Audit logger functionality
- ✅ Droid self-reporting interface
- ✅ Integration between components
- ✅ File creation and NDJSON validation
- ✅ Performance analysis capabilities

## 🔒 Security and Privacy

### Data Collection

- Only execution metadata and droid-reported data
- No source code content logging
- File paths and names only (not file contents)
- Error messages sanitized for sensitive information

### Data Retention

- Configurable retention policies
- Automatic cleanup of stale execution data
- Audit trail preservation compliance

## 🚀 Usage Examples

### BAAS Orchestrator Integration

```python
# Enhanced task delegation in BAAS Orchestrator
execution_id = logger.log_task_execution_started(
    task_id="1.1", 
    droid_id=selected_droid,
    description=task_description
)

# Set environment for droid self-reporting
os.environ["DROID_EXECUTION_ID"] = execution_id
os.environ["DROID_ID"] = selected_droid

# Delegate task with full context
Task(selected_droid, f"Execute task {task_id} with execution tracking")

# Monitor and collect results
# (Handled automatically through droid self-reports)
```

### Custom Droid Implementation

```markdown
---
name: my-custom-droid
description: Custom droid with execution tracking
model: inherit
---

# My Custom Droid

```python
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent.parent.parent / "src" / "baas"))
from droid_interface import TaskExecution

with TaskExecution("2.1", "Custom implementation task") as task:
    # Your droid logic here
    result_files = implement_feature()
    task.result = {"files_created": result_files}
```
```

## 🔄 Continuous Improvement

### Performance Optimization

- Metrics-based droid selection
- Adaptive timeout configuration
- Resource usage pattern analysis
- Success rate trend monitoring

### Future Enhancements

- Predictive performance modeling
- Automatic droid capability discovery
- Advanced error pattern recognition
- Cross-project baseline comparisons

## 📚 API Reference

### AuditLogger Class

```python
class AuditLogger:
    def log_task_execution_started(task_id, droid_id, description) -> str
    def log_task_execution_completed(execution_id, result, success=True)
    def log_task_execution_abandoned(execution_id, reason="timeout")
    def log_droid_self_report(droid_id, status, details)
    def log_performance_metrics()
    def validate_and_store_result(execution_id, result) -> bool
    def generate_execution_summary() -> Dict[str, Any]
    def cleanup_stale_executions(timeout_seconds=3600)
```

### DroidExecutionInterface Class

```python
class DroidExecutionInterface:
    def report_status(status, details=None)
    def report_task_start(task_id, description, context=None)
    def report_task_progress(task_id, progress, message=None)
    def report_task_completion(task_id, result, success=True)
    def report_error(task_id, error, context=None)
    def report_resource_usage(cpu_percent=None, memory_mb=None, disk_io_mb=None)
```

### TaskExecution Context Manager

```python
class TaskExecution:
    def __init__(self, task_id, description, interface=None)
    def __enter__() -> TaskExecution
    def __exit__(exc_type, exc_val, exc_tb) -> bool
```

---

**Built for Droid Forge with ❤️ and comprehensive auditing**
