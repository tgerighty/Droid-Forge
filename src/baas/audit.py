"""
Audit logging system for Droid Forge
Implements NDJSON logging as specified in the PRD
"""

import json
import os
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, Any, Optional, List
import threading
import time


class ExecutionTracker:
    """Tracks execution lifecycle and performance metrics"""
    
    def __init__(self):
        self.active_tasks: Dict[str, Dict[str, Any]] = {}
        self.active_droids: Dict[str, Dict[str, Any]] = {}
        self.completed_tasks: List[Dict[str, Any]] = []
        self.performance_metrics: Dict[str, Any] = {}
        self.lock = threading.Lock()
    
    def start_task_execution(self, task_id: str, droid_id: str, description: str) -> str:
        """Record task start with timestamp"""
        execution_id = f"exec-{int(time.time())}-{task_id}"
        with self.lock:
            self.active_tasks[execution_id] = {
                "task_id": task_id,
                "droid_id": droid_id,
                "description": description,
                "start_time": datetime.now(timezone.utc).isoformat(),
                "status": "executing",
                "execution_id": execution_id
            }
        return execution_id
    
    def complete_task_execution(self, execution_id: str, result: Dict[str, Any], success: bool = True):
        """Record task completion with duration and results"""
        with self.lock:
            if execution_id in self.active_tasks:
                task = self.active_tasks[execution_id]
                end_time = datetime.now(timezone.utc)
                start_time = datetime.fromisoformat(task["start_time"])
                duration = (end_time - start_time).total_seconds()
                
                task.update({
                    "end_time": end_time.isoformat(),
                    "duration_seconds": duration,
                    "status": "completed" if success else "failed",
                    "result": result
                })
                
                self.completed_tasks.append(task.copy())
                del self.active_tasks[execution_id]
                
                # Update performance metrics
                self._update_performance_metrics(task["droid_id"], duration, success)
    
    def abandon_task_execution(self, execution_id: str, reason: str = "timeout"):
        """Handle abandoned/crashed tasks"""
        with self.lock:
            if execution_id in self.active_tasks:
                task = self.active_tasks[execution_id]
                end_time = datetime.now(timezone.utc)
                start_time = datetime.fromisoformat(task["start_time"])
                duration = (end_time - start_time).total_seconds()
                
                task.update({
                    "end_time": end_time.isoformat(),
                    "duration_seconds": duration,
                    "status": "abandoned",
                    "abandon_reason": reason,
                    "result": {"error": f"Task abandoned: {reason}"}
                })
                
                self.completed_tasks.append(task.copy())
                del self.active_tasks[execution_id]
                
                # Update performance metrics
                self._update_performance_metrics(task["droid_id"], duration, False)
    
    def record_droid_self_report(self, droid_id: str, status: str, details: Dict[str, Any]):
        """Record self-reported status from droid"""
        with self.lock:
            self.active_droids[droid_id] = {
                "droid_id": droid_id,
                "status": status,
                "last_report": datetime.now(timezone.utc).isoformat(),
                "details": details
            }
    
    def _update_performance_metrics(self, droid_id: str, duration: float, success: bool):
        """Update performance metrics for droid"""
        if droid_id not in self.performance_metrics:
            self.performance_metrics[droid_id] = {
                "total_executions": 0,
                "successful_executions": 0,
                "failed_executions": 0,
                "total_duration": 0.0,
                "avg_duration": 0.0,
                "success_rate": 0.0
            }
        
        metrics = self.performance_metrics[droid_id]
        metrics["total_executions"] += 1
        metrics["total_duration"] += duration
        metrics["avg_duration"] = metrics["total_duration"] / metrics["total_executions"]
        
        if success:
            metrics["successful_executions"] += 1
        else:
            metrics["failed_executions"] += 1
        
        metrics["success_rate"] = metrics["successful_executions"] / metrics["total_executions"]
    
    def get_performance_summary(self) -> Dict[str, Any]:
        """Generate performance summary report"""
        with self.lock:
            return {
                "generated_at": datetime.now(timezone.utc).isoformat(),
                "total_tasks_completed": len(self.completed_tasks),
                "active_tasks": len(self.active_tasks),
                "droid_performance": self.performance_metrics.copy(),
                "recent_failures": [task for task in self.completed_tasks[-10:] if task.get("status") in ["failed", "abandoned"]]
            }
    
    def cleanup_stale_tasks(self, timeout_seconds: int = 3600):
        """Clean up tasks that have been active too long"""
        with self.lock:
            current_time = datetime.now(timezone.utc)
            stale_executions = []
            
            for execution_id, task in self.active_tasks.items():
                start_time = datetime.fromisoformat(task["start_time"])
                if (current_time - start_time).total_seconds() > timeout_seconds:
                    stale_executions.append(execution_id)
            
            for execution_id in stale_executions:
                self.abandon_task_execution(execution_id, "timeout")


class AuditLogger:
    """NDJSON audit logger with enhanced execution tracking for the Droid Foundry"""
    
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        self.logs_dir = self.project_root / ".droid-forge" / "logs"
        self.logs_dir.mkdir(parents=True, exist_ok=True)
        
        self.audit_file = self.logs_dir / "audit.ndjson"
        self.events_file = self.logs_dir / "events.ndjson"
        self.results_file = self.logs_dir / "results.ndjson"
        self.performance_file = self.logs_dir / "performance.ndjson"
        
        self.run_id = self._generate_run_id()
        self.execution_tracker = ExecutionTracker()
    
    def _generate_run_id(self) -> str:
        """Generate unique run ID with timestamp"""
        now = datetime.now(timezone.utc)
        return f"r-{now.strftime('%Y%m%d-%H%M')}"
    
    def _write_event(self, filename: Path, event_type: str, data: Dict[str, Any]):
        """Write event to NDJSON file"""
        event = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "event_type": event_type,
            "run_id": self.run_id,
            **data
        }
        
        with open(filename, 'a', encoding='utf-8') as f:
            f.write(json.dumps(event) + '\n')
    
    def log_audit(self, action: str, details: Optional[Dict[str, Any]] = None):
        """Log audit event"""
        data = {"action": action}
        if details:
            data["details"] = details
        
        self._write_event(self.audit_file, "audit.recorded", data)
    
    def log_task_scheduled(self, task_id: str, description: str):
        """Log task scheduled event"""
        self._write_event(self.events_file, "task.scheduled", {
            "task_id": task_id,
            "status": "scheduled",
            "details": {"description": description}
        })
    
    def log_task_started(self, task_id: str, droid_id: Optional[str] = None):
        """Log task started event"""
        data = {"task_id": task_id, "status": "started"}
        if droid_id:
            data["droid_id"] = droid_id
        
        self._write_event(self.events_file, "task.started", data)
    
    def log_task_completed(self, task_id: str, droid_id: Optional[str] = None):
        """Log task completed event"""
        data = {"task_id": task_id, "status": "completed"}
        if droid_id:
            data["droid_id"] = droid_id
        
        self._write_event(self.events_file, "task.completed", data)
    
    def log_task_failed(self, task_id: str, error: str, droid_id: Optional[str] = None):
        """Log task failed event"""
        data = {
            "task_id": task_id,
            "status": "failed",
            "details": {"error": error}
        }
        if droid_id:
            data["droid_id"] = droid_id
        
        self._write_event(self.events_file, "task.failed", data)
    
    def log_droid_started(self, droid_id: str, task_id: Optional[str] = None):
        """Log droid started event"""
        data = {"droid_id": droid_id, "status": "started"}
        if task_id:
            data["task_id"] = task_id
        
        self._write_event(self.events_file, "droid.started", data)
    
    def log_droid_completed(self, droid_id: str, task_id: Optional[str] = None):
        """Log droid completed event"""
        data = {"droid_id": droid_id, "status": "completed"}
        if task_id:
            data["task_id"] = task_id
        
        self._write_event(self.events_file, "droid.completed", data)
    
    def log_git_commit(self, sha: str, branch: str, message: str):
        """Log git commit event"""
        self._write_event(self.events_file, "git.commit", {
            "git": {
                "sha": sha,
                "branch": branch,
                "message": message
            }
        })
    
    def log_process_files_sync(self, source: str, ref: str):
        """Log ai-dev-tasks process files synchronization"""
        self.log_audit("process_files_sync", {
            "source": source,
            "ref": ref
        })
    
    # Enhanced execution tracking methods
    def log_task_execution_started(self, task_id: str, droid_id: str, description: str) -> str:
        """Log task execution start with tracking"""
        execution_id = self.execution_tracker.start_task_execution(task_id, droid_id, description)
        
        self._write_event(self.events_file, "task.execution.started", {
            "task_id": task_id,
            "droid_id": droid_id,
            "execution_id": execution_id,
            "status": "executing",
            "details": {"description": description}
        })
        return execution_id
    
    def log_task_execution_completed(self, execution_id: str, result: Dict[str, Any], success: bool = True):
        """Log task execution completion with results"""
        self.execution_tracker.complete_task_execution(execution_id, result, success)
        
        self._write_event(self.events_file, "task.execution.completed", {
            "execution_id": execution_id,
            "status": "completed" if success else "failed",
            "result": result
        })
        
        # Log structured result data
        self._write_event(self.results_file, "task.result", {
            "execution_id": execution_id,
            "success": success,
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "result_data": result
        })
    
    def log_task_execution_abandoned(self, execution_id: str, reason: str = "timeout"):
        """Log task execution abandonment/timeout"""
        self.execution_tracker.abandon_task_execution(execution_id, reason)
        
        self._write_event(self.events_file, "task.execution.abandoned", {
            "execution_id": execution_id,
            "status": "abandoned",
            "reason": reason
        })
    
    def log_droid_self_report(self, droid_id: str, status: str, details: Dict[str, Any]):
        """Log droid self-reported status"""
        self.execution_tracker.record_droid_self_report(droid_id, status, details)
        
        self._write_event(self.events_file, "droid.self_report", {
            "droid_id": droid_id,
            "status": status,
            "details": details
        })
    
    def log_performance_metrics(self):
        """Log current performance metrics"""
        metrics = self.execution_tracker.get_performance_summary()
        
        self._write_event(self.performance_file, "performance.metrics", metrics)
        
        # Also log to audit trail
        self.log_audit("performance_metrics_generated", {
            "total_tasks": metrics["total_tasks_completed"],
            "active_tasks": metrics["active_tasks"],
            "droids_tracked": len(metrics["droid_performance"])
        })
    
    def validate_and_store_result(self, execution_id: str, result: Dict[str, Any]) -> bool:
        """Validate and categorize execution results"""
        # Basic validation
        if not isinstance(result, dict):
            return False
        
        # Categorize result
        result_category = "unknown"
        if "files_created" in result:
            result_category = "file_operations"
        elif "commits" in result:
            result_category = "git_operations"
        elif "tests_run" in result:
            result_category = "testing"
        elif "error" in result:
            result_category = "error"
        
        # Store validated result
        validated_result = {
            "execution_id": execution_id,
            "category": result_category,
            "validated_at": datetime.now(timezone.utc).isoformat(),
            "original_result": result
        }
        
        self._write_event(self.results_file, "task.result.validated", validated_result)
        return True
    
    def generate_execution_summary(self) -> Dict[str, Any]:
        """Generate comprehensive execution summary"""
        performance = self.execution_tracker.get_performance_summary()
        
        return {
            "run_id": self.run_id,
            "generated_at": datetime.now(timezone.utc).isoformat(),
            "execution_summary": performance,
            "log_files": {
                "audit": str(self.audit_file),
                "events": str(self.events_file),
                "results": str(self.results_file),
                "performance": str(self.performance_file)
            }
        }
    
    def cleanup_stale_executions(self, timeout_seconds: int = 3600):
        """Clean up stale execution tracking"""
        self.execution_tracker.cleanup_stale_tasks(timeout_seconds)
        
        self.log_audit("stale_executions_cleanup", {
            "timeout_seconds": timeout_seconds
        })
