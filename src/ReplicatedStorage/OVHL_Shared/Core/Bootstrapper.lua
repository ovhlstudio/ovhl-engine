-- [[ BOOTSTRAPPER (ABSOLUTE STANDARD) ]]
local Bootstrapper = {}
-- ABSOLUTE PATH
local Logger = require(script.Parent.Logger)

local _modules = {}

function Bootstrapper:Register(def)
    if _modules[def.Name] then return end
    _modules[def.Name] = def
end

function Bootstrapper:GetModule(name) return _modules[name] end

function Bootstrapper:ResolveDependencies()
    local sorted = {}
    local visited = {}
    local temp = {}
    local hasError = false
    
    local registeredNames = {}
    for name, _ in pairs(_modules) do table.insert(registeredNames, name) end
    Logger:Debug("BOOTSTRAP", "Registry State: [" .. table.concat(registeredNames, ", ") .. "]")

    local function visit(name)
        if temp[name] then error("Circular Dependency: " .. name) end
        if visited[name] then return end
        temp[name] = true
        
        local mod = _modules[name]
        if mod and mod.Dependencies then
            for _, depName in ipairs(mod.Dependencies) do
                if not _modules[depName] then
                    Logger:Critical("BOOTSTRAP", "Missing Dependency: " .. depName .. " (required by " .. name .. ")")
                    hasError = true
                else
                    visit(depName)
                end
            end
        end
        
        visited[name] = true
        temp[name] = nil
        if not hasError then table.insert(sorted, mod) end
    end

    for name, _ in pairs(_modules) do 
        if not visited[name] then visit(name) end 
    end
    
    return hasError and nil or sorted
end

function Bootstrapper:Start()
    Logger:Info("BOOTSTRAP", "Resolving Dependencies...")
    local loadOrder = self:ResolveDependencies()
    
    if not loadOrder then 
        Logger:Critical("BOOTSTRAP", "HALTING BOOT due to Dependency Failure") 
        return 
    end
    
    -- Init Phase
    for _, mod in ipairs(loadOrder) do
        if type(mod.OnInit) == "function" then
            local s, e = pcall(function() mod:OnInit() end)
            if not s then Logger:Critical("BOOTSTRAP", "Init Failed: " .. mod.Name, {error=e}) end
        end
    end
    
    -- Start Phase
    for _, mod in ipairs(loadOrder) do
        if type(mod.OnStart) == "function" then
            task.spawn(function()
                local s, e = pcall(function() mod:OnStart() end)
                if not s then Logger:Critical("BOOTSTRAP", "Start Failed: " .. mod.Name, {error=e}) end
            end)
        end
    end
    
    Logger:Info("BOOTSTRAP", "System Operational", {modules=#loadOrder})
end

return Bootstrapper
