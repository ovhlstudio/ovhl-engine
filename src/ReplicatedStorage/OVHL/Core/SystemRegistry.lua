--[[
OVHL FRAMEWORK V.1.0.1
@Component: SystemRegistry (Core Orchestrator)
@Path: ReplicatedStorage.OVHL.Core.SystemRegistry
@Purpose: Full Lifecycle Orchestrator
@Version: 1.0.1
--]]

local SystemRegistry = {}
SystemRegistry.__index = SystemRegistry

function SystemRegistry.new(ovhl, logger)
    local self = setmetatable({}, SystemRegistry)
    self._systems = {} 
    self._manifests = {} 
    self._loadOrder = {} 
    self._status = {} 
    self._ovhl = ovhl
    self._logger = logger
    -- [FIX VERSION]
    self._logger:Info("SYSTEMREGISTRY", "System Registry V.1.0.1 (4-Phase Lifecycle) initialized")
    return self
end

function SystemRegistry:RegisterAndStartFromManifests(manifestsMap)
    self._manifests = manifestsMap

    local success, result = pcall(function() return self:_ResolveLoadOrder() end)
    if not success then
        self._logger:Critical("SYSTEMREGISTRY", "FATAL BOOT ERROR: Circular Dependency!", { error = result })
        return 0, table.getn(self._manifests)
    end
    self._loadOrder = result

    local initCount, initFailed = self:_RunInitializationPhase()
    if initFailed > 0 then
        self._logger:Critical("SYSTEMREGISTRY", "FATAL BOOT ERROR: Init Failed!", { failed = initFailed })
        return initCount, initFailed
    end

    self:_RegisterWithOVHL()
    local startCount, startFailed = self:_RunStartPhase()
    return startCount, startFailed
end

function SystemRegistry:Shutdown()
    self._logger:Info("SYSTEMREGISTRY", "Memulai Fase 4 (Destroy/Shutdown)...")
    local success, result = pcall(function() return self:_RunDestroyPhase() end)
    if not success then
        self._logger:Critical("SYSTEMREGISTRY", "FATAL SHUTDOWN ERROR!", { error = result })
    else
        self._logger:Info("SYSTEMREGISTRY", "Shutdown complete.", { systems = result })
    end
end

function SystemRegistry:_ResolveLoadOrder()
    local visited = {}
    local tempMarked = {}
    local order = {}
    local function visit(systemName)
        if tempMarked[systemName] then error("Circular Dependency: " .. systemName, 2) end
        if not visited[systemName] then
            local manifest = self._manifests[systemName]
            if not manifest then error("Missing Dependency: " .. systemName, 2) end
            tempMarked[systemName] = true
            for _, depName in ipairs(manifest.dependencies or {}) do visit(depName) end
            tempMarked[systemName] = nil
            visited[systemName] = true
            table.insert(order, systemName)
        end
    end
    for systemName, _ in pairs(self._manifests) do visit(systemName) end
    return order
end

function SystemRegistry:_RunInitializationPhase()
    local startedCount = 0
    local failedCount = 0
    self._logger:Info("SYSTEMREGISTRY", "Memulai Fase 1 (Initialize)...")

    for _, systemName in ipairs(self._loadOrder) do
        local manifest = self._manifests[systemName]
        local success, moduleClass = pcall(require, manifest.modulePath)
        if not success then
            self._status[systemName] = "ERROR_LOAD"
            self._logger:Error("SYSREG", "Startup GAGAL", { system = systemName, error = "Require fail" })
            failedCount = failedCount + 1
            continue
        end

        local success, systemInstance = pcall(moduleClass.new)
        if not success then
            self._status[systemName] = "ERROR_NEW"
            self._logger:Error("SYSREG", "Startup GAGAL", { system = systemName, error = "New fail" })
            failedCount = failedCount + 1
            continue
        end

        if systemInstance.Initialize and type(systemInstance.Initialize) == "function" then
            local success, errorMsg = pcall(function() systemInstance:Initialize(self._logger) end)
            if not success then
                self._status[systemName] = "ERROR_INIT"
                self._logger:Error("SYSREG", "Startup GAGAL", { system = systemName, error = errorMsg })
                failedCount = failedCount + 1
                continue
            end
        end

        self._status[systemName] = "INIT"
        self._systems[systemName] = systemInstance
        startedCount = startedCount + 1
    end
    return startedCount, failedCount
end

function SystemRegistry:_RegisterWithOVHL()
    for systemName, systemInstance in pairs(self._systems) do
        if self._status[systemName] == "INIT" then
            -- [CRITICAL KEEP] Phase 5 Fix: Dot Notation
            self._ovhl.RegisterSystem(systemName, systemInstance) 
        end
    end
end

function SystemRegistry:_RunStartPhase()
    local startedCount = 0
    local failedCount = 0
    self._logger:Info("SYSTEMREGISTRY", "Memulai Fase 3 (Start)...")

    for _, systemName in ipairs(self._loadOrder) do
        local systemInstance = self._systems[systemName]
        if self._status[systemName] == "INIT" then
            if systemInstance.Start and type(systemInstance.Start) == "function" then
                local success, errorMsg = pcall(function() systemInstance:Start() end)
                if not success then
                    self._status[systemName] = "ERROR_START"
                    self._logger:Error("SYSREG", "Startup GAGAL", { system = systemName, error = errorMsg })
                    failedCount = failedCount + 1
                else
                    self._status[systemName] = "READY"
                    startedCount = startedCount + 1
                    self._logger:Debug("SYSTEMREGISTRY", "Started (Ready)", { system = systemName })
                end
            else
                self._status[systemName] = "READY"
                startedCount = startedCount + 1
                self._logger:Debug("SYSTEMREGISTRY", "Started (Pasif)", { system = systemName })
            end
        end
    end
    return startedCount, failedCount
end

function SystemRegistry:_RunDestroyPhase()
    local destroyedCount = 0
    local failedCount = 0
    self._logger:Info("SYSTEMREGISTRY", "Memulai Fase 4 (Destroy)...")

    for i = #self._loadOrder, 1, -1 do
        local systemName = self._loadOrder[i]
        local systemInstance = self._systems[systemName]
        if self._status[systemName] == "READY" then
            if systemInstance.Destroy and type(systemInstance.Destroy) == "function" then
                local success, errorMsg = pcall(function() systemInstance:Destroy() end)
                if not success then
                    self._status[systemName] = "ERROR_DESTROY"
                    self._logger:Error("SYSREG", "Shutdown GAGAL", { system = systemName, error = errorMsg })
                    failedCount = failedCount + 1
                else
                    self._status[systemName] = "DESTROYED"
                    destroyedCount = destroyedCount + 1
                end
            else
                self._status[systemName] = "DESTROYED"
                destroyedCount = destroyedCount + 1
            end
        end
    end
    return destroyedCount, failedCount
end

function SystemRegistry:GetSystemStatus(systemName) return self._status[systemName] or "NOT_FOUND" end
function SystemRegistry:GetLoadOrder() return self._loadOrder end
function SystemRegistry:GetHealthStatus()
    local health = {}
    for systemName, manifest in pairs(self._manifests) do
        health[systemName] = { Status = self._status[systemName] or "REGISTERED", Dependencies = manifest.dependencies or {} }
    end
    return health
end

return SystemRegistry
