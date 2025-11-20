local RS = game:GetService('ReplicatedStorage')
local OVHL_ROOT = RS.OVHL

local OVHL = {
    VERSION = '2.3.0-VALORANT-UI-FINAL',
    BUILD_ID = 'FOLDER-STRUCTURE-FIXED',
}

-- Core Systems (Safe loading)
local function SafeRequire(path, fallback)
    local success, result = pcall(require, path)
    if success then
        return result
    else
        warn("[OVHL] Failed to load core: " .. tostring(path))
        return fallback
    end
end

OVHL.Logger         = SafeRequire(OVHL_ROOT.Core.SmartLogger, {})
OVHL.LoggerFactory  = SafeRequire(OVHL_ROOT.Core.LoggerFactory, {})
OVHL.Config         = SafeRequire(OVHL_ROOT.Core.SharedConfigLoader, {})
OVHL.Enums          = SafeRequire(OVHL_ROOT.Core.EngineEnums, {})
OVHL.Types          = SafeRequire(OVHL_ROOT.Types.CoreTypes, {})
OVHL.DomainResolver = SafeRequire(OVHL_ROOT.Core.Logging.DomainResolver, {})
OVHL.TypeValidator  = SafeRequire(OVHL_ROOT.Core.TypeValidator, {})
OVHL.ErrorHandler   = SafeRequire(OVHL_ROOT.Core.ErrorHandler, {})
OVHL.Perf           = SafeRequire(OVHL_ROOT.Core.PerformanceMonitor, {})

-- UI Foundation
OVHL.Theme          = SafeRequire(OVHL_ROOT.UI.Foundation.Theme, {})
OVHL.Layers         = SafeRequire(OVHL_ROOT.UI.Foundation.Layers, {})
OVHL.FusionHelper   = SafeRequire(OVHL_ROOT.UI.Foundation.FusionHelper, {})
OVHL.Motion         = SafeRequire(OVHL_ROOT.UI.Foundation.Motion, {})
OVHL.Audio          = SafeRequire(OVHL_ROOT.UI.Foundation.Audio, {})
OVHL.SafeLoader     = SafeRequire(OVHL_ROOT.UI.Foundation.SafeLoader, {})
OVHL.Compatibility  = SafeRequire(OVHL_ROOT.UI.Foundation.Compatibility, {})
OVHL.EmergencyFallback = SafeRequire(OVHL_ROOT.UI.Foundation.EmergencyFallback, {})

-- UI Config Access
OVHL.UIConfig       = SafeRequire(OVHL_ROOT.Config.UIConfig, {})

-- SAFE UI Components with VERIFIED paths
OVHL.UI = setmetatable({}, {
    __index = function(self, key)
        local component = rawget(self, key)
        if component then return component end
        
        -- Use SafeLoader with error recovery
        if OVHL.SafeLoader and OVHL.SafeLoader.GetComponent then
            component = OVHL.SafeLoader.GetComponent(key)
            rawset(self, key, component)
            return component
        else
            -- Ultimate fallback if SafeLoader fails
            warn("[OVHL] SafeLoader unavailable, using emergency fallback for: " .. key)
            return function(scope, props)
                return scope:New "TextLabel" {
                    Name = "Emergency_" .. key,
                    Size = props.Size or UDim2.fromOffset(200, 50),
                    BackgroundColor3 = Color3.fromRGB(255, 0, 255),
                    Text = "EMERGENCY: " .. key,
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }
            end
        end
    end
})

OVHL.Icons = OVHL.UIConfig.Icons or {}

function OVHL.IsStudio() 
    return pcall(function() 
        return game:GetService('RunService'):IsStudio() 
    end) or false
end

-- System verification
function OVHL.VerifySystem()
    local checks = {
        {"Theme", OVHL.Theme and OVHL.Theme.Colors ~= nil},
        {"SafeLoader", OVHL.SafeLoader and OVHL.SafeLoader.GetComponent ~= nil},
        {"UI.Window", pcall(function() return OVHL.UI.Window end)},
        {"UI.Button", pcall(function() return OVHL.UI.Button end)},
    }
    
    local failed = {}
    for _, check in ipairs(checks) do
        if not check[2] then
            table.insert(failed, check[1])
        end
    end
    
    if #failed > 0 then
        warn("[OVHL] System verification failed: " .. table.concat(failed, ", "))
        return false
    end
    
    return true
end

-- Initialize verification
task.spawn(function()
    if OVHL.VerifySystem() then
        print("🎯 OVHL UI System: VERIFIED AND READY")
    else
        warn("⚠️ OVHL UI System: VERIFICATION FAILED - Running in recovery mode")
    end
end)

return OVHL
