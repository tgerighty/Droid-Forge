"""
Audit logging system for Geonosis Droid Factory
Implements NDJSON logging as specified in the PRD
"""

import json
import os
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, Any, Optional


class AuditLogger:
    """NDJSON audit logger for the Geonosis factory"""
    
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        self.logs_dir = self.project_root / ".factory" / "logs"
        self.logs_dir.mkdir(parents=True, exist_ok=True)
        
        self.audit_file = self.logs_dir / "audit.ndjson"
        self.events_file = self.logs_dir / "events.ndjson"
        
        self.run_id = self._generate_run_id()
    
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
