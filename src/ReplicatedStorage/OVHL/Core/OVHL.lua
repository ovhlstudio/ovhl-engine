--[[
OVHL FRAMEWORK V.1.0.1
@Component: OVHL (Core API Gateway)
@Path: ReplicatedStorage.OVHL.Core.OVHL
@Purpose: Central API Gateway (Static Dot Notation)
@Version: 1.0.1
--]]

local OVHL = {}
-- Note: OVHL is now a Static Library, no metatable needed for self context.

local _systems = {}
local _modules = {}
local _initialized = false

-- [REFACTOR] Changed to Dot Notation
function OVHL.GetSystem(systemName)
    if _systems[systemName] then return _systems[systemName] end
    
    -- Recursive search fallback
    local success, system = pcall(function()
        -- Check ReplicatedStorage (Shared/Client)
        local rsSystems = game:GetService("ReplicatedStorage").OVHL.Systems
        for _, child in ipairs(rsSystems:GetDescendants()) do
            if child:IsA("ModuleScript") and child.Name == systemName then
                return require(child)
            end
        end
        
        -- Check ServerScriptService (Server Only) - [PHASE 5 ADDITION]
        if game:GetService("RunService"):IsServer() then
            local ssSystems = game:GetService("ServerScriptService").OVHL.Systems
            for _, child in ipairs(ssSystems:GetDescendants()) do
                if child:IsA("ModuleScript") and child.Name == systemName then
                    return require(child)
                end
            end
        end
        return nil
    end)
    
    if success and system then
        _systems[systemName] = system
        return system
    end
    return nil
end

function OVHL.GetService(serviceName)
    if not _initialized then return nil end
    local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
    local success, service = pcall(function() return Knit.GetService(serviceName) end)
    return success and service or nil
end

function OVHL.GetController(controllerName)
    if not _initialized then return nil end
    local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
    local success, controller = pcall(function() return Knit.GetController(controllerName) end)
    return success and controller or nil
end

function OVHL.GetModule(moduleName) return _modules[moduleName] end

function OVHL.GetConfig(moduleName, key, context)
    local ConfigLoader = OVHL.GetSystem("ConfigLoader")
    if ConfigLoader then
        local config = ConfigLoader:ResolveConfig(moduleName, context or "Server")
        return key and config[key] or config
    end
    return nil
end

function OVHL.GetClientConfig(moduleName, key)
    local ConfigLoader = OVHL.GetSystem("ConfigLoader")
    if ConfigLoader then
        local config = ConfigLoader:GetClientSafeConfig(moduleName)
        return key and config[key] or config
    end
    return nil
end

function OVHL.ValidateInput(schemaName, data)
    local InputValidator = OVHL.GetSystem("InputValidator")
    if InputValidator then return InputValidator:Validate(schemaName, data) end
    return true, "InputValidator not available"
end

function OVHL.CheckPermission(player, permissionNode)
    local PermissionCore = OVHL.GetSystem("PermissionCore")
    if PermissionCore then return PermissionCore:Check(player, permissionNode) end
    return true
end

function OVHL.CheckRateLimit(player, action)
    local RateLimiter = OVHL.GetSystem("RateLimiter")
    if RateLimiter then return RateLimiter:Check(player, action) end
    return true
end

function OVHL.RegisterSystem(name, instance) _systems[name] = instance end
function OVHL.RegisterModule(name, instance) _modules[name] = instance end
function OVHL.MarkInitialized() _initialized = true end
function OVHL.IsInitialized() return _initialized end

function OVHL.GetSystemStatus(systemName)
    local SystemRegistry = OVHL.GetSystem("SystemRegistry")
    return SystemRegistry and SystemRegistry:GetSystemStatus(systemName) or "SYSTEMREGISTRY_NOT_AVAILABLE"
end

function OVHL.GetSystemsHealth()
    local SystemRegistry = OVHL.GetSystem("SystemRegistry")
    return SystemRegistry and SystemRegistry:GetHealthStatus() or {}
end

return OVHL
