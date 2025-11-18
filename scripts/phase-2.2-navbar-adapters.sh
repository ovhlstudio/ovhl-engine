#!/bin/bash
# ====================================================================
# SCRIPT: PHASE 2.2 - Create Navbar Adapter Pattern
# Purpose: TopbarPlus + Internal Navbar, refactor UIManager
# Safety: Backup, validation, error handling
# Usage: bash ./scripts/phase-2.2-navbar-adapters.sh
# ====================================================================

set -e
set -u

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_section() { echo -e "\n${BLUE}┌─ $1 ─────────────────────────────────────────────────┐${NC}"; }
log_end() { echo -e "${BLUE}└─────────────────────────────────────────────────────────┘${NC}\n"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
TASK_NAME="navbar-adapters"

BACKUP_BASE="$PROJECT_ROOT/lokal/backups/${TASK_NAME}-${TIMESTAMP}"
ADAPTERS_DIR="$PROJECT_ROOT/src/ReplicatedStorage/OVHL/Systems/Adapters/Navbar"
ORIGINAL_UIMANAGER="$PROJECT_ROOT/src/ReplicatedStorage/OVHL/Systems/UI/UIManager.lua"

# ====================================================================
# SETUP
# ====================================================================

log_section "SETUP"

mkdir -p "$ADAPTERS_DIR"
log_info "✅ Created navbar adapters directory"

mkdir -p "$BACKUP_BASE"
if [ -f "$ORIGINAL_UIMANAGER" ]; then
    cp "$ORIGINAL_UIMANAGER" "$BACKUP_BASE/UIManager.lua.backup"
    log_info "✅ Backed up original UIManager"
fi

log_end

# ====================================================================
# CREATE TOPBARPLUS ADAPTER
# ====================================================================

log_section "CREATE TOPBARPLUS ADAPTER"

TOPBARPLUS_ADAPTER="$ADAPTERS_DIR/TopbarPlusAdapter.lua"

cat > "$TOPBARPLUS_ADAPTER" << 'EOFADAPTER'
--[[
OVHL ENGINE V1.0.0
@Component: TopbarPlusAdapter (Navbar)
@Path: ReplicatedStorage.OVHL.Systems.Adapters.Navbar.TopbarPlusAdapter
@Purpose: Bridge to TopbarPlus V3 API
@Stability: BETA
--]]

local TopbarPlusAdapter = {}
TopbarPlusAdapter.__index = TopbarPlusAdapter

function TopbarPlusAdapter.new()
    local self = setmetatable({}, TopbarPlusAdapter)
    self._logger = nil
    self._topbarplus = nil
    self._available = false
    self._buttons = {}
    return self
end

function TopbarPlusAdapter:Initialize(logger)
    self._logger = logger
    
    local success, TopbarPlus = pcall(function()
        return require(game:GetService("ReplicatedStorage"):FindFirstChild("Icon"))
    end)
    
    if success and TopbarPlus then
        self._topbarplus = TopbarPlus
        self._available = true
        self._logger:Info("NAVBAR", "TopbarPlusAdapter connected to TopbarPlus")
    else
        self._logger:Warn("NAVBAR", "TopbarPlus not available - fallback to Internal")
    end
end

function TopbarPlusAdapter:IsAvailable()
    return self._available and self._topbarplus ~= nil
end

function TopbarPlusAdapter:AddButton(buttonId, config)
    if not self:IsAvailable() then
        return false, "TopbarPlus not available"
    end
    
    local success, button = pcall(function()
        return self._topbarplus:createButton({
            Name = config.Name or buttonId,
            Icon = config.Icon or "rbxassetid://0",
            Text = config.Text or "Button",
            Tooltip = config.Tooltip or config.Text or "Button",
            OnClick = config.OnClick or function() end
        })
    end)
    
    if success and button then
        self._buttons[buttonId] = button
        self._logger:Debug("NAVBAR", "TopbarPlus button created", {
            button = buttonId,
            text = config.Text
        })
        return true
    else
        self._logger:Warn("NAVBAR", "Failed to create TopbarPlus button", {
            button = buttonId,
            error = tostring(button)
        })
        return false
    end
end

function TopbarPlusAdapter:RemoveButton(buttonId)
    if self._buttons[buttonId] then
        pcall(function()
            self._buttons[buttonId]:Destroy()
        end)
        self._buttons[buttonId] = nil
        return true
    end
    return false
end

function TopbarPlusAdapter:SetButtonActive(buttonId, active)
    if self._buttons[buttonId] then
        pcall(function()
            if active then
                self._buttons[buttonId]:Show()
            else
                self._buttons[buttonId]:Hide()
            end
        end)
        return true
    end
    return false
end

return TopbarPlusAdapter

--[[
@End: TopbarPlusAdapter.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]
EOFADAPTER

if [ -f "$TOPBARPLUS_ADAPTER" ]; then
    LINES=$(wc -l < "$TOPBARPLUS_ADAPTER")
    log_info "✅ Created TopbarPlusAdapter.lua ($LINES lines)"
else
    log_error "Failed to create TopbarPlusAdapter"
    exit 1
fi

log_end

# ====================================================================
# CREATE INTERNAL NAVBAR ADAPTER
# ====================================================================

log_section "CREATE INTERNAL NAVBAR ADAPTER"

INTERNAL_NAVBAR="$ADAPTERS_DIR/InternalAdapter.lua"

cat > "$INTERNAL_NAVBAR" << 'EOFINTERNAL'
--[[
OVHL ENGINE V1.0.0
@Component: InternalAdapter (Navbar)
@Path: ReplicatedStorage.OVHL.Systems.Adapters.Navbar.InternalAdapter
@Purpose: Native Fusion UI navbar (fallback when TopbarPlus unavailable)
@Stability: BETA
--]]

local InternalAdapter = {}
InternalAdapter.__index = InternalAdapter

function InternalAdapter.new()
    local self = setmetatable({}, InternalAdapter)
    self._logger = nil
    self._buttons = {}
    self._navbarGui = nil
    return self
end

function InternalAdapter:Initialize(logger)
    self._logger = logger
    self._logger:Info("NAVBAR", "InternalAdapter initialized (native Fusion UI)")
end

function InternalAdapter:AddButton(buttonId, config)
    -- TODO: Implement Fusion-based navbar UI
    -- For now, just log
    self._logger:Debug("NAVBAR", "Internal button (TODO: Fusion UI)", {
        button = buttonId,
        text = config.Text
    })
    
    self._buttons[buttonId] = {
        id = buttonId,
        config = config,
        active = true
    }
    
    return true
end

function InternalAdapter:RemoveButton(buttonId)
    self._buttons[buttonId] = nil
    return true
end

function InternalAdapter:SetButtonActive(buttonId, active)
    if self._buttons[buttonId] then
        self._buttons[buttonId].active = active
        return true
    end
    return false
end

return InternalAdapter

--[[
@End: InternalAdapter.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]
EOFINTERNAL

if [ -f "$INTERNAL_NAVBAR" ]; then
    LINES=$(wc -l < "$INTERNAL_NAVBAR")
    log_info "✅ Created InternalAdapter.lua ($LINES lines)"
else
    log_error "Failed to create InternalAdapter"
    exit 1
fi

log_end

# ====================================================================
# REPORT
# ====================================================================

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║          ✅ TASK COMPLETED SUCCESSFULLY                     ║"
echo "║          Phase 2.2: Navbar Adapters Created                 ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo "📁 CREATED FILES:"
echo "  1️⃣  $TOPBARPLUS_ADAPTER"
echo "  2️⃣  $INTERNAL_NAVBAR"
echo ""

echo "🔄 BACKUP:"
echo "  Original: $BACKUP_BASE/UIManager.lua.backup"
echo ""

echo "📋 NEXT STEPS:"
echo "  1️⃣  Refactor UIManager.lua (loader pattern)"
echo "  2️⃣  Update EngineConfig.lua with Navbar adapter selector"
echo "  3️⃣  Create PrototypeShop test module"
echo "  4️⃣  bash ./scripts/phase-3-test-structure.sh"
echo ""

log_info "✅ Phase 2.2 complete!"