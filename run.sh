#!/bin/bash

###############################################################################
# OVHL BACKUP ORGANIZER
# Purpose: Move all .bak files to ./lokal/backups/ with timestamp folder
# Version: 1.0.0
# Author: OVHL DevTools
# Usage: ./organize_backups.sh
###############################################################################

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
BACKUPS_DIR="./lokal/backups"
SOURCE_DIR="./src"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FOLDER="${BACKUPS_DIR}/v1_0_0_standardization_${TIMESTAMP}"
VERBOSE=true

# Stats
TOTAL_BACKUPS=0
MOVED_BACKUPS=0
ERRORS=0

###############################################################################
# UTILITY FUNCTIONS
###############################################################################

log_info() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${BLUE}[INFO]${NC} $1"
    fi
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    ERRORS=$((ERRORS + 1))
}

print_header() {
    echo ""
    echo -e "${BLUE}======================================${NC}"
    echo -e "${BLUE}  OVHL BACKUP ORGANIZER${NC}"
    echo -e "${BLUE}======================================${NC}"
    echo ""
}

print_stats() {
    echo ""
    echo -e "${BLUE}======================================${NC}"
    echo "Backups found: $TOTAL_BACKUPS"
    echo -e "Moved: ${GREEN}$MOVED_BACKUPS${NC}"
    echo -e "Errors: ${RED}$ERRORS${NC}"
    echo -e "Destination: $BACKUP_FOLDER"
    echo -e "${BLUE}======================================${NC}"
    echo ""
}

###############################################################################
# MAIN FUNCTIONS
###############################################################################

main() {
    print_header
    
    # Check if source directory exists
    if [ ! -d "$SOURCE_DIR" ]; then
        log_error "Source directory not found: $SOURCE_DIR"
        exit 1
    fi
    
    # Find all .bak files
    log_info "Searching for .bak files in: $SOURCE_DIR"
    local bak_count=$(find "$SOURCE_DIR" -name "*.bak" 2>/dev/null | wc -l)
    
    if [ "$bak_count" -eq 0 ]; then
        log_warn "No .bak files found"
        exit 0
    fi
    
    TOTAL_BACKUPS=$bak_count
    log_success "Found $TOTAL_BACKUPS .bak files"
    echo ""
    
    # Create backup destination folder
    log_info "Creating backup folder structure..."
    
    if mkdir -p "$BACKUP_FOLDER"; then
        log_success "Backup folder created: $BACKUP_FOLDER"
    else
        log_error "Failed to create folder: $BACKUP_FOLDER"
        exit 1
    fi
    
    # Create timestamp file (reference)
    cat > "${BACKUP_FOLDER}/README.txt" << EOF
OVHL V1.0.0 Standardization Backups
Created: $(date)
Timestamp: $TIMESTAMP

These are backup files from the V1.0.0 standardization process.
Original files are located in ./src/

To restore:
  1. Locate the original file in ./src/
  2. Copy corresponding .bak file from here
  3. Rename .bak to .lua (remove .bak extension)
  4. Replace the updated file

Backup folder: $(pwd)/$BACKUP_FOLDER
EOF
    
    log_success "Created README.txt"
    echo ""
    
    # Move all .bak files
    log_info "Moving .bak files..."
    
    find "$SOURCE_DIR" -name "*.bak" -print0 2>/dev/null | while IFS= read -r -d '' file; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            local relative_path=$(echo "$file" | sed "s|${SOURCE_DIR}/||" | sed 's|.bak$||')
            local dest_subdir="$BACKUP_FOLDER/$(dirname "$relative_path")"
            
            # Create subdirectory structure
            mkdir -p "$dest_subdir"
            
            # Move file
            if mv "$file" "${dest_subdir}/${filename}"; then
                log_success "Moved: $relative_path.bak"
                MOVED_BACKUPS=$((MOVED_BACKUPS + 1))
            else
                log_error "Failed to move: $file"
            fi
        fi
    done
    
    # Verify all moved
    local remaining=$(find "$SOURCE_DIR" -name "*.bak" 2>/dev/null | wc -l)
    
    if [ "$remaining" -eq 0 ]; then
        log_success "All backups organized successfully!"
    else
        log_warn "$remaining .bak files still in src/ (may be new or failed move)"
    fi
    
    print_stats
    
    # Create summary file
    cat > "${BACKUP_FOLDER}/MANIFEST.txt" << EOF
OVHL V1.0.0 Standardization - Backup Manifest
==============================================

Total Backups: $TOTAL_BACKUPS
Moved: $MOVED_BACKUPS
Errors: $ERRORS

Timestamp: $TIMESTAMP
Date: $(date)

Directory Structure:
---
$BACKUP_FOLDER/
├── README.txt
├── MANIFEST.txt (this file)
├── ReplicatedStorage/
│   └── OVHL/
│       ├── Config/
│       ├── Core/
│       ├── Shared/
│       ├── Systems/
│       └── Types/
├── ServerScriptService/
│   └── OVHL/
│       └── Modules/
└── StarterPlayer/
    └── StarterPlayerScripts/
        └── OVHL/
            └── Modules/

All original folder structure is preserved for easy restoration.
EOF
    
    log_success "Created MANIFEST.txt"
    echo ""
    log_success "Backup organization complete!"
    echo -e "${BLUE}Backups stored at: ${NC}$BACKUP_FOLDER"
}

###############################################################################
# ENTRY POINT
###############################################################################

main "$@"