--[[
    OVHL ENGINE V1.2.0
    @Component: ComponentScanner (Core System)
    @Path: ReplicatedStorage.OVHL.Systems.UI.ComponentScanner
    @Purpose: Recursive finder for Native UI elements (Config Driven)
    @State: Refactor V1.2.0
--]]

local ComponentScanner = {}
ComponentScanner.__index = ComponentScanner

function ComponentScanner.new()
    local self = setmetatable({}, ComponentScanner)
    self._logger = nil
    return self
end

function ComponentScanner:Initialize(logger)
    self._logger = logger
    self._logger:Info("SCANNER", "ComponentScanner Ready (V1.2.0)")
end

-- @param rootInstance: Instance (ScreenGui/Frame)
-- @param componentMap: Table { Key = "InstanceName" }
function ComponentScanner:Scan(rootInstance, componentMap)
    if not rootInstance then return nil, "Root instance is nil" end
    if not componentMap then return nil, "Component map is nil" end

    local results = {}
    local missing = {}

    local function deepFind(parent, name)
        return parent:FindFirstChild(name, true) 
    end

    for key, targetName in pairs(componentMap) do
        local instance = deepFind(rootInstance, targetName)
        if instance then
            results[key] = instance
        else
            table.insert(missing, targetName)
        end
    end

    return results, missing
end

return ComponentScanner
