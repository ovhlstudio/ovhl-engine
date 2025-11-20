--[[ @Component: SharedConfigLoader (V2 STRICT STANDARD) ]]
local Loader = {}
local RS = game:GetService("ReplicatedStorage")

local function DeepMerge(t, s)
    for k,v in pairs(s) do
        if type(v) == "table" and type(t[k]) == "table" then DeepMerge(t[k], v)
        else t[k] = v end
    end
end

function Loader.Load(moduleName)
    local modFolder = RS.OVHL.Modules:FindFirstChild(moduleName)
    if not modFolder then
        warn("[OVHL CONFIG] Module not found:", moduleName)
        return {} 
    end

    local configFile = modFolder:FindFirstChild("SharedConfig")
    if not configFile then
        warn("[OVHL CONFIG] SharedConfig missing for:", moduleName)
        return {}
    end

    local cfg = require(configFile)

    -- STRICT VALIDATION (V2 Section 5)
    if not cfg.Meta then
        warn("CRITICAL VIOLATION: " .. moduleName .. " config missing Meta!")
    end
    
    if not cfg.Network then
        cfg.Network = { Route = moduleName.."/Main", Requests = {} }
    end

    return cfg
end

return Loader
