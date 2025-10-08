#!/usr/bin/env python3
"""
Simple audit log analysis tool for Droid Forge
Analyzes NDJSON logs to provide insights on droid performance and usage
"""

import json
import argparse
import sys
from pathlib import Path
from datetime import datetime
from collections import defaultdict, Counter
import statistics


def load_ndjson(file_path):
    """Load NDJSON file and return list of events"""
    events = []
    try:
        with open(file_path, 'r') as f:
            for line in f:
                if line.strip():
                    events.append(json.loads(line))
    except FileNotFoundError:
        print(f"File not found: {file_path}")
        return []
    return events


def analyze_events(events):
    """Analyze events and return metrics"""
    metrics = {
        'total_events': len(events),
        'runs': defaultdict(dict),
        'tasks': defaultdict(dict),
        'droids': Counter(),
        'event_types': Counter(),
        'durations': []
    }
    
    task_start_times = {}
    droid_start_times = {}
    
    for event in events:
        event_type = event.get('event_type')
        run_id = event.get('run_id')
        timestamp = datetime.fromisoformat(event['timestamp'].replace('Z', '+00:00'))
        
        metrics['event_types'][event_type] += 1
        
        if event_type == 'task.started':
            task_id = event.get('task_id')
            task_start_times[task_id] = timestamp
            
        elif event_type == 'task.completed':
            task_id = event.get('task_id')
            if task_id in task_start_times:
                duration = (timestamp - task_start_times[task_id]).total_seconds()
                metrics['durations'].append(duration)
                metrics['tasks'][task_id] = {
                    'duration': duration,
                    'status': 'completed',
                    'droid_id': event.get('droid_id'),
                    'run_id': run_id
                }
                del task_start_times[task_id]
                
        elif event_type == 'task.failed':
            task_id = event.get('task_id')
            metrics['tasks'][task_id] = {
                'status': 'failed',
                'error': event.get('details', {}).get('error', 'Unknown error'),
                'run_id': run_id
            }
            if task_id in task_start_times:
                del task_start_times[task_id]
                
        elif event_type == 'droid.started':
            droid_id = event.get('droid_id')
            droid_start_times[droid_id] = timestamp
            metrics['droids'][droid_id] += 1
            
        elif event_type == 'droid.completed':
            droid_id = event.get('droid_id')
            if droid_id in droid_start_times:
                duration = (timestamp - droid_start_times[droid_id]).total_seconds()
                # Store droid duration if needed
                del droid_start_times[droid_id]
    
    return metrics


def print_summary(metrics):
    """Print analysis summary"""
    print(f"\n📊 Droid Forge Audit Analysis")
    print("=" * 50)
    
    print(f"Total Events: {metrics['total_events']}")
    print(f"Unique Tasks: {len(metrics['tasks'])}")
    print(f"Unique Droids Used: {len(metrics['droids'])}")
    
    # Task completion rates
    completed_tasks = sum(1 for task in metrics['tasks'].values() if task['status'] == 'completed')
    failed_tasks = sum(1 for task in metrics['tasks'].values() if task['status'] == 'failed')
    total_tasks = completed_tasks + failed_tasks
    
    if total_tasks > 0:
        completion_rate = (completed_tasks / total_tasks) * 100
        print(f"Task Completion Rate: {completion_rate:.1f}% ({completed_tasks}/{total_tasks})")
        print(f"Failed Tasks: {failed_tasks}")
    
    # Duration statistics
    if metrics['durations']:
        print(f"\n⏱️  Task Duration Statistics:")
        print(f"Average: {statistics.mean(metrics['durations']):.1f}s")
        print(f"Median: {statistics.median(metrics['durations']):.1f}s")
        print(f"Min: {min(metrics['durations']):.1f}s")
        print(f"Max: {max(metrics['durations']):.1f}s")
    
    # Event type breakdown
    print(f"\n📋 Event Types:")
    for event_type, count in metrics['event_types'].most_common():
        print(f"  {event_type}: {count}")
    
    # Droid usage
    print(f"\n🤖 Droid Usage:")
    for droid_id, count in metrics['droids'].most_common(10):
        print(f"  {droid_id}: {count} times")
    
    # Failed tasks details
    failed_tasks_details = [task for task in metrics['tasks'].values() if task['status'] == 'failed']
    if failed_tasks_details:
        print(f"\n❌ Failed Tasks:")
        for task in failed_tasks_details:
            print(f"  Task {task.get('task_id', 'unknown')}: {task['error']}")


def main():
    parser = argparse.ArgumentParser(description='Analyze Corellian audit logs')
    parser.add_argument('--project-dir', default='.', help='Project directory path')
    parser.add_argument('--events', action='store_true', help='Analyze events.ndjson')
    parser.add_argument('--audit', action='store_true', help='Analyze audit.ndjson')
    parser.add_argument('--all', action='store_true', help='Analyze both files')
    
    args = parser.parse_args()
    
    project_dir = Path(args.project_dir)
    logs_dir = project_dir / '.factory' / 'logs'
    
    if not args.events and not args.audit and not args.all:
        args.all = True
    
    if args.all or args.events:
        events_file = logs_dir / 'events.ndjson'
        print(f"\nAnalyzing events from: {events_file}")
        events = load_ndjson(events_file)
        if events:
            metrics = analyze_events(events)
            print_summary(metrics)
    
    if args.all or args.audit:
        audit_file = logs_dir / 'audit.ndjson'
        print(f"\nAnalyzing audit logs from: {audit_file}")
        audit_events = load_ndjson(audit_file)
        if audit_events:
            print(f"Audit Events: {len(audit_events)}")
            # Simple audit analysis
            audit_actions = Counter(event.get('action', 'unknown') for event in audit_events)
            print("Audit Actions:")
            for action, count in audit_actions.most_common():
                print(f"  {action}: {count}")


if __name__ == '__main__':
    main()
