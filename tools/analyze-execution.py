#!/usr/bin/env python3
"""
Execution tracking analysis tool for Droid Forge
Analyzes performance metrics, execution patterns, and droid utilization
"""

import json
import argparse
from pathlib import Path
from datetime import datetime, timezone
from typing import Dict, Any, List, Optional
from collections import defaultdict, Counter
import sys


class ExecutionAnalyzer:
    """Analyzes execution tracking data and generates performance reports"""
    
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        self.logs_dir = self.project_root / ".factory" / "logs"
        
        self.events_file = self.logs_dir / "events.ndjson"
        self.results_file = self.logs_dir / "results.ndjson"
        self.performance_file = self.logs_dir / "performance.ndjson"
        self.droid_status_file = self.logs_dir / "droid_status.ndjson"
        
        self.events = []
        self.results = []
        self.performance_metrics = []
        self.droid_status = []
        
    def load_data(self):
        """Load all execution tracking data"""
        for file_path, data_attr in [
            (self.events_file, "events"),
            (self.results_file, "results"),
            (self.performance_file, "performance_metrics"),
            (self.droid_status_file, "droid_status")
        ]:
            if file_path.exists():
                try:
                    with open(file_path, 'r') as f:
                        setattr(self, data_attr, [json.loads(line) for line in f if line.strip()])
                except Exception as e:
                    print(f"Warning: Could not load {file_path}: {e}")
    
    def analyze_execution_patterns(self) -> Dict[str, Any]:
        """Analyze execution patterns and timelines"""
        execution_started = [e for e in self.events if e.get("event_type") == "task.execution.started"]
        execution_completed = [e for e in self.events if e.get("event_type") == "task.execution.completed"]
        execution_abandoned = [e for e in self.events if e.get("event_type") == "task.execution.abandoned"]
        
        # Calculate execution durations
        durations = []
        for completed in execution_completed:
            execution_id = completed.get("execution_id")
            started = next((e for e in execution_started if e.get("execution_id") == execution_id), None)
            if started:
                start_time = datetime.fromisoformat(started["timestamp"])
                end_time = datetime.fromisoformat(completed["timestamp"])
                duration = (end_time - start_time).total_seconds()
                durations.append({
                    "execution_id": execution_id,
                    "duration_seconds": duration,
                    "droid_id": completed.get("droid_id", "unknown"),
                    "task_id": completed.get("task_id", "unknown")
                })
        
        return {
            "total_executions_started": len(execution_started),
            "total_executions_completed": len(execution_completed),
            "total_executions_abandoned": len(execution_abandoned),
            "completion_rate": len(execution_completed) / len(execution_started) if execution_started else 0,
            "abandonment_rate": len(execution_abandoned) / len(execution_started) if execution_started else 0,
            "average_duration": sum(d["duration_seconds"] for d in durations) / len(durations) if durations else 0,
            "execution_details": durations[:20],  # Top 20 durations
            "longest_executions": sorted(durations, key=lambda x: x["duration_seconds"], reverse=True)[:10]
        }
    
    def analyze_droid_performance(self) -> Dict[str, Any]:
        """Analyze individual droid performance metrics"""
        droid_stats = defaultdict(lambda: {
            "executions": 0,
            "successful": 0,
            "failed": 0,
            "abandoned": 0,
            "total_duration": 0.0,
            "avg_duration": 0.0,
            "self_reports": 0,
            "last_seen": None
        })
        
        # Analyze execution events
        execution_events = [e for e in self.events if e.get("event_type") in [
            "task.execution.started", "task.execution.completed", "task.execution.abandoned"
        ]]
        
        for event in execution_events:
            droid_id = event.get("droid_id", "unknown")
            event_type = event.get("event_type")
            
            droid_stats[droid_id]["executions"] += 1
            
            if event_type == "task.execution.completed":
                if event.get("status") == "completed":
                    droid_stats[droid_id]["successful"] += 1
                else:
                    droid_stats[droid_id]["failed"] += 1
            elif event_type == "task.execution.abandoned":
                droid_stats[droid_id]["abandoned"] += 1
        
        # Analyze self-reports
        for status in self.droid_status:
            droid_id = status.get("droid_id", "unknown")
            droid_stats[droid_id]["self_reports"] += 1
            
            timestamp = datetime.fromisoformat(status["timestamp"])
            if droid_stats[droid_id]["last_seen"] is None or timestamp > droid_stats[droid_id]["last_seen"]:
                droid_stats[droid_id]["last_seen"] = timestamp
        
        # Calculate success rates and averages
        for droid_id, stats in droid_stats.items():
            if stats["executions"] > 0:
                stats["success_rate"] = stats["successful"] / stats["executions"]
                stats["failure_rate"] = stats["failed"] / stats["executions"]
            else:
                stats["success_rate"] = 0.0
                stats["failure_rate"] = 0.0
        
        return dict(droid_stats)
    
    def analyze_result_patterns(self) -> Dict[str, Any]:
        """Analyze result categories and patterns"""
        result_categories = Counter()
        error_patterns = Counter()
        success_patterns = Counter()
        
        for result in self.results:
            category = result.get("category", "unknown")
            result_categories[category] += 1
            
            if result.get("success", True):
                success_patterns[category] += 1
            else:
                error_patterns[category] += 1
        
        validated_results = [r for r in self.results if r.get("event_type") == "task.result.validated"]
        
        return {
            "result_categories": dict(result_categories),
            "success_by_category": dict(success_patterns),
            "errors_by_category": dict(error_patterns),
            "total_validated_results": len(validated_results),
            "validation_rate": len(validated_results) / len(self.results) if self.results else 0
        }
    
    def detect_performance_issues(self) -> List[Dict[str, Any]]:
        """Detect common performance issues and anomalies"""
        issues = []
        
        execution_patterns = self.analyze_execution_patterns()
        droid_performance = self.analyze_droid_performance()
        
        # High abandonment rate
        if execution_patterns["abandonment_rate"] > 0.1:  # > 10%
            issues.append({
                "type": "high_abandonment_rate",
                "severity": "warning",
                "description": f"High task abandonment rate: {execution_patterns['abandonment_rate']:.1%}",
                "recommendation": "Review timeout settings and droid reliability"
            })
        
        # Slow droids
        for droid_id, stats in droid_performance.items():
            if stats["executions"] > 2 and stats["success_rate"] < 0.5:  # < 50% success rate
                issues.append({
                    "type": "poor_droid_performance",
                    "severity": "error",
                    "droid_id": droid_id,
                    "description": f"Droid {droid_id} has low success rate: {stats['success_rate']:.1%}",
                    "recommendation": "Review droid capabilities and task matching"
                })
        
        # Check for stuck tasks (long running without completion)
        execution_started = [e for e in self.events if e.get("event_type") == "task.execution.started"]
        execution_completed = [e for e in self.events if e.get("event_type") == "task.execution.completed"]
        
        started_ids = {e.get("execution_id") for e in execution_started}
        completed_ids = {e.get("execution_id") for e in execution_completed}
        stuck_ids = started_ids - completed_ids
        
        if stuck_ids:
            issues.append({
                "type": "stuck_executions",
                "severity": "warning",
                "count": len(stuck_ids),
                "description": f"{len(stuck_ids)} executions may be stuck",
                "execution_ids": list(stuck_ids)[:5],  # Show first 5
                "recommendation": "Check for timeout configuration or droid hanging"
            })
        
        return issues
    
    def generate_performance_report(self) -> Dict[str, Any]:
        """Generate comprehensive performance report"""
        self.load_data()
        
        return {
            "report_generated_at": datetime.now(timezone.utc).isoformat(),
            "project_root": str(self.project_root),
            "data_summary": {
                "events_loaded": len(self.events),
                "results_loaded": len(self.results),
                "performance_metrics_loaded": len(self.performance_metrics),
                "droid_status_entries": len(self.droid_status)
            },
            "execution_patterns": self.analyze_execution_patterns(),
            "droid_performance": self.analyze_droid_performance(),
            "result_patterns": self.analyze_result_patterns(),
            "performance_issues": self.detect_performance_issues(),
            "recent_activity": self.get_recent_activity()
        }
    
    def get_recent_activity(self, hours: int = 24) -> List[Dict[str, Any]]:
        """Get recent activity from the last N hours"""
        cutoff_time = datetime.now(timezone.utc).timestamp() - (hours * 3600)
        recent_activity = []
        
        for event in self.events[-100:]:  # Last 100 events
            try:
                event_time = datetime.fromisoformat(event["timestamp"]).timestamp()
                if event_time > cutoff_time:
                    recent_activity.append(event)
            except:
                continue
        
        return recent_activity
    
    def print_report(self, report: Dict[str, Any]):
        """Print formatted performance report"""
        print(f"\n{'='*60}")
        print(f"EXECUTION PERFORMANCE REPORT")
        print(f"Generated: {report['report_generated_at']}")
        print(f"{'='*60}")
        
        print(f"\n📊 DATA SUMMARY:")
        data_summary = report["data_summary"]
        print(f"  Events loaded:      {data_summary['events_loaded']}")
        print(f"  Results loaded:     {data_summary['results_loaded']}")
        print(f"  Performance metrics: {data_summary['performance_metrics_loaded']}")
        print(f"  Droid status entries: {data_summary['droid_status_entries']}")
        
        print(f"\n🚀 EXECUTION PATTERNS:")
        exec_patterns = report["execution_patterns"]
        print(f"  Total executions started:   {exec_patterns['total_executions_started']}")
        print(f"  Total executions completed: {exec_patterns['total_executions_completed']}")
        print(f"  Total executions abandoned: {exec_patterns['total_executions_abandoned']}")
        print(f"  Completion rate:            {exec_patterns['completion_rate']:.1%}")
        print(f"  Abandonment rate:           {exec_patterns['abandonment_rate']:.1%}")
        print(f"  Average duration:           {exec_patterns['average_duration']:.1f}s")
        
        if exec_patterns['longest_executions']:
            print(f"\n  Longest executions:")
            for i, exec_info in enumerate(exec_patterns['longest_executions'][:3], 1):
                print(f"    {i}. {exec_info['droid_id']} - {exec_info['duration_seconds']:.1f}s ({exec_info['task_id']})")
        
        print(f"\n🤖 DROID PERFORMANCE:")
        droid_perf = report["droid_performance"]
        for droid_id, stats in sorted(droid_perf.items(), key=lambda x: x[1]["executions"], reverse=True):
            if stats["executions"] > 0:
                print(f"  {droid_id}:")
                print(f"    Executions: {stats['executions']}")
                print(f"    Success rate: {stats['success_rate']:.1%}")
                print(f"    Self-reports: {stats['self_reports']}")
        
        print(f"\n📈 RESULT PATTERNS:")
        result_patterns = report["result_patterns"]
        print(f"  Result categories: {result_patterns['result_categories']}")
        print(f"  Validation rate: {result_patterns['validation_rate']:.1%}")
        
        if report["performance_issues"]:
            print(f"\n⚠️  PERFORMANCE ISSUES:")
            for issue in report["performance_issues"]:
                severity_emoji = "🚨" if issue["severity"] == "error" else "⚠️"
                print(f"  {severity_emoji} {issue['description']}")
                print(f"     💡 {issue['recommendation']}")
        
        print(f"\n{'='*60}\n")


def main():
    parser = argparse.ArgumentParser(description="Analyze Droid Forge execution tracking")
    parser.add_argument("--project-dir", default=".", help="Project root directory")
    parser.add_argument("--full", action="store_true", help="Show full detailed report")
    parser.add_argument("--json", action="store_true", help="Output JSON instead of formatted report")
    parser.add_argument("--events", action="store_true", help="Show only execution events analysis")
    parser.add_argument("--droids", action="store_true", help="Show only droid performance analysis")
    parser.add_argument("--issues", action="store_true", help="Show only performance issues")
    
    args = parser.parse_args()
    
    analyzer = ExecutionAnalyzer(args.project_dir)
    report = analyzer.generate_performance_report()
    
    if args.json:
        print(json.dumps(report, indent=2))
    elif args.events:
        print("EXECUTION EVENTS ANALYSIS:")
        print(json.dumps(report["execution_patterns"], indent=2))
    elif args.droids:
        print("DROID PERFORMANCE ANALYSIS:")
        print(json.dumps(report["droid_performance"], indent=2))
    elif args.issues:
        print("PERFORMANCE ISSUES:")
        print(json.dumps(report["performance_issues"], indent=2))
    else:
        analyzer.print_report(report)


if __name__ == "__main__":
    main()
