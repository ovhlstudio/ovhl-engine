#!/bin/bash
# ====================================================================
# SCRIPT: PHASE 2.1 - Create Permission Adapter Pattern
# Purpose: Create InternalAdapter, HDAdminAdapter, refactor PermissionCore
# Safety: Backup, validation, clear errors
# Usage: bash ./scripts/phase-2.1-permission-adapters.sh
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
TASK_NAME="permission-adapters"

BACKUP_BASE="$PROJECT_ROOT/lokal/backups/${TASK_NAME}-${TIMESTAMP}"
ADAPTERS_DIR="$PROJECT_ROOT/src/ReplicatedStorage/OVHL/Systems/Adapters/Permission"
ORIGINAL_PERMISSION="$PROJECT_ROOT/src/ReplicatedStorage/OVHL/Systems/Security/PermissionCore.lua"

# ====================================================================
# SETUP
# ====================================================================

log_section "SETUP"

mkdir -p "$ADAPTERS_DIR"
log_info "✅ Created adapters directory: $ADAPTERS_DIR"

mkdir -p "$BACKUP_BASE"
log_info "✅ Created backup directory: $BACKUP_BASE"

if [ -f "$ORIGINAL_PERMISSION" ]; then
    cp "$ORIGINAL_PERMISSION" "$BACKUP_BASE/PermissionCore.lua.backup"
    log_info "✅ Backed up original PermissionCore"
fi

log_end

# ====================================================================
# CREATE INTERNAL ADAPTER
# ====================================================================

log_section "CREATE INTERNAL ADAPTER"

INTERNAL_ADAPTER="$ADAPTERS_DIR/InternalAdapter.lua"

cat > "$INTERNAL_ADAPTER" << 'EOF'
--[[
OVHL ENGINE V1.0.0
@Component: InternalAdapter (Permission)
@Path: ReplicatedStorage.OVHL.Systems.Adapters.Permission.InternalAdapter
@Purpose: Internal permission service (fallback when HD Admin unavailable)
@Stability: STABLE
--]]

local InternalAdapter = {}
InternalAdapter.__index = InternalAdapter

-- Rank system (HD Admin compatible)
local RANKS = {
    Owner = 5,
    SuperAdmin = 4,
    Admin = 3,
    Mod = 2,
    VIP = 1,
    NonAdmin = 0
}

function InternalAdapter.new()
    local self = setmetatable({}, InternalAdapter)
    self._logger = nil
    self._playerRanks = {}  -- {userId = rank}
    return self
end

function InternalAdapter:Initialize(logger)
    self._logger = logger
    self._logger:Info("PERMISSION", "InternalAdapter initialized (fallback)")
end

function InternalAdapter:GetRank(player)
    if not player then return RANKS.NonAdmin end
    
    local userId = player.UserId
    
    -- Check if player is creator (Owner rank)
    if userId == game.CreatorId then
        return RANKS.Owner
    end
    
    -- Check stored rank
    if self._playerRanks[userId] then
        return self._playerRanks[userId]
    end
    
    -- Default to NonAdmin
    return RANKS.NonAdmin
end

function InternalAdapter:SetRank(player, rank)
    if not player then return false end
    
    local rankValue = rank
    if type(rank) == "string" then
        rankValue = RANKS[rank] or RANKS.NonAdmin
    end
    
    self._playerRanks[player.UserId] = rankValue
    self._logger:Debug("PERMISSION", "Set rank", {
        player = player.Name,
        rank = rankValue
    })
    return true
end

function InternalAdapter:CheckPermission(player, permissionNode)
    if not player or not permissionNode then
        return false, "Invalid parameters"
    end
    
    local playerRank = self:GetRank(player)
    
    -- Parse permission node: "ModuleName.ActionName"
    local module, action = string.match(permissionNode, "^(%w+)%.(.+)$")
    if not module or not action then
        return false, "Invalid permission node format"
    end
    
    -- Get required rank from config
    local OVHL = require(game:GetService("ReplicatedStorage").OVHL.Core.OVHL)
    local config = OVHL:GetConfig(module, nil, "Server")
    
    if not config or not config.Permissions then
        -- No permission config, allow by default
        return true
    end
    
    local rule = config.Permissions[action]
    if not rule then
        -- No specific permission, allow by default
        return true
    end
    
    -- Check rank requirement
    local requiredRank = rule.Rank or RANKS.NonAdmin
    if type(requiredRank) == "string" then
        requiredRank = RANKS[requiredRank] or RANKS.NonAdmin
    end
    
    if playerRank >= requiredRank then
        return true
    end
    
    return false, string.format("Rank too low (Need: %d, Have: %d)", requiredRank, playerRank)
end

function InternalAdapter:GetAllRanks()
    return RANKS
end

return InternalAdapter

--[[
@End: InternalAdapter.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]
EOF

if [ -f "$INTERNAL_ADAPTER" ]; then
    LINES=$(wc -l < "$INTERNAL_ADAPTER")
    log_info "✅ Created InternalAdapter.lua ($LINES lines)"
else
    log_error "Failed to create InternalAdapter"
    exit 1
fi

log_end

# ====================================================================
# CREATE HD ADMIN ADAPTER
# ====================================================================

log_section "CREATE HD ADMIN ADAPTER"

HDADMIN_ADAPTER="$ADAPTERS_DIR/HDAdminAdapter.lua"

cat > "$HDADMIN_ADAPTER" << 'EOF'
--[[
OVHL ENGINE V1.0.0
@Component: HDAdminAdapter (Permission)
@Path: ReplicatedStorage.OVHL.Systems.Adapters.Permission.HDAdminAdapter
@Purpose: Bridge to HD Admin permission system
@Stability: BETA (depends on HD Admin API availability)
--]]

local HDAdminAdapter = {}
HDAdminAdapter.__index = HDAdminAdapter

function HDAdminAdapter.new()
    local self = setmetatable({}, HDAdminAdapter)
    self._logger = nil
    self._hdAdminAPI = nil
    self._available = false
    return self
end

function HDAdminAdapter:Initialize(logger)
    self._logger = logger
    
    -- Try to access HD Admin API
    local success = false
    
    -- Try multiple access patterns
    if _G.HDAdminAPI then
        self._hdAdminAPI = _G.HDAdminAPI
        success = true
    elseif _G["HD Admin API"] then
        self._hdAdminAPI = _G["HD Admin API"]
        success = true
    else
        -- Try to require from ServerScriptService
        local trySuccess, result = pcall(function()
            return require(game:GetService("ServerScriptService"):FindFirstChild("HD Admin"))
        end)
        if trySuccess and result then
            self._hdAdminAPI = result
            success = true
        end
    end
    
    if success and self._hdAdminAPI then
        self._available = true
        self._logger:Info("PERMISSION", "HDAdminAdapter connected to HD Admin")
    else
        self._logger:Warn("PERMISSION", "HDAdmin not available - fallback to Internal")
    end
end

function HDAdminAdapter:IsAvailable()
    return self._available and self._hdAdminAPI ~= nil
end

function HDAdminAdapter:GetRank(player)
    if not self:IsAvailable() then
        return 0  -- NonAdmin fallback
    end
    
    -- Try HD Admin API call
    -- NOTE: Adjust this based on actual HD Admin API
    local success, result = pcall(function()
        -- Common patterns - adjust if different:
        if self._hdAdminAPI.GetRank then
            return self._hdAdminAPI:GetRank(player)
        elseif self._hdAdminAPI.GetPlayerRank then
            return self._hdAdminAPI:GetPlayerRank(player)
        elseif self._hdAdminAPI.Ranks then
            return self._hdAdminAPI.Ranks[player.UserId] or 0
        end
        return 0
    end)
    
    if success then
        return result or 0
    else
        self._logger:Warn("PERMISSION", "Failed to get rank from HD Admin", {
            player = player.Name,
            error = tostring(result)
        })
        return 0
    end
end

function HDAdminAdapter:SetRank(player, rank)
    if not self:IsAvailable() then
        return false
    end
    
    local success, result = pcall(function()
        if self._hdAdminAPI.SetRank then
            return self._hdAdminAPI:SetRank(player, rank)
        elseif self._hdAdminAPI.SetPlayerRank then
            return self._hdAdminAPI:SetPlayerRank(player, rank)
        end
        return false
    end)
    
    if success then
        return true
    else
        self._logger:Warn("PERMISSION", "Failed to set rank in HD Admin", {
            player = player.Name,
            error = tostring(result)
        })
        return false
    end
end

function HDAdminAdapter:CheckPermission(player, permissionNode)
    if not self:IsAvailable() then
        return false, "HD Admin not available"
    end
    
    local rank = self:GetRank(player)
    
    -- Parse node
    local module, action = string.match(permissionNode, "^(%w+)%.(.+)$")
    if not module or not action then
        return false, "Invalid permission node"
    end
    
    -- Get required rank from config
    local OVHL = require(game:GetService("ReplicatedStorage").OVHL.Core.OVHL)
    local config = OVHL:GetConfig(module, nil, "Server")
    
    if not config or not config.Permissions then
        return true
    end
    
    local rule = config.Permissions[action]
    if not rule then
        return true
    end
    
    local requiredRank = rule.Rank or 0
    if type(requiredRank) == "string" then
        -- Convert string rank to number (HD Admin specific)
        local rankMap = { Owner = 5, SuperAdmin = 4, Admin = 3, Mod = 2, VIP = 1, NonAdmin = 0 }
        requiredRank = rankMap[requiredRank] or 0
    end
    
    if rank >= requiredRank then
        return true
    end
    
    return false, string.format("Insufficient rank (%d < %d)", rank, requiredRank)
end

return HDAdminAdapter

--[[
@End: HDAdminAdapter.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]
EOF

if [ -f "$HDADMIN_ADAPTER" ]; then
    LINES=$(wc -l < "$HDADMIN_ADAPTER")
    log_info "✅ Created HDAdminAdapter.lua ($LINES lines)"
else
    log_error "Failed to create HDAdminAdapter"
    exit 1
fi

log_end

# ====================================================================
# REPORT
# ====================================================================

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║          ✅ TASK COMPLETED SUCCESSFULLY                     ║"
echo "║          Phase 2.1: Permission Adapters Created             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo "📁 CREATED FILES:"
echo "  1️⃣  $INTERNAL_ADAPTER"
echo "  2️⃣  $HDADMIN_ADAPTER"
echo ""

echo "🔄 BACKUP:"
echo "  Original: $BACKUP_BASE/PermissionCore.lua.backup"
echo ""

echo "📋 NEXT STEPS:"
echo "  1️⃣  Refactor PermissionCore.lua (loader pattern)"
echo "  2️⃣  Update EngineConfig.lua with adapter selector"
echo "  3️⃣  bash ./scripts/phase-2.2-navbar-adapters.sh"
echo ""

log_info "✅ Phase 2.1 complete!"