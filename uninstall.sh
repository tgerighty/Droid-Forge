#!/bin/bash

# Droid Forge Uninstallation Script
# Removes Droid Forge installations from project and/or user directories

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}   ${RED}🗑️  Droid Forge Uninstaller${NC}                   ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}   ${RED}Complete removal of droids and configuration${NC}    ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_help() {
    echo "Droid Forge Uninstallation Script"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --help, -h         Show this help message"
    echo "  --project-only     Remove only from current project directory"
    echo "  --user-only        Remove only from user directory (~/.factory/droids)"
    echo "  --both             Remove from both project and user directories (default)"
    echo "  --dry-run          Show what would be removed without actually removing"
    echo "  --verbose          Show detailed output during removal"
    echo ""
    echo "Examples:"
    echo "  $0                 # Interactive mode with options"
    echo "  $0 --project-only  # Remove from current project only"
    echo "  $0 --user-only     # Remove from user directory only"
    echo "  $0 --dry-run       # Preview what would be removed"
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

print_danger() {
    echo -e "${RED}🔥 $1${NC}"
}

# Variables
DRY_RUN=false
VERBOSE=false
REMOVE_PROJECT=false
REMOVE_USER=false
INTERACTIVE=true

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                print_help
                exit 0
                ;;
            --project-only)
                REMOVE_PROJECT=true
                REMOVE_USER=false
                INTERACTIVE=false
                shift
                ;;
            --user-only)
                REMOVE_PROJECT=false
                REMOVE_USER=true
                INTERACTIVE=false
                shift
                ;;
            --both)
                REMOVE_PROJECT=true
                REMOVE_USER=true
                INTERACTIVE=false
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --verbose)
                VERBOSE=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
}

# Check if we're in a project with Droid Forge
check_project_installation() {
    if [ -f "droid-forge.yaml" ] || [ -d ".factory" ] || [ -f "AGENTS.md" ]; then
        return 0
    else
        return 1
    fi
}

# Check if user has personal installation
check_user_installation() {
    if [ -d "$HOME/.factory/droids" ] && [ "$(ls -A "$HOME/.factory/droids" 2>/dev/null)" ]; then
        return 0
    else
        return 1
    fi
}

# Count droids in a directory
count_droids() {
    local dir="$1"
    if [ -d "$dir" ]; then
        find "$dir" -name "*-droid-forge.md" 2>/dev/null | wc -l | tr -d ' '
    else
        echo "0"
    fi
}

# List droids in a directory
list_droids() {
    local dir="$1"
    if [ -d "$dir" ]; then
        find "$dir" -name "*-droid-forge.md" -exec basename {} \; 2>/dev/null | sort
    fi
}

# Scan for installations
scan_installations() {
    print_info "Scanning for Droid Forge installations..."
    echo ""
    
    local project_found=false
    local user_found=false
    
    # Check project directory
    if check_project_installation; then
        project_found=true
        print_info "📁 Project installation detected in: $(pwd)"
        
        local droid_count
        droid_count=$(count_droids ".factory/droids")
        if [ "$droid_count" -gt 0 ]; then
            print_info "   Droids found: $droid_count"
            if [ "$VERBOSE" = true ]; then
                list_droids ".factory/droids" | while read -r droid; do
                    echo "     • $droid"
                done
            fi
        fi
        
        # List other project files
        local project_files=()
        [ -f "droid-forge.yaml" ] && project_files+=("droid-forge.yaml")
        [ -f "AGENTS.md" ] && project_files+=("AGENTS.md")
        [ -f "DROID-FORGE-SETUP.md" ] && project_files+=("DROID-FORGE-SETUP.md")
        [ -d "tools" ] && project_files+=("tools/")
        [ -d "tests" ] && project_files+=("tests/")
        [ -d "tasks" ] && project_files+=("tasks/")
        [ -d ".droid-forge" ] && project_files+=(".droid-forge/")
        
        if [ ${#project_files[@]} -gt 0 ]; then
            print_info "   Additional files: ${project_files[*]}"
        fi
    else
        print_info "📁 No project installation found in current directory"
    fi
    
    echo ""
    
    # Check user directory
    if check_user_installation; then
        user_found=true
        print_info "👤 Personal installation detected in: $HOME/.factory/droids"
        
        local droid_count
        droid_count=$(count_droids "$HOME/.factory/droids")
        print_info "   Droids found: $droid_count"
        if [ "$VERBOSE" = true ]; then
            list_droids "$HOME/.factory/droids" | while read -r droid; do
                echo "     • $droid"
            done
        fi
    else
        print_info "👤 No personal installation found in $HOME/.factory/droids"
    fi
    
    echo ""
    
    if [ "$project_found" = false ] && [ "$user_found" = false ]; then
        print_warning "No Droid Forge installations found"
        echo ""
        print_info "If you believe Droid Forge is installed elsewhere, you can:"
        echo "   • Run this script from the project directory"
        echo "   • Check if droids are in a different location"
        echo "   • Use --verbose to see more details"
        exit 0
    fi
    
    return 0
}

# Interactive selection
interactive_selection() {
    local project_available=false
    local user_available=false
    
    check_project_installation && project_available=true
    check_user_installation && user_available=true
    
    if [ "$project_available" = false ] && [ "$user_available" = false ]; then
        print_error "No installations found to remove"
        exit 0
    fi
    
    echo ""
    print_info "Select what to uninstall:"
    echo ""
    
    local options=()
    local option_num=1
    
    if [ "$project_available" = true ]; then
        echo "$option_num) Project installation ($(pwd))"
        options+=("project")
        option_num=$((option_num + 1))
    fi
    
    if [ "$user_available" = true ]; then
        echo "$option_num) Personal installation ($HOME/.factory/droids)"
        options+=("user")
        option_num=$((option_num + 1))
    fi
    
    if [ "$project_available" = true ] && [ "$user_available" = true ]; then
        echo "$option_num) Both installations"
        options+=("both")
    fi
    
    echo "0) Cancel"
    echo ""
    
    while true; do
        read -p "Select option [0-$((option_num - 1))]: " -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[0]$ ]]; then
            print_info "Uninstallation cancelled"
            exit 0
        elif [[ $REPLY =~ ^[1-9][0-9]*$ ]] && [ "$REPLY" -le $((option_num - 1)) ]; then
            local selection_index=$((REPLY - 1))
            local selection="${options[$selection_index]}"
            
            case "$selection" in
                "project")
                    REMOVE_PROJECT=true
                    REMOVE_USER=false
                    ;;
                "user")
                    REMOVE_PROJECT=false
                    REMOVE_USER=true
                    ;;
                "both")
                    REMOVE_PROJECT=true
                    REMOVE_USER=true
                    ;;
            esac
            break
        else
            print_warning "Please enter a valid option"
        fi
    done
}

# Remove files/directories with safety checks
remove_safely() {
    local path="$1"
    local description="$2"
    
    if [ "$DRY_RUN" = true ]; then
        print_info "Would remove: $description ($path)"
        return 0
    fi
    
    if [ -e "$path" ]; then
        if [ "$VERBOSE" = true ]; then
            print_info "Removing: $description ($path)"
        fi
        
        if rm -rf "$path" 2>/dev/null; then
            return 0
        else
            print_warning "Failed to remove: $description ($path)"
            return 1
        fi
    else
        if [ "$VERBOSE" = true ]; then
            print_info "Not found (skipping): $description ($path)"
        fi
        return 0
    fi
}

# Remove project installation
remove_project_installation() {
    print_info "Removing project installation..."
    echo ""
    
    local removed_files=()
    local failed_files=()
    
    # Remove droids
    if [ -d ".factory/droids" ]; then
        local droid_count
        droid_count=$(count_droids ".factory/droids")
        if [ "$droid_count" -gt 0 ]; then
            if remove_safely ".factory/droids" "Project droids directory"; then
                removed_files+=("$droid_count droids")
            else
                failed_files+=("droids")
            fi
        fi
    fi
    
    # Remove other project files
    local project_files=(
        "droid-forge.yaml:Configuration file"
        "AGENTS.md:Coding guidelines"
        "DROID-FORGE-SETUP.md:Setup documentation"
        "tools/:Execution tools"
        "tests/:Test framework"
        "tasks/:Task directory"
        ".droid-forge/:Working directory"
        ".factory/:Factory directory"
    )
    
    for file_info in "${project_files[@]}"; do
        local file="${file_info%%:*}"
        local description="${file_info##*:}"
        if remove_safely "$file" "$description"; then
            removed_files+=("$description")
        else
            failed_files+=("$description")
        fi
    done
    
    # Clean up .gitignore entries (optional)
    if [ -f ".gitignore" ] && [ "$DRY_RUN" = false ]; then
        if grep -q "# Droid Forge" ".gitignore" 2>/dev/null; then
            if [ "$VERBOSE" = true ]; then
                print_info "Cleaning up .gitignore entries"
            fi
            # Create temporary file without Droid Forge entries
            grep -v "# Droid Forge" ".gitignore" | grep -v "^\.factory/$" | grep -v "^\.droid-forge/$" > ".gitignore.tmp" 2>/dev/null || true
            mv ".gitignore.tmp" ".gitignore" 2>/dev/null || true
            removed_files+=(".gitignore entries")
        fi
    fi
    
    # Summary
    echo ""
    if [ ${#removed_files[@]} -gt 0 ]; then
        print_success "Project installation removed successfully"
        print_info "Removed: ${removed_files[*]}"
    fi
    
    if [ ${#failed_files[@]} -gt 0 ]; then
        print_warning "Some items could not be removed: ${failed_files[*]}"
        print_info "You may need to remove them manually"
    fi
}

# Remove user installation
remove_user_installation() {
    print_info "Removing personal installation from $HOME/.factory/droids..."
    echo ""
    
    local droid_count
    droid_count=$(count_droids "$HOME/.factory/droids")
    
    if [ "$droid_count" -gt 0 ]; then
        if remove_safely "$HOME/.factory/droids" "Personal droids directory"; then
            print_success "Removed $droid_count droids from personal directory"
        else
            print_warning "Failed to remove personal droids directory"
            print_info "You may need to remove it manually: rm -rf $HOME/.factory/droids"
        fi
    else
        print_info "No droids found in personal directory"
    fi
    
    # Also remove empty .factory directory if it's empty
    if [ -d "$HOME/.factory" ] && [ ! "$(ls -A "$HOME/.factory" 2>/dev/null)" ]; then
        if remove_safely "$HOME/.factory" "Empty .factory directory"; then
            if [ "$VERBOSE" = true ]; then
                print_info "Removed empty .factory directory"
            fi
        fi
    fi
}

# Final confirmation
final_confirmation() {
    echo ""
    print_danger "⚠️  FINAL WARNING ⚠️"
    echo ""
    echo "You are about to permanently remove Droid Forge installation(s):"
    echo ""
    
    if [ "$REMOVE_PROJECT" = true ]; then
        echo "📁 Project installation in: $(pwd)"
        echo "   • All droids in .factory/droids/"
        echo "   • Configuration files (droid-forge.yaml, AGENTS.md)"
        echo "   • Tools, tests, and task directories"
        echo ""
    fi
    
    if [ "$REMOVE_USER" = true ]; then
        echo "👤 Personal installation in: $HOME/.factory/droids"
        local droid_count
        droid_count=$(count_droids "$HOME/.factory/droids")
        echo "   • $droid_count personal droids"
        echo ""
    fi
    
    if [ "$DRY_RUN" = true ]; then
        print_info "DRY RUN MODE - No files will actually be removed"
        echo ""
        return 0
    fi
    
    echo "This action cannot be undone!"
    echo ""
    
    while true; do
        read -p "Are you absolutely sure you want to proceed? (yes/NO): " -r
        echo ""
        if [[ $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
            return 0
        elif [[ -z "$REPLY" ]] || [[ $REPLY =~ ^[Nn][Oo]?$ ]]; then
            print_info "Uninstallation cancelled"
            exit 0
        else
            print_warning "Please type 'yes' to confirm or 'no' to cancel"
        fi
    done
}

# Show completion summary
show_summary() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}   ${GREEN}✅ Uninstallation Complete!${NC}                   ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ "$DRY_RUN" = true ]; then
        print_info "Dry run completed - no files were actually removed"
        echo ""
        print_info "To perform the actual removal, run without --dry-run"
    else
        print_success "Droid Forge has been uninstalled successfully"
        echo ""
        
        if [ "$REMOVE_PROJECT" = true ]; then
            print_info "Project directory cleaned up"
        fi
        
        if [ "$REMOVE_USER" = true ]; then
            print_info "Personal installation removed"
        fi
        
        echo ""
        print_info "To reinstall Droid Forge in the future:"
        echo "   • Clone the repository: git clone https://github.com/tgerighty/Droid-Forge.git"
        echo "   • Run: cd Droid-Forge && ./install.sh"
        echo ""
        print_info "Thank you for using Droid Forge! 👋"
    fi
}

# Main function
main() {
    print_header
    
    # Parse command line arguments
    parse_args "$@"
    
    # Scan for installations
    scan_installations
    
    # Determine what to remove
    if [ "$INTERACTIVE" = true ]; then
        interactive_selection
    elif [ "$REMOVE_PROJECT" = false ] && [ "$REMOVE_USER" = false ]; then
        # Default to both if nothing specified
        REMOVE_PROJECT=true
        REMOVE_USER=true
    fi
    
    # Show what will be removed
    echo ""
    print_info "The following will be removed:"
    echo ""
    
    if [ "$REMOVE_PROJECT" = true ] && check_project_installation; then
        local droid_count
        droid_count=$(count_droids ".factory/droids")
        echo "📁 Project Installation ($(pwd)):"
        echo "   • $droid_count droids"
        echo "   • Configuration and documentation files"
        echo "   • Tools, tests, and working directories"
        echo ""
    fi
    
    if [ "$REMOVE_USER" = true ] && check_user_installation; then
        local droid_count
        droid_count=$(count_droids "$HOME/.factory/droids")
        echo "👤 Personal Installation ($HOME/.factory/droids):"
        echo "   • $droid_count droids"
        echo ""
    fi
    
    # Final confirmation
    final_confirmation
    
    # Perform removal
    if [ "$REMOVE_PROJECT" = true ]; then
        remove_project_installation
        echo ""
    fi
    
    if [ "$REMOVE_USER" = true ]; then
        remove_user_installation
        echo ""
    fi
    
    # Show summary
    show_summary
}

# Handle interrupts gracefully
trap 'echo ""; print_warning "Uninstallation interrupted"; exit 1' INT TERM

# Run main function with all arguments
main "$@"
