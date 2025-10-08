#!/usr/bin/env python3
"""
Test script for execution tracking system
Validates all components work together correctly
"""

import sys
import os
import time
import json
from pathlib import Path

# Add src to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent / "src" / "baas"))

from audit import AuditLogger
from droid_interface import DroidExecutionInterface, TaskExecution


def test_audit_logger():
    """Test enhanced audit logger functionality"""
    print("🧪 Testing AuditLogger...")
    
    project_root = Path(__file__).parent.parent
    logger = AuditLogger(str(project_root))
    
    # Test execution tracking
    execution_id = logger.log_task_execution_started(
        task_id="test-1.1",
        droid_id="test-droid",
        description="Test task execution"
    )
    print(f"  ✓ Started execution: {execution_id}")
    
    # Simulate some work
    time.sleep(0.1)
    
    # Test completion
    result = {"files_created": ["test.py"], "tests_passed": 5}
    logger.log_task_execution_completed(execution_id, result, success=True)
    print(f"  ✓ Completed execution successfully")
    
    # Test performance metrics
    logger.log_performance_metrics()
    print(f"  ✓ Logged performance metrics")
    
    # Test result validation
    is_valid = logger.validate_and_store_result(execution_id, result)
    print(f"  ✓ Result validation: {is_valid}")
    
    # Generate execution summary
    summary = logger.generate_execution_summary()
    print(f"  ✓ Generated execution summary")
    
    return True


def test_droid_interface():
    """Test droid self-reporting interface"""
    print("🧪 Testing DroidExecutionInterface...")
    
    project_root = Path(__file__).parent.parent
    interface = DroidExecutionInterface(str(project_root))
    
    # Test status reporting
    report = interface.report_status("executing", {"test": True})
    print(f"  ✓ Reported status: {report['status']}")
    
    # Test task start reporting
    task_report = interface.report_task_start("test-2.1", "Test task via interface")
    print(f"  ✓ Reported task start: {task_report['details']['task_id']}")
    
    # Test progress reporting
    progress_report = interface.report_task_progress("test-2.1", 0.5, "Half way done")
    print(f"  ✓ Reported progress: {progress_report['details']['progress']}")
    
    # Test completion
    completion_result = {"output": "test completed successfully"}
    completion_report = interface.report_task_completion("test-2.1", completion_result, True)
    print(f"  ✓ Reported task completion: {completion_report['status']}")
    
    # Test context manager
    try:
        with TaskExecution("test-3.1", "Context manager test") as task:
            task.result = {"context_manager": True}
            time.sleep(0.05)  # Simulate work
        print(f"  ✓ Context manager executed successfully")
    except Exception as e:
        print(f"  ✗ Context manager failed: {e}")
        return False
    
    return True


def test_integration():
    """Test integration between audit logger and droid interface"""
    print("🧪 Testing Integration...")
    
    project_root = Path(__file__).parent.parent
    logger = AuditLogger(str(project_root))
    
    # Simulate droid execution using droid interface
    os.environ["DROID_EXECUTION_ID"] = "test-integration-exec"
    os.environ["DROID_ID"] = "integration-test-droid"
    
    interface = DroidExecutionInterface(str(project_root))
    
    # Start task through audit logger
    execution_id = logger.log_task_execution_started(
        task_id="int-1.1",
        droid_id="integration-test-droid",
        description="Integration test task"
    )
    
    # Droid self-reports progress
    interface.report_task_progress("int-1.1", 0.3, "Starting integration work")
    time.sleep(0.1)
    
    interface.report_task_progress("int-1.1", 0.7, "Almost done")
    time.sleep(0.1)
    
    # Droid reports completion
    result = {"integration_test": True, "files_modified": 3}
    interface.report_task_completion("int-1.1", result, True)
    
    # Complete through audit logger
    logger.log_task_execution_completed(execution_id, result, success=True)
    
    # Log droid self-report
    logger.log_droid_self_report("integration-test-droid", "completed", {
        "task_id": "int-1.1",
        "result": result
    })
    
    print(f"  ✓ Integration test completed successfully")
    
    # Clean up environment
    if "DROID_EXECUTION_ID" in os.environ:
        del os.environ["DROID_EXECUTION_ID"]
    if "DROID_ID" in os.environ:
        del os.environ["DROID_ID"]
    
    return True


def test_file_outputs():
    """Test that log files are created and contain expected data"""
    print("🧪 Testing File Outputs...")
    
    project_root = Path(__file__).parent.parent
    logs_dir = project_root / ".factory" / "logs"
    
    expected_files = [
        "audit.ndjson",
        "events.ndjson", 
        "results.ndjson",
        "performance.ndjson",
        "droid_status.ndjson"
    ]
    
    for filename in expected_files:
        file_path = logs_dir / filename
        if file_path.exists() and file_path.stat().st_size > 0:
            print(f"  ✓ {filename} exists with data")
        else:
            print(f"  ✗ {filename} missing or empty")
            return False
    
    # Test NDJSON format validation
    for filename in expected_files:
        file_path = logs_dir / filename
        try:
            with open(file_path, 'r') as f:
                lines = f.readlines()
                for line in lines:
                    if line.strip():
                        json.loads(line)  # Validate JSON format
            print(f"  ✓ {filename} valid NDJSON format")
        except Exception as e:
            print(f"  ✗ {filename} invalid format: {e}")
            return False
    
    return True


def test_performance_analysis():
    """Test the performance analysis tool"""
    print("🧪 Testing Performance Analysis...")
    
    try:
        # Import using sys.path approach
        sys.path.insert(0, str(Path(__file__).parent))
        from analyze_execution import ExecutionAnalyzer
        
        project_root = Path(__file__).parent.parent
        analyzer = ExecutionAnalyzer(str(project_root))
        
        # Load data
        analyzer.load_data()
        print(f"  ✓ Loaded execution data")
        
        # Generate report
        report = analyzer.generate_performance_report()
        print(f"  ✓ Generated performance report")
        
        # Check report structure
        required_keys = ["execution_patterns", "droid_performance", "result_patterns"]
        for key in required_keys:
            if key in report:
                print(f"  ✓ Report contains {key}")
            else:
                print(f"  ✗ Report missing {key}")
                return False
        
        return True
        
    except Exception as e:
        print(f"  ✗ Performance analysis failed: {e}")
        return False


def run_all_tests():
    """Run all tests and report results"""
    print("🚀 Starting Execution Tracking System Tests\n")
    
    tests = [
        test_audit_logger,
        test_droid_interface,
        test_integration,
        test_file_outputs,
        test_performance_analysis
    ]
    
    passed = 0
    total = len(tests)
    
    for test in tests:
        try:
            if test():
                passed += 1
                print(f"  ✅ PASSED\n")
            else:
                print(f"  ❌ FAILED\n")
        except Exception as e:
            print(f"  💥 ERROR: {e}\n")
    
    print(f"{'='*50}")
    print(f"TEST RESULTS: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 All tests passed! Execution tracking system is working correctly.")
        
        # Show log file locations
        project_root = Path(__file__).parent.parent
        logs_dir = project_root / ".factory" / "logs"
        print(f"\n📁 Log files created at: {logs_dir}")
        print(f"   View with: python tools/analyze-execution.py")
        
        return True
    else:
        print(f"❌ {total - passed} tests failed. Please check the implementation.")
        return False


def cleanup_test_data():
    """Clean up test log files"""
    print("🧹 Cleaning up test data...")
    
    project_root = Path(__file__).parent.parent
    logs_dir = project_root / ".factory" / "logs"
    
    for file_path in logs_dir.glob("*.ndjson"):
        try:
            file_path.unlink()
            print(f"  🗑️  Removed {file_path.name}")
        except:
            pass


if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="Test execution tracking system")
    parser.add_argument("--cleanup", action="store_true", help="Clean up test data only")
    parser.add_argument("--no-cleanup", action="store_true", help="Don't clean up after tests")
    
    args = parser.parse_args()
    
    if args.cleanup:
        cleanup_test_data()
    else:
        success = run_all_tests()
        
        if not args.no_cleanup:
            cleanup_test_data()
        
        sys.exit(0 if success else 1)
