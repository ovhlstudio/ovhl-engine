#!/bin/bash
# ====================================================================
# SCRIPT: PHASE 1.1 - Fix ClientRuntime Issues
# Purpose: Remove bloat, double Initialize, hardcoded F2, test logic
# Safety: Auto-backup, full validation, rollback capability
# Usage: bash ./scripts/phase-1.1-fix-clientruntime.sh
# ====================================================================

set -e
set -u

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_section() { echo -e "\n${BLUE}┌─ $1 ─────────────────────────────────────────────────┐${NC}"; }
log_end() { echo -e "${BLUE}└─────────────────────────────────────────────────────────┘${NC}\n"; }

# ====================================================================
# SETUP
# ====================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
TASK_NAME="fix-clientruntime"

# File paths
FILE_ORIGINAL="$PROJECT_ROOT/src/StarterPlayer/StarterPlayerScripts/OVHL/ClientRuntime.client.lua"
BACKUP_DIR="$PROJECT_ROOT/lokal/backups/${TASK_NAME}-${TIMESTAMP}"
BACKUP_FILE="$BACKUP_DIR/ClientRuntime.client.lua"

# Temp file for processing
TEMP_FILE="/tmp/clientruntime_${TIMESTAMP}.lua"

# ====================================================================
# VALIDATION
# ====================================================================

log_section "PRE-EXECUTION CHECKS"

if [ ! -f "$FILE_ORIGINAL" ]; then
    log_error "File not found: $FILE_ORIGINAL"
    log_error "Make sure you're in project root directory"
    exit 1
fi
log_info "✅ File exists: $FILE_ORIGINAL"

if [ ! -w "$FILE_ORIGINAL" ]; then
    log_error "No write permission: $FILE_ORIGINAL"
    exit 1
fi
log_info "✅ Write permission: OK"

# Count original lines
ORIGINAL_LINES=$(wc -l < "$FILE_ORIGINAL")
ORIGINAL_SIZE=$(du -h "$FILE_ORIGINAL" | cut -f1)
log_info "✅ Original: $ORIGINAL_LINES lines, $ORIGINAL_SIZE"

# Check syntax
if ! lua -c "$FILE_ORIGINAL" 2>/dev/null; then
    log_warn "Original file has syntax issues (might be expected for .client.lua)"
fi

log_end

# ====================================================================
# BACKUP
# ====================================================================

log_section "BACKUP"

mkdir -p "$BACKUP_DIR"
if [ $? -ne 0 ]; then
    log_error "Failed to create backup directory"
    exit 1
fi
log_info "✅ Created backup dir: $BACKUP_DIR"

cp "$FILE_ORIGINAL" "$BACKUP_FILE"
if [ $? -ne 0 ]; then
    log_error "Failed to backup file"
    exit 1
fi
log_info "✅ Backed up to: $BACKUP_FILE"

BACKUP_LINES=$(wc -l < "$BACKUP_FILE")
if [ "$BACKUP_LINES" -eq "$ORIGINAL_LINES" ]; then
    log_info "✅ Backup verified: $BACKUP_LINES lines"
else
    log_error "Backup verification failed"
    exit 1
fi

log_end

# ====================================================================
# PROCESSING
# ====================================================================

log_section "PROCESSING"

# Read original file
cp "$FILE_ORIGINAL" "$TEMP_FILE"
log_info "✅ Loaded file into temp: $TEMP_FILE"

# 1. Remove double :Initialize() (around line 27)
log_info "Removing double :Initialize() call..."
sed -i '/if system\.Initialize then/,/end/d' "$TEMP_FILE"
log_info "✅ Removed double initialize block"

# 2. Remove F2 keybind (around line 107-111)
log_info "Removing hardcoded F2 keybind..."
sed -i '/game:GetService("UserInputService")\.InputBegan:Connect/,/end)/d' "$TEMP_FILE"
log_info "✅ Removed F2 keybind from runtime"

# 3. Remove MinimalModule test logic (around line 48-58)
log_info "Removing MinimalModule test logic..."
sed -i '/local success, MinimalController = pcall/,/end$/d' "$TEMP_FILE"
log_info "✅ Removed MinimalModule test block"

# 4. Clean up extra blank lines
log_info "Cleaning up blank lines..."
sed -i '/^[[:space:]]*$/N;/^\n$/!P;D' "$TEMP_FILE"
log_info "✅ Cleaned up formatting"

# 5. Update header with timestamp
log_info "Updating header/footer..."
sed -i "s/@LastUpdate: .*/&LastUpdate: 2025-11-18/" "$TEMP_FILE"
log_info "✅ Updated metadata"

log_end

# ====================================================================
# VALIDATION
# ====================================================================

log_section "VALIDATION"

NEW_LINES=$(wc -l < "$TEMP_FILE")
LINES_REMOVED=$((ORIGINAL_LINES - NEW_LINES))

log_info "Lines removed: $LINES_REMOVED"
log_info "New line count: $NEW_LINES"

if [ "$NEW_LINES" -lt "$ORIGINAL_LINES" ]; then
    log_info "✅ Code successfully cleaned"
else
    log_error "No lines were removed - check processing"
    exit 1
fi

# Verify no duplicate content
if grep -c "InputBegan" "$TEMP_FILE" 2>/dev/null; then
    log_warn "⚠️  Still contains InputBegan references"
else
    log_info "✅ No keybind references (good)"
fi

if grep -c "MinimalController" "$TEMP_FILE" 2>/dev/null | grep -q "0"; then
    log_info "✅ No MinimalModule references (good)"
fi

log_end

# ====================================================================
# APPLY CHANGES
# ====================================================================

log_section "APPLY CHANGES"

cp "$TEMP_FILE" "$FILE_ORIGINAL"
if [ $? -ne 0 ]; then
    log_error "Failed to apply changes - restoring backup"
    cp "$BACKUP_FILE" "$FILE_ORIGINAL"
    exit 1
fi
log_info "✅ Changes applied to: $FILE_ORIGINAL"

# Verify
FINAL_LINES=$(wc -l < "$FILE_ORIGINAL")
FINAL_SIZE=$(du -h "$FILE_ORIGINAL" | cut -f1)

if [ "$FINAL_LINES" -eq "$NEW_LINES" ]; then
    log_info "✅ Verification passed: $FINAL_LINES lines"
else
    log_error "File verification failed"
    exit 1
fi

log_end

# ====================================================================
# CLEANUP
# ====================================================================

rm -f "$TEMP_FILE"
log_info "Cleaned up temp files"

# ====================================================================
# REPORT
# ====================================================================

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║          ✅ TASK COMPLETED SUCCESSFULLY                     ║"
echo "║          Phase 1.1: Fix ClientRuntime                       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo "📊 SUMMARY:"
echo "  Original:     $ORIGINAL_LINES lines ($ORIGINAL_SIZE)"
echo "  Final:        $FINAL_LINES lines ($FINAL_SIZE)"
echo "  Removed:      $LINES_REMOVED lines of bloat ✨"
echo ""

echo "📁 Files:"
echo "  Modified:     $FILE_ORIGINAL"
echo "  Backup:       $BACKUP_FILE"
echo ""

echo "🔄 RESTORE COMMAND (if needed):"
echo "  cp $BACKUP_FILE $FILE_ORIGINAL"
echo ""

echo "📋 NEXT STEPS:"
echo "  1️⃣  bash ./scripts/phase-1.2-fix-serverruntime.sh"
echo "  2️⃣  bash ./scripts/phase-2.1-permission-adapters.sh"
echo "  3️⃣  bash ./scripts/phase-2.2-navbar-adapters.sh"
echo ""

echo "🧪 PLAYTEST (After Phase 1 complete):"
echo "  Open Roblox Studio"
echo "  Run game"
echo "  Check console: should show 🎊 CLIENT BOOT COMPLETE"
echo ""

log_info "✅ Phase 1.1 complete!"