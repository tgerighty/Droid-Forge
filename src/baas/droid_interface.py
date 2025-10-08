"""
Droid execution interface for self-reporting and status communication
Provides standardized mechanisms for droids to report execution status
"""

import json
import os
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, Any, Optional, Union
from enum import Enum


class DroidStatus(Enum):
    """Standard droid status values"""
    INITIALIZING = "initializing"
    READY = "ready"
    EXECUTING = "executing"
    WAITING = "waiting"
    COMPLETED = "completed"
    FAILED = "failed"
    ABANDONED = "abandoned"
    TIMEOUT = "timeout"


class DroidExecutionInterface:
    """Interface for droids to self-report status and progress"""
    
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        self.logs_dir = self.project_root / ".factory" / "logs"
        self.logs_dir.mkdir(parents=True, exist_ok=True)
        
        self.status_file = self.logs_dir / "droid_status.ndjson"
        self.execution_id = self._get_execution_id()
        self.droid_id = self._detect_droid_id()
        
    def _get_execution_id(self) -> Optional[str]:
        """Get execution ID from environment or generate new one"""
        execution_id = os.environ.get("DROID_EXECUTION_ID")
        if not execution_id:
            # Try to read from status tracking file
            tracking_file = self.project_root / ".factory" / "current_execution.json"
            if tracking_file.exists():
                try:
                    with open(tracking_file, 'r') as f:
                        data = json.load(f)
                        execution_id = data.get("execution_id")
                except:
                    pass
        return execution_id
    
    def _detect_droid_id(self) -> str:
        """Auto-detect droid ID from environment or context"""
        droid_id = os.environ.get("DROID_ID")
        if droid_id:
            return droid_id
            
        # Try to detect from process name or script
        script_name = os.path.basename(os.environ.get("SCRIPT_NAME", ""))
        if script_name:
            droid_id = script_name.replace(".md", "").replace(".py", "")
        
        # Fallback to generic identifier
        return droid_id or "unknown-droid"
    
    def report_status(self, status: Union[DroidStatus, str], details: Optional[Dict[str, Any]] = None):
        """Report current droid status with optional details"""
        if isinstance(status, DroidStatus):
            status = status.value
        
        report = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "droid_id": self.droid_id,
            "execution_id": self.execution_id,
            "status": status,
            "details": details or {}
        }
        
        # Write to status log
        with open(self.status_file, 'a', encoding='utf-8') as f:
            f.write(json.dumps(report) + '\n')
        
        return report
    
    def report_task_start(self, task_id: str, task_description: str, context: Optional[Dict[str, Any]] = None):
        """Report task start for execution tracking"""
        return self.report_status("executing", {
            "task_id": task_id,
            "task_description": task_description,
            "context": context or {},
            "event_type": "task_start"
        })
    
    def report_task_progress(self, task_id: str, progress: float, message: Optional[str] = None):
        """Report task progress (0.0 to 1.0)"""
        return self.report_status("executing", {
            "task_id": task_id,
            "progress": max(0.0, min(1.0, progress)),
            "message": message or f"Progress: {int(progress * 100)}%",
            "event_type": "progress"
        })
    
    def report_task_completion(self, task_id: str, result: Dict[str, Any], success: bool = True):
        """Report task completion with results"""
        status = "completed" if success else "failed"
        
        return self.report_status(status, {
            "task_id": task_id,
            "result": result,
            "success": success,
            "event_type": "task_completion"
        })
    
    def report_error(self, task_id: str, error: str, context: Optional[Dict[str, Any]] = None):
        """Report error occurrence"""
        return self.report_status("failed", {
            "task_id": task_id,
            "error": error,
            "context": context or {},
            "event_type": "error"
        })
    
    def report_resource_usage(self, cpu_percent: Optional[float] = None, 
                            memory_mb: Optional[float] = None, 
                            disk_io_mb: Optional[float] = None):
        """Report resource usage for performance monitoring"""
        details = {"event_type": "resource_usage"}
        if cpu_percent is not None:
            details["cpu_percent"] = cpu_percent
        if memory_mb is not None:
            details["memory_mb"] = memory_mb
        if disk_io_mb is not None:
            details["disk_io_mb"] = disk_io_mb
            
        return self.report_status("executing", details)


# Convenience functions for droid usage
def get_droid_interface(project_root: Optional[str] = None) -> DroidExecutionInterface:
    """Get droid interface instance"""
    if project_root is None:
        # Try to detect project root
        project_root = os.getcwd()
        # Look for .factory directory or droid-forge.yaml
        for depth in range(5):  # Check up to 5 levels up
            check_path = Path(project_root)
            if (check_path / ".factory").exists() or (check_path / "droid-forge.yaml").exists():
                break
            project_root = str(check_path.parent)
    
    return DroidExecutionInterface(project_root)


def report_status(status: Union[DroidStatus, str], details: Optional[Dict[str, Any]] = None):
    """Convenience function to report status"""
    interface = get_droid_interface()
    return interface.report_status(status, details)


def report_task_start(task_id: str, task_description: str, context: Optional[Dict[str, Any]] = None):
    """Convenience function to report task start"""
    interface = get_droid_interface()
    return interface.report_task_start(task_id, task_description, context)


def report_task_progress(task_id: str, progress: float, message: Optional[str] = None):
    """Convenience function to report task progress"""
    interface = get_droid_interface()
    return interface.report_task_progress(task_id, progress, message)


def report_task_completion(task_id: str, result: Dict[str, Any], success: bool = True):
    """Convenience function to report task completion"""
    interface = get_droid_interface()
    return interface.report_task_completion(task_id, result, success)


def report_error(task_id: str, error: str, context: Optional[Dict[str, Any]] = None):
    """Convenience function to report error"""
    interface = get_droid_interface()
    return interface.report_error(task_id, error, context)


# Context manager for task execution
class TaskExecution:
    """Context manager for automated task execution tracking"""
    
    def __init__(self, task_id: str, task_description: str, 
                 interface: Optional[DroidExecutionInterface] = None):
        self.task_id = task_id
        self.task_description = task_description
        self.interface = interface or get_droid_interface()
        self.result = None
        self.success = True
        
    def __enter__(self):
        self.report = self.interface.report_task_start(self.task_id, self.task_description)
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_type is not None:
            self.success = False
            self.result = {"error": str(exc_val), "exception_type": exc_type.__name__}
            self.interface.report_error(self.task_id, str(exc_val))
        else:
            self.result = {"completed": True, "description": self.task_description}
            
        self.interface.report_task_completion(self.task_id, self.result, self.success)
        return True  # Suppress exceptions after logging


# Usage example for droids:
"""
# Method 1: Direct function calls
from src.baas.droid_interface import report_task_start, report_task_progress, report_task_completion

report_task_start("1.1", "Implement user authentication system")
# ... do work ...
report_task_progress("1.1", 0.5, "Setting up database models")
# ... do more work ...
report_task_completion("1.1", {"files_created": ["auth.py", "models.py"]}, success=True)

# Method 2: Context manager (recommended)
from src.baas.droid_interface import TaskExecution

with TaskExecution("1.2", "Create API endpoints") as task:
    # Work automatically tracked
    files_created = ["api/auth.py", "api/users.py"]
    task.result = {"files_created": files_created}
    # Completion automatically logged on exit
"""
