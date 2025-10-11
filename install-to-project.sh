#!/bin/bash
set -euo pipefail

# Droid Forge Project Installer
# Installs Droid Forge One-Shot Mode into a target project directory
# Usage: ./install-to-project.sh [target-directory]

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get script directory (where Droid Forge source is)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR"

# Print functions
print_header() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}   ${BLUE}🚀 Droid Forge Project Installer${NC}            ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}   ${BLUE}One-Shot Autonomous Execution Mode${NC}          ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_step() {
    echo ""
    echo -e "${CYAN}▶ $1${NC}"
}

# Show usage
show_usage() {
    echo "Usage: $0 [target-directory]"
    echo ""
    echo "Arguments:"
    echo "  target-directory    Path to the project where you want to install Droid Forge"
    echo "                      (If not provided, will prompt interactively)"
    echo ""
    echo "Example:"
    echo "  $0 ~/projects/my-awesome-app"
    echo ""
    echo "What gets installed:"
    echo "  • All Droid Forge droids (.factory/droids/)"
    echo "  • Configuration file (droid-forge.yaml)"
    echo "  • Execution tools (tools/)"
    echo "  • Test framework (tests/)"
    echo "  • Documentation (AGENTS.md)"
    echo ""
}

# Check prerequisites
check_prerequisites() {
    print_step "Checking prerequisites"
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        print_error "Git is required but not installed"
        echo "   Please install git first: https://git-scm.com/downloads"
        exit 1
    fi
    print_success "Git found: $(git --version | head -1)"
    
    # Check if Factory.ai CLI is installed
    if ! command -v droid &> /dev/null; then
        print_warning "Factory.ai CLI (droid) not found"
        echo "   To use one-shot mode, install from: https://docs.factory.ai/cli/getting-started/quickstart"
        echo ""
        read -p "   Continue installation anyway? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
    else
        print_success "Factory.ai CLI found"
    fi
    
    # Check if we're in the Droid Forge source directory
    if [ ! -f "$SOURCE_DIR/droid-forge.yaml" ]; then
        print_error "Not in Droid Forge source directory"
        echo "   Please run this script from the Droid Forge repository root"
        exit 1
    fi
    print_success "Droid Forge source directory verified"
}

# Get target directory
get_target_directory() {
    local target="$1"
    
    if [ -z "$target" ]; then
        print_step "Select target project directory"
        echo ""
        echo "Enter the full path to your project directory:"
        echo "(e.g., /Users/you/projects/my-app or ~/projects/my-app)"
        echo ""
        read -p "Target directory: " target
        
        # Expand tilde
        target="${target/#\~/$HOME}"
        
        if [ -z "$target" ]; then
            print_error "No target directory specified"
            exit 1
        fi
    fi
    
    # Expand tilde if present
    target="${target/#\~/$HOME}"
    
    # Convert to absolute path
    if [[ "$target" != /* ]]; then
        target="$(pwd)/$target"
    fi
    
    echo "$target"
}

# Verify target directory
verify_target_directory() {
    local target="$1"
    
    print_step "Verifying target directory: $target"
    
    # Check if directory exists
    if [ ! -d "$target" ]; then
        print_warning "Directory does not exist: $target"
        read -p "   Create it? (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mkdir -p "$target"
            print_success "Created directory: $target"
        else
            print_error "Installation cancelled"
            exit 1
        fi
    else
        print_success "Target directory exists"
    fi
    
    # Check if it's a git repository
    if [ -d "$target/.git" ]; then
        print_success "Git repository detected"
    else
        print_warning "Not a git repository"
        read -p "   Initialize git repository? (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            (cd "$target" && git init)
            print_success "Initialized git repository"
        else
            print_info "Continuing without git initialization"
        fi
    fi
    
    # Check if Droid Forge is already installed
    if [ -f "$target/droid-forge.yaml" ]; then
        print_warning "Droid Forge appears to be already installed in this directory"
        read -p "   Overwrite existing installation? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Installation cancelled"
            exit 1
        fi
    fi
}

# Install droids
install_droids() {
    local target="$1"
    
    print_step "Installing Droid Forge droids"
    
    # Create .factory/droids directory
    mkdir -p "$target/.factory/droids"
    
    # Copy all droid files
    local droid_count=0
    if [ -d "$SOURCE_DIR/.factory/droids" ]; then
        for droid_file in "$SOURCE_DIR/.factory/droids"/*.md; do
            if [ -f "$droid_file" ]; then
                local droid_name=$(basename "$droid_file")
                cp "$droid_file" "$target/.factory/droids/"
                print_success "Installed: $droid_name"
                droid_count=$((droid_count + 1))
            fi
        done
    fi
    
    if [ $droid_count -eq 0 ]; then
        print_error "No droids found in source directory"
        exit 1
    fi
    
    print_success "Installed $droid_count droids"
}

# Install tools
install_tools() {
    local target="$1"
    
    print_step "Installing execution tools"
    
    # Create tools directory
    mkdir -p "$target/tools"
    
    # Copy all tool scripts
    local tool_count=0
    if [ -d "$SOURCE_DIR/tools" ]; then
        for tool_file in "$SOURCE_DIR/tools"/*.sh; do
            if [ -f "$tool_file" ]; then
                local tool_name=$(basename "$tool_file")
                cp "$tool_file" "$target/tools/"
                chmod +x "$target/tools/$tool_name"
                print_success "Installed: $tool_name"
                tool_count=$((tool_count + 1))
            fi
        done
    fi
    
    print_success "Installed $tool_count tools"
}

# Install tests
install_tests() {
    local target="$1"
    
    print_step "Installing test framework"
    
    # Create tests directory
    mkdir -p "$target/tests/integration"
    
    # Copy test files
    local test_count=0
    if [ -d "$SOURCE_DIR/tests" ]; then
        for test_file in "$SOURCE_DIR/tests"/*.sh; do
            if [ -f "$test_file" ]; then
                local test_name=$(basename "$test_file")
                cp "$test_file" "$target/tests/"
                chmod +x "$target/tests/$test_name"
                test_count=$((test_count + 1))
            fi
        done
        
        # Copy integration tests
        if [ -d "$SOURCE_DIR/tests/integration" ]; then
            for test_file in "$SOURCE_DIR/tests/integration"/*.sh; do
                if [ -f "$test_file" ]; then
                    local test_name=$(basename "$test_file")
                    cp "$test_file" "$target/tests/integration/"
                    chmod +x "$target/tests/integration/$test_name"
                    test_count=$((test_count + 1))
                fi
            done
        fi
    fi
    
    print_success "Installed $test_count test files"
}

# Install configuration
install_configuration() {
    local target="$1"
    
    print_step "Installing configuration"
    
    # Copy droid-forge.yaml
    if [ -f "$SOURCE_DIR/droid-forge.yaml" ]; then
        cp "$SOURCE_DIR/droid-forge.yaml" "$target/"
        print_success "Installed: droid-forge.yaml"
    else
        print_warning "droid-forge.yaml not found in source"
    fi
    
    # Create tasks directory with template
    mkdir -p "$target/tasks"
    
    # Create a simple task template
    cat > "$target/tasks/template.md" << 'EOF'
## Relevant Files

- `path/to/file.ext` - Description

## Tasks

- [ ] 1.0 Major Task Category
  - [ ] 1.1 Sub-task description
  - [ ] 1.2 Another sub-task
EOF
    print_success "Created: tasks/template.md"
}

# Install documentation
install_documentation() {
    local target="$1"
    
    print_step "Installing documentation"
    
    # Copy AGENTS.md
    if [ -f "$SOURCE_DIR/AGENTS.md" ]; then
        cp "$SOURCE_DIR/AGENTS.md" "$target/"
        print_success "Installed: AGENTS.md (coding guidelines)"
    fi
    
    # Create a README for the installation
    cat > "$target/DROID-FORGE-SETUP.md" << 'EOF'
# Droid Forge - One-Shot Mode Setup

This project has been configured with Droid Forge One-Shot Autonomous Execution Mode.

## Quick Start

### 1. Prerequisites

Ensure you have the Factory.ai CLI installed:
```bash
# Check if installed
droid --version

# If not installed, visit:
# https://docs.factory.ai/cli/getting-started/quickstart
```

### 2. Using One-Shot Mode

Start the manager orchestrator and select "one-shot" when prompted:

```bash
droid
> Ask manager-orchestrator-droid-forge to execute my tasks
```

When asked about execution mode, respond with **"one-shot"** for autonomous execution.

### 3. Configuration

Review and customize `droid-forge.yaml` for your project:
- Adjust delegation rules
- Configure git workflow patterns
- Set quality gate thresholds
- Customize one-shot mode settings

### 4. Creating Tasks

1. Copy the template:
   ```bash
   cp tasks/template.md tasks/my-feature.md
   ```

2. Edit your task file with specific requirements

3. Run the manager orchestrator to execute tasks

## Files Installed

- `.factory/droids/` - All Droid Forge droids
- `tools/` - Execution tools and utilities
- `tests/` - Test framework
- `tasks/` - Task directory (with template)
- `droid-forge.yaml` - Configuration
- `AGENTS.md` - Coding guidelines for AI agents
- `DROID-FORGE-SETUP.md` - This file

## Documentation

- **AGENTS.md** - Complete guide for AI agents using Droid Forge
- **droid-forge.yaml** - Configuration reference with comments

## Support

For issues or questions:
- GitHub: https://github.com/tgerighty/Droid-Forge
- Docs: See AGENTS.md for comprehensive usage guide

## What is One-Shot Mode?

One-Shot Mode enables fully autonomous task execution:
- No confirmation prompts between sub-tasks
- Automatic test generation and execution
- Quality gate enforcement (linting, security, coverage)
- Auto-commit and push after each sub-task
- Automated PR creation and iterative review
- Error recovery with retry logic

Perfect for well-defined features where you want complete automation!
EOF
    print_success "Created: DROID-FORGE-SETUP.md"
}

# Create .gitignore entries
update_gitignore() {
    local target="$1"
    
    print_step "Updating .gitignore"
    
    local gitignore_entries=(
        "# Droid Forge"
        ".droid-forge/"
        "*.log"
        ".DS_Store"
    )
    
    # Create or append to .gitignore
    local gitignore_file="$target/.gitignore"
    local needs_update=false
    
    if [ ! -f "$gitignore_file" ]; then
        needs_update=true
    elif ! grep -q "# Droid Forge" "$gitignore_file" 2>/dev/null; then
        needs_update=true
    fi
    
    if [ "$needs_update" = true ]; then
        echo "" >> "$gitignore_file"
        for entry in "${gitignore_entries[@]}"; do
            echo "$entry" >> "$gitignore_file"
        done
        print_success "Updated .gitignore with Droid Forge entries"
    else
        print_info ".gitignore already contains Droid Forge entries"
    fi
}

# Show completion summary
show_summary() {
    local target="$1"
    
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}   ${GREEN}✅ Installation Complete!${NC}                     ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    print_info "Droid Forge has been installed to:"
    echo "   $target"
    echo ""
    
    print_info "Next steps:"
    echo ""
    echo "1. Navigate to your project:"
    echo "   cd \"$target\""
    echo ""
    echo "2. Review the setup guide:"
    echo "   cat DROID-FORGE-SETUP.md"
    echo ""
    echo "3. Customize configuration:"
    echo "   nano droid-forge.yaml"
    echo ""
    echo "4. Create your first task:"
    echo "   cp tasks/template.md tasks/my-first-feature.md"
    echo "   nano tasks/my-first-feature.md"
    echo ""
    echo "5. Start using one-shot mode:"
    echo "   droid"
    echo "   > Ask manager-orchestrator-droid-forge to analyze and execute my tasks"
    echo ""
    
    print_success "Happy autonomous developing! 🚀"
    echo ""
}

# Main installation function
main() {
    local target_dir="${1:-}"
    
    print_header
    
    # Check prerequisites
    check_prerequisites
    
    # Get and verify target directory
    target_dir=$(get_target_directory "$target_dir")
    verify_target_directory "$target_dir"
    
    # Perform installation
    install_droids "$target_dir"
    install_tools "$target_dir"
    install_tests "$target_dir"
    install_configuration "$target_dir"
    install_documentation "$target_dir"
    update_gitignore "$target_dir"
    
    # Show summary
    show_summary "$target_dir"
}

# Handle script arguments
case "${1:-}" in
    "--help"|"-h")
        print_header
        show_usage
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac
