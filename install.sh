#!/bin/bash

# Droid Forge Installation Script
# Installs and configures Droid Forge with Factory.ai droids

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo -e "${BLUE}🔨 Droid Forge Installation${NC}"
    echo "================================"
}

print_help() {
    echo "Droid Forge Installation Script"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --help, -h    Show this help message"
    echo "  --uninstall   Remove Droid Forge installation"
    echo "  --check       Check if Droid Forge is properly installed"
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

# Check prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        print_error "Git is required but not installed. Please install git first."
        exit 1
    fi
    print_success "Git found: $(git --version)"
    
    # Check if Factory.ai CLI is installed
    if ! command -v droid &> /dev/null; then
        print_warning "Factory.ai CLI not found. This is optional for droid usage."
        echo "   To use droids with Factory.ai, visit: https://factory.ai"
        echo "   You can still use the droids as markdown documentation without the CLI."
        echo ""
        read -p "Continue without Factory.ai CLI? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        print_success "Factory.ai CLI found: $(droid --version 2>/dev/null || echo 'version unknown')"
    fi
}

# Create directories
setup_directories() {
    print_info "Setting up directories..."
    
    # Create .factory directory if it doesn't exist
    if [ ! -d ".factory" ]; then
        mkdir -p .factory
        print_success "Created .factory directory"
    fi
    
    # Create .factory/droids directory if it doesn't exist
    if [ ! -d ".factory/droids" ]; then
        mkdir -p .factory/droids
        print_success "Created .factory/droids directory"
    fi
}

# Install core droids
install_core_droids() {
    print_info "Setting up droids..."
    
    # Ask user where they want to install droids
    echo ""
    print_info "Where would you like to install the Droid Forge droids?"
    echo "1) Project directory (.factory/droids) - For project-specific droids"
    echo "2) User directory (~/.factory/droids) - For personal droid installation"
    echo ""
    
    while true; do
        read -p "Select option (1 or 2): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[12]$ ]]; then
            break
        else
            print_warning "Please enter 1 or 2"
        fi
    done
    
    if [ "$REPLY" = "1" ]; then
        INSTALL_LOCATION="project"
        print_info "Installing to project directory (.factory/droids)"
    else
        INSTALL_LOCATION="user"
        print_info "Installing to user directory (~/.factory/droids)"
    fi
    
    # List of core droids to install
    local core_droids=(
        "manager-orchestrator-droid-forge"
        "task-manager-droid-forge"
        "git-workflow-orchestrator-droid-forge"
        "ai-dev-tasks-integrator-droid-forge"
        "auto-pr-droid-forge"
        "reliability-droid-forge"
        "backend-engineer-droid-forge"
        "frontend-engineer-droid-forge"
        "debugging-expert-droid-forge"
        "security-audit-droid-forge"
        "biome-droid-forge"
        "unit-test-droid-forge"
    )
    
    # Create the target directory if needed
    if [ "$INSTALL_LOCATION" = "user" ]; then
        mkdir -p "$HOME/.factory/droids"
        print_info "Created user droids directory at $HOME/.factory/droids"
    else
        mkdir -p ".factory/droids"
        print_info "Created project droids directory at .factory/droids"
    fi
    
    # Install each droid
    for droid in "${core_droids[@]}"; do
        print_info "Setting up $droid..."
        
        # Check if droid file exists in the repository
        if [ -f ".factory/droids/${droid}.md" ]; then
            # Check if target file already exists
            if [ "$INSTALL_LOCATION" = "user" ]; then
                TARGET_FILE="$HOME/.factory/droids/${droid}.md"
            else
                TARGET_FILE=".factory/droids/${droid}.md"
            fi
            
            # If target file exists, check if we should replace it based on version
            if [ -f "$TARGET_FILE" ]; then
                # Extract version from repo file (first line should contain version)
                REPO_VERSION=""
                if [ -r ".factory/droids/${droid}.md" ]; then
                    REPO_VERSION=$(grep -E "^version:" ".factory/droids/${droid}.md" | cut -d: -f2- | tr -d ' ')
                fi
                
                # Extract version from target file
                TARGET_VERSION=""
                if [ -r "$TARGET_FILE" ]; then
                    TARGET_VERSION=$(grep -E "^version:" "$TARGET_FILE" | cut -d: -f2- | tr -d ' ')
                fi
                
                # Replace if repo version is newer or target doesn't have version info
                if [ -n "$REPO_VERSION" ] && [ -n "$TARGET_VERSION" ]; then
                    # Simple string comparison for version numbers (assuming semantic versioning format)
                    if [ "$REPO_VERSION" \> "$TARGET_VERSION" ] 2>/dev/null; then
                        cp ".factory/droids/${droid}.md" "$TARGET_FILE"
                        print_success "Upgraded $droid (version $REPO_VERSION > $TARGET_VERSION)"
                    else
                        # Even if same version or older, copy to ensure consistency
                        cp ".factory/droids/${droid}.md" "$TARGET_FILE"
                        print_success "Set up $droid (file copied)"
                    fi
                else
                    # If version info not found in either file, always copy repo version to ensure latest
                    cp ".factory/droids/${droid}.md" "$TARGET_FILE"
                    if [ -n "$REPO_VERSION" ]; then
                        print_success "Set up $droid (version $REPO_VERSION)"
                    else
                        print_success "Set up $droid (file copied)"
                    fi
                fi
            else
                # File doesn't exist in target, just copy it
                cp ".factory/droids/${droid}.md" "$TARGET_FILE"
                print_success "Set up $droid"
            fi
        else
            print_warning "Droid file not found: .factory/droids/${droid}.md"
        fi
    done
}

# Configure droid-forge.yaml
configure_droid_forge() {
    print_info "Configuring droid-forge.yaml..."
    
    if [ ! -f "droid-forge.yaml" ]; then
        print_error "droid-forge.yaml not found. Please ensure you're in the Droid Forge root directory."
        exit 1
    fi
    
    # Check if configuration is already set up
    if grep -q "locations:" droid-forge.yaml; then
        print_success "droid-forge.yaml already configured"
    else
        print_warning "droid-forge.yaml needs manual configuration"
        print_info "Please review and update droid-forge.yaml with your settings"
    fi
}

# Run initial tests
run_tests() {
    print_info "Running initial tests..."
    
    # Test droid installation
    if [ -d "$HOME/.factory/droids" ] && [ "$(ls -A $HOME/.factory/droids 2>/dev/null)" ]; then
        print_success "Droids installed successfully"
        ls -la "$HOME/.factory/droids/"
    else
        print_error "No droids found in $HOME/.factory/droids/"
    fi
}

# Display next steps
show_next_steps() {
    print_info "Installation completed! Next steps:"
    echo ""
    echo "1. Review and customize droid-forge.yaml:"
    echo "   nano droid-forge.yaml"
    echo ""
    echo "2. If you have Factory.ai CLI access:"
    echo "   factory \"Analyze this project and create tasks\""
    echo ""
    echo "3. Explore available droids:"
    echo "   ls -la ~/.factory/droids/"
    echo "   cat ~/.factory/droids/manager-orchestrator-droid-forge.md"
    echo ""
    echo "4. Read the documentation:"
    echo "   - README.md (overview and usage)"
    echo "   - DROID_CREATION_GUIDE.md (create custom droids)"
    echo "   - GITHUB_REPO_GUIDE.md (GitHub integration)"
    echo ""
    echo "5. Create your first task file:"
    echo "   cp tasks/template.md tasks/my-first-task.md"
    echo ""
    print_success "Droid Forge is ready to use! 🚀"
    
    if command -v factory &> /dev/null; then
        echo ""
        echo "✨ Factory.ai CLI detected - you can use droids directly!"
    else
        echo ""
        echo "📚 Droids are available as documentation and templates"
        echo "   Get Factory.ai CLI at: https://factory.ai"
    fi
}

# Main installation function
main() {
    print_header
    
    # Check if we're in the right directory
    if [ ! -f "droid-forge.yaml" ] && [ ! -f "README.md" ]; then
        print_error "Please run this script from the Droid Forge root directory"
        exit 1
    fi
    
    # Run installation steps
    check_prerequisites
    setup_directories
    install_core_droids
    configure_droid_forge
    run_tests
    show_next_steps
}

# Handle script arguments
case "${1:-}" in
    "--help"|"-h")
        print_help
        exit 0
        ;;
    "--uninstall")
        print_warning "Uninstalling Droid Forge..."
        
        # Ask user which location to uninstall from
        echo ""
        print_info "Which installation would you like to remove?"
        echo "1) Project directory (.factory/droids) - Remove project-specific droids"
        echo "2) User directory (~/.factory/droids) - Remove personal droid installation"
        echo "3) Both locations"
        echo ""
        
        while true; do
            read -p "Select option (1, 2, or 3): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[123]$ ]]; then
                break
            else
                print_warning "Please enter 1, 2, or 3"
            fi
        done
        
        # Remove droids based on user selection
        if [ "$REPLY" = "1" ] || [ "$REPLY" = "3" ]; then
            # Remove droids from project directory
            if [ -d ".factory/droids" ]; then
                print_info "Removing droids from .factory/droids..."
                rm -f ".factory/droids/"*droid-forge.md
                print_success "Droids removed from project directory"
            fi
        fi
        
        if [ "$REPLY" = "2" ] || [ "$REPLY" = "3" ]; then
            # Remove droids from personal directory
            if [ -d "~/.factory/droids" ]; then
                print_info "Removing droids from ~/.factory/droids..."
                rm -f ~/.factory/droids/*-droid-forge.md
                print_success "Droids removed from personal directory"
            fi
        fi
        
        print_info "Droid Forge uninstalled successfully"
        exit 0
        ;;
    "--check")
        print_info "Checking Droid Forge installation..."
        
        # Check directories
        if [ -d ".factory/droids" ]; then
            print_success ".factory/droids directory exists"
        else
            print_error ".factory/droids directory missing"
        fi
        
        # Check droids in personal directory
        if [ -d "~/.factory/droids" ]; then
            local droid_count=$(find ~/.factory/droids -name "*-droid-forge.md" | wc -l)
            print_success "Found $droid_count droids in personal directory"
        else
            print_error "Personal droids directory missing"
        fi
        
        # Check configuration
        if [ -f "droid-forge.yaml" ]; then
            print_success "droid-forge.yaml exists"
        else
            print_error "droid-forge.yaml missing"
        fi
        
        print_info "Check completed"
        exit 0
        ;;
    "")
        main
        ;;
    *)
        print_error "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac
