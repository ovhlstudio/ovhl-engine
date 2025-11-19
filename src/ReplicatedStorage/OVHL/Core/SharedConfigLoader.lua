--[[ @Component: SharedConfigLoader (Shared) ]]
local Loader = {}

local function DeepMerge(t, s)
    for k,v in pairs(s) do
        if type(v) == "table" and type(t[k]) == "table" then DeepMerge(t[k], v)
        else t[k] = v end
    end
end

function Loader.Load(moduleName)
    local cfg = {}
    -- ABSOLUTE REQUIRE
    local RS = game:GetService("ReplicatedStorage")
    local modFolder = RS.OVHL.Modules:FindFirstChild(moduleName)
    
    if modFolder then
        local shareSc = modFolder:FindFirstChild("SharedConfig")
        if shareSc then DeepMerge(cfg, require(shareSc)) end
    end
    
    return cfg
end
return Loader
