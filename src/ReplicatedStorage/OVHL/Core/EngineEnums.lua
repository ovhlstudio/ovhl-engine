--[[ @Component: EngineEnums (HD Standard) ]]
local EngineEnums = {
    Permission = { 
        NonAdmin  = 0,
        VIP       = 1,
        Mod       = 2, 
        Admin     = 3, 
        HeadAdmin = 4,
        Owner     = 5
    },
    
    UIMode = { Native = "Native", Fusion = "Fusion", Hybrid = "Hybrid" },
    LogLevel = { DEBUG = 1, INFO = 2, WARN = 3, ERROR = 4, FATAL = 5 }
}
table.freeze(EngineEnums)
return EngineEnums
