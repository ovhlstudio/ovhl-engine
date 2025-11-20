--[[
    OVHL Framework Public API (AAA Final)
    Single Source of Truth.
]]

local RS = game:GetService('ReplicatedStorage')
local OVHL_ROOT = RS.OVHL

local OVHL = {
    VERSION = '2.2.0-STABLE',
    BUILD_ID = 'V10-FIXED',
}

-- Core Systems
OVHL.Logger         = require(OVHL_ROOT.Core.SmartLogger)
OVHL.LoggerFactory  = require(OVHL_ROOT.Core.LoggerFactory)
OVHL.Config         = require(OVHL_ROOT.Core.SharedConfigLoader)
OVHL.Enums          = require(OVHL_ROOT.Core.EngineEnums)
OVHL.Types          = require(OVHL_ROOT.Types.CoreTypes)
OVHL.DomainResolver = require(OVHL_ROOT.Core.Logging.DomainResolver)
OVHL.TypeValidator  = require(OVHL_ROOT.Core.TypeValidator)
OVHL.ErrorHandler   = require(OVHL_ROOT.Core.ErrorHandler)
OVHL.Perf           = require(OVHL_ROOT.Core.PerformanceMonitor)

-- UI Foundation
OVHL.Theme          = require(OVHL_ROOT.UI.Foundation.Theme)
OVHL.Layers         = require(OVHL_ROOT.UI.Foundation.Layers)
OVHL.FusionHelper   = require(OVHL_ROOT.UI.Foundation.FusionHelper)
-- Note: Typography dipindah ke UI Component Loader biar konsisten

-- Lazy UI Components
OVHL.UI = setmetatable({}, {
    __index = function(self, key)
        local component = rawget(self, key)
        if component then return component end
        
        local paths = {
            -- Foundation as Component
            Typography = OVHL_ROOT.UI.Foundation.Typography, -- [FIXED] Added here!
            
            -- Surfaces
            Window = OVHL_ROOT.UI.Components.Surfaces.Window,
            Card = OVHL_ROOT.UI.Components.Surfaces.Card,
            Tooltip = OVHL_ROOT.UI.Components.Surfaces.Tooltip,
            Separator = OVHL_ROOT.UI.Components.Surfaces.Separator,
            
            -- Inputs
            Button = OVHL_ROOT.UI.Components.Inputs.Button,
            TextField = OVHL_ROOT.UI.Components.Inputs.TextField,
            
            -- Containers
            Flex = OVHL_ROOT.UI.Components.Containers.Flex,
            Grid = OVHL_ROOT.UI.Components.Containers.Grid,
            Canvas = OVHL_ROOT.UI.Components.Containers.Canvas,
            
            -- Feedback
            Badge = OVHL_ROOT.UI.Components.Feedback.Badge,
            LoadingSpinner = OVHL_ROOT.UI.Components.Feedback.LoadingSpinner,
        }
        
        local path = paths[key]
        if path then
            component = require(path)
            rawset(self, key, component)
            return component
        end
        error('[OVHL API] Unknown UI component: ' .. tostring(key))
    end
})

OVHL.Icons = require(OVHL_ROOT.UI.Assets.Icons)

function OVHL.IsStudio() return game:GetService('RunService'):IsStudio() end

return OVHL
