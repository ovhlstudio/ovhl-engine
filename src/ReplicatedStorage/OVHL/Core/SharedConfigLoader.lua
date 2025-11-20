--[[ @Component: SharedConfigLoader (Validated) ]]
local RS = game:GetService("ReplicatedStorage")
local Loader = {}
local Schema = require(script.Parent.ConfigSchema)

function Loader.Load(moduleName)
    local modFolder = RS.OVHL.Modules:FindFirstChild(moduleName)
    if not modFolder then
        warn("[CONFIG] Module not found: " .. moduleName)
        return {} 
    end

    local configFile = modFolder:FindFirstChild("SharedConfig")
    if not configFile then
        warn("[CONFIG] SharedConfig missing for: " .. moduleName)
        return {}
    end

    local success, cfg = pcall(require, configFile)
    if not success then
        warn("[CONFIG] Syntax Error in " .. moduleName .. ": " .. tostring(cfg))
        return {}
    end

    -- STRICT VALIDATION
    local ok, err = pcall(Schema.Validate, cfg, moduleName)
    if not ok then
        warn(err) -- Warn only, don't crash thread, simply return safe default?
        -- Or crash? Claude said "FAIL FAST". Let's error.
        error(err)
    end
    
    -- Defaults
    if not cfg.Network then
        cfg.Network = { Route = moduleName, Requests = {} }
    end

    return cfg
end

return Loader
