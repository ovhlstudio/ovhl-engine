--[[
OVHL ENGINE V1.0.0
@Component: ConfigLoader (Foundation)
@Path: ReplicatedStorage.OVHL.Systems.Foundation.ConfigLoader
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.0.0 - CONFIG LOADER SYSTEM
Version: 3.0.1
Path: ReplicatedStorage.OVHL.Systems.Foundation.ConfigLoader
FIXES: Added defensive logger checks
--]]

local ConfigLoader = {}
ConfigLoader.__index = ConfigLoader

function ConfigLoader.new()
    local self = setmetatable({}, ConfigLoader)
    self._logger = nil
    return self
end

function ConfigLoader:Initialize(logger)
    self._logger = logger
    self._logger:Info("CONFIG", "ConfigLoader initialized")
end

function ConfigLoader:ResolveConfig(moduleName, context)
    local finalConfig = {}
    
    -- LAYER 1: Engine Config
    local engineConfig = self:LoadEngineConfig()
    self:MergeDeep(finalConfig, engineConfig)
    
    -- LAYER 2: Shared Module Config
    local sharedConfig = self:LoadSharedConfig(moduleName)
    if sharedConfig then
        self:MergeDeep(finalConfig, sharedConfig)
    end
    
    -- LAYER 3: Context-Specific Config
    if context == "Server" then
        local serverConfig = self:LoadServerConfig(moduleName)
        if serverConfig then
            self:MergeDeep(finalConfig, serverConfig)
        end
    elseif context == "Client" then
        local clientConfig = self:LoadClientConfig(moduleName)
        if clientConfig then
            self:MergeDeep(finalConfig, clientConfig)
        end
    end
    
    if self._logger then
        self._logger:Debug("CONFIG", "Config resolved", {
            module = moduleName,
            context = context,
            layers = 3
        })
    end
    
    return finalConfig
end

function ConfigLoader:LoadEngineConfig()
    local success, config = pcall(function()
        return require(game:GetService("ReplicatedStorage").OVHL.Config.EngineConfig)
    end)
    return success and config or {}
end

function ConfigLoader:LoadSharedConfig(moduleName)
    local success, config = pcall(function()
        return require(game:GetService("ReplicatedStorage").OVHL.Shared.Modules[moduleName].SharedConfig)
    end)
    return success and config or nil
end

function ConfigLoader:LoadServerConfig(moduleName)
    local success, config = pcall(function()
        return require(game:GetService("ServerScriptService").OVHL.Modules[moduleName].ServerConfig)
    end)
    return success and config or nil
end

function ConfigLoader:LoadClientConfig(moduleName)
    local success, config = pcall(function()
        return require(game:GetService("StarterPlayer").StarterPlayerScripts.OVHL.Modules[moduleName].ClientConfig)
    end)
    return success and config or nil
end

function ConfigLoader:MergeDeep(target, source)
    for key, value in pairs(source) do
        if type(value) == "table" and type(target[key]) == "table" then
            self:MergeDeep(target[key], value)
        else
            target[key] = value
        end
    end
end

function ConfigLoader:GetClientSafeConfig(moduleName)
    local serverConfig = self:ResolveConfig(moduleName, "Server")
    local clientSafe = {}
    
    -- Filter out sensitive keys
    local SENSITIVE_KEYS = {"Permissions", "API", "DebugMode", "APIKey", "Secret", "Token"}
    
    for key, value in pairs(serverConfig) do
        local isSensitive = false
        for _, sensitiveKey in ipairs(SENSITIVE_KEYS) do
            if string.lower(tostring(key)) == string.lower(tostring(sensitiveKey)) then
                isSensitive = true
                break
            end
        end
        
        if not isSensitive then
            clientSafe[key] = value
        end
    end
    
    if self._logger then
        self._logger:Debug("CONFIG", "Client-safe config generated", {
            module = moduleName,
            filteredKeys = #SENSITIVE_KEYS
        })
    end
    
    return clientSafe
end

return ConfigLoader

--[[
@End: ConfigLoader.lua
@Version: 1.0.1
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]
