--[[
OVHL ENGINE V1.0.0
@Component: PermissionCore (Core)
@Path: ReplicatedStorage.OVHL.Systems.Security.PermissionCore
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.0.0 - PERMISSION CORE (HD ADMIN STYLE)
Version: 3.1.0
Path: ReplicatedStorage.OVHL.Systems.Security.PermissionCore
FEATURES:
- Mimics HD Admin Ranks (Owner, Admin, Mod, etc)
- Config-driven Rank mapping
--]]

local PermissionCore = {}
PermissionCore.__index = PermissionCore

-- HD Admin Standard Ranks
local RANKS = {
    Owner = 5,
    SuperAdmin = 4,
    Admin = 3,
    Mod = 2,
    VIP = 1,
    NonAdmin = 0
}

function PermissionCore.new()
    local self = setmetatable({}, PermissionCore)
    self._logger = nil
    self._providers = {}
    self._fallbackProvider = self:_createFallbackProvider()
    self._permissionCache = {}
    return self
end

function PermissionCore:Initialize(logger)
    self._logger = logger
    self._providers["Fallback"] = self._fallbackProvider
    self._logger:Info("PERMISSION", "Permission Core initialized (HD Admin Style)")
end

function PermissionCore:_createFallbackProvider()
    return {
        Name = "Fallback",
        Priority = 1,
        
        Check = function(player, permissionNode)
            local module, action = string.match(permissionNode, "^(%w+)%.(.+)$")
            if not module or not action then return false, "Invalid node" end
            
            -- Load Config dynamically
            local success, config = pcall(function()
                return require(game:GetService("ReplicatedStorage").OVHL.Core.OVHL):GetConfig(module)
            end)
            
            if not success or not config or not config.Permissions then 
                return false, "No config/rules found" 
            end
            
            local rule = config.Permissions[action]
            if not rule then return false, "No permission rule for action: " .. action end
            
            -- Check Ranks
            local playerRankId = self:_getPlayerRankId(player)
            local requiredRank = rule.Rank or RANKS.NonAdmin -- Default to 0
            
            -- Convert String Rank to ID if needed
            if type(requiredRank) == "string" then
                requiredRank = RANKS[requiredRank] or 999
            end
            
            if playerRankId >= requiredRank then
                return true
            end
            
            return false, "Rank too low (Required: " .. tostring(requiredRank) .. ", Got: " .. tostring(playerRankId) .. ")"
        end
    }
end

function PermissionCore:_getPlayerRankId(player)
    -- SIMULATE HD ADMIN LOGIC
    if player.UserId == game.CreatorId then return RANKS.Owner end
    -- Bisa ditambah logic check GroupRank disini nanti
    return RANKS.NonAdmin -- Default everyone is 0
end

function PermissionCore:Check(player, permissionNode)
    local provider = self._providers["Fallback"] -- Prioritize HD Admin later
    local allowed, reason = provider.Check(player, permissionNode)
    
    if allowed then
        self._logger:Debug("PERMISSION", "Access Granted", {player=player.Name, node=permissionNode})
    else
        self._logger:Warn("PERMISSION", "Access Denied", {player=player.Name, node=permissionNode, reason=reason})
    end
    
    return allowed, reason
end

return PermissionCore

--[[
@End: PermissionCore.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

