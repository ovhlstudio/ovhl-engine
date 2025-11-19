--[[
OVHL FRAMEWORK V.1.1.0
@Component: OVHL (Core API Gateway)
@Path: ReplicatedStorage.OVHL.Core.OVHL
@Purpose: Central API Gateway (Supports V1.1.0 Split Architecture)
@Version: 1.1.0
--]]

local OVHL = {}
local RunService = game:GetService("RunService")

local _systems = {}
local _modules = {}
local _initialized = false

-- [V1.1.0] Helper: Get Search Paths
local function GetSearchFolders()
    local paths = {}
    
    -- 1. Shared (Always)
    table.insert(paths, game:GetService("ReplicatedStorage").OVHL.Systems)
    
    -- 2. Server Only
    if RunService:IsServer() then
        table.insert(paths, game:GetService("ServerScriptService").OVHL.Systems)
    end
    
    -- 3. Client Only
    if RunService:IsClient() then
        local ps = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerScripts")
        if ps then
            local ovhl = ps:FindFirstChild("OVHL")
            if ovhl then table.insert(paths, ovhl:FindFirstChild("Systems")) end
        end
    end
    
    return paths
end

function OVHL.GetSystem(systemName)
    -- 1. Fast Path: Memory Cache
    if _systems[systemName] then return _systems[systemName] end
    
    -- 2. Slow Path: Deep Search (Fallback if not registered yet)
    local success, system = pcall(function()
        local folders = GetSearchFolders()
        
        for _, folder in ipairs(folders) do
            if folder then
                for _, child in ipairs(folder:GetDescendants()) do
                    if child:IsA("ModuleScript") and child.Name == systemName then
                        return require(child)
                    end
                end
            end
        end
        return nil
    end)
    
    if success and system then
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
