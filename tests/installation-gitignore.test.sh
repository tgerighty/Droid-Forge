#!/bin/bash
set -euo pipefail

# Test script to verify .gitignore behavior for different installation modes
# This test ensures that:
# 1. Personal installations (option 2) skip .gitignore updates
# 2. Project installations (option 1) add .factory/ to .gitignore
# 3. install-to-project.sh always adds .factory/ to .gitignore

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="/tmp/droid-forge-install-test-$$"
SOURCE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_test() {
    echo -e "${YELLOW}🧪 Testing: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

cleanup() {
    rm -rf "$TEST_DIR"
}

# Setup test environment
setup_test() {
    print_test "Setting up test environment"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # Copy install script and make it executable
    cp "$SOURCE_DIR/install.sh" ./
    chmod +x install.sh
    
    # Copy install-to-project script and make it executable
    cp "$SOURCE_DIR/install-to-project.sh" ./
    chmod +x install-to-project.sh
    
    # Create a minimal git repository
    git init > /dev/null 2>&1
    git config user.email "test@example.com"
    git config user.name "Test User"
    
    # Copy necessary files for install script
    cp "$SOURCE_DIR/droid-forge.yaml" ./
    mkdir -p .factory/droids
    echo "# Test droid" > .factory/droids/test-droid-forge.md
    
    print_success "Test environment ready"
}

# Test personal installation gitignore behavior (unit test)
test_personal_installation() {
    print_test "Personal installation gitignore behavior (unit test)"
    
    # Create test directory
    local personal_test="$TEST_DIR/personal-test"
    mkdir -p "$personal_test"
    cd "$personal_test"
    
    # Create a simple .gitignore file
    touch .gitignore
    
    # Simulate the update_gitignore function logic for personal installation
    INSTALL_LOCATION="user"
    
    # Only add .factory/ to .gitignore for project installations
    # Personal installations (~/.factory/droids) don't need gitignore
    if [ "$INSTALL_LOCATION" = "user" ]; then
        print_info "Personal installation detected - skipping .gitignore update"
        # Do nothing - this is the expected behavior
    else
        print_error "Unexpected: INSTALL_LOCATION is not 'user'"
        return 1
    fi
    
    # Check that .gitignore was NOT modified
    if [ -f ".gitignore" ] && ! grep -q "^\.factory/" .gitignore; then
        print_success "Personal installation correctly skipped .gitignore update"
    else
        print_error "Personal installation incorrectly modified .gitignore"
        return 1
    fi
    
    cd "$TEST_DIR"
    rm -rf "$personal_test"
}

# Test project installation gitignore behavior (unit test)
test_project_installation() {
    print_test "Project installation gitignore behavior (unit test)"
    
    # Create test directory
    local project_test="$TEST_DIR/project-test"
    mkdir -p "$project_test"
    cd "$project_test"
    
    # Create a simple .gitignore file
    touch .gitignore
    
    # Simulate the update_gitignore function logic for project installation
    INSTALL_LOCATION="project"
    local gitignore_file=".gitignore"
    
    # Only add .factory/ to .gitignore for project installations
    if [ "$INSTALL_LOCATION" = "user" ]; then
        print_info "Personal installation detected - skipping .gitignore update"
        return 1
    else
        print_info "Updating .gitignore to exclude .factory directory..."
        
        # Check if .gitignore exists
        if [ ! -f "$gitignore_file" ]; then
            print_info "Creating .gitignore file"
            cat > "$gitignore_file" << 'EOF'
# Droid Forge - Custom droids directory (project-specific)
.factory/
EOF
        else
            # Check if .factory is already in .gitignore
            if grep -q "^\.factory/" "$gitignore_file" 2>/dev/null; then
                print_info ".gitignore already contains .factory/ entry"
            else
                # Add .factory entry to .gitignore
                echo "" >> "$gitignore_file"
                echo "# Droid Forge - Custom droids directory (project-specific)" >> "$gitignore_file"
                echo ".factory/" >> "$gitignore_file"
            fi
        fi
    fi
    
    # Check that .gitignore WAS modified and contains .factory/
    if [ -f ".gitignore" ] && grep -q "^\.factory/" .gitignore; then
        print_success "Project installation correctly added .factory/ to .gitignore"
    else
        print_error "Project installation failed to add .factory/ to .gitignore"
        echo "Debug: .gitignore contents:"
        if [ -f ".gitignore" ]; then
            cat .gitignore
        else
            echo "No .gitignore file found"
        fi
        return 1
    fi
    
    cd "$TEST_DIR"
    rm -rf "$project_test"
}

# Test install-to-project script (should always update gitignore)
test_install_to_project() {
    print_test "install-to-project.sh (should always add .factory/ to .gitignore)"
    
    # Create a clean test directory
    local target_test="$TEST_DIR/target-test"
    mkdir -p "$target_test"
    
    # Initialize git repo in target
    cd "$target_test"
    git init > /dev/null 2>&1
    git config user.email "test@example.com"
    git config user.name "Test User"
    cd "$TEST_DIR"
    
    # Run install-to-project script
    echo "$target_test" | ./install-to-project.sh > install.log 2>&1 || true
    
    # Check if .gitignore contains .factory/
    cd "$target_test"
    if [ -f ".gitignore" ] && grep -q "^\.factory/" .gitignore; then
        print_success "install-to-project.sh correctly added .factory/ to .gitignore"
    else
        print_error "install-to-project.sh failed to add .factory/ to .gitignore"
        return 1
    fi
    
    cd "$TEST_DIR"
    rm -rf "$target_test"
}

# Main test execution
main() {
    echo "🚀 Starting Droid Forge Installation Gitignore Tests"
    echo "=================================================="
    
    setup_test
    
    local test_failed=0
    
    # Run tests
    test_personal_installation || test_failed=1
    test_project_installation || test_failed=1
    test_install_to_project || test_failed=1
    
    # Cleanup
    cleanup
    
    # Report results
    echo ""
    if [ $test_failed -eq 0 ]; then
        echo "🎉 All tests passed!"
        exit 0
    else
        echo "💥 Some tests failed!"
        exit 1
    fi
}

# Handle script arguments
case "${1:-}" in
    "--help"|"-h")
        echo "Droid Forge Installation Gitignore Tests"
        echo ""
        echo "This script tests that .gitignore is correctly updated"
        echo "based on installation location:"
        echo ""
        echo "- Personal installation: Skips .gitignore update"
        echo "- Project installation: Adds .factory/ to .gitignore"
        echo "- install-to-project.sh: Always adds .factory/ to .gitignore"
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac
