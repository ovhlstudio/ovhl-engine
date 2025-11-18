--[[
OVHL FRAMEWORK V.1.0.1
@Component: @Component: PermissionCore (Core System) (Standard)
@Path: ServerScriptService.OVHL.Systems.Security.PermissionCore
@Purpose: Permission logic (SERVER ONLY)
@Refactor: V.1.0.1 Dot Notation + Path Fix
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
    self._adapterName = nil
    self._isServer = RunService:IsServer()
    
    if not self._isServer then
        error("CRITICAL SECURITY: PermissionCore loaded on Client!")
    end
    return self
end

function PermissionCore:Initialize(logger)
    self._logger = logger
    local success, engineConfig = pcall(function()
        return require(ReplicatedStorage.OVHL.Config.EngineConfig)
    end)
    self._adapterName = (success and engineConfig and engineConfig.Adapters and engineConfig.Adapters.Permission) or "InternalAdapter"
    self._logger:Info("PERMISSION", "PermissionCore initialized (Server Safe)", {adapter = self._adapterName})
end

function PermissionCore:Start()
    -- [FIX] Adapters are in ReplicatedStorage, NOT ServerScriptService
    local adapterFolder = ReplicatedStorage.OVHL.Systems.Adapters.Permission
    self:_loadAdapter(adapterFolder, self._adapterName)

    if self._isServer then
        self:_startReplication()
    end
end

function PermissionCore:_loadAdapter(folder, name)
    local adapterModule = folder:FindFirstChild(name)
    if not adapterModule then
        self._logger:Warn("PERMISSION", "Adapter missing, using Internal", {requested = name})
        return self:_loadInternal(folder)
    end
    
    local success, AdapterClass = pcall(require, adapterModule)
    if not success then return self:_loadInternal(folder) end
    
    local adapterInstance = AdapterClass.new()
    if adapterInstance.Initialize then adapterInstance:Initialize(self._logger) end
    
    if adapterInstance.IsAvailable and not adapterInstance:IsAvailable() then
        self._logger:Warn("PERMISSION", "Adapter unavailable, fallback to Internal", {adapter = name})
        return self:_loadInternal(folder)
    end
    
    self._adapter = adapterInstance
    self._logger:Info("PERMISSION", "Adapter active", {adapter = name})
end

function PermissionCore:_loadInternal(folder)
    local mod = folder:FindFirstChild("InternalAdapter")
    if mod then
        local cls = require(mod)
        self._adapter = cls.new()
        if self._adapter.Initialize then self._adapter:Initialize(self._logger) end
    end
end

function PermissionCore:_startReplication()
    local function updateRank(player)
        if not self._adapter then return end
        local rank = self._adapter:GetRank(player)
        player:SetAttribute("OVHL_Rank", rank)
        self._logger:Debug("PERMISSION", "Rank Replicated", {player = player.Name, rank = rank})
    end
    Players.PlayerAdded:Connect(updateRank)
    for _, p in ipairs(Players:GetPlayers()) do updateRank(p) end
end

function PermissionCore:Check(player, permissionNode)
    if not self._isServer then return false, "Client blocked" end
    if not self._adapter then return false, "System not ready" end
    
    local rank = self._adapter:GetRank(player)
    local module, action = string.match(permissionNode, "^(%w+)%.(.+)$")
    local requiredRank = 0
    
    if module then
        local OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
        -- [FIX] Use Dot Notation
        local config = OVHL.GetConfig(module, nil, "Server")
        if config and config.Permissions and config.Permissions[action] then
            local req = config.Permissions[action].Rank
            local rankMap = { Owner = 5, HeadAdmin = 4, SuperAdmin = 4, Admin = 3, Mod = 2, VIP = 1, NonAdmin = 0 }
            requiredRank = (type(req) == "string" and rankMap[req]) or tonumber(req) or 0
        end
    end

    if rank >= requiredRank then return true end
    return false, "Rank too low (" .. tostring(rank) .. " < " .. tostring(requiredRank) .. ")"
end

return PermissionCore
