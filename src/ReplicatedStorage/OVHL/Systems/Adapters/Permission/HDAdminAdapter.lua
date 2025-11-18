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
