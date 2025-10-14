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
    
    # Create the target directory if needed
    if [ "$INSTALL_LOCATION" = "user" ]; then
        TARGET_DIR="$HOME/.factory/droids"
        mkdir -p "$TARGET_DIR"
        print_info "Created user droids directory at $TARGET_DIR"
    else
        TARGET_DIR=".factory/droids"
        mkdir -p "$TARGET_DIR"
        print_info "Created project droids directory at $TARGET_DIR"
    fi
    
    # Install all droids using wildcard with improved version handling
    local droid_count=0
    local updated_count=0
    local new_count=0
    
    if [ -d ".factory/droids" ]; then
        for droid_file in .factory/droids/*-droid-forge.md; do
            if [ -f "$droid_file" ]; then
                # Skip backup files
                if [[ "$droid_file" == *.backup ]]; then
                    continue
                fi
                
                local droid_name
                droid_name=$(basename "$droid_file" .md)
                local TARGET_FILE
                TARGET_FILE="$TARGET_DIR/$(basename "$droid_file")"
                
                # Extract version from source file
                local source_version=""
                if [ -r "$droid_file" ]; then
                    source_version=$(grep -E "^version:" "$droid_file" 2>/dev/null | head -1 | cut -d: -f2- | tr -d ' "')
                fi
                
                # Extract version from target file if it exists
                local target_version=""
                if [ -r "$TARGET_FILE" ]; then
                    target_version=$(grep -E "^version:" "$TARGET_FILE" 2>/dev/null | head -1 | cut -d: -f2- | tr -d ' "')
                fi
                
                local action="Installed"
                local should_copy=false
                
                # Determine if we need to copy/update
                if [ ! -f "$TARGET_FILE" ]; then
                    # New installation
                    should_copy=true
                    action="Installed"
                    new_count=$((new_count + 1))
                elif [ -n "$source_version" ] && [ -n "$target_version" ]; then
                    # Both have version info - compare them
                    if [ "$source_version" != "$target_version" ]; then
                        should_copy=true
                        action="Updated"
                        updated_count=$((updated_count + 1))
                    fi
                else
                    # Missing version info - copy to ensure latest
                    should_copy=true
                    action="Refreshed"
                    updated_count=$((updated_count + 1))
                fi
                
                if [ "$should_copy" = true ]; then
                    cp "$droid_file" "$TARGET_FILE"
                    if [ -n "$source_version" ]; then
                        print_success "$action: $droid_name (v$source_version)"
                    else
                        print_success "$action: $droid_name"
                    fi
                else
                    print_info "Skipped: $droid_name (already up to date)"
                fi
                
                droid_count=$((droid_count + 1))
            fi
        done
    fi
    
    if [ $droid_count -eq 0 ]; then
        print_error "No droids found in .factory/droids/"
        exit 1
    fi
    
    if [ $new_count -gt 0 ]; then
        print_info "New installations: $new_count droids"
    fi
    if [ $updated_count -gt 0 ]; then
        print_info "Updated: $updated_count droids to newer versions"
    fi
    print_success "Processed $droid_count droids total"
    
    # Verify key droids are installed
    verify_key_droids "$TARGET_DIR"
}

# Verify key droids are properly installed
verify_key_droids() {
    local droids_dir="$1"
    
    print_info "Verifying key droids installation..."
    
    local key_droids=(
        "manager-orchestrator-droid-forge.md"
        "replit-assessment-droid-forge.md"
        "frontend-engineer-droid-forge.md"
        "backend-engineer-droid-forge.md"
        "unit-test-droid-forge.md"
        "security-assessment-droid-forge.md"
        "typescript-integration-droid-forge.md"
        "bug-hunter-droid-forge.md"
    )
    
    local missing_droids=()
    local found_droids=0
    
    for droid in "${key_droids[@]}"; do
        if [ -f "$droids_dir/$droid" ]; then
            print_success "✓ $droid"
            found_droids=$((found_droids + 1))
        else
            print_warning "✗ Missing: $droid"
            missing_droids+=("$droid")
        fi
    done
    
    if [ ${#missing_droids[@]} -eq 0 ]; then
        print_success "All key droids verified ($found_droids/$#key_droids)"
    else
        print_warning "Missing ${#missing_droids[@]} key droids: ${missing_droids[*]}"
        print_info "These droids are recommended for optimal Droid Forge functionality"
    fi
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

# Update .gitignore for .factory directory
update_gitignore() {
    # Only add .factory/ to .gitignore for project installations
    # Personal installations (~/.factory/droids) don't need gitignore
    if [ "$INSTALL_LOCATION" = "user" ]; then
        print_info "Personal installation detected - skipping .gitignore update"
        print_info "Personal droids are installed outside the project and don't need gitignore"
        return
    fi
    
    print_info "Updating .gitignore to exclude .factory directory..."
    
    local gitignore_file=".gitignore"
    
    # Check if .gitignore exists
    if [ ! -f "$gitignore_file" ]; then
        print_info "Creating .gitignore file"
        cat > "$gitignore_file" << 'EOF'
# Droid Forge - Custom droids directory (project-specific)
.factory/
EOF
        print_success "Created .gitignore with .factory/ entry"
        return
    fi
    
    # Check if .factory is already in .gitignore
    if grep -q "^\.factory/" "$gitignore_file" 2>/dev/null; then
        print_info ".gitignore already contains .factory/ entry"
        return
    fi
    
    # For project installations, always add .factory/ if it's not already there
    # (Don't skip just because there's a Droid Forge section elsewhere)
    
    # Add .factory entry to .gitignore
    echo "" >> "$gitignore_file"
    echo "# Droid Forge - Custom droids directory (project-specific)" >> "$gitignore_file"
    echo ".factory/" >> "$gitignore_file"
    print_success "Added .factory/ to .gitignore for project installation"
}

# Run initial tests
run_tests() {
    print_info "Running initial tests..."
    
    # Test droid installation based on where they were installed
    if [ "$INSTALL_LOCATION" = "user" ]; then
        if [ -d "$HOME/.factory/droids" ] && [ "$(ls -A "$HOME/.factory/droids" 2>/dev/null)" ]; then
            local droid_count
            droid_count=$(find "$HOME/.factory/droids" -name "*-droid-forge.md" 2>/dev/null | wc -l | tr -d ' ')
            print_success "Droids installed successfully: $droid_count droids in $HOME/.factory/droids/"
        else
            print_error "No droids found in $HOME/.factory/droids/"
        fi
    else
        if [ -d ".factory/droids" ] && [ "$(ls -A ".factory/droids" 2>/dev/null)" ]; then
            local droid_count
            droid_count=$(find ".factory/droids" -name "*-droid-forge.md" 2>/dev/null | wc -l | tr -d ' ')
            print_success "Droids installed successfully: $droid_count droids in .factory/droids/"
        else
            print_error "No droids found in .factory/droids/"
        fi
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
    update_gitignore
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
            if [ -d "$HOME/.factory/droids" ]; then
                print_info "Removing droids from ~/.factory/droids..."
                rm -f "$HOME/.factory/droids"/*-droid-forge.md
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
        if [ -d "$HOME/.factory/droids" ]; then
            droid_count=$(find "$HOME/.factory/droids" -name "*-droid-forge.md" 2>/dev/null | wc -l | tr -d ' ')
            print_success "Found $droid_count droids in personal directory"
        else
            print_info "Personal droids directory not found (optional)"
        fi
        
        # Check droids in project directory
        if [ -d ".factory/droids" ]; then
            droid_count=$(find .factory/droids -name "*-droid-forge.md" 2>/dev/null | wc -l | tr -d ' ')
            print_success "Found $droid_count droids in project directory"
        else
            print_info "Project droids directory not found (optional)"
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
