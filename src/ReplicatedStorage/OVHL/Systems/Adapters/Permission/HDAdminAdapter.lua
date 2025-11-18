--[[
OVHL FRAMEWORK V.1.0.1
@Component: HDAdminAdapter (Permission)
@Path: ReplicatedStorage.OVHL.Systems.Adapters.Permission.HDAdminAdapter
@Purpose: Bridge to HD Admin (Server) & Passive State Reader (Client)
@Stability: STABLE
--]]

local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local HDAdminAdapter = {}
HDAdminAdapter.__index = HDAdminAdapter

function HDAdminAdapter.new()
    local self = setmetatable({}, HDAdminAdapter)
    self._logger = nil
    self._hdAdminAPI = nil
    self._available = false
    self._isServer = RunService:IsServer()
    return self
end

function HDAdminAdapter:Initialize(logger)
    self._logger = logger
    
    if self._isServer then
        self:_connectServer()
    else
        -- CLIENT: ALWAYS AVAILABLE (Passive Mode)
        self._available = true 
        self._logger:Info("PERMISSION", "HDAdminAdapter (Client) Ready in Passive Mode")
    end
end

function HDAdminAdapter:_connectServer()
    -- 1. Cek Global Injection
    if _G.HDAdminMain then
        self._hdAdminAPI = _G.HDAdminMain
        self._available = true
        self._logger:Info("PERMISSION", "HDAdminAdapter connected via _G")
        return
    end

    -- 2. Cek Folder ServerScriptService
    local hdFolder = ServerScriptService:FindFirstChild("HD Admin")
    if hdFolder then
        local mainModule = hdFolder:FindFirstChild("MainModule") 
        if not mainModule then
             local core = hdFolder:FindFirstChild("Core")
             if core then mainModule = core:FindFirstChild("MainModule") end
        end

        if mainModule and mainModule:IsA("ModuleScript") then
            local success, api = pcall(require, mainModule)
            if success and api then
                self._hdAdminAPI = api
                self._available = true
                self._logger:Info("PERMISSION", "HDAdminAdapter connected via Module")
                return
            end
        end
    end
    self._logger:Warn("PERMISSION", "HDAdmin plugin not found on Server!")
end

function HDAdminAdapter:IsAvailable()
    return self._available
end

function HDAdminAdapter:GetRank(player)
    -- CLIENT: BACA ATRIBUT (Passive State)
    if not self._isServer then
        return player:GetAttribute("OVHL_Rank") or 0
    end

    -- SERVER: AKSES API ASLI
    if not self._hdAdminAPI then return 0 end
    
    local success, result = pcall(function()
        if self._hdAdminAPI.GetRank then
            return self._hdAdminAPI:GetRank(player)
        elseif self._hdAdminAPI.GetPlayerRank then
            return self._hdAdminAPI:GetPlayerRank(player)
        elseif self._hdAdminAPI.GetUserRank then
             return self._hdAdminAPI:GetUserRank(player.UserId)
        end
        return 0
    end)
    
    return success and result or 0
end

function HDAdminAdapter:CheckPermission(player, permissionNode)
    -- Tidak ada logic permission node di adapter, serahkan rank saja
    -- Logic mapping node -> rank ada di PermissionCore
    return true -- Stub, logic utama di PermissionCore
end

function HDAdminAdapter:SetRank(player, rank) return false end

return HDAdminAdapter

--[[
@End: HDAdminAdapter.lua
@Version: 1.0.1
@See: docs/302_ADR_LOG.md (ADR-007 Passive State)
--]]
