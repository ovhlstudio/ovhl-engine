--[[
OVHL ENGINE V1.0.0
@Component: OVHL (Core)
@Path: ReplicatedStorage.OVHL.Core.OVHL
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.0.0 - ENHANCED API GATEWAY (PATCHED)
Version: 3.0.1
Path: ReplicatedStorage.OVHL.Core.OVHL
FIXES: Fixed GetSystem path finding logic
--]]

local OVHL = {}
OVHL.__index = OVHL

local _systems = {}
local _modules = {}
local _initialized = false

function OVHL:GetSystem(systemName)
    if _systems[systemName] then return _systems[systemName] end
    
    -- Fix: Don't use FindFirstChild with paths. Use recursive search properly.
    local success, system = pcall(function()
        local systemsFolder = game:GetService("ReplicatedStorage").OVHL.Systems
        for _, child in ipairs(systemsFolder:GetDescendants()) do
            if child:IsA("ModuleScript") and child.Name == systemName then
                return require(child)
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

function OVHL:GetService(serviceName)
    if not _initialized then return nil end
    local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
    local success, service = pcall(function() return Knit.GetService(Knit, serviceName) end)
    return success and service or nil
end

function OVHL:GetController(controllerName)
    if not _initialized then return nil end
    local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
    local success, controller = pcall(function() return Knit.GetController(Knit, controllerName) end)
    return success and controller or nil
end

function OVHL:GetModule(moduleName) return _modules[moduleName] end

function OVHL:GetConfig(moduleName, key, context)
    local ConfigLoader = self:GetSystem("ConfigLoader")
    if ConfigLoader then
        local config = ConfigLoader:ResolveConfig(moduleName, context or "Server")
        return key and config[key] or config
    end
    return nil
end

function OVHL:GetClientConfig(moduleName, key)
    local ConfigLoader = self:GetSystem("ConfigLoader")
    if ConfigLoader then
        local config = ConfigLoader:GetClientSafeConfig(moduleName)
        return key and config[key] or config
    end
    return nil
end

function OVHL:ValidateInput(schemaName, data)
    local InputValidator = self:GetSystem("InputValidator")
    if InputValidator then return InputValidator:Validate(schemaName, data) end
    return true, "InputValidator not available"
end

function OVHL:CheckPermission(player, permissionNode)
    local PermissionCore = self:GetSystem("PermissionCore")
    if PermissionCore then return PermissionCore:Check(player, permissionNode) end
    return true
end

function OVHL:CheckRateLimit(player, action)
    local RateLimiter = self:GetSystem("RateLimiter")
    if RateLimiter then return RateLimiter:Check(player, action) end
    return true
end

function OVHL:RegisterSystem(name, instance) _systems[name] = instance end
function OVHL:RegisterModule(name, instance) _modules[name] = instance end
function OVHL:MarkInitialized() _initialized = true end
function OVHL:IsInitialized() return _initialized end

function OVHL:GetSystemStatus(systemName)
    local SystemRegistry = self:GetSystem("SystemRegistry")
    return SystemRegistry and SystemRegistry:GetSystemStatus(systemName) or "SYSTEMREGISTRY_NOT_AVAILABLE"
end

function OVHL:GetSystemsHealth()
    local SystemRegistry = self:GetSystem("SystemRegistry")
    return SystemRegistry and SystemRegistry:GetHealthStatus() or {}
end

function OVHL:GetSystemsLoadOrder()
    local SystemRegistry = self:GetSystem("SystemRegistry")
    return SystemRegistry and SystemRegistry:GetLoadOrder() or {}
end

return OVHL

--[[
@End: OVHL.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

