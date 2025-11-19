--[[
    OVHL ENGINE V1.2.0
    @Component: ConfigLoader (Foundation)
    @Path: ReplicatedStorage.OVHL.Systems.Foundation.ConfigLoader
    @Purpose: Secure Deep Merging of Configurations (Anti-Poisoning)
    @State: Refactor V1.2.0 (Deep Merge Fix)
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
    self._logger:Info("CONFIG", "ConfigLoader Ready V1.2.0 (Deep Merge Fixed)")
end

-- [CRITICAL FIX] Deep Copy Logic
function ConfigLoader:MergeDeep(target, source)
    for key, value in pairs(source) do
        if type(value) == "table" then
            if type(target[key]) ~= "table" then
                target[key] = {}
            end
            self:MergeDeep(target[key], value)
        else
            target[key] = value
        end
    end
end

function ConfigLoader:ResolveConfig(moduleName, context)
    local finalConfig = {}
    local RS = game:GetService("ReplicatedStorage")
    local SSS = game:GetService("ServerScriptService")
    local SPS = game:GetService("StarterPlayer").StarterPlayerScripts
    
    local success, engineCfg = pcall(require, RS.OVHL.Config.EngineConfig)
    if success then self:MergeDeep(finalConfig, engineCfg) end
    
    local sPath = RS.OVHL.Shared.Modules:FindFirstChild(moduleName)
    if sPath and sPath:FindFirstChild("SharedConfig") then
        local succ, sCfg = pcall(require, sPath.SharedConfig)
        if succ then self:MergeDeep(finalConfig, sCfg) end
    end
    
    if context == "Server" then
        local srvPath = SSS.OVHL.Modules:FindFirstChild(moduleName)
        if srvPath and srvPath:FindFirstChild("ServerConfig") then
            local succ, srvCfg = pcall(require, srvPath.ServerConfig)
            if succ then self:MergeDeep(finalConfig, srvCfg) end
        end
    elseif context == "Client" then
        local clPath = SPS.OVHL.Modules:FindFirstChild(moduleName)
        if clPath and clPath:FindFirstChild("ClientConfig") then
            local succ, clCfg = pcall(require, clPath.ClientConfig)
            if succ then self:MergeDeep(finalConfig, clCfg) end
        end
    end
    
    return finalConfig
end

function ConfigLoader:GetClientSafeConfig(moduleName)
    return self:ResolveConfig(moduleName, "Client")
end

return ConfigLoader
