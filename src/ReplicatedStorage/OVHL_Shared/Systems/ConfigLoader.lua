-- [[ CONFIG LOADER (ABSOLUTE STANDARD) ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("OVHL_Shared")

local ConfigLoader = {}

function ConfigLoader.Merge(target, source)
    for k, v in pairs(source) do
        if type(v) == "table" and type(target[k]) == "table" then
            ConfigLoader.Merge(target[k], v)
        else
            target[k] = v
        end
    end
    return target
end

function ConfigLoader.GetConfig(moduleName)
    local finalConfig = {}
    
    -- Global
    local global = require(Shared.Library.SharedConfig)
    ConfigLoader.Merge(finalConfig, global)
    
    -- Shared Module
    local sharedMod = Shared.Modules:FindFirstChild(moduleName)
    if sharedMod then
        local cfg = sharedMod:FindFirstChild("ShopConfig") or sharedMod:FindFirstChild("SharedConfig")
        if cfg then ConfigLoader.Merge(finalConfig, require(cfg)) end
    end
    
    return finalConfig
end

return ConfigLoader
