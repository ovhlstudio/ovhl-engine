--[[
OVHL ENGINE V1.0.0
@Component: PermissionCore (Refactored - Adapter Loader)
@Path: ReplicatedStorage.OVHL.Systems.Security.PermissionCore
@Purpose: Load permission adapter based on config, delegate permission checks
@Stability: STABLE
--]]

local PermissionCore = {}
PermissionCore.__index = PermissionCore

function PermissionCore.new()
    local self = setmetatable({}, PermissionCore)
    self._logger = nil
    self._adapter = nil
    self._adapterName = nil
    return self
end

function PermissionCore:Initialize(logger)
    self._logger = logger
    
    -- FIX: Direct require to EngineConfig
    local success, engineConfig = pcall(function()
        return require(game:GetService("ReplicatedStorage").OVHL.Config.EngineConfig)
    end)
    
    if success and engineConfig and engineConfig.Adapters then
        self._adapterName = engineConfig.Adapters.Permission or "InternalAdapter"
    else
        self._logger:Warn("PERMISSION", "Failed to load EngineConfig, using Internal")
        self._adapterName = "InternalAdapter"
    end
    
    self._logger:Info("PERMISSION", "PermissionCore initialized", {adapter = self._adapterName})
end

function PermissionCore:Start()
    local adapterFolder = script.Parent.Parent.Adapters.Permission
    self:_loadAdapter(adapterFolder, self._adapterName)
end

function PermissionCore:_loadAdapter(folder, name)
    local adapterModule = folder:FindFirstChild(name)
    
    -- Try finding requested adapter
    if not adapterModule then
        self._logger:Warn("PERMISSION", "Adapter not found, fallback to Internal", {requested = name})
        return self:_loadInternal(folder)
    end
    
    -- Try loading it
    local success, AdapterClass = pcall(require, adapterModule)
    if not success then
        self._logger:Error("PERMISSION", "Failed to require adapter", {error = tostring(AdapterClass)})
        return self:_loadInternal(folder)
    end
    
    -- Instantiate & Initialize
    local adapterInstance = AdapterClass.new()
    if adapterInstance.Initialize then
        adapterInstance:Initialize(self._logger)
    end
    
    -- SMART FALLBACK CHECK
    if adapterInstance.IsAvailable and not adapterInstance:IsAvailable() then
        self._logger:Warn("PERMISSION", "Adapter unavailable, triggering fallback", {adapter = name})
        return self:_loadInternal(folder)
    end
    
    self._adapter = adapterInstance
    self._logger:Info("PERMISSION", "Adapter active", {adapter = name})
end

function PermissionCore:_loadInternal(folder)
    -- Prevent infinite loop if Internal itself is failing (though unlikely)
    if self._adapterName == "InternalAdapter" and not self._adapter then
       -- Internal loaded directly below
    end

    local internalModule = folder:FindFirstChild("InternalAdapter")
    if internalModule then
        local success, InternalClass = pcall(require, internalModule)
        if success then
            self._adapter = InternalClass.new()
            if self._adapter.Initialize then self._adapter:Initialize(self._logger) end
            self._logger:Info("PERMISSION", "Fallback to InternalAdapter active")
            return
        end
    end
    self._logger:Critical("PERMISSION", "CRITICAL: Failed to load InternalAdapter fallback!")
end

function PermissionCore:Check(player, permissionNode)
    if not self._adapter then return false, "System not ready" end
    
    -- Added Logging for Debugging
    local allowed, reason = self._adapter:CheckPermission(player, permissionNode)
    if not allowed then
        self._logger:Warn("PERMISSION", "Access Denied", {
            player = player.Name,
            node = permissionNode,
            reason = reason
        })
    end
    return allowed, reason
end

function PermissionCore:GetRank(player)
    if not self._adapter then return 0 end
    return self._adapter:GetRank(player)
end

function PermissionCore:SetRank(player, rank)
    if not self._adapter then return false end
    return self._adapter:SetRank(player, rank)
end

return PermissionCore

--[[
@End: PermissionCore.lua
@Version: 1.0.2 (Smart Fallback)
--]]
