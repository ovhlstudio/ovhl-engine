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
    local config = OVHL.GetConfig(module, nil, "Server")
    
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
