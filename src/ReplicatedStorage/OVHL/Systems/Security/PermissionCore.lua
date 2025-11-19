--[[
    OVHL FRAMEWORK V.1.1.0 (PERMISSION CORE)
    @Logic: Strict loading. Fallback only if Adapter is missing entirely.
--]]

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PermissionCore = {}
PermissionCore.__index = PermissionCore

function PermissionCore.new()
    local self = setmetatable({}, PermissionCore)
    self._logger = nil
    self._adapter = nil
    self._isServer = RunService:IsServer()
    return self
end

function PermissionCore:Initialize(logger)
    self._logger = logger
    
    -- Default ke HDAdminAdapter (Hardcoded biar gak salah config)
    local adapterName = "HDAdminAdapter"
    local context = self._isServer and "Server" or "Client"
    self._logger:Info("PERMISSION", "Init PermissionCore ("..context..")", {adapter = adapterName})
    
    local folder = ReplicatedStorage.OVHL.Systems.Adapters.Permission
    local mod = folder:FindFirstChild(adapterName)
    
    if mod then
        local cls = require(mod)
        local instance = cls.new()
        if instance.Initialize then instance:Initialize(logger) end
        
        -- STRICT CHECK: Fallback hanya jika folder HD Admin HILANG
        if instance:IsAvailable() then
            self._adapter = instance
            self._logger:Info("PERMISSION", "✅ Adapter READY: " .. adapterName)
        else
            self._logger:Warn("PERMISSION", "⛔ HD Admin not installed/found. Using Internal Fallback.")
            self:_loadInternal(folder)
        end
    else
        self._logger:Critical("PERMISSION", "Adapter Module Missing! Using Internal Fallback.")
        self:_loadInternal(folder)
    end
end

function PermissionCore:_loadInternal(folder)
    local mod = folder:FindFirstChild("InternalAdapter")
    if mod then
        local cls = require(mod)
        self._adapter = cls.new()
        if self._adapter.Initialize then self._adapter:Initialize(self._logger) end
    end
end

function PermissionCore:Start()
    if self._isServer then
        -- Replikasi Rank ke Client via Attribute
        local function updateRank(player)
            if not self._adapter then return end
            local rank = self._adapter:GetRank(player)
            player:SetAttribute("OVHL_Rank", rank)
        end
        Players.PlayerAdded:Connect(updateRank)
        for _, p in ipairs(Players:GetPlayers()) do updateRank(p) end
    end
end

function PermissionCore:Check(player, permissionNode)
    if not self._adapter then return false, "System Error" end
    local rank = self._adapter:GetRank(player)
    return rank > 0 
end

return PermissionCore
