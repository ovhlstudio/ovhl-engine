--[[
OVHL ENGINE V3.0.0 - ENGINE CONFIGURATION
Version: 3.0.0
Path: ReplicatedStorage.OVHL.Config.EngineConfig
--]]

return {
    -- Engine behavior
    DebugMode = true,
    EnableHotReload = false,

    -- Performance settings
    ObjectPoolSize = 50,
    MaxNetworkRetries = 3,

    -- UI settings
    DefaultUIMode = "Auto",
    EnableUIAnimations = true,

    -- Logging settings
    Logging = {
        Model = "DEBUG", -- SILENT, NORMAL, DEBUG, VERBOSE
        EnableFileLogging = false,
        EnableColors = true,
    },

    -- Network settings
    RateLimitEnabled = true,
    RequestsPerMinute = 100,

    -- Fallback settings
    EnableFallbackSystems = true,
    FallbackTimeout = 5,

    -- Kernel settings
    Kernel = {
        AutoScanModules = true,
        ScanInterval = 30,
        HotReloadModules = false,
    },
}
