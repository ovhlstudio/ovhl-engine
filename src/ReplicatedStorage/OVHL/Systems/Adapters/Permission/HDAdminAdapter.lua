--[[
OVHL ENGINE V1.0.0
@Component: HDAdminAdapter (Permission)
@Path: ReplicatedStorage.OVHL.Systems.Adapters.Permission.HDAdminAdapter
@Purpose: Bridge to HD Admin permission system (Context Aware)
@Stability: BETA
--]]

local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
    
    -- STRATEGI KONEKSI BERDASARKAN KONTEKS
    if self._isServer then
        self:_connectServer()
    else
        self:_connectClient()
    end
    
    if self._available then
        self._logger:Info("PERMISSION", "HDAdminAdapter connected", {context = self._isServer and "Server" or "Client"})
    else
        -- Silent fail on client is normal if HD Admin hides itself
        local level = self._isServer and "Warn" or "Debug"
        self._logger[level](self._logger, "PERMISSION", "HDAdmin not detected - fallback to Internal")
    end
end

function HDAdminAdapter:_connectServer()
    -- 1. Cek Global Injection Standard
    if _G.HDAdminMain then
        self._hdAdminAPI = _G.HDAdminMain
        self._available = true
        return
    end

    -- 2. Cek Folder Fisik di ServerScriptService (Standard Boot)
    -- Gambar user menunjukkan: ServerScriptService -> HD Admin -> Settings (Module)
    local hdFolder = ServerScriptService:FindFirstChild("HD Admin")
    if hdFolder then
        local mainModule = hdFolder:FindFirstChild("MainModule") -- Biasanya di dalam folder Core atau root
        if not mainModule then
             -- Coba cari di subfolder Core (sesuai gambar user)
             local core = hdFolder:FindFirstChild("Core")
             if core then mainModule = core:FindFirstChild("MainModule") end
        end

        if mainModule and mainModule:IsA("ModuleScript") then
            local success, api = pcall(require, mainModule)
            if success and api then
                self._hdAdminAPI = api
                self._available = true
                return
            end
        end
    end
end

function HDAdminAdapter:_connectClient()
    -- Client biasanya akses via _G.HDAdminClient atau module di ReplicatedStorage
    -- Untuk V1.0.0, kita biarkan client fallback ke Internal dulu agar UI aman
    -- Kecuali kita tau persis API client HD Admin (sering berubah)
    self._available = false 
end

function HDAdminAdapter:IsAvailable()
    return self._available and self._hdAdminAPI ~= nil
end

function HDAdminAdapter:GetRank(player)
    if not self:IsAvailable() then return 0 end
    
    local success, result = pcall(function()
        -- API Standard HD Admin: GetUserRank(userId) atau GetRank(player)
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
    if not self:IsAvailable() then return false, "HD Admin unavailable" end
    
    local rank = self:GetRank(player)
    local requiredRank = self:_resolveRequiredRank(permissionNode)
    
    if rank >= requiredRank then
        return true
    end
    return false, string.format("Insufficient rank (%d < %d)", rank, requiredRank)
end

function HDAdminAdapter:_resolveRequiredRank(permissionNode)
    -- Helper: Baca config modul untuk mapping string -> number
    local module, action = string.match(permissionNode, "^(%w+)%.(.+)$")
    if not module then return 0 end

    local OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
    local config = OVHL:GetConfig(module, nil, self._isServer and "Server" or "Client")
    
    if not config or not config.Permissions or not config.Permissions[action] then
        return 0 -- Default allow if no rule
    end
    
    local req = config.Permissions[action].Rank
    
    -- HD Admin Rank Map Standard
    local rankMap = { 
        Owner = 5, HeadAdmin = 4, SuperAdmin = 4, 
        Admin = 3, Mod = 2, VIP = 1, NonAdmin = 0 
    }
    
    if type(req) == "string" then return rankMap[req] or 0 end
    return tonumber(req) or 0
end

-- Stub methods
function HDAdminAdapter:SetRank(player, rank) return false end

return HDAdminAdapter

--[[
@End: HDAdminAdapter.lua
@Version: 1.0.2 (Context Aware)
--]]
