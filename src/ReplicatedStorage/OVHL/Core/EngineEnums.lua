--[[ @Component: EngineEnums (HD Admin Standard) ]]
local EngineEnums = {
    -- 1:1 Mirror of HD Admin Ranks
    Permission = { 
        NonAdmin  = 0, -- Default
        VIP       = 1, -- Donors
        Mod       = 2, -- Moderators
        Admin     = 3, -- Administrators
        HeadAdmin = 4, -- Head Administrators (Missing before)
        Owner     = 5  -- Game Creator
    },
    
    UIMode = { Native = "Native", Fusion = "Fusion", Hybrid = "Hybrid" },
    LogLevel = { DEBUG = 1, INFO = 2, WARN = 3, ERROR = 4, FATAL = 5 }
}
table.freeze(EngineEnums)
return EngineEnums
