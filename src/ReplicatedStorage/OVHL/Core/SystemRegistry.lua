--[[
OVHL ENGINE V3.0.0 - SYSTEM REGISTRY (PATCHED)
Version: 3.0.1
FIXES: Removed table.size usage
--]]

local SystemRegistry = {}
SystemRegistry.__index = SystemRegistry

function SystemRegistry.new()
    local self = setmetatable({}, SystemRegistry)
    self._systems = {}
    self._dependencies = {}
    self._loadOrder = {}
    self._status = {}
    self._ovhl = nil
    self._logger = nil
    return self
end

function SystemRegistry:Initialize(ovhl, logger)
    self._ovhl = ovhl
    self._logger = logger
    self._logger:Info("SYSTEMREGISTRY", "System Registry initialized")
end

function SystemRegistry:RegisterSystem(systemName, systemInstance, dependencies)
    if string.match(systemName, "Service$") or string.match(systemName, "Controller$") then
        self._logger:Error("SYSTEMREGISTRY", "Knit services should use Knit", {system = systemName})
        return false
    end
    
    self._systems[systemName] = systemInstance
    self._dependencies[systemName] = dependencies or {}
    self._status[systemName] = "REGISTERED"
    
    self._logger:Debug("SYSTEMREGISTRY", "System registered", {system = systemName})
    return true
end

function SystemRegistry:ResolveLoadOrder()
    local visited = {}
    local tempMarked = {}
    local order = {}
    
    local function visit(systemName)
        if tempMarked[systemName] then error("Circular dependency: " .. systemName) end
        if not visited[systemName] then
            tempMarked[systemName] = true
            local deps = self._dependencies[systemName] or {}
            for _, depName in ipairs(deps) do
                if self._systems[depName] then visit(depName) end
            end
            tempMarked[systemName] = nil
            visited[systemName] = true
            table.insert(order, systemName)
        end
    end
    
    for systemName, _ in pairs(self._systems) do visit(systemName) end
    self._loadOrder = order
    return order
end

function SystemRegistry:AutoStartSystems()
    local loadOrder = self:ResolveLoadOrder()
    local startedCount = 0
    local failedCount = 0
    
    self._logger:Info("SYSTEMREGISTRY", "Starting systems")
    
    for _, systemName in ipairs(loadOrder) do
        local success, result = self:StartSystem(systemName)
        if success then startedCount = startedCount + 1
        else 
            failedCount = failedCount + 1
            self._logger:Error("SYSTEMREGISTRY", "Startup failed", {system = systemName, error = result})
        end
    end
    
    return startedCount, failedCount
end

function SystemRegistry:StartSystem(systemName)
    local system = self._systems[systemName]
    if not system then return false, "Not found" end
    if self._status[systemName] == "READY" then return true end
    
    local deps = self._dependencies[systemName] or {}
    for _, depName in ipairs(deps) do
        if self._status[depName] ~= "READY" then return false, "Dependency not ready: " .. depName end
    end
    
    if system.Initialize and type(system.Initialize) == "function" then
        local success, errorMsg = pcall(function() system:Initialize(self._logger) end)
        if not success then
            self._status[systemName] = "ERROR"
            return false, errorMsg
        end
    end
    
    self._status[systemName] = "READY"
    self._logger:Debug("SYSTEMREGISTRY", "Started", {system = systemName})
    return true
end

function SystemRegistry:GetSystemStatus(systemName) return self._status[systemName] or "NOT_FOUND" end
function SystemRegistry:GetLoadOrder() return self._loadOrder end

function SystemRegistry:GetHealthStatus()
    local health = {}
    for systemName, system in pairs(self._systems) do
        health[systemName] = {
            Status = self._status[systemName],
            Dependencies = self._dependencies[systemName] or {}
        }
    end
    return health
end

function SystemRegistry:RegisterWithOVHL()
    for systemName, system in pairs(self._systems) do
        if self._status[systemName] == "READY" then
            self._ovhl:RegisterSystem(systemName, system)
        end
    end
end

return SystemRegistry
